---
title: Apache Dubbo 初识
date: 2020-06-19 01:52:09
tags:
---

一.应用架构的演进过程
目标

了解软件架构的演进过程

学习路径

主流的互联网技术特点
架构演变的过程
单体架构
垂直架构
分布式服务架构
SOA架构
微服务架构
1.1 主流的互联网技术特点
分布式 、高并发、集群、负载均衡、高可用。

分布式：一件事情拆开来做。

集群：一件事情所有服务器一起做。

负载均衡：将请求平均分配到不同的服务器中，达到均衡的目的。

高并发：同一时刻，处理同一件事情的处理能力（解决方案：分布式、集群、负载均衡）

高可用：系统都是可用的。

1.2. 架构演变的过程
1.2.1 单一应用架构（all in one）
当网站流量很小时，只需一个应用，将所有功能都部署在一起，以减少部署节点和成本。此时，用于简化增删改查工作量的数据访问框架(ORM)是关键。

架构优点：

架构简单，前期开发成本低、开发周期短，适合小型项目（OA、CRM、ERP 企业内部应用）。

架构缺点：

全部功能集成在一个工程中

业务代码耦合度高，不易维护。

维护成本高，不易拓展

并发量大，不易解决

技术栈受限，只能使用一种语言开发。

1.2.2 垂直应用架构
当访问量逐渐增大，单一应用增加机器带来的加速度越来越小，将应用拆成互不相干的几个应用，以提升效率。此时，用于加速前端页面开发的Web框架(MVC)是关键。

架构优点：

业务代码相对解耦

维护成本相对易于拓展（修改一个功能，可以直接修改一个项目，单独部署）

并发量大相对易于解决（搭建集群）

技术栈可扩展（不同的系统可以用不同的编程语言编写）。

架构缺点：

功能集中在一个项目中，不利于开发、扩展、维护。

代码之间存在数据、方法的冗余

1.2.3 分布式服务架构
当垂直应用越来越多，应用之间交互不可避免，将核心业务抽取出来，作为独立的服务，逐渐形成稳定的服务中心，使前端应用能更快速的响应多变的市场需求。此时，用于提高业务复用及整合的分布式服务框架(RPC)是关键。

架构优点：

业务代码完全解耦，并可实现通用

维护成本易于拓展（修改一个功能，可以直接修改一个项目，单独部署）

并发量大易于解决（搭建集群）

技术栈完全扩展（不同的系统可以用不同的编程语言编写）。

架构缺点：

缺少统一管理资源调度的框架

1.2.4 流动计算架构（SOA）
当服务越来越多，容量的评估，小服务资源的浪费等问题逐渐显现，此时需增加一个调度中心基于访问压力实时管理集群容量，提高集群利用率。此时，用于提高机器利用率的资源调度和治理中心(SOA)是关键。

架构优点
业务代码完全解耦，并可实现通用
维护成本易于拓展（修改一个功能，可以直接修改一个项目，单独部署）
并发量大易于解决（搭建集群）
技术栈完全扩展（不同的系统可以用不同的编程语言编写）。
框架实现了服务治理，不去担心集群的使用情况(失败会尝试其它服务….)
1.2.5 小结
单体架构

全部功能集中在一个项目内（All in one）。

垂直架构

按照业务进行切割，形成小的单体项目。

分布式

应用调用服务，服务挂了，有其它可用，缺少服务治理

SOA架构

服务的提供者（以服务为主 service调用dao->数据库），消费者。
服务提供者与消费都注册到中心，由中心统一管理分配，失败重试，负载均衡。。。有服务治理
可以使用dubbo作为调度的工具（RPC协议）, Zookeeper作为注册中心
微服务架构

将系统服务层完全独立出来，抽取为一个一个的微服务。 以功能为主(controller->service-dao->数据库 独立)
特点一：抽取的粒度更细，遵循单一原则，数据可以在服务之间完成数据传输（一般使用restful请求调用资源）。
特点二： 采用轻量级框架协议传输。（可以使用spring cloud）（http协议 restful json）
特点三： 每个服务都使用不同的数据库，完全独立和解耦 (分库分表)。
二.RPC（远程过程调用）
目标

了解什么是RPC

学习路径

RPC介绍

RPC组件

RPC调用

2.1 RPC介绍
​ Remote Procedure Call 远程过程调用，是分布式架构的核心，按响应方式分如下两种：

 同步调用：客户端调用服务方方法，等待直到服务方返回结果或者超时，再继续自己的操作。

 异步调用：客户端把消息发送给中间件，不再等待服务端返回，直接继续自己的操作。

是一种进程间的通信方式

它允许应用程序调用网络上的另一个应用程序中的方法

对于服务的消费者而言，无需了解远程调用的底层细节，是透明的

需要注意的是RPC并不是一个具体的技术，而是指整个网络远程调用过程。

RPC是一个泛化的概念，严格来说一切远程过程调用手段都属于RPC范畴。各种开发语言都有自己的RPC框架。Java中的RPC框架比较多，广泛使用的有RMI、Hessian、Dubbo、spring Cloud(restapi http)等。

2.2 RPC组件
RPC架构里包含如下4个组件:

客户端(Client)：服务调用者
客户端存根(Client Stub)：存放服务端地址信息，将客户端的请求参数打包成网络消息，再通过网络发送给服务方
服务端存根(Server Stub)：接受客户端发送过来的消息并解包，再调用本地服务
服务端(Server)：服务提供者。
2.3 RPC调用
服务调用方（client）调用以本地调用方式调用服务；
client stub接收到调用后负责将方法、参数等组装成能够进行网络传输的消息体在Java里就是序列化的过程
client stub找到服务地址，并将消息通过网络发送到服务端；
server stub收到消息后进行解码,在Java里就是反序列化的过程；
server stub根据解码结果调用本地的服务；
本地服务执行处理逻辑；
本地服务将结果返回给server stub；
server stub将返回结果打包成消息，Java里的序列化；
server stub将打包后的消息通过网络并发送至消费方；
client stub接收到消息，并进行解码, Java里的反序列化；
服务调用方（client）得到最终结果。
2.3.1 小结
RPC 远程过程调用： 一台电脑调用另一台电脑上的方法
RPC组件及调用过程 客户端->客户端存根(序列化(发送)与反序列化(接收),服务端信息)->服务端存根(接收-反序列，返回结果-序列化)->服务端真正的方法
调用方式：调用方用的是接口，服务方是真正的实现
三.Apache Dubbo概述
目标

了解什么是dubbo

学习路径

dubbo简介
dubbo架构
3.1. Dubbo简介
Apache Dubbo是一款高性能的Java RPC框架。其前身是阿里巴巴公司开源的一个高性能、轻量级的开源Java RPC框架，可以和Spring框架无缝集成。

Dubbo官网地址：http://dubbo.apache.org

Dubbo提供了三大核心能力：面向接口的远程方法调用，智能容错和负载均衡，以及服务自动注册和发现。

3.2. Dubbo架构


虚线都是异步访问，实线都是同步访问
蓝色:在启动时完成的功能
红色虚线(实线)都是程序运行过程中执行的功能

节点	角色名称
Provider	暴露服务的服务提供方 服务方
Consumer	调用远程服务的服务消费方 调用方
Registry	服务注册与发现的注册中心
Monitor	统计服务的调用次数和调用时间的监控中心
Container	服务运行容器
调用关系说明:

服务容器负责启动，加载，运行服务提供者。
服务提供者在启动时，向注册中心注册自己提供的服务。
服务消费者在启动时，向注册中心订阅自己所需的服务。
注册中心返回服务提供者地址列表给消费者，如果有变更，注册中心将基于长连接推送变更数据给消费者。
服务消费者，从提供者地址列表中，基于软负载均衡算法，选一台提供者进行调用，如果调用失败，再选另一台调用。
服务消费者和提供者，在内存中累计调用次数和调用时间，定时每分钟发送一次统计数据到监控中心。
什么是长连接

长连接多用于操作频繁，点对点的通讯，而且连接数不能太多情况。每个TCP连接都需要三步握手，这需要时间，如果每个操作都是短连接，再操作的话那么处理速度会降低很多，所以每个操作完后都不断开，下次处理时直接发送数据包就OK了，不用建立TCP连接。

3.3 小结
dubbo 远程调用框架 RPC

dubbo架构

 角色： 客户端与服务提供方 监控器注册中心

 组员：服务消费端（调用者），服务提供方（容器）, 注册中心, 监控中心(负载均衡)

四.Dubbo快速开发
目标

使用dubbo，完成服务消费者，调用，服务提供者方法

操作路径

环境准备
创建父工程（dubbo_parent) 依赖管理
创建公共子模块(dubbo_common) 实体类
创建接口子模块(dubbo_interface)
创建服务提供者模块(dubbo_provider) 对接口的实现
创建服务消费者模块(dubbo_consumer) 引用接口
Zookeeper中存放Dubbo服务结构(注册中心)
讲解

Dubbo作为一个RPC框架，其最核心的功能就是要实现跨网络的远程调用，服务提供者、服务消费者会使用共同的接口，故本小节先创建一个父工程，父工程下有4个子模块，一个是公共子模块，一个是接口模块，一个是服务提供者模块，一个是服务消费者模块。通过Dubbo来实现服务消费方远程调用服务提供方的方法。

实现的业务为：根据id查询用户对象

业务描述：页面发送请求：user/findById.do?id=1 根据id从数据库获取用户对象

实现步骤：

环境准备：创建数据库，创建t_user表
创建父工程，基于maven，打包方式为pom，工程名：dubbo_parent
创建公共子模块,创建user实体类，打包方式为jar，工程名:dubbo_common
创建接口子模块，在父工程的基础上，打包方式为jar，模块名：dubbo_interface
创建服务提供者子模块，在父工程的基础上，打包方式为war，模块名：dubbo_provider
创建服务消费者模子块，在父工程的基础上，打包方式为war，模块名：dubbo_consumer
4.1 环境准备

```sql
create database itcastdubbo;

CREATE TABLE `t_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) 
INSERT INTO t_user(username,age) VALUES("张三",22);
INSERT INTO t_user(username,age) VALUES("李四",20);
INSERT INTO t_user(username,age) VALUES("王五",25);
```


4.2 创建父工程
父工程，不实现任何代码，主要是添加工程需要的库的依赖管理（DependencyManagement），依赖管理就是解决项目中多个模块间公共依赖的版本号、scope的控制范围。

本项目需要使用spring-webmvc，使用dubbo（务必2.6.2以上版本）、zookeeper及其客户端（curator-framework）、Spring、Mybatis依赖库。

创建结构

```bash
./
├── dubbo_common
│   ├── dubbo_common.iml
│   ├── pom.xml
│   └── src
│       ├── main
│       └── test
├── dubbo_consumer
│   ├── pom.xml
│   └── src
│       ├── main
│       └── test
├── dubbo_interface
│   ├── pom.xml
│   └── src
│       ├── main
│       └── test
├── dubbo_parent.iml
├── dubbo_provider
│   ├── pom.xml
│   └── src
│       ├── main
│       └── test
└── pom.xml
dubbo_parent pom.xml增加依赖
```



详细信息
4.3 公共子模块 —— dubbo-common
pom.xml

```xml
<artifactId>dubbo_common</artifactId>
<packaging>jar</packaging>
```


创建User实体类

```java
public class User implements Serializable {
  private Integer id;
  private String username;
  private Integer age;
  //此处省略getter/setter/toString
}
```

4.4 接口子模块 —— dubbo_interface
pom.xml

```xml
<artifactId>dubbo_interface</artifactId>
<packaging>jar</packaging>

<dependencies>
  <dependency>
    <groupId>org.example</groupId>
    <artifactId>dubbo_common</artifactId>
    <version>1.0-SNAPSHOT</version>
  </dependency>
</dependencies>
```


UserService

1
2
3
public interface UserService {
    User findById(Integer id);
}
4.5 服务提供者模块
此模块是服务提供者模块，需要在容器启动时，把服务注册到zookeeper,故需要引入spring-webmvc,zookeeper及客户端依赖。

使用war 方式，需要依赖dubbo_interface

结构

```bash
./
├── pom.xml
└── src
├── main
│   ├── java
│   │   └── com
│   │       └── test
│   │           ├── dao
│   │           │   └── UserDao.java
│   │           └── service
│   │               └── impl
│   │                   └── UserServiceImpl.java
│   ├── resources
│   │   ├── com
│   │   │   └── test
│   │   │       └── dao
│   │   │           └── UserDao.xml
│   │   ├── jdbc.properties
│   │   ├── spring-dao.xml
│   │   ├── spring-provider.xml
│   │   └── spring-service.xml
│   └── webapp
│       └── WEB-INF
│           └── web.xml
└── test
└── java
```

4.5.1 配置dubbo_provider依赖
pom.xml

详细信息
4.5.2 初始化java资源目录
UserDao

```java
public interface UserDao {
  User findById(Integer id);
}
```


UserServiceImpl

```java
@Service
public class UserServiceImpl implements UserService {@Autowired
private UserDao userDao;

@Override
public User findById(Integer id) {
return userDao.findById(id);
}
```
}
在resource下创建com/test/dao目录，创建UserDao接口的映射文件


```xml
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="com.test.dao.UserDao">
  
<?xml version="1.0" encoding="utf-8" ?>
<select id="findById" resultType="com.test.pojo.User" parameterType="int">
  select * from t_user where id = #{id}
</select>
```
</mapper>
4.5.3 初始化resources目录
spring-dao.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">
  <!--  加载jdbc配置文件   -->
  <context:property-placeholder location="classpath:jdbc.properties"/>

  <!-- 数据源   -->
  <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
    <property name="driverClassName" value="${jdbc.driver}"/>
    <property name="url" value="${jdbc.url}"/>
    <property name="username" value="${jdbc.user}"/>
    <property name="password" value="${jdbc.password}"/>
  </bean>
  <!-- 工厂 -->
  <bean class="org.mybatis.spring.SqlSessionFactoryBean">
    <property name="dataSource" ref="dataSource"/>
    <property name="typeAliasesPackage" value="com.test.pojo"/>
  </bean>
  <!-- dao扫描   -->
  <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
    <property name="basePackage" value="com.test.dao"/>
  </bean>
</beans>
```


jdbc.properties

```properties
jdbc.driver=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/itcastdubbo
jdbc.user=root
jdbc.password=root
spring-service.xml
```



```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tx="http://www.springframework.org/schema/tx"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx.xsd">

  <!--  事务管理器  -->
  <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource" ref="dataSource"/>
  </bean>
  <!--  事务注解  -->
  <tx:annotation-driven/>
  <!--  注入dao  -->
  <import resource="classpath:spring-dao.xml"/>
</beans>
```


spring-provider.xml


    
```xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://dubbo.apache.org/schema/dubbo http://dubbo.apache.org/schema/dubbo/dubbo.xsd">
  <!--  发布服务的名称  -->
  <dubbo:application name="dubbo_provider"/>
  <!--  注册中心zookeeper:-->
  <dubbo:registry address="zookeeper://127.0.0.1:2181"/>
  <!-- service:  注册上去服务
interface： 发布服务的接口
ref: spring容器的bean对象
将来通过这个interface调用服务时，就来调用spring容器中的对象的方法
-->
  <dubbo:service interface="com.test.service.UserService" ref="userService"/>
  <!--  服务真正的执行者  -->
  <bean id="userService" class="com.test.service.impl.UserServiceImpl"/>
  <!--  注入spring-service.xml  -->
  <import resource="classpath:spring-service.xml"/>

  <!--发布dubbo协议，默认端口20880-->
  <dubbo:protocol name="dubbo" port="20881"/>
  <!-- 超时时间 -->
  <dubbo:provider timeout="100000"/>
```
</beans>
log4j.properties

```properties
### direct log messages to stdout ###

log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target=System.err
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%d{ABSOLUTE} %5p %c{1}:%L - %m%n

### direct messages to file mylog.log ###

log4j.appender.file=org.apache.log4j.FileAppender
log4j.appender.file.File=c:\\mylog.log
log4j.appender.file.layout=org.apache.log4j.PatternLayout
log4j.appender.file.layout.ConversionPattern=%d{ABSOLUTE} %5p %c{1}:%L - %m%n

### set log levels - for more verbose logging change 'info' to 'debug' ###

log4j.rootLogger=debug, stdout
```

4.5.4 启动项目
只要能启动spring的容器（加载spring的配置文件）就可以启动项目，因此有2种方式

ClassPathXmlApplication

```java
public class ProviderApplication {
  public static void main(String[] args) throws IOException {
    new ClassPathXmlApplicationContext("classpath:spring-provider.xml");
    System.in.read();
  }
}
```


监听器与springMVC

web.xml


```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://java.sun.com/xml/ns/javaee"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
         version="2.5">
  <!-- 方式一: listener 启动spring容器
<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>classpath:spring-provider.xml</param-value>
</context-param>
<listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>
  -->
  <!-- 方式二: 启动mvc的核心控制器   -->
  <servlet>
    <servlet-name>dispatcherServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:spring-provider.xml</param-value>
    </init-param>
    <load-on-startup>4</load-on-startup>
  </servlet>
  <servlet-mapping>
    <servlet-name>dispatcherServlet</servlet-name>
    <url-pattern>/*</url-pattern>
  </servlet-mapping>
```
</web-app>
4.5.5 注册中心验证
启动zookeeper，作为dubbo的注册中心

登录zookeeper客户端，直接查看ls /dubbo/com.test.service.UserService节点

```bash
[zk: localhost:2181(CONNECTED) 34] ls /dubbo/com.test.service.UserService
[configurators, providers]
```


如果 /dubbo下面没有这个节点，说明没有注册上，

如果有，内容是空，说明已经掉线

正常注册并连接在线

```bash
[zk: localhost:2181(CONNECTED) 35] ls /dubbo/com.test.service.UserService/providers
[dubbo%3A%2F%2F10.254.4.87%3A20880%2Fcom.test.service.UserService%3Fanyhost%3Dtrue%26application%3Ddubbo_provide%26dubbo%3D2.6.2%26generic%3Dfalse%26interface%3Dcom.test.service.UserService%26methods%3DfindById%26pid%3D33771%26revision%3D1.0-SNAPSHOT%26side%3Dprovider%26timestamp%3D1592563739288]
```


注意：

消费者与提供者应用名称不能相同

如果有多个服务提供者，名称不能相同，通信端口也不能相同

只有服务提供者才会配置服务发布的协议，默认是dubbo协议，端口号是20880

可以在spring-dubbo.xml中配置协议的端口

4.6 服务消费者模块
此模块是服务消费者模块，此模块基于是Web应用，需要引入spring-webmvc，需要在容器启动时，去zookeeper注册中心订阅服务,需要引入dubbo、zookeeper及客户端依赖。

4.6.1 子模块dubbo_consumer导包
pom.xml

```xml
<artifactId>dubbo_consumer</artifactId>
<packaging>war</packaging>

<dependencies>
  <dependency>
    <groupId>org.example</groupId>
    <artifactId>dubbo_interface</artifactId>
    <version>1.0-SNAPSHOT</version>
  </dependency>
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
  </dependency>
  <dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-core</artifactId>
    <version>2.9.0</version>
  </dependency>
  <dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.9.0</version>
  </dependency>
  <dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-annotations</artifactId>
    <version>2.9.0</version>
  </dependency>
  <dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>servlet-api</artifactId>
    <version>2.5</version>
    <scope>provided</scope>
  </dependency>

  <dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>dubbo</artifactId>
  </dependency>
  <dependency>
    <groupId>org.apache.zookeeper</groupId>
    <artifactId>zookeeper</artifactId>
  </dependency>
  <dependency>
    <groupId>org.apache.curator</groupId>
    <artifactId>curator-framework</artifactId>
  </dependency>
  <dependency>
    <groupId>org.apache.curator</groupId>
    <artifactId>curator-recipes</artifactId>
  </dependency>
</dependencies>
```

4.6.2 初始化java资源目录
UserController

```java
@RestController
@RequestMapping("/user")
public class UserController {

  @Reference(loadbalance = "roundrobin")
  private UserService userService;

  @RequestMapping("/findById")
  public User findById(Integer id){
    // 调用服务
    User user = userService.findById(id);
    // 返回json数据
    return user;
  }
```
}
4.6.3 初始化resources资源目录
spring-dubbo.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://dubbo.apache.org/schema/dubbo http://dubbo.apache.org/schema/dubbo/dubbo.xsd">
  <!--  发布的名称  -->
  <dubbo:application name="dubbo_consumer"/>
  <!--  注册中心  -->
  <dubbo:registry address="zookeeper://127.0.0.1:2181"/>
  <!--  服务订阅扫包
      (2.6.0 事务问题)使用了服务的那controller的包, springmvc中的controller也不需要扫包了
      <dubbo:reference>就不要了
      在controller的服务注入使用@Reference(dubbo)
  -->
  <dubbo:annotation package="com.test"/>
  <!--  id的值必须与controller中的@autowired的属性名称要一致
    <dubbo:reference interface="com.test.service.UserService" id="userService"/>
   -->
  <!--  启动时是否检查服务提供者是否存在，true: 则会检查【上线时】，没有则报错。false不检查
     retries: 失败后的重试次数
     -->
  <dubbo:consumer check="false" timeout="2000" retries="2"/>
</beans>
```


spring-mvc.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">
  <!--  扫controller-->
  <context:component-scan base-package="com.test.controller"/>
  <!--  注解驱动  -->
  <mvc:annotation-driven/>
  <!--  引入dubbo配置文件-->
  <import resource="classpath:spring-dubbo.xml"/>
</beans>
```

log4j.properties

之前的配置文件直接复制即可

web.xml

```xml

<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://java.sun.com/xml/ns/javaee"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
         version="2.5">
  <servlet>
    <servlet-name>DispatcherServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:spring-mvc.xml</param-value>
    </init-param>
    <load-on-startup>4</load-on-startup>
  </servlet>
  <servlet-mapping>
    <servlet-name>DispatcherServlet</servlet-name>
    <url-pattern>/</url-pattern>
  </servlet-mapping>

  <filter>
    <filter-name>CharacterEncodingFilter</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
      <param-name>encoding</param-name>
      <param-value>UTF-8</param-value>
    </init-param>
  </filter>
  <filter-mapping>
    <filter-name>CharacterEncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
</web-app>
```

4.6.5 启动服务消费者并测试
访问：localhost:8081/dubbo_consumer/user/findById?id=3
显示：{“id”:3,”username”:”C”,”age”:25}
注意：因为是RPC的框架，要求传递的参数和实体类要实现序列化

参数：Integer类型（实现序列化接口java.io.Serializable）

返回值：User（实现序列化接口java.io.Serializable），如果不进行序列化，抛出异常

4.7 Zookeeper中存放Dubbo服务结构（作为Dubbo运行的注册中心）
Zookeeper树型目录服务：



流程说明

服务提供者(Provider)启动时: 向 /dubbo/com.foo.BarService/providers 目录下写入自己的 URL 地址

服务消费者(Consumer)启动时: 订阅 /dubbo/com.foo.BarService/providers 目录下的提供者 URL 地址。并向 /dubbo/com.foo.BarService/consumers 目录下写入自己的 URL 地址

监控中心(Monitor)启动时: 订阅 /dubbo/com.foo.BarService 目录下的所有提供者和消费者 URL 地址

4.8 小结
dubbo_parent 版本控制
dubbo_common 实体类
dubbo_interface 共用接口
dubbo_provider 服务提供者 dao(spring-dao.xml 整合mybatis), 事务(spring-service.xml), 注册到注册中心(spring-prodvider.xml)
启动方式： 3种 推荐开发中用main方法类，tomcat来启动(监听器，springmvc的方式)

dubbo_consumer controller接收参数调用服务接口 spring-mvc.xml, 注册到注册中心 spring-dubbo.xml web.xml dispatcherServlet tomcat来启动

子模块工程间的关系

dubbo_consumer依赖于dubbo_interface(依赖于common) war tomcat
dubbo_provider(service,dao)依赖于dubbo_interface(依赖于common) war tomcat
五.Dubbo管理控制台
我们在开发时，需要知道Zookeeper注册中心都注册了哪些服务，有哪些消费者来消费这些服务。我们可以通过部署一个管理中心来实现。其实管理中心就是一个web应用，部署到tomcat即可。

目标

Dubbo管理控制台的使用（即Dubbo监控中心）

使用路径

安装（dubbo-admin.war）
使用（dubbo-admin.war）

5.1. 安装
下载dubbo-admin.war，放入Tomcat的webapps中

```bash
$ find ./apache-tomcat-8.5.54 -name "dubbo*war*" -type f    
./apache-tomcat-8.5.54/webapps/dubbo-admin.war
```


启动Tomcat,此war文件会自动解压

```bash
$ ./apache-tomcat-8.5.54/bin/startup.sh
Using CATALINA_BASE:   /Users/swzxsyh/Program/apache-tomcat-8.5.54
Using CATALINA_HOME:   /Users/swzxsyh/Program/apache-tomcat-8.5.54
Using CATALINA_TMPDIR: /Users/swzxsyh/Program/apache-tomcat-8.5.54/temp
Using JRE_HOME:        /Library/Java/JavaVirtualMachines/jdk1.8.0_221.jdk/Contents/Home
Using CLASSPATH:       /Users/swzxsyh/Program/apache-tomcat-8.5.54/bin/bootstrap.jar:/Users/swzxsyh/Program/apache-tomcat-8.5.54/bin/tomcat-juli.jar
Tomcat started.
```


修改WEB-INF下的dubbo.properties文件

```properties
# 注意dubbo.registry.address对应的值需要对应当前使用的Zookeeper的ip地址和端口号

dubbo.registry.address=zookeeper://localhost:2181
dubbo.admin.root.password=root
dubbo.admin.guest.password=guest
重启tomcat
```

5.2. 使用
访问

```bash
localhost:8080/dubbo-admin/
```

账号密码都为admn或都为guest，上方配置文件中配置的

启动服务提供者工程和服务消费者工程，可以在查看到对应的信息

5.3 小结
安装（dubbo-admin.war），放置到tomcat webapp目录下，zookeeper不是本地则要修改WEB-INF下的dubbo.properties文件， 改zookeeper的ip地址。

使用（dubbo-admin.war）

访问localhost:8080/dubbo-admin/，输入用户名(root)和密码(root)

六.Dubbo相关配置说明
目标

Dubbo相关配置说明

路径

包扫描（dubbo注解配置）

服务接口访问协议dubbo协议

rmi协议

启动时检查

超时调用

6.1. 包扫描
1
<dubbo:annotation package="com.test.service" />
服务提供者和服务消费者前面章节实现都是基于配置文件进行服务注册与订阅，如果使用包扫描，可以使用注解方式实现，推荐使用这种方式。

6.1.1 服务提供者，使用注解实现
在spring-dubbo.xml中配置

1
<dubbo:annotation package="com.test.service" />
服务提供者和服务消费者都需要配置，表示包扫描，作用是扫描指定包(包括子包)下的类。

同时去掉以下配置：

```xml
<!--指定暴露的服务接口及实例-->
<dubbo:service interface="com.test.service.UserService"
               ref="userSerivce"/>
<!--配置业务类实例-->
<bean id="userSerivce"
      class="com.test.service.impl.UserServiceImpl"/>
```


在Controller类中使用@Reference注解

```java
@Reference(loadbalance = "roundrobin")
private UserService userService;
```


注意：其中@Reference是dubbo包下（com.alibaba.dubbo.config.annotation.Reference）的注解。表示订阅服务

6.1.3 重启服务测试使用
重启服务提供者模块 dubbo-provider

重启服务消费者模块 dubbo-consumer

在浏览器输入测试URL：localhost:8081/dubbo_consumer/user/findById?id=3

6.2 服务接口访问协议【提供方修改】
1
<dubbo:protocol name="dubbo" port="20881"></dubbo:protocol>
一般在服务提供者一方配置，可以指定使用的协议名称和端口号。

其中Dubbo支持的协议有：dubbo、rmi、hessian、http、webservice、rest、redis等。

推荐使用的是dubbo协议，默认端口号：20880。

dubbo 协议采用单一长连接和 NIO 异步通讯，适合于小数据量、大并发的服务调用，以及服务消费者机器数远大于服务提供者机器数的情况。不适合传送大数据量的服务，比如传文件，传视频等，除非请求量很低。

也可以在同一个工程中配置多个协议，不同服务可以使用不同的协议， 在spring-provider.xml配置文件中添加：

```xml
<!-- 多协议配置 -->
<dubbo:protocol name="dubbo" port="20881" />
<dubbo:protocol name="rmi" port="1099" />
```


dubbo协议：

连接个数：单连接
连接方式：长连接
传输协议：TCP
传输方式：NIO异步传输
序列化：Hessian二进制序列化
适用范围：传入传出参数数据包较小（建议小于100K），消费者比提供者个数多，单一消费者无法压满提供者，尽量不要用dubbo协议传输大文件或超大字符串。
适用场景：常规远程服务方法调用
rmi协议：

连接个数：多连接
连接方式：短连接
传输协议：TCP
传输方式：同步传输
序列化：Java标准二进制序列化
适用范围：传入传出参数数据包大小混合，消费者与提供者个数差不多，可传文件。
适用场景：常规远程服务方法调用，与原生RMI服务互操作
详情使用可通过博客文章：https://www.cnblogs.com/duanxz/p/3555876.html了解

6.3 启动时检查
1
<dubbo:consumer check="false"/>
上面这个配置需要配置在服务消费者一方，如果不配置默认check值为true。Dubbo 缺省会在启动时检查依赖的服务是否可用，不可用时会抛出异常，阻止 Spring 初始化完成，以便上线时，能及早发现问题。可以通过将check值改为false来关闭检查。

建议在开发阶段将check值设置为false，在生产环境下改为true。

如果设置为true，启动服务消费者，会抛出异常，表示没有服务提供者

6.4. 超时调用
默认的情况下，dubbo调用的时间为一秒钟，如果超过一秒钟就会报错，所以我们可以设置超时时间长些，保证调用不出问题，这个时间需要根据业务来进行确定。

修改消费者 配置文件

```xml
<!--超时时间为10秒钟-->
<dubbo:consumer timeout="10000"></dubbo:consumer>
修改提供者配置文件

1
2
<!--超时时间设置为10秒钟-->
<dubbo:provider timeout="10000"></dubbo:provider>
```


6.5 小结
包扫描（dubbo注解配置）


<dubbo:annotation package="com.test"></dubbo:annotation>
服务提供方: @Service -> alibaba.dubbo包
消费方: controller, @Autowired=> @Reference-> alibaba.dubbo
服务接口访问协议

（服务提供者）

dubbo协议
rmi协议

<!--配置Dubbo的协议（dubbo协议，默认端口20880-->
<dubbo:protocol name="dubbo" port="20881"></dubbo:protocol>
<!--配置rmi的协议-->
<dubbo:protocol name="rmi" port="1099"></dubbo:protocol>
启动时检查

```xml
（服务消费者）
<dubbo:consumer check="false"></dubbo:consumer> 开发时。发布时一定为true超时调用

（服务消费者）
<dubbo:consumer check="false" timeout="10000"></dubbo:consumer>
（服务提供者）

<dubbo:provider timeout="10000"></dubbo:provider>
```




七.负载均衡
目标

Dubbo配置负载均衡

学习路径

负载均衡介绍
测试负载均衡效果
7.1. 介绍
负载均衡（Load Balance）：其实就是将请求分摊到多个操作单元上进行执行，从而共同完成工作任务。

在集群负载均衡时，Dubbo 提供了多种均衡策略（包括随机random、轮询roundrobin、最少活跃调用数leastactive），缺省【默认】为random随机调用。

配置负载均衡策略，既可以在服务提供者一方配置（@Service(loadbalance = “roundrobin”)），也可以在服务消费者一方配置（@Reference(loadbalance = “roundrobin”)），两者取一

如下在服务消费者指定负载均衡策略，可在@Reference添加@Reference(loadbalance = “roundrobin”)



```java
@RestController
@RequestMapping("/user")
public class UserController {
  @Reference(loadbalance = "roundrobin")
  private UserSerivce userService;
}
```
7.2. 测试负载均衡效果
增加一个提供者，提供相同的服务;

 正式生产环境中，最终会把服务端部署到多台机器上，故不需要修改任何代码，只需要部署到不同机器即可测试。下面我们通过启动 ProviderApplication 类来做测试

修改为轮询

```java
@RestController
@RequestMapping("/user")
public class UserController {

  @Reference(loadbalance = "roundrobin")
  private UserService userService;

  @RequestMapping("/findById")
  public User findById(Integer id){
    // 调用服务
    User user = userService.findById(id);
    // 返回json数据
    return user;
  }
}
```


先启动一个ProviderApplication

IDEA——Edit Configuration——Add New Configuration——Application——进行配置

设置可以启动多个实例

勾选刚刚配置的Application中的 Allow parallel run

修改spring-provider.xml 端口依次改为20881,20882,20883

1
2
<!-- 使用Dubbo协议的服务会在初始化时建立长连接-->
<dubbo:protocol name="dubbo" port="20881"/>
启动ProviderApplication,最终有3个，分别端口为20881，20882，20883

其中

1
2
@Reference(loadbalance = "roundrobin") 		// 表示轮询
@Reference(loadbalance = "random")       	// 表示随机（默认）
访问测试

启动消费者，访问：http://localhost:92/user/findById?id=3

7.3 小结
负载均衡: 把请求均匀分配到各服务提供者上

loadbalance:

random 随机 默认
roundrobin 轮循
leastactive 最少活跃数
consistenhash 一致哈希
八.配置中心
目标

Dubbo配置中心

路径

配置中心环境介绍

实现配置中心

（1）在Zookeeper中添加数据源所需配置

（2）在dubbo-common中导入jar包, 在这里实现配置中心的读取与监听

（3）删除数据库配置文件，数据库配置从Zookeeper上读取

添加watch机制

添加监听(数据库配置信息的节点， 节点数据变化时，重新设置数据库的配置信息，刷新容器)
获取Spring容器对象，再刷新
8.1. 环境介绍
​ 数据发布/订阅即所谓的配置中心：发布者将数据发布到ZooKeeper一系列节点上面，订阅者进行数据订阅，当数据有变化时，可以及时得到数据的变化通知，达到动态及时获取数据的目的。

现在项目中有两个提供者，配置了相同的数据源，如果此时要修改数据源，必须同时修改两个才可以。

 我们可以将数据源中需要的配置信息配置存储在zookeeper中，如果修改数据源配置，使用zookeeper的watch机制，同时对提供者的数据源信息更新。

8.2. 实现配置中心
操作路径

在zookeeper中添加数据源所需配置
在dubbo-common中导入jar包

修改数据源，读取zookeeper中数据源所需配置数据

在dubbo-common中创建工具类：SettingCenterUtil,继承PropertyPlaceholderConfigurer
编写载入zookeeper中配置文件，传递到Properties属性中
重写processProperties方法
修改spring-dao.xml
watch机制

添加监听
获取容器对象，刷新spring容器：SettingCenterUtil,实现ApplicationContextAware
8.2.1 在zookeeper中添加数据源所需配置

```bash
[zk: localhost:2181(CONNECTED) 71] create /config 'config'
Created /config
[zk: localhost:2181(CONNECTED) 72] create /config/jdbc.url 'jdbc:mysql://localhost:3306/test_01'
Created /config/jdbc.url
[zk: localhost:2181(CONNECTED) 76] create /config/jdbc.user 'root
Created /config/jdbc.user
[zk: localhost:2181(CONNECTED) 77] create /config/jdbc.password 'root' 
Created /config/jdbc.password     
[zk: localhost:2181(CONNECTED) 78] create /config/jdbc.driver 'com.mysql.jdbc.Driver'
Created /config/jdbc.driver
[zk: localhost:2181(CONNECTED) 79] 
```

8.2.2 在dubbo-common中导入jar包
详细信息
8.2.3 修改数据源，读取zookeeper中数据
8.2.3.1 在dubbo-common中创建工具类：SettingCenterUtil,继承PropertyPlaceholderConfigurer

```bash
$ cd dubbo_common/src/main/java   
 ~/P/i/d/d/s/m/java
$ tree  
.
└── com
    └── test
        ├── pojo
        │   └── User.java
        └── utils
            └── SettingCenterUtil.java
```

```java
public class SettingCenterUtil extends PropertyPlaceholderConfigurer 
```

8.2.3.2 编写载入zookeeper中配置文件，传递到Properties属性中
详细信息
8.2.3.3 重写processProperties方法

```java
/**

 * 处理properties内容,相当于此标签
 * <context:property-placeholder location="classpath:jdbc.properties"></context:property-placeholder>
 * @param beanFactoryToProcess
 * @param props
 * @throws BeansException
   */
@Override
protected void processProperties(ConfigurableListableBeanFactory beanFactoryToProcess, Properties props) throws BeansException {
  // 载入zookeeper配置信息，即从Zookeeper中获取数据源的连接信息
  loadZk(props);
  super.processProperties(beanFactoryToProcess, props);
}
```

 * 8.2.3.4 修改spring-dao.xml
 
 ```xml
 <!--  注释  加载jdbc配置文件   -->
    <!--    <context:property-placeholder location="classpath:jdbc.properties"/>-->
    <!--  添加  加载配置中心对象   -->
    <bean class="com.test.utils.SettingCenterUtil"></bean>
 ```

8.2.4 watch机制
8.2.4.1 在SettingCenterUtil中添加监听

```java
/**

   * 添加对zookeeper中数据库配置的监听
      @param props
          */
private void addWatch(Properties props){
  //connectString       连接字符串 host:port
  String connectString = "127.0.0.1:2181";
  //sessionTimeoutMs    session timeout  会话超时时间
  int sessionTimeoutMs = 1000;
  //connectionTimeoutMs connection timeout 连接超时时间
  int connectionTimeoutMs = 1000;
  //retryPolicy         retry policy to use  重试策略
  // baseSleepTimeMs  每次重试间隔时间
  // 1.创建重试策略
  RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000,1);
  // 2. 创建客户端
  CuratorFramework client = CuratorFrameworkFactory.newClient(connectString, sessionTimeoutMs, connectionTimeoutMs, retryPolicy);
  // 3. 启动
  client.start();// 启动

  TreeCache treeCache = new TreeCache(client, "/config");
  try {
    treeCache.start();
    // 添加监听
    treeCache.getListenable().addListener(new TreeCacheListener() {
      @Override
      public void childEvent(CuratorFramework client, TreeCacheEvent event) throws Exception {
        if(event.getType() == TreeCacheEvent.Type.NODE_UPDATED){
          // 如果是jdbc.url的值变更
          if(event.getData().getPath().equals("/config/jdbc.url")){
            props.setProperty("jdbc.url",new String(event.getData().getData()));
          }else if(event.getData().getPath().equals("/config/jdbc.driver")){
            // 如果 jdbc.driver变更
            props.setProperty("jdbc.driver",new String(event.getData().getData()));
          }else if(event.getData().getPath().equals("/config/jdbc.user")){
            // 用户名修改了
            props.setProperty("jdbc.user",new String(event.getData().getData()));
          }else if(event.getData().getPath().equals("/config/jdbc.password")){
            // 密码修改了
            props.setProperty("jdbc.password",new String(event.getData().getData()));
          }
          // 刷新spring容器
          applicationContext.refresh();
        }
      }
    });
  } catch (Exception e) {
    e.printStackTrace();
  }
}
```


注意：

不要关闭client，否则无法进行监控
修改完成后必须刷新spring容器的对象
8.2.4.2 获取容器对象，刷新spring容器
修改SettingCenterUtil实现ApplicationContextAware接口，重写setApplicationContext方法，获取applicationContext对象。

AbstractApplicationContext容器对象父类，提供了refresh方法，可以刷新容器中的对象，故强制转换。

在processProperties的方法中，添加addWatch(props);

```java
protected void processProperties(ConfigurableListableBeanFactory beanFactoryToProcess, Properties props) throws BeansException {
  loadZk(props);
  addWatch(props);
  super.processProperties(beanFactoryToProcess, props);
}
```


修改Zookeeper的配置

```bash
[zk: localhost:2181(CONNECTED) 79] set /config/jdbc.url "jdbc:mysql:///test"
[zk: localhost:2181(CONNECTED) 80] get /config/jdbc.url
jdbc:mysql:///test
```


8.3 小结
配置中心环境介绍 回看zookeeper配置中心的图
实现配置中心
在Zookeeper中添加数据源所需配置
在dubbo-common中导入jar包
修改数据源,读取Zookeeper中数据,继承ProperteisPlaceHolderConfigurer.processProperties, 读取zk中的数据库配置,设置进props参数
watch机制
添加监听 TreeCache, event.type=node_update, 注意：判断path 不要关闭客户端
获取容器对象且刷新
