---
title: Spring-Bean实例化方式
date: 2022-07-06 23:43:11
tags:
---

# 常规方式

- 通过构造方法实例化

  ```java
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
          https://www.springframework.org/schema/beans/spring-beans.xsd">
  <bean id="test" class="com.learn.Test" />
  <bean id="test1" class="com.learn.Test">
       <constructor-arg name="id" value="1"/>
  </bean>
  </beans>
  ```

  ```java
  import org.springframework.context.support.ClassPathXmlApplicationContext;
  
  public class DemoApplication {
      public static  void main(String[] args) {
          ClassPathXmlApplicationContext  ca=new ClassPathXmlApplicationContext("beans.xml");
          Test testA=(Test)ca.getBean("test");
      }
  }
  ```

  <!-- more -->

- 通过静态工厂实例化

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
          https://www.springframework.org/schema/beans/spring-beans.xsd">
  <bean id="rFactory" class="com.test.TestFactory" factory-method="testFactory"/>
  <bean id="rFactory1" class="com.test.TestFactory" factory-method="testFactory">
      <constructor-arg name="id" value="111"/>
  </bean>
  </beans>
  ```

  ```java
  //TestFactory工厂类
  
  public class TestFactory {
    //静态方法
    public static Test testFactory(){
      return new Test();
    }
    public static Test testFactory(String id){
      return new Test(id);
    }
  }
  
  //DemoApplication.java
  import org.springframework.context.support.ClassPathXmlApplicationContext;
  public class DemoApplication {
    public static  void main(String[] args) {
      ClassPathXmlApplicationContext  ca=new ClassPathXmlApplicationContext("beans.xml");
    }
  }
  ```

  

- 通过实例工厂实例化

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             https://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean  id="rFactory" class="com.learn.TestFactory" />
    <bean id="test" factory-bean="rFactory" factory-method="testFactory"></bean>
    <bean id="test1" factory-bean="rFactory" factory-method="testFactory">
      <constructor-arg name="id" value="666"></constructor-arg>
    </bean>
  </beans>
  ```

  ```java
  //TestFactory.java
  public class TestFactory {
    //不能用静态方法
    public  Test testFactory(){
      return new Test();
    }
    public  Test testFactory(String id){
      return new Test(id);
    }
  }
  
  //DemoApplication.java
  import org.springframework.context.support.ClassPathXmlApplicationContext;
  public class DemoApplication {
    public static  void main(String[] args) {
      ClassPathXmlApplicationContext  ca=new ClassPathXmlApplicationContext("beans.xml");
      //Test testA=(Test)ca.getBean("rFactory1");
    }
  }
  ```

  

- 通过FactoryBean实例化

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             https://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="test-by-factoryBean"  class="com.learn.TestFactoryBean"/>
  </beans>
  ```

  

  ```java
  import org.springframework.beans.factory.FactoryBean;
  public class TestFactoryBean implements FactoryBean {
    @Override
    public Object getObject() throws Exception {
      return Test.createTest();
    }
    @Override
    public Class<?> getObjectType() {
      return Test.class;
    }
  }
  
  import org.springframework.context.support.ClassPathXmlApplicationContext;
  public class DemoApplication {
    public static  void main(String[] args) {
      ClassPathXmlApplicationContext  ca=new ClassPathXmlApplicationContext("beans.xml");
      Test testA=(Test)ca.getBean("test-by-factoryBean");
    }
  }
  ```

  



# 特殊方式

- ServiceLoader 利用JDK里面的反向控制

  ```java
  public final class ServiceLoader<S>
      implements Iterable<S>
  {
      private static final String PREFIX = "META-INF/services/";
      //....
  }
  
  需要在classpath下创建META-INF/services/目录,在此目录下创建一个文件名为工厂接口的文件(注意不需要后缀),此文件里面放上此接口的全类路径
  
  └── resources
      ├── META-INF
      │   └── services
      │       └── com.learn.TestFactory
      ├── application.properties
      └── beans.xml
  注意:com.learn.TestFactory 是个文件
  里面的内容为工厂接口:
  com.learn.DefaultTestFactory
  调用DemoApplication.java
  ```

  ```java
  import org.springframework.context.support.ClassPathXmlApplicationContext;
  import java.util.Iterator;
  import java.util.ServiceLoader;
  public class DemoApplication {
      public static  void main(String[] args) {
          ClassPathXmlApplicationContext  ca=new ClassPathXmlApplicationContext("beans.xml");
          ServiceLoader<TestFactory> serviceLoader= ServiceLoader.load(TestFactory.class,Thread.currentThread().getContextClassLoader());
          Iterator<TestFactory> iterator = serviceLoader.iterator();
          while(iterator.hasNext()){
              TestFactory next = iterator.next();
              System.out.println(next.testFactory());
          }
      }
  }
  ```

  

- ServiceLoaderFactoryBean 

  ```xml
  beans.xml
  
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
          https://www.springframework.org/schema/beans/spring-beans.xsd">
  <bean id="instance-by-serviceLoaderFactoryBean" class="org.springframework.beans.factory.serviceloader.ServiceLoaderFactoryBean">
    <property name="serviceType" value="com.learn.TestFactory"></property>
  </bean>
  </beans>
  ```

  ```java
  //调用DemoApplication.java
  public class DemoApplication {
      public static  void main(String[] args) {
          ClassPathXmlApplicationContext  ca=new ClassPathXmlApplicationContext("beans.xml");
          ServiceLoader bean = ca.getBean("instance-by-serviceLoaderFactoryBean", ServiceLoader.class);
          Iterator iterator = bean.iterator();
          while (iterator.hasNext()){
              TestFactory next = (TestFactory) iterator.next();
              System.out.println(next.testFactory());
          }
      }
  }
  ```

  

- AutowireCapableBeanFactory#createBean

  ```java
  package com.learn;
  public class DemoApplication {
    public static  void main(String[] args) {
      ApplicationContext ac=new ClassPathXmlApplicationContext("beans.xml");
      AutowireCapableBeanFactory abf = ac.getAutowireCapableBeanFactory();
      DefaultTestFactory bean = abf.createBean(DefaultTestFactory.class);
      System.out.println(bean.testFactory());
    }
  }
  ```

  

- BeanDefinitionRegistry#registerBeanDefinition

  ```java
  public class DemoApplication {
    public static  void main(String[] args) {
      AnnotationConfigApplicationContext ac=new AnnotationConfigApplicationContext();
      ac.register(DemoApplication.class);
      registerBean(ac,"testa");
      ac.refresh();
      Test testa = (Test) ac.getBean("testa");
      System.out.println(testa);
      ac.close();
    }
    public static void registerBean(BeanDefinitionRegistry reg,String beanName){
      BeanDefinitionBuilder beanDefinitionBuilder = BeanDefinitionBuilder.genericBeanDefinition(Test.class);
      reg.registerBeanDefinition(beanName,beanDefinitionBuilder.getBeanDefinition());
    }
  }
  ```

  

来源：

https://rumenz.com/rumenbiji/Spring-Bean-common-instantiate.html

https://rumenz..com/rumenbiji/Spring-Bean-special-instantiate.html
