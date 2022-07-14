---
title: Spring-面试题
date: 2022-07-05 19:01:51
tags:
---

# Spring-面试题

## 什么是嵌入式服务器？

### 为什么要使用嵌入式服务器

- 外部服务器写完代码后需打包额外部署，需要额外学习部署内容
- Springboot内置Tomcat服务器，使用java -jar方式，将web工程变成基本java工程，简化开发部署方式

## 使用Spring的优势

- 通过DI、AOP消除样板式代码简化企业开发

- 低代码侵入性

- 基于Spring框架开发的代码，可以独立于各种应用服务器

- IOC降低业务对象替换复杂性，提高解耦性

- AOP支持将通用任务集中处理，提高复用能力

- 生态强大，领域范围大，与第三方框架整合，组件众多，简化开发

- 组件化功能，可以自定义引入所需组件，降低代码臃肿

<!-- more -->

## Spring的核心

- 开源框架
- 众多组件
- IOC && AOP && 容器

### Spring核心组件

- `spring core`：提供了框架的基本组成部分，包括控制反转（Inversion of Control，IOC）和依赖注入（Dependency Injection，DI）功能。
- `spring beans`：提供了BeanFactory，是工厂模式的一个经典实现，Spring将管理对象称为Bean。
- `spring context`：构建于 core 封装包基础上的 context 封装包，提供了一种框架式的对象访问方法。
- `spring jdbc`：提供了一个JDBC的抽象层，消除了烦琐的JDBC编码和数据库厂商特有的错误代码解析， 用于简化JDBC。
- `spring aop`：提供了面向切面的编程实现，让你可以自定义拦截器、切点等。
- `spring Web`：提供了针对 Web 开发的集成特性，例如文件上传，利用 servlet listeners 进行 ioc 容器初始化和针对 Web 的 ApplicationContext。
- `spring test`：主要为测试提供支持的，支持使用JUnit或TestNG对Spring组件进行单元测试和集成测试。

## Spring的事务传播机制

事务通过不同传播特性，保证事务在多个方法互相调用时传播，实现事务正常执行

| propagation_XXX | 我的理解                                                     | 官方                                                         |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| REQUIRED        | 子事务共用父事务，谁有异常都回滚（同甘共苦）                 | 支持一个当前事务;如果不存在，创建一个新的。                  |
| REQUIRES_NEW    | 子事务单干，父、子事务互不影响（前提：父事务做了子事务的异常捕获，否则子事务可影响父事务）（子成年自立） | 创建一个新的事务，如果存在当前事务的话暂停（挂起）当前事务 。 |
| NESTED          | 子事务受父事务影响，父事务不受子事务影响（前提：父事务做了子事务的异常捕获，否则子事务可影响父事务）（子幼儿时期） | 如果当前存在事务，则在嵌套事务内执行。如果当前没有事务，则进行与REQUIRED类似的操作 |
| SUPPORTS        | 支持事务：如果有父事务，就共用父事务；否则子事务也不存在 （必须存在父亲，否则儿子也不存在） | 支持当前事务；如果不存在当前事务则执行非事务。               |
| NOT_SUPPORTED   | 该方法非事务地执行，不参与事务（不认父亲）                   | 不执行当前事务；而是总是执行非事务                           |
| MANDATORY       | 强制事务，不存在父事务，抛异常                               | 支持当前事务；如果不存在当前事务则抛出一个异常               |
| NEVER           | 强制非事务，存在父事务，抛异常                               | 不支持当前事务；如果存在当前事务则抛出一个异常               |

### NESTED和REQUIRED_NEW区别

REQUIRED_NEW是新建一个事务并且新开始的事务与原有事务无关，而NESTED则是当前存在事务时会开启一个嵌套事务，在NESTED情况下，父事务回滚时，子事务也会回归。而在REQUIRED_NEW情况下，原有事务回滚，不会影响新开的事务

### NESTED和REQUIRED区别

REQUIRED情况下，调用方存在事务时，则被调用方和调用方使用同一事务，那么被调用方出现异常时，由于共用一个事务，使用无论是否catch异常，事务都会回滚。而在NESTED情况下，被调用方发送异常时，调用方可以catch其异常，这样只有子事务回滚，父事务不会回滚

## Spring事务的隔离级别有哪些

### 与DataBase相同

- Read Uncommited
- Read Commited
- Read Repeatable
- Serializable

在进行配置时，若DataBase和Spring代码中隔离级别不同，以Spring配置为主

## Spring的事务是如何回滚的？

Spring事务是由AOP实现，首先生成具体代理对象，如何按照AOP流程执行具体操作逻辑。正常情况下要通过通知完成核心功能，但事务本身通过通知实现，而是通过TransactionInterceptor实现，然后调用invoke来实现具体的逻辑

1. 先做准备工作，解析各个方法上事务相关的属性，根据具体的属性判断是否开启新事务
2. 当需要开启时，获取数据库连接，关闭自动提交功能，开启事务
3. 执行具体SQL逻辑操作
4. 操作过程中如果失败，会通过completeTransactionAfterThrowing完成事务回滚操作，具体逻辑是通过doRollBack方法实现的，实现时也要先获取连接对象，通过连接对象回滚
5. 如果执行过程中，没有任何意外发生，则通过commitTransactionAfterReturing完成事务commit操作，提交具体逻辑由doCommit方法实现，实现也是先获取连接，通过连接对象来提交
6. 当事务执行完毕后，需要清除相关事务信息cleanupTransactionInfo

### 细致化节点

- TransactionInfo
- TransactionStatus

## 谈一下Spring事务传播？

7种传播方式

### 事务嵌套处理方式

事务传播特性指的是不同方法的嵌套调用过程中，事务应该如何处理，是同一个事务还是不同事务，当出现异常时是回滚还是提交，两个方法之间的相关影响。使用较多是REQUIRED、REQUIRES_NEW，NESTED

- 可以分为三类
  - 支持当前事务
  - 不支持当前事务
  - 嵌套事务
- 如果外层方法是REQUIRED，内层方法是REQUIRED、REQUIRES_NEW，NESTED
- 如果外层方法是REQUIRES_NEW，内层方法是REQUIRED、REQUIRES_NEW，NESTED
- 如果外层方法是NESTED，内层方法是REQUIRED、REQUIRES_NEW，NESTED

### 核心处理逻辑

1. 判断内外方法是否同一个事务

   - 是

     异常统一在外层方法执行

   - 否

     内层方法可能影响到外层方法，但外层方法不会影响内层方法

   - 特殊情况：NESTED

2. 

## Spring事务的实现原理

### 声明式事务

事务本应由DataBase控制，但为方便用户进行业务操作，Spring对事务进行扩展实现，通过添加@Transaction实现，当添加此注解后事务的自动功能会关闭，由Spring框架进行控制。

事务操作是AOP的一个核心体现，当一个事务添加@Transaction注解后，Spring会基于这个类生产一个代理对象，将这个代理对象作为Bean，当使用这个代理对象的方法时，如果有事务处理，会先把事务自动提交给关系，如何执行具体业务逻辑。如果执行逻辑未异常，则代理逻辑直接commit，如果异常，则Rollback。用户可以控制对哪些异常进行回滚操作。

#### TransactionInterceptor



DynamicAdvicedAdapter Interceptor 拦截器链



### 编程式事务

通过代码控制事务的处理逻辑。一般很少使用编程式事务。



## Spring事务什么时候会失效

- Bean对象没有被Spring容器管理
- 方法的访问修饰符不是public
- 本方法内调用事务方法
- 数据源没有配置事务管理器
- 数据库不支持事务
- 异常被捕获
- 异常类型错误或配置错误



## Spring框架中使用了哪些设计模式及应用场景

- 工厂模式
  - BeanFactory 及Application Context创建中使用
- 原型模式
  - 指定Bean作用域为Prototype
- 模板方法—用来解决代码重复的问题
  - BeanFactory 及Application Context实现中使用
  - 比如.RestTemplate, JmsTemplate, JpaTemplate。
- 代理模式
  - 在 AOP 和 remoting 中被用的比较多。
- 策略模式
  - 加载资源方式，使用不同方法
  - 如ClassPathResource,FileSystemResource,ServletContextResource,UrlResource都有共同接口Resource。
- 单例模式
  - 在 Spring 配置文件中定义的 Bean 默认为单例模式。
- 观察者模式 
  - Spring中的ApplicationEvent,ApplicationListener,ApplicationEventPublisher
- 适配器模式
  - MethodBeforeAdviceAdapter,ThrowsAdviceAdapter,AfterReturingAdapter
- 装饰器模式
- 源码中类型带Wrapper或者Decorator都是
- 责任链模式
  - 用AOP时会先生成一个拦截器链
- 委托者模式
  - delegate



## 说说你对AOP的理解

AOP即面向切面编程，核心是解耦

- 切面 Aspect

  **声明公共逻辑**

  关注点模块化，这个关注点可能横切多个对象。事务管理是企业级Java中有关横切关注点的例子。在Spring AOP中，切面可以使用通用类基于模式方式(schema-based approach)或者在普通类中以@Aspect注解方式实现

  - 模式方式：配置文件
  - @Aspect：@AspectJ

- 连接点 Join Point

  告知容器要在这个节点中切入

  在程序执行过程中某个特定的点。在Spring AOP中，一个连接点总是代码一个方法的执行

- 通知 Advice

  在切面某个特定连接点上执行的动作

  包含多种类型：around/before/after

  以拦截器作为通知模型，并维护一个以连接点为中心的拦截器链

- 切点 Pointcut

  **匹配连接点的断言**。

  通知和切点表达式相关联，并在**满足这个切点**的连接点上运行。

  切点表达式如何与连接点匹配是AOP的核心：Spring默认使用Aspectj切点语义

- 引入 Introduction

  声明额外的方法或某个类型的字段。Spring运行引入新的接口（以及一个对应的实现）到任何被通知的对象上。

  引入也被称为内部类型声明(inter)

- 目标对象 Target Object

  被一个货多个切面所通知的对象，也被称作被通知(advised)对象。既然Spring AOP上通过运行时代理实现，那么这个对象永远是一个被代理(proxied)对象

- AOP代理 AOP Proxy

  AOP框架创建的对象，用来实现切面契约(aspect contract)（包括通知方法执行等功能）。在Spring中，AOP可以是JDK动态代理或者CGLIG代理

- 织入 Weaving

  把切面连接到其他的应用程序类型或者对象上，并创建一个被通知的对象过程。这个过程可以在编译时(如Aspect J编译器)、类加载时或运行时中完成。Spring和其他纯JAVA AOP框架一样，是在运行时完成植入的。

系统由不同组件构成，每个组件负责特定功能。如果需要为各个功能业务均添加一段公共功能代码，会造成代码冗余。因此只需将公共功能的代码抽出构成切面，注入到目标对象（业务）中即可。

AOP基于这个思路，通过动态代理，将需要注入切面的对象进行代理，在进行调用时候，直接将公共功能的逻辑添加，不需要变更原有业务代码逻辑，只需在原有业务基础做一些增强即可

### 声明式事务具体业务处理逻辑



## Spring的AOP的底层实现原理

AOP是IOC流程中新增的一个扩展点：BeanPostProcessor

AOP概念，应用场景，动态代理

Bean的创建过程中有一个步骤可以对Bean进行扩展实现，AOP本身就是一个扩展功能，所以在BeanPostProcessor方法中进行实现

- 代理对象的创建过程(advice,切面，切点)
- 通过JDK或CGLIB方式生成代理对象
- 在执行调用方法时，会调用到生成的字节码(ASM)文件中，直接找到DynamicAdvisoredInterceptor类中的Interceptor方法，从此方法开始执行
- 根据之前定义好的通知来生成拦截器链
- 从拦截器链中依次获取每一个通知开始进行执行，在执行过程中，为了方便找到下一个通知，会有一个CglibMethodInvocation对象，找的时候是从-1开始查找并执行的



## 说说你对IOC的理解

依赖注入。

IOC是通过依赖注入对象对象的过程，它们使用的对象，是通过构造函数参数、工厂方法参数或者是从工厂方法的构造参数或返回值的对象实例设置的属性，然后容器在创建Bean时注入这些需要的依赖。

这个过程相对普通创建的过程是反向的(因此称之IOC-Inversion of Control)，Bean本身通过直接构造类来控制依赖关系的实例化或位置，或提供注入服务定位器模式之类的机制。

- 谁负责控制

  IOC容器控制对象

- 控制什么

  在实现过程中需要的对象以及需要依赖的对象

- 什么是反转

  非主动创建的对象。依赖的对象之间由IOC容器创建后注入到对象中，由主动创建变为被动接受，即反转

- 哪些方面被反转

  依赖的对象

### IOC容器创建过程

- 容器对象创建
- XML/注解解析过程
- Bean Processor扩展点过程
- 如何通过反射方式进行实例化
- 初始化做的基础操作



## 谈谈Spring IOC的理解，原理与实现

控制反转：由使用者主动创建，交由Spring构建对象以及对象依赖，由Spring管理对象。

### DI 依赖注入

把对应的属性值注入到具体对象中。例如@Autowired、pupulateBean完成属性值的注入

### DL 依赖查找

### 容器

存储对象，使用Map结构存储，在Spring中一般存在三级缓存，完整Bean对象存放在SingletonObjects中。

整个Bean的生命周期，创建-使用-销毁全都是由容器管理(Bean声明周期)

#### 容器创建过程

- BeanFactory
- DefaultListableBeanFactory
- 向Bean工厂中设置一些参数、属性
  - BeanPostProcessor
  - Aware接口子类

#### 加载解析Bean对象，准备要创建的Bean对象的定义对象BeanDefinition

- XML或注解解析过程

#### BeanFactoryPostProcessor处理

- ConfigurationClassPostProcessor

#### BeanPostProcessor的注册功能

方便后续对Bean对象完成具体的扩展功能

#### 通过反射将BeanDefinition对象实例化成具体Bean对象

#### Bean对象的初始化过程

- 填充属性 populateBean
- 调用Aware子类的方法
- 调用BeanPostProcessor前置处理器方法
- 调用Init-Method方法
- 调用BeanPostProcessor的后置处理方法

#### 生产完整Bean对象

- 通过context.getBean()方法直接获取

#### 销毁过程

- 判断是否实现DispoableBean接口
- 或调用destoryMethod方法



## 谈一下Spring IOC的底层实现

#### 反射

#### 工厂

#### 设计模式

#### 方法与流程

- 先通过createBeanFactory创建一个Bean工厂(DefaultListableBeanFactory)
- 开始循环创建对象，因为容器中Bean都是Singleton，所以优先通过getBean,doGetBean方式从容器查找
- 如果找不到，则通过createBean,doCreateBean方法，以反射方式创建对象，一般情况下使用的是无参的构造方法createBeanInstance(getDeclaredConstructor,newInstance)
- 进行对象的属性填充populateBean
- 进行其他初始化操作initializingBean

## 如何实现一个IOC容器

1. 准备基本容器的对象，包含Map结构的集合，方便后续过程中存储具体对象
2. 进行配置文件的读取或注解解析工作，将需要创建的Bean都封装成BeanDefinition对象存储在容器中
3. 容器将封装好的BeanDefinition对象通过反射方式进行实例化，完成对象的实例化操作
4. 进行对象的初始化操作，设置类中对应的属性值，即依赖注入。完成整个对象的创建，编程一个完整的Bean对象，存储在容器的Map结构中
5. 通过容器获取对象，进行对象的获取和逻辑处理工作
6. 提供销毁操作，当对象不用或关闭容器时，将无用对象进行销毁



## Spring支持的Bean作用域有哪些

### Singleton

使用该属性定义Bean时，IOC仅创建一个Bean实例，IOC每次返回的是同一个Bean实例

### Prototype

使用该属性定义Bean时，IOC可以创建多个Bean实例，每次返回一个新的Bean实例

### Request

该属性仅对HTTP请求产生作用，使用该属性定义Bean时，每次HTTP请求都会创建一个新的Bean，适用于WebApplicationContext环境

### Session

该属性仅适用于HTTP Session，同一个Session共享一个Bean实例。不同Session使用不同Bean实例。

### Global-Session

该属性仅适用于HTTP Session，同Session作用域不同的是，所有Session共享一个Bean实例



## Spring框架中单例Bean是否线程安全

Spring中的Bean对象默认是Singleton的，框架并没有对Bean进行多线程的封装处理。

如果Bean是有状态的，则需要开发人员自己保重现场安全，最简单就是把Bean作用域由Singleton更改为prototype，这样每次请求Bean对象就相当于是创建新的对象来保证线程安全。

有状态就是有数据存储的功能。

无状态就是不存储数据，Controller、Service等本身不是线程安全的，只是调用里面的方法，而且多线程调用一个实例的方法，会在内存中复制遍历，这是自己线程的工作内存，是最安全的。

因此使用时，不要在Bean中声明任何有状态的实例变量或者类变量，如果必须如此，应使用ThreadLocal吧变量变成线程私有，如果Bean的实例变量或者类变量需要在多个线程之间共享，那么只能使用Synchronized，Lock，CAS等实现线程同步方法。



## 描述一下Bean的生命周期

- 实例化Bean

  反射的方式生成对象，此时的创建只是在堆中申请空间，属性都是默认值

- 填充Bean属性

  - populateBean()
  - 循环依赖的问题(三级缓存)

- 调用Aware接口相关方法

  - invokeAwareMethod(完成BeanName，BeanFactrory，BeanClassLoader对象的属性设置)

- 调用BeanPostProcessor中的前置处理方法

  - ApplicationContextPostProcessor设置对象
    - ApplicationContext
    - Environment
    - ResourceLoader
    - EmbeddedValueResolverAware

- 调用Init-Method方法

  - invokeInitMehtod()
  - 判断是否实现initializingBean接口
    - 调用afterPropertieSet方法

- 调用BeanPostProcessor后置处理方法

  - Spring AOP在此实现，AbstractAutoProxyCreator
  - 注册Destuction相关的回调接口，方便对象进行销毁工作

- 获取完整对象

  - context.getBean()方式进行对象获取

- 销毁流程

  - 判断是否实现DispoableBean接口
  - 或调用destoryMethod方法



## Spring是如何解决循环依赖的问题的

三级缓存，提前暴露对象，AOP

### 什么是循环依赖

A依赖B，B也依赖A

### Bean创建过程

#### 实例化 && 初始化（填充属性）

1. 实例化A对象，此时A对象依赖b属性空，填充属性b
2. 从容器中查找对象B，如果有直接赋值不存在循环依赖问题(此时不可能找到)，找不到直接创建B对象
3. 实例化B对象，此时B对象中a属性空，填充属性a
4. 从容器中查找A对象，找不到直接创建

此时A对象不是一个完整状态，只完成实例化为完成初始化，如果在程序调用过程中，拥有某个对象的引用，可优先吧非完整状态对象优先赋值，等待后续操作完成赋值，相当于提前暴露了某个不完整对象的引用，所以解决问题的核心在于实例化和初始化分开操作，这是解决循环依赖的关键。

当所有对象都完成实例化和初始化操作后，要把完整的对象放到容器，此时容器中存在对象的几个状态

> - 完成实例化但未完成初始化状态
> - 完整状态

因为都在容器中，使用需要使用不同的Map结构来进行存储，此时有了一级缓存和二级缓存，如果一级缓存中已存在，则二级缓存中不会存在同名对象，因为查找方式是一级、二级、三级依次查找。

一级缓存中放的是完整对象，二级缓存中放的是非完整对象。

#### 为什么需要三级缓存

三级缓存的Value是ObjectFactory，是一个函数式接口，存在的意义是保证在整个容器的运行过程中同名的Bean对象只有一个。

如果一个对象需要被代理或需要生成代理对象，则需要优先生成一个普通对象。

普通对象和代理对象不能同时出现在容器中，因此当一个对象需要被代理时，需要使用代理对象覆盖之前的普通对象。在实际调用过程中，没办法确定什么时候对象被使用，使用要求当某个对象被调用时，优先判断此对象是否需要被代理，类似一种回调机制的实现，因此传入Lambda表达式时，可以提供Lambda表达式来执行对象的覆盖过程，getEarlyBeanReference()

因此，所有的Bean对象在创建时，都要优先放入三级缓存中，在后续使用过程中，如果需要被代理则返回代理对象，不需要则直接返回普通对象。

### 缓存的放置时间和删除时间

- 三级缓存：createBeanInstance之后
  - addSingletonFactory
- 二级缓存：第一次从三级缓存确定对象是代理对象还是普通对象时会放入二级缓存，同时删除二级缓存
  - getSingleton
- 一级缓存：生成完整对象后放入一级缓存，删除二三级缓存
  - addSingleton



## Bean Factory与FactoryBean有什么区别

### 相同点

都是创建Bean对象

### 不同点

使用BeanFactory创建对象时，必须遵循严格的生命周期流程。

如果想要简单自定义某个对象的创建，同时创建完成的对象想交给Spring管理，此时需要实现FactoryBean接口

- isSingleton
  - 是否Singleton对象
- getObjectType
  - 获取返回对象的类型
- getObject
  - 自定义创建对象的过程(new ,反射，动态代理)



## Spring加载注解和配置文件概述

### 读取

- XML

   IO流读取到 Memory通过 SAX/Dom4j 解析为 Document 获取内部Node节点  放入Object

- Annotation 

  通过reflect注册为 Class 调用方法getAnnotation

  根据是否交给Spring管理进行对象创建

XML/Annotation都是定义Bean基本信息，通过接口注册到BeanDefinition中Bean的定义信息(Map结构)





## Spring生命周期

从对象创建到使用到销毁过程

### 实例化

在堆空间中申请空间，对象的属性值一般是默认值。即反射创建对象的过程

createBeanInstance反射创建对象

### 初始化属性赋值

- 自定义属性赋值
  - populateBean set方法完成赋值操作
- 容器对象属性赋值
  - Aware接口实现invokeAwareMethods

### Bean对象的扩展

此时Bean理论上是可以直接使用，但是需要判断是否需要扩展

- 执行前置处理方法
- BeanPostProcessor
  - AOP做Bean的拓展实现
- 执行后置处理方法

### 初始化方法的调用

- 执行前置处理方法
- 执行初始化方法
  - invokeInitMethod
  - 检查Bean是否实现了InitializingBean接口
  - 调用afterProptertiesSet方法
- 执行后置处理方法



## 循环依赖问题的思考

### 三个缓存结构Map分别存储什么类型对象

- 一级缓存
  - 成品
- 二级缓存
  - 半成品
- 三级缓存
  - Lambda表达式

### 三个Map结构在进行对象查找时，顺序是什么

一级缓存 -- 二级缓存 -- 三级缓存

### 如果只有一个Map结构，是否可以解决循环依赖问题

理论上可行。

使用两个Map结构可以区分成品 / 半成品，半成品对象不能直接暴露给外部对象使用，可以设置标识位区分，但相较两个Map更为麻烦

### 如果只有两个Map结构，是否可以解决循环依赖问题

不存在代理对象时，可以只有两个Map

### 为什么使用三级缓存后可以解决AOP循环引用

- 一个容器中，不能包含同名的两个对象

- 对象创建过程中，原始对象可能需要生成代理对象

- 创建出代理 对象，程序调用中应该使用代理对象，但代码既定情况下，程序无法判断需要获取代理对象还是原始对象

  因此，当出现代理对象时，要使用代理对象替换掉原始对象

### 代理对象在初始化过程的扩展阶段创建，属性赋值阶段已过，如何完成替换

需要在前置过程（属性赋值）时，判断是否需要生成代理对象

### 为何一定要Lambda表达式机制完成

对象被暴露时机或被嵌套对象引用是没办法提前确定好的，所以只有在被调用时才可以进行原始对象还是代理对象的判断。使用Lambda表达式类似于一种回调机制，不暴露时，不需要暴露执行，当需要被调用时，才真正执行Lambda表达式，来判断返回的到底是代理对象还是原始对象



## BeanFactory 和 ApplicationContext有什么区别？

### BeanFactory-框架基础设施

BeanFactory 是 Spring 框架的基础设施，面向 Spring 本身；

ApplicationContext 面向使用Spring 框架的开发者，几乎所有的应用场合我们都直接使用 ApplicationContext 而非底层的 BeanFactory。

- **BeanDefinitionRegistry 注册表** ：Spring 配置文件中每一个节点元素在 Spring 容器里都通过一个 BeanDefinition 对象表示，它描述了 Bean 的配置信息。而 BeanDefinitionRegistry 接口提供了向容器手工注册BeanDefinition 对象的方法。
- **BeanFactory 顶层接口** ：位于类结构树的顶端 ，它最主要的方法就是 getBean(String beanName)，该方法从容器中返回特定名称的 Bean，BeanFactory 的功能通过其他的接口得到不断扩展：
- **ListableBeanFactory** ：该接口定义了访问容器中 Bean 基本信息的若干方法，如查看 Bean 的个数、获取某一类型Bean 的配置名、查看容器中是否包括某一 Bean 等方法；
- **HierarchicalBeanFactory 父子级** ：父子级联 IoC 容器的接口，子容器可以通过接口方法访问父容器；通过HierarchicalBeanFactory 接口， Spring 的 IoC 容器可以建立父子层级关联的容器体系，子容器可以访问父容器中的 Bean，但父容器不能访问子容器的 Bean。Spring 使用父子容器实现了很多功能，比如在 Spring MVC 中，展现层 Bean 位于一个子容器中，而业务层和持久层的 Bean 位于父容器中。这样，展现层 Bean 就可以引用业务层和持久层的 Bean，而业务层和持久层的 Bean 则看不到展现层的 Bean。
- **ConfigurableBeanFactory** ：是一个重要的接口，增强了 IoC 容器的可定制性，它定义了设置类装载器、属性编辑器、容器初始化后置处理器等方法；
- **AutowireCapableBeanFactory 自动装配** ：定义了将容器中的 Bean 按某种规则（如按名字匹配、按类型匹配等）进行自动装配的方法；
- **SingletonBeanRegistry 运行期间注册单例 Bean** ：定义了允许在运行期间向容器注册单实例 Bean 的方法；对于单实例（ singleton）的 Bean 来说，BeanFactory 会缓存 Bean 实例，所以第二次使用 getBean() 获取 Bean 时将直接从IoC 容器的缓存中获取 Bean 实例。Spring 在 DefaultSingletonBeanRegistry 类中提供了一个用于缓存单实例 Bean 的缓存器，它是一个用 HashMap 实现的缓存器，单实例的 Bean 以beanName 为键保存在这个 HashMap 中。
- **依赖日志框架** ：在初始化 BeanFactory 时，必须为其提供一种日志框架，比如使用 Log4J， 即在类路径下提供 Log4J 配置文件，这样启动 Spring 容器才不会报错。

### ApplicationContext 面向开发应用

ApplicationContext 由 BeanFactory 派生而来，提供了更多面向实际应用的功能。

ApplicationContext 继承了 HierarchicalBeanFactory 和 ListableBeanFactory 接口，在此基础

上，还通过多个其他的接口扩展了 BeanFactory 的功能：

- ClassPathXmlApplicationContext：默认从类路径加载配置文件
- FileSystemXmlApplicationContext：默认从文件系统中装载配置文件
- ApplicationEventPublisher：让容器拥有发布应用上下文事件的功能，包括容器启动事件、关闭事件等。
- MessageSource：为应用提供 i18n 国际化消息访问的功能；
- ResourcePatternResolver ：所有 ApplicationContext 实现类都实现了类似于
- PathMatchingResourcePatternResolver：通过带前缀的 Ant 风格的资源文件路径装载 Spring 的配置文件。
- LifeCycle：该接口是 Spring 2.0 加入的，该接口提供了 start()和 stop()两个方法，主要用于控制异步处理过程。在具体使用时，该接口同时被 ApplicationContext 实现及具体Bean 实现， ApplicationContext 会将 start/stop 的信息传递给容器中所有实现了该接口的 Bean，以达到管理和控制 JMX、任务调度等目的。
- ConfigurableApplicationContext ：扩展于 ApplicationContext，它新增加了两个主要的方法：refresh()和 close()，让 ApplicationContext 具有启动、刷新和关闭应用上下文的能力。在应用上下文关闭的情况下调用 refresh()即可启动应用上下文，在已经启动的状态下，调用 refresh()则清除缓存并重新装载配置信息，而调用 close()则可关闭应用上下文。

### 区别

BeanFactory和ApplicationContext是Spring的两大核心接口，都可以当做Spring的容器。其中ApplicationContext是BeanFactory的子接口。

#### 依赖关系

BeanFactory：是Spring里面最底层的接口，包含了各种Bean的定义，读取bean配置文档，管理bean的加载、实例化，控制bean的生命周期，维护bean之间的依赖关系。

ApplicationContext：接口作为BeanFactory的派生，除了提供BeanFactory所具有的功能外，还提供了更完整的框架功能：

- 继承MessageSource，因此支持国际化。
- 统一的资源文件访问方式。
- 提供在监听器中注册bean的事件。
- 同时加载多个配置文件。
- 载入多个（有继承关系）上下文 ，使得每一个上下文都专注于一个特定的层次，比如应用的web层。

#### 加载方式

BeanFactroy：采用的是延迟加载形式来注入Bean的，即只有在使用到某个Bean时(调getBean())，才对该Bean进行加载实例化。这样，我们就不能发现一些存在的Spring的配置问题。如果Bean的某一个属性没有注入，BeanFacotry加载后，直至第一次使用调用getBean方法才会抛出异常。

ApplicationContext：它是在容器启动时，一次性创建了所有的Bean。这样，在容器启动时，我们就可以发现Spring中存在的配置错误，这样有利于检查所依赖属性是否注入。ApplicationContext启动后预载入所有的单实例Bean，通过预载入单实例bean ,确保当你需要的时候，你就不用等待，因为它们已经创建好了。

相对于基本的BeanFactory，ApplicationContext 唯一的不足是占用内存空间。当应用程序配置Bean较多时，程序启动较慢。

#### 创建方式

BeanFactory通常以编程的方式被创建，ApplicationContext还能以声明的方式创建，如使用ContextLoader。

#### 注册方式

BeanFactory和ApplicationContext都支持BeanPostProcessor、BeanFactoryPostProcessor的使用，但两者之间的区别是：BeanFactory需要手动注册，而ApplicationContext则是自动注册。

#### ApplicationContext通常的实现

- FileSystemXmlApplicationContext ：此容器从一个XML文件中加载beans的定义，XML Bean 配置文件的全路径名必须提供给它的构造函数。
- ClassPathXmlApplicationContext：此容器也从一个XML文件中加载beans的定义，这里，你需要正确设置classpath因为这个容器将在classpath里找bean配置。
- WebXmlApplicationContext：此容器加载一个XML文件，此文件定义了一个WEB应用的所有bean。



## 五种不同方式的自动装配

Spring 装配包括手动装配和自动装配，手动装配是有基于 xml 装配、构造方法、setter 方法等自动装配有五种自动装配的方式，可以用来指导 Spring 容器用自动装配方式来进行依赖注入。

- `no`：默认的方式是不进行自动装配，通过显式设置 ref 属性来进行装配。
- `byName`：通过参数名 自动装配，Spring 容器在配置文件中发现 bean 的 autowire 属性被设置成 byName，之后容器试图匹配、装配和该 bean 的属性具有相同名字的 bean。
- `byType`：通过参数类型自动装配，Spring 容器在配置文件中发现 bean 的 autowire 属性被设置成 byType，之后容器试图匹配、装配和该 bean 的属性具有相同类型的 bean。如果有多个 bean 符合条件，则抛出错误。
- `constructor`：这个方式类似于 byType， 但是要提供给构造器参数，如果没有确定的带参数的构造器参数类型，将会抛出异常。
- `autodetect`：首先尝试使用 constructor 来自动装配，如果无法工作，则使用 byType 方式。



## Spring通知类型

在AOP术语中，切面的工作被称为通知，实际上是程序执行时要通过SpringAOP框架触发的代码段。Spring切面可以应用5种类型的通知：

- 前置通知（Before）：在目标方法被调用之前调用通知功能；
- 后置通知（After）：在目标方法完成之后调用通知，此时不会关心方法的输出是什么；
- 返回通知（After-returning ）：在目标方法成功执行之后调用通知；
- 异常通知（After-throwing）：在目标方法抛出异常后调用通知；
- 环绕通知（Around）：通知包裹了被通知的方法，在被通知的方法调用之前和调用之后执行自定义的行为。

### 同一个aspect，不同advice的执行顺序

没有异常情况下的执行顺序：

- around before advice
- before advice
- target method 执行
- around after advice
- after advice
- afterReturning

有异常情况下的执行顺序：

- around before advice
- before advice
- target method 执行
- around after advice
- after advice
- afterThrowing:异常发生
- java.lang.RuntimeException: 异常发生





###### 来源：

https://www.cnblogs.com/pengsay/p/16368104.html

https://www.bilibili.com/video/BV1aa411j72q
