---
title: SpringBoot-面试题
date: 2022-07-05 19:01:55
tags:
---

# SpringBoot 面试题

## Spring Boot 的核心注解是哪个？它主要由哪几个注解组成的？

启动类上面的注解是@SpringBootApplication，它也是 Spring Boot 的核心注解，主要组合包含 了以下` 3 个注解`：

`@SpringBootConfiguration：`组合了 @Configuration 注解，实现配置文件的功能。

`@EnableAutoConfiguration：`打开自动配置的功能，也可以关闭某个自动配置的选项

`@ComponentScan`：Spring组件扫描。

## SpringBoot 生命周期

SpringBoot应用的生命周期，整体上可以分为SpringApplication初始化阶段、SpringApplication运行阶段、SpringApplication结束阶段、SpringBoot应用退出四个阶段。

<!-- more -->

## Spring Boot 支持哪些日志框架？推荐和默认的日志框架是哪个？

Spring Boot 支持 Java Util Logging, Log4j2, Lockback 作为日志框架，如果你使用 Starters 启动 器，`Spring Boot 将使用 Logback 作为默认日志框架`，但是不管是那种日志框架他都支持将配置 文件输出到控制台或者文件中。

## SpringBoot Starter的工作原理

我个人理解SpringBoot就是由各种Starter组合起来的，我们自己也可以开发Starter `在sprinBoot启动时由@SpringBootApplication注解会自动去maven中读取每个starter中的spring.factories文件`,该文件里配置了所有需要被创建spring容器中的bean，`并且进行自动配置把bean注入SpringContext中 `（SpringContext是Spring的配置文件）

## 开启 Spring Boot 特性有哪几种方式？

1. 继承spring-boot-starter-parent项目
2. 导入spring-boot-dependencies项目依赖

## SpringBoot 实现热部署有哪几种方式？

热部署就是可以不用重新运行SpringBoot项目可以实现操作后台代码自动更新到以运行的项目中 主要`有两种方式`：

- Spring Loaded
- Spring-boot-devtools

## SpringBoot事务的使用

SpringBoot的事务很简单，首先使用注解`@EnableTransactionManagement`开启事务之后，然后在 Service方法上添加注解`Transactional`便可。

## Async异步调用方法

在SpringBoot中使用异步调用是很简单的，只需要在方法上使用@Async注解即可实现方法的异步 调用。 注意：需要在启动类加入@EnableAsync使异步调用@Async注解生效。

## 如何在 Spring Boot 启动的时候运行一些特定的代码？

可以实现接口 `ApplicationRunner` 或者 `CommandLineRunner`，这两个接口实现方式一样，它们都只提供了一个 `run` 方法

## Spring Boot 有哪几种读取配置的方式？

Spring Boot 可以通过` @PropertySource,@Value,@Environment, @ConfigurationPropertie注解`来绑定变量

## 什么是 JavaConfig？

Spring JavaConfig 是 Spring 社区的产品，Spring 3.0引入了他，它提供了配置 Spring IOC 容器的纯Java 方法。因此它有助于避免使用 XML 配置。使用 JavaConfig 的优点在于：

- 面向对象的配置。由于配置被定义为 JavaConfig 中的类，因此用户可以充分利用 Java 中的面向对象功能。一个配置类可以继承另一个，重写它的@Bean 方法等。
- 减少或消除 XML 配置。基于依赖注入原则的外化配置的好处已被证明。但是，许多开发人员不希望在 XML 和 Java 之间来回切换。JavaConfig 为开发人员提供了一种纯 Java 方法来配置与 XML 配置概念相似的 Spring 容器。从技术角度来讲，只使用 JavaConfig 配置类来配置容器是可行的，但实际上很多人认为将JavaConfig 与 XML 混合匹配是理想的。
- 类型安全和重构友好。JavaConfig 提供了一种类型安全的方法来配置 Spring容器。由于 Java5.0 对泛型的支持，现在可以按类型而不是按名称检索 bean，不需要任何强制转换或基于字符串的查找。

**「常用的Java config：」**

```java
@Configuration：在类上打上写下此注解，表示这个类是配置类

@ComponentScan：在配置类上添加 @ComponentScan 注解。该注解默认会扫描该类所在的包下所有的配置类，相当于之前的 <context:component-scan >。

@Bean：bean的注入：相当于以前的< bean id="objectMapper" class="org.codehaus.jackson.map.ObjectMapper" />

@EnableWebMvc：相当于xml的<mvc:annotation-driven >

@ImportResource： 相当于xml的 < import resource="applicationContextcache.xml">
```



## SpringBoot的自动配置原理是什么

主要是Spring Boot的启动类上的核心注解SpringBootApplication注解主配置类，有了这个主配置 类启动时就会为SpringBoot开启一个`@EnableAutoConfiguration`注解自动配置功能。 有了这个EnableAutoConfiguration的话就会：

1. 从配置文件*META_INF/Spring.factories*加载可能用到的自动配置类
2. 去重，并将exclude和excludeName属性携带的类排除
3. 过滤，将满足条件*（@Conditional）*的自动配置类返回

## YAML 配置的优势在哪里

YAML现在可以算是非常流行的一种配置文件格式了，无论是前端还是后端，都可以见到YAML配
置。那么YAML配置和传统的properties配置相比到底有哪些优势呢？

- 配置有序，在一些特殊的场景下，配置有序很关键
- 简洁明了，他还支持数组，数组中的元素可以是基本数据类型也可以是对象
- 相比properties配置文件，YAML还有一个缺点，就是不支持@PropertySource注解导入自定义的YAML配置

## Spring Boot 是否可以使用 XML 配置 ?

- Spring Boot 推荐使用 Java 配置而非 XML 配置，但是 Spring Boot 中也可以使用 XML 配置，通过 @ImportResource 注解可以引入一个 XML 配置。

### Spring boot 核心配置文件是什么？bootstrap.properties 和 application.properties 有何区别

- 单纯做SpringBoot开发，可能不太容易遇到bootstrap.properties配置文件，但是在结合
  SpringCloud时，这个配置就会经常遇到了，特别是在需要加载一些远程配置文件的时侯。
- springboot核心的两个配置文件：
  - bootstrap (. yml或. properties): boostrap由父Application Context加载，比
    applicaton优先加载，配置在应用程序上下文的引导阶段生效。一般来说我们在Spring
    cloud配置就会使用这个文件。且boostrap里面的属性不能被覆盖；
  - application (.yml =或. properties): 由ApplicatonContext 加载，用于Spring boot 项目的自动化配置

## 什么是 Spring Profiles

- Spring Profiles机制给我们提供的就是来回切换配置文件的功能
- SpringProfiles允许用户根据配置文件(dev，test,prod等）来注册bean。因此，当应用程序
  在开发中运行时，只有某些Bean可以加载，而在Production中，某些其他Bean可以加载。
  假设我们的要求是Swagger文档仅适用于QA环境，并且禁用所有其他文档。这可以使用配置文
  件来完成。SpringBoot使得使用配置文件非常简单

## SpringBoot多数据源拆分的思路

- 先在properties配置文件中配置两个数据源，创建分包mapper，使用@ConfifigurationProperties读取properties中的配置，使用@MapperScan注册到对应的mapper包中

## SpringBoot多数据源事务如何管理

- 第一种方式是在service层的@TransactionManager中使用transactionManager指定DataSourceConfifig中配置的事务
- 第二种是使用jta-atomikos实现分布式事务管理

## 保护 Spring Boot 应用有哪些方法？

- 在生产中使用HTTPS
- 使用Snyk检查你的依赖关系
- 升级到最新版本
- 启用CSRF保护
- 使用内容安全策略防止XSS攻击

## Spring Boot 中如何解决跨域问题 ?

- 跨域可以在前端通过 JSONP 来解决，但是 JSONP 只可以发送 GET 请求，无法发送其他类型的请求，在 RESTful 风格的应用中，就显得非常鸡肋，因此我们推荐在后端通过 （CORS，Crossorigin resource sharing） 来解决跨域问题。这种解决方案并非 Spring Boot 特有的，在传统的SSM 框架中，就可以通过 CORS 来解决跨域问题，只不过之前我们是在 XML 文件中配置 CORS ，现在可以通过实现WebMvcConfifigurer接口然后重写addCorsMappings方法解决跨域问题。

  ```java
  @Configuration
  public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
      registry.addMapping("/**")
        .allowedOrigins("*")
        .allowCredentials(true)
        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
        .maxAge(3600);
    }
  }
  ```

  

## SpringBoot异常处理相关注解?

- @ControllerAdvice
- @ExceptionHandler

## SpringBoot配置监控?

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

来源：

https://zhuanlan.zhihu.com/p/474889994

https://developer.aliyun.com/article/943628
