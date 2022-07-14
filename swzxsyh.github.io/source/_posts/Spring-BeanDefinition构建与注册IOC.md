---
title: Spring-BeanDefinition构建与注册IOC
date: 2022-07-06 23:42:30
tags:
---

# Spring中的BeanDefinition

> BeanDefinition 是 Spring Framework 中定义 Bean 的配置元信息接口.BeanDefinition描述一个bean. 包括bean的属性,构造函数参数列表,依赖bean,是否是单例,bean的类名等等

## BeanDefinition元信息

| 属性 (Property)          | 说明                                         |
| ------------------------ | -------------------------------------------- |
| Class                    | Bean全类名，必须是具体类，不能用抽象类或接口 |
| Name                     | Bean的名称或者ID                             |
| scope                    | Bean的作用域 (如: singleton, prototype 等)   |
| Constructor arguments    | Bean构造器参数（用于依赖注入）               |
| Properties               | Bean属性设置（用于依赖注入）                 |
| Autowiring mode          | Bean自动绑定模式（如：通过名称byName)        |
| Lazy initialization mode | Bean延迟初始化模式（延迟和非延迟）           |
| Initialization method    | Bean初始化回调方法名称                       |
| Destruction method       | Bean销毁回调方法名称                         |

<!-- more -->

## 源码

```java
/*
 * Copyright 2002-2020 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.beans.factory.config;

import org.springframework.beans.BeanMetadataElement;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.core.AttributeAccessor;
import org.springframework.core.ResolvableType;
import org.springframework.lang.Nullable;

/**
 * A BeanDefinition describes a bean instance, which has property values,
 * constructor argument values, and further information supplied by
 * concrete implementations.
 *
 * <p>This is just a minimal interface: The main intention is to allow a
 * {@link BeanFactoryPostProcessor} to introspect and modify property values
 * and other bean metadata.
 *
 * @author Juergen Hoeller
 * @author Rob Harrop
 * @since 19.03.2004
 * @see ConfigurableListableBeanFactory#getBeanDefinition
 * @see org.springframework.beans.factory.support.RootBeanDefinition
 * @see org.springframework.beans.factory.support.ChildBeanDefinition
 */
public interface BeanDefinition extends AttributeAccessor, BeanMetadataElement {

  /**
	 * Scope identifier for the standard singleton scope: {@value}.
	 * <p>Note that extended bean factories might support further scopes.
	 * @see #setScope
	 * @see ConfigurableBeanFactory#SCOPE_SINGLETON
	 */
  String SCOPE_SINGLETON = ConfigurableBeanFactory.SCOPE_SINGLETON;

  /**
	 * Scope identifier for the standard prototype scope: {@value}.
	 * <p>Note that extended bean factories might support further scopes.
	 * @see #setScope
	 * @see ConfigurableBeanFactory#SCOPE_PROTOTYPE
	 */
  String SCOPE_PROTOTYPE = ConfigurableBeanFactory.SCOPE_PROTOTYPE;


  /**
	 * Role hint indicating that a {@code BeanDefinition} is a major part
	 * of the application. Typically corresponds to a user-defined bean.
	 */
  int ROLE_APPLICATION = 0;

  /**
	 * Role hint indicating that a {@code BeanDefinition} is a supporting
	 * part of some larger configuration, typically an outer
	 * {@link org.springframework.beans.factory.parsing.ComponentDefinition}.
	 * {@code SUPPORT} beans are considered important enough to be aware
	 * of when looking more closely at a particular
	 * {@link org.springframework.beans.factory.parsing.ComponentDefinition},
	 * but not when looking at the overall configuration of an application.
	 */
  int ROLE_SUPPORT = 1;

  /**
	 * Role hint indicating that a {@code BeanDefinition} is providing an
	 * entirely background role and has no relevance to the end-user. This hint is
	 * used when registering beans that are completely part of the internal workings
	 * of a {@link org.springframework.beans.factory.parsing.ComponentDefinition}.
	 */
  int ROLE_INFRASTRUCTURE = 2;


  // Modifiable attributes

  /**
	 * Set the name of the parent definition of this bean definition, if any.
	 */
  void setParentName(@Nullable String parentName);

  /**
	 * Return the name of the parent definition of this bean definition, if any.
	 */
  @Nullable
  String getParentName();

  /**
	 * Specify the bean class name of this bean definition.
	 * <p>The class name can be modified during bean factory post-processing,
	 * typically replacing the original class name with a parsed variant of it.
	 * @see #setParentName
	 * @see #setFactoryBeanName
	 * @see #setFactoryMethodName
	 */
  void setBeanClassName(@Nullable String beanClassName);

  /**
	 * Return the current bean class name of this bean definition.
	 * <p>Note that this does not have to be the actual class name used at runtime, in
	 * case of a child definition overriding/inheriting the class name from its parent.
	 * Also, this may just be the class that a factory method is called on, or it may
	 * even be empty in case of a factory bean reference that a method is called on.
	 * Hence, do <i>not</i> consider this to be the definitive bean type at runtime but
	 * rather only use it for parsing purposes at the individual bean definition level.
	 * @see #getParentName()
	 * @see #getFactoryBeanName()
	 * @see #getFactoryMethodName()
	 */
  @Nullable
  String getBeanClassName();

  /**
	 * Override the target scope of this bean, specifying a new scope name.
	 * @see #SCOPE_SINGLETON
	 * @see #SCOPE_PROTOTYPE
	 */
  void setScope(@Nullable String scope);

  /**
	 * Return the name of the current target scope for this bean,
	 * or {@code null} if not known yet.
	 */
  @Nullable
  String getScope();

  /**
	 * Set whether this bean should be lazily initialized.
	 * <p>If {@code false}, the bean will get instantiated on startup by bean
	 * factories that perform eager initialization of singletons.
	 */
  void setLazyInit(boolean lazyInit);

  /**
	 * Return whether this bean should be lazily initialized, i.e. not
	 * eagerly instantiated on startup. Only applicable to a singleton bean.
	 */
  boolean isLazyInit();

  /**
	 * Set the names of the beans that this bean depends on being initialized.
	 * The bean factory will guarantee that these beans get initialized first.
	 */
  void setDependsOn(@Nullable String... dependsOn);

  /**
	 * Return the bean names that this bean depends on.
	 */
  @Nullable
  String[] getDependsOn();

  /**
	 * Set whether this bean is a candidate for getting autowired into some other bean.
	 * <p>Note that this flag is designed to only affect type-based autowiring.
	 * It does not affect explicit references by name, which will get resolved even
	 * if the specified bean is not marked as an autowire candidate. As a consequence,
	 * autowiring by name will nevertheless inject a bean if the name matches.
	 */
  void setAutowireCandidate(boolean autowireCandidate);

  /**
	 * Return whether this bean is a candidate for getting autowired into some other bean.
	 */
  boolean isAutowireCandidate();

  /**
	 * Set whether this bean is a primary autowire candidate.
	 * <p>If this value is {@code true} for exactly one bean among multiple
	 * matching candidates, it will serve as a tie-breaker.
	 */
  void setPrimary(boolean primary);

  /**
	 * Return whether this bean is a primary autowire candidate.
	 */
  boolean isPrimary();

  /**
	 * Specify the factory bean to use, if any.
	 * This the name of the bean to call the specified factory method on.
	 * @see #setFactoryMethodName
	 */
  void setFactoryBeanName(@Nullable String factoryBeanName);

  /**
	 * Return the factory bean name, if any.
	 */
  @Nullable
  String getFactoryBeanName();

  /**
	 * Specify a factory method, if any. This method will be invoked with
	 * constructor arguments, or with no arguments if none are specified.
	 * The method will be invoked on the specified factory bean, if any,
	 * or otherwise as a static method on the local bean class.
	 * @see #setFactoryBeanName
	 * @see #setBeanClassName
	 */
  void setFactoryMethodName(@Nullable String factoryMethodName);

  /**
	 * Return a factory method, if any.
	 */
  @Nullable
  String getFactoryMethodName();

  /**
	 * Return the constructor argument values for this bean.
	 * <p>The returned instance can be modified during bean factory post-processing.
	 * @return the ConstructorArgumentValues object (never {@code null})
	 */
  ConstructorArgumentValues getConstructorArgumentValues();

  /**
	 * Return if there are constructor argument values defined for this bean.
	 * @since 5.0.2
	 */
  default boolean hasConstructorArgumentValues() {
    return !getConstructorArgumentValues().isEmpty();
  }

  /**
	 * Return the property values to be applied to a new instance of the bean.
	 * <p>The returned instance can be modified during bean factory post-processing.
	 * @return the MutablePropertyValues object (never {@code null})
	 */
  MutablePropertyValues getPropertyValues();

  /**
	 * Return if there are property values defined for this bean.
	 * @since 5.0.2
	 */
  default boolean hasPropertyValues() {
    return !getPropertyValues().isEmpty();
  }

  /**
	 * Set the name of the initializer method.
	 * @since 5.1
	 */
  void setInitMethodName(@Nullable String initMethodName);

  /**
	 * Return the name of the initializer method.
	 * @since 5.1
	 */
  @Nullable
  String getInitMethodName();

  /**
	 * Set the name of the destroy method.
	 * @since 5.1
	 */
  void setDestroyMethodName(@Nullable String destroyMethodName);

  /**
	 * Return the name of the destroy method.
	 * @since 5.1
	 */
  @Nullable
  String getDestroyMethodName();

  /**
	 * Set the role hint for this {@code BeanDefinition}. The role hint
	 * provides the frameworks as well as tools an indication of
	 * the role and importance of a particular {@code BeanDefinition}.
	 * @since 5.1
	 * @see #ROLE_APPLICATION
	 * @see #ROLE_SUPPORT
	 * @see #ROLE_INFRASTRUCTURE
	 */
  void setRole(int role);

  /**
	 * Get the role hint for this {@code BeanDefinition}. The role hint
	 * provides the frameworks as well as tools an indication of
	 * the role and importance of a particular {@code BeanDefinition}.
	 * @see #ROLE_APPLICATION
	 * @see #ROLE_SUPPORT
	 * @see #ROLE_INFRASTRUCTURE
	 */
  int getRole();

  /**
	 * Set a human-readable description of this bean definition.
	 * @since 5.1
	 */
  void setDescription(@Nullable String description);

  /**
	 * Return a human-readable description of this bean definition.
	 */
  @Nullable
  String getDescription();


  // Read-only attributes

  /**
	 * Return a resolvable type for this bean definition,
	 * based on the bean class or other specific metadata.
	 * <p>This is typically fully resolved on a runtime-merged bean definition
	 * but not necessarily on a configuration-time definition instance.
	 * @return the resolvable type (potentially {@link ResolvableType#NONE})
	 * @since 5.2
	 * @see ConfigurableBeanFactory#getMergedBeanDefinition
	 */
  ResolvableType getResolvableType();

  /**
	 * Return whether this a <b>Singleton</b>, with a single, shared instance
	 * returned on all calls.
	 * @see #SCOPE_SINGLETON
	 */
  boolean isSingleton();

  /**
	 * Return whether this a <b>Prototype</b>, with an independent instance
	 * returned for each call.
	 * @since 3.0
	 * @see #SCOPE_PROTOTYPE
	 */
  boolean isPrototype();

  /**
	 * Return whether this bean is "abstract", that is, not meant to be instantiated.
	 */
  boolean isAbstract();

  /**
	 * Return a description of the resource that this bean definition
	 * came from (for the purpose of showing context in case of errors).
	 */
  @Nullable
  String getResourceDescription();

  /**
	 * Return the originating BeanDefinition, or {@code null} if none.
	 * <p>Allows for retrieving the decorated bean definition, if any.
	 * <p>Note that this method returns the immediate originator. Iterate through the
	 * originator chain to find the original BeanDefinition as defined by the user.
	 */
  @Nullable
  BeanDefinition getOriginatingBeanDefinition();

}
```



## 方法解释

- `String: getBeanClassName`: 返回当前 bean definition 定义的类名
- `ConstructorArgumentValues: getConstructorArgumentValues`: 返回 bean 的构造函数参数
- `String[]: getDependsOn`: 返回当前 bean 所依赖的其他 bean 的名称
- `String: getFactoryBeanName`: 返回 factory bean 的名称
- `String: getFactoryMethodName`: 返回工厂方法的名称
- `BeanDefinition: getOriginatingBeanDefinition`: 返回原始的 BeanDefinition, 如果不存在返回`null`
- `String: getParentName`: 返回当前 bean definition 的父 definition 的名字
- `MutablePropertyValues: getPropertyValues`: 返回一个用于新的 bean 实例上的属性值
- `String: getScope`: 返回当前 bean 的目标范围
- `boolean: isAbstract`: 当前 bean 是否是 abstract, 意味着不能被实例化
- `boolean: isLazyInit`: bean 是否是延迟初始化
- `boolean: isPrimary`: bean 是否为自动装配的主要候选 bean
- `boolean: isPrototype`: bean 是否是多实例
- `boolean: isSingleton`: bean 是否是单例
- `void: setAutowiredCandidate(boolean)`: 设置 bean 是否对其他 bean 是自动装配的候选 bean
- `void: setBeanClassName(String)`: 指定 bean definition 的类名
- `void: setDependsOn(String ...)`: 设置当前 bean 初始化所依赖的 beans 的名称
- `void: setFactoryBeanName(String)`: 如果 factory bean 的名称
- `void: setFactoryMethodName(String)`: 设置工厂的方法名
- `void: setLazyInit(boolean lazyInit)`: 设置是否延迟初始化
- `void: setParentName(String)`: 设置父 definition 的名称
- `void: setPrimary(boolean)`: 设置是否主要的候选 bean
- `void: setScope(String)`: 设置 bean 的范围, 如: 单例, 多实例

# Spring中构建BeanDefinition的两种方法

## BeanDefinitionBuilder

```java
//1.通过BeanDefinitionBuilder
BeanDefinitionBuilder bdb=BeanDefinitionBuilder.genericBeanDefinition(Test.class);
//设置属性
bdb.addPropertyValue("code",1).addPropertyValue("name","test");
//获取BeanDefinition
BeanDefinition bd=bdb.getBeanDefinition();
//后期的BeanDefinition还是可以修改的
System.out.println(bd);
```



## GenericBeanDefinition

```java
//2.通过GenericBeanDefinition
 GenericBeanDefinition gb= new GenericBeanDefinition();
 //设置bean
 gb.setBeanClass(Test.class);
 //设置属性
 MutablePropertyValues mp=new MutablePropertyValues();
 mp.add("code",1).add("name","test");
 gb.setPropertyValues(mp);
 System.out.println(gb);
```

# Spring中将BeanDefinition注册到IOC容器中

- XML配置元信息
  - <bean name=”...” ... />
- 注解:
  - @Bean,@Component,@Import
- 命名:
  - BeanDefinitionRegistry#registerBeanDefition
- 非命名
  - BeanDefinitionReaderUtils#registerWithGeneratedName
- AnnotatedBeanDefinitionReader#register

## XMl配置元信息

```xml
<bean id="test" class="com.learn.Test"/>
```

## @Bean,@Component,@Import 注解

```java
@Import(DemoApplication.Config.class)
public class DemoApplication {
  public static  void main(String[] args) {
    AnnotationConfigApplicationContext ac=new AnnotationConfigApplicationContext();
    ac.register(DemoApplication.class);
    ac.refresh();
    System.out.println("Test类"+ac.getBeansOfType(Test.class));
    System.out.println("Config类"+ac.getBeansOfType(Config.class));
    System.out.println("DemoApplication类"+ac.getBeansOfType(DemoApplication.class));
    ac.close();
  }
  @Component
  public static class Config{
    @Bean
    public Test test(){
      Test r=new Test();
      r.set("1");
      r.setName("test");
      return r;
    }
  }
}
```

## BeanDefinitionRegistry#registerBeanDefinition

## BeanDefinitionReaderUtils#registerWithGeneratedName

```java
@Import(DemoApplication.Config.class) //1.注解方式
public class DemoApplication {
    public static  void main(String[] args) {
       AnnotationConfigApplicationContext ac=new AnnotationConfigApplicationContext();
       //ac.register(DemoApplication.class); //1.注解方式
       // 2.BeanDefinitionReaderUtils#registerWithGeneratedName,BeanDefinitionRegistry#registerBeanDefinition
       registryBeanDefinition(ac,"test");
       registryBeanDefinition(ac,null);
       ac.refresh();
       System.out.println("Test"+ac.getBeansOfType(Test.class));
       ac.close();
    }
    private static void registryBeanDefinition(BeanDefinitionRegistry reg,String beanName){
        BeanDefinitionBuilder builder= BeanDefinitionBuilder.genericBeanDefinition(Test.class);
        builder.addPropertyValue("code","1").addPropertyValue("name","test");
        if(StringUtils.isEmpty(beanName)){ //非命名
            BeanDefinitionReaderUtils.registerWithGeneratedName(builder.getBeanDefinition(),reg);
        }else{
            //命名
            reg.registerBeanDefinition(beanName,builder.getBeanDefinition());
        }
    }
    @Component //1.注解方式
    public static class Config{
       @Bean //1.注解方式
       public Test test(){
          Test r=new Test();
          r.setCode("1");
          r.setName("test");
          return r;
       }
    }
}
```

## AnnotatedBeanDefinitionReader#register

- register —>>this.reader.register
- this.reader —>>private final AnnotatedBeanDefinitionReader reader;

```java
AnnotationConfigApplicationContext ac=new AnnotationConfigApplicationContext();
ac.register(DemoApplication.class);
```



来源：

https://rumenz.com/rumenbiji/spring-beandefinition.html

https://rumenz.com/rumenbiji/spring-beandefinition-build.html

https://rumenz.com/rumenbiji/Spring-registerBeanDefinition.html



