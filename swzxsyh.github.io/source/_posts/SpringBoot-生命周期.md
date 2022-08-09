---
title: SpringBoot-生命周期
date: 2022-07-07 19:34:50
tags:
---

# SpringBoot 生命周期

SpringBoot应用的生命周期，整体上可以分为SpringApplication初始化阶段、SpringApplication运行阶段、SpringApplication结束阶段、SpringBoot应用退出四个阶段。

<!-- more -->

## SpringApplication初始化阶段

SpringApplication初始化阶段可以分为SpringApplication构造阶段和SpringApplication配置阶段。初始化阶段以发布ApplicationStartingEvent事件为止。

- SpringApplication构造阶段

通过SpringApplication构造方法或SpringApplicationBuilder构建SpringApplication对象的过程可以归纳为构造阶段。

- SpringApplication配置阶段

SpringApplication对象创建之后，调用set或相关属性设置方法的操作可以归纳为配置阶段。

## SpringApplication运行阶段

SpringApplication运行阶段又可以划分为SpringApplication准备阶段、ApplicationContext启动阶段（refreshContext）、ApplicationContext启动后阶段，以发布ApplicationStartedEvent事件为止。

- SpringApplication准备阶段

从运行SpringApplication#run方法（发布ApplicationStartingEvent事件后）到SpringApplication#prepareContext方法（含）属于SpringApplication准备阶段。以发布ApplicationPreparedEvent事件为止。

- ApplicationContext启动阶段

SpringApplication#refreshContext方法属于ApplicationContext启动阶段，以发布ContextRefreshedEvent事件为止。

- ApplicationContext启动后阶段

从SpringApplication#afterRefresh到发布ApplicationStartedEvent事件为止。

## SpringApplication结束阶段

从发布ApplicationStartedEvent事件（不含）开始到发布发布ApplicationReadyEvent事件或ApplicationFailedEvent为止。

## SpringBoot应用退出阶段

从关闭应用上下文到调用SpringApplication#exit或SpringApplication#handlerFailure或抛出异常错误为止。

# SpringBoot生命周期事件

## SpringBoot事件

SpringBoot应用生命周期中的事件，都是通过EventPublishingRunListener对象来触发的。EventPublishingRunListener对象是SpringApplicationRunListener接口的实现类，定义在spring.factories文件中，通过Spring的扩展机制加载。SpringBoot应用生命周期事件共有8种，从启动引导类创建SpringApplication对象开始。

- ApplicationStartingEvent应用开始启动事件

SpringApplication对象调用run方法后，首先会创建事件监听器，事件监听器创建完毕即立刻触发ApplicationStartingEvent事件，此时环境变量、应用上下文等所有东西都还没创建或准备。

- ApplicationEnviromentPreparedEvent应用环境准备事件

系统变量（JAVA_HOME、CLASSPATH等）、系统属性（java.version等）以及命令行参数等加载和封装到环境变量environment后触发。application.yaml文件中的属性，此时正通过ConfigFileApplicationListener监听并触发此事件进行加载中，所以，如果应用自定义监听器监听ApplicationEnviromentPreparedEvent事件，想要在自定义监听器中获取application.yaml文件中的属性，需要注意自定义监听器要实现排序并且应该排在ConfigFileApplicationListener之后，否则有可能获取不到属性。

- ApplicationContextInitializedEvent应用上下文初始化事件

此时应用上下文已经创建，在为应用上下文绑定环境变量（包括application.yaml文件中的属性），并且应用了SpringApplication创建时加载的初始化器，之后触发此事件。注意，目前发现，2.0.4版本中还没有实现此事件。

- ApplicationPreparedEvent应用准备事件

命令行参数对象和banner对象以单例被注册到容器，bean定义覆盖、延迟初始化处理器等参数被设置到容器或应用上下文中，同时SpringApplication创建时设置的主要配置源也已经被加载解析，接着触发ApplicationPreparedEvent事件。注意，如果配置源是Java配置类（注解），此时Java配置类将被注册为bean定义，但还未开始解析注解背后的逻辑；而如果配置源是xml或package包，则将会加载解析或扫描配置源，解析或扫描到的bean定义将被注册到容器中。ApplicationPreparedEvent和前面的ApplicationContextInitializedEvent事件都是在准备应用上下文的阶段（SpringApplication#prepareContext方法中）被触发。

- ApplicationStartedEvent应用已启动事件

应用上下文已经刷新，并且调用了刷新后方法（afterRefresh）后触发此事件。此时自动配置已经完成，即相关bean定义已经被加载到容器中并且实例化了所有单例bean，同时启动了内嵌的Web服务器。在触发此事件之前，会触发Spring的ContextRefreshedEvent上下文就绪事件。

- ApplicationReadyEvent应用已就绪事件

即运行中的状态。在启动运行器ApplicationRunner和CommandLineRunner执行任务后触发此事件。此时SpringBoot应用已经可以接受请求对外提供服务了。

- ApplicationFailedEvent应用运行失败事件

如果SpringBoot在启动过程中（不包括ApplicationStartingEvent事件和之前部分代码）发生错误或异常，将触发ApplicationFailedEvent事件。

- AvailabilityChangeEvent可用性变更事件

AvailabilityChangeEvent事件用于在内部标识当前应用的状态，一共有两类。一类是生存状态，另外一类是服务状态，分别都有两种可标识的状态。生存状态包括正确启动、启动异常两种，服务状态包括接受请求、拒绝请求两种。在发布ApplicationStartedEvent事件同时，SpringBoot会发布AvailabilityChangeEvent的生存状态为正确启动；在发布ApplicationReadyEvent应用已就绪事件同时，SpringBoot会发布AvailabilityChangeEvent的服务状态为接受请求。

## Spring事件

- ContextRefreshedEvent上下文刷新事件/就绪事件

调用ApplicationContext#refresh方法触发

- ContextStartedEvent上下文启动事件

调用ApplicationContext#start方法触发

- ContextStoppedEvent上下文停止事件

调用ApplicationContext#stop方法触发

- ContextClosedEvent上下文关闭事件

调用ApplicationContext#close方法触发

- RequestHandledEvent请求已处理事件

SpringMVC中的事件

# 生命周期事件总结

SpringBoot中可以监听到Spring的事件，但事件源不同，SpringBoot中的事件源是SpringAppication对象，而Spring中的事件源则是具体的ApplicationContext对象。

在Spring中，自定义事件监听器，一般可以通过实现ApplicationListener接口或注解@EventListener，然后注册为bean来实现对Spring的全生命周期事件的监听。

在SpringBoot中，由于实现原理导致，使用注解@EventListener方式只能监听SpringBoot的部分生命周期事件；可以通过实现ApplicationListener接口，然后为SpringApplication对象添加或设置监听器，或使用Spring的扩展机制在META-INF/spring.factories中配置监听器的方式来实现对SpringBoot的全生命周期事件的监听。





###### 来源：

https://blog.csdn.net/chengshangqian/article/details/117391418
