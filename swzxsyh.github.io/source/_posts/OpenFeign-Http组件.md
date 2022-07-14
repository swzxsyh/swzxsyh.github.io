---
title: OepnFeign-Http组件
date: 2022-07-05 17:46:09
tags:
---

# OpenFeign

## 介绍

Feign 就是一个 Http 客户端的模板，目标是减少 HTTP API 的复杂性，希望能将 HTTP 远程服务调用做到像 RPC 一样易用。Feign 集成 RestTemplate、Ribbon 实现了客户端的负载均衡的 Http 调用，并对原调用方式进行了封装，使得开发者不必手动使用 RestTemplate 调用服务，而是声明一个接口，并在这个接口中标注一个注解即可完成服务调用，这样更加符合面向接口编程的宗旨，客户端在调用服务端时也不需要再关注请求的方式、地址以及是 forObject 还是 forEntity，结构更加明了，耦合也更低，简化了开发。

在 Feign 的基础上，衍生出了 openFeign。

openFeign 在 Feign 的基础上支持了 SpringMVC 的注解，如 @RequestMapping 等。OpenFeign 的 @FeignClient 可以解析 SpringMVC 的 @RequestMapping 注解下的接口，并通过动态代理的方式产生实现类，实现类中做负载均衡并调用其他服务。

总的就是，openFeign 作为微服务架构下服务间调用的解决方案，是一种声明式、模板化的 HTTP 的模板，使 HTTP 请求就像调用本地方法一样，通过 openFeign 可以替代基于 RestTemplate 的远程服务调用，并且默认集成了 Ribbon 进行负载均衡。

<!-- more -->

### openFeign 默认的超时时间的

默认分别是连接超时时间 10秒、读超时时间 60秒，源码在 feign.Request.Options#Options() 这个方法中

openFeign 集成了 Ribbon，如果openFeign没有设置对应得超时时间，那么将会采用Ribbon的默认超时时间(Ribbon 的默认超时连接时间、读超时时间都是是1秒，源码在org.org.springframework.cloud.openfeign.ribbon.FeignLoadBalancer#execute()方法中)。由之产生两种方案，如下：

- 设置openFeign的超时时间
- 设置Ribbon的超时时间

## 替换的 HTTP 客户端：

openFeign 默认使用的是 JDK 原生的 **URLConnection** 发送 HTTP 请求，没有连接池，但是对每个地址会保持一个长连接，即利用 HTTP 的 persistence connection。在生产环境中，通常不使用默认的 http client。

### 通常有两种选择

#### ApacheHttpClient

#### OkHttp









###### 来源：

Feign https://blog.csdn.net/a745233700/article/details/122916856

openFeign 与 Ribbon 的联系：https://www.cnblogs.com/unchain/p/13405814.html

https://developer.51cto.com/article/699142.html
