---
title: SpringBoot
date: 2022-07-05 00:54:40
tags:
---

# SpringBoot

Springboot是Spring框架的脚手架，以达到快速构建项目，预置第三方配置，开箱即用的目的。



## Springboot两大核心：

- Spring boot如何实现自动化配置（简化配置核心）
  - 基于configuration、EnableXXX、Condition

- spring-boot-starter

<!-- more -->



## 核心功能

- 自动装配：针对Spring应用程序常见的应用功能，Springboot能自动提供相关配置
- 起步依赖：Springboot通过起步依赖为项目的依赖管理提供帮助。起步依赖其实就是特殊的maven依赖和gradle依赖，利用了传递依赖解析，把常用库聚合在一起，组成了几个为特定功能而定制的依赖。
- 端点监控：Springboot可以对正在运行的项目进行监控。

## Springboot的优点：

- 可以快速构建
- 可以对主流开发框架无配置集成
- 可以独立运行，无需外部依赖servlet容器

从本质上讲，Springboot就是Spring，它帮我们完成了一些SpringBean配置。Springboot使用“习惯优于配置”的理念，让项目快速的运行起来。

## 核心注解

- @SpringBootApplication

  在Spring Boot入口类中，唯一的一个注解就是@SpringBootApplication。它是Spring Boot项目的核心注解，用于开启自动配置，准确说是通过该注解内组合的@EnableAutoConfiguration开启了自动配置。

- @EnableAutoConfiguration

  @EnableAutoConfiguration的主要功能是启动Spring应用程序上下文时进行自动配置，它会尝试猜测并配置项目可能需要的Bean。自动配置通常是基于项目classpath中引入的类和已定义的Bean来实现的。在此过程中，被自动配置的组件来自项目自身和项目依赖的jar包中。

- @Import

  @EnableAutoConfiguration的关键功能是通过@Import注解导入的ImportSelector来完成的。从源代码得知@Import(AutoConfigurationImportSelector.class)是@EnableAutoConfiguration注解的组成部分，也是自动配置功能的核心实现者。

  

- @Conditional

  @Conditional注解是由Spring 4.0版本引入的新特性，可根据是否满足指定的条件来决定是否进行Bean的实例化及装配，比如，设定当类路径下包含某个jar包的时候才会对注解的类进行实例化操作。总之，就是根据一些特定条件来控制Bean实例化的行为。

- @Conditional衍生注解

  在Spring Boot的autoconfigure项目中提供了各类基于@Conditional注解的衍生注解，它们适用不同的场景并提供了不同的功能。通过阅读这些注解的源码，你会发现它们其实都组合了@Conditional注解，不同之处是它们在注解中指定的条件（Condition）不同。常见的衍生注解如下：

  - @ConditionalOnBean：在容器中有指定Bean的条件下。
  - @ConditionalOnClass：在classpath类路径下有指定类的条件下。
  - @ConditionalOnMissingBean：当容器里没有指定Bean的条件时。
  - @ConditionalOnMissingClass：当类路径下没有指定类的条件时。



## 启动原理

- 框架上整合第三方依赖：

- maven父集成：Springboot-start-web，集成了spring-boot-start继而集成了spring-boot-autoconfigure、spring-core、springframework等jar包

  

- 无配置文件集成SpringMvc

  - SpringbootApplication注解，是一个集合注解，主要集成了
    - SpringBootConfiguration，它本质上就是@Configuration，本身就是一个spring容器
    - 集成了@EnableAutoConfiguration，通过@Import将Spring-boot-autoconfiguration下WETA-INF下的Spring.factories中配置的Tomcat、springmvc等各种配置集成进来
    - 集成了@ComponentScan扫描并加载符合条件的组件，比如@Conponent、@Repositry等各种bean，并最终将这些Bean加载到Spring容器中

- 内置集成Tomcat



## Spring和SpringBoot关联

springboot 是 spring 家族的一个项目，他的目标是提高使用者的开发效率。

spring主要是对aop，ioc等思想做了一些实现，可以对代码做解耦。spring boot主要是简化开发一些环境的搭建。
