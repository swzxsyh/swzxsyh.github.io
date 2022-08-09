---
layout: post
title: Spring Bean初始化方法
date: 2022-06-30 11:06:29
tags:
---

# Spring Bean初始化及@Bean销毁

- @PostConstruct
- @Bean(initMethod = "X")
- @InitilizingBean#afterPropertiesSet

## @PostConstruct

```java
@PostConstruct
public void init(){
  System.out.println("PostConstruct init.......");
}
```

## @Bean(initMethod = "X")

- 初始化

```java
/**
* 显式指定bean的名称,初始化调用方法即销毁调用方法
* @return
*/
@Bean(name = "orderBean",initMethod = "init",destroyMethod = "destroy")
public static  OrderAllServiceImpl orderBeanFactory(){
  return new OrderAllServiceImpl();
}
```

- 销毁方式-1：在 OrderAllServiceImpl 实现类中写 init 方法和 destroy 方法


```java
public class OrderAllServiceImpl implements  OrderAllService{
  public void init(){
    log.info("bean init start...");
  }

  @Override
  public List<Product> getProductList(String orderCode) {
    //TODO
    return new ArrayList<>();
  }

  public void destroy(){
    log.info("bean destory...");
  }}
```

- 销毁方式-2：使用方法注解 @PostConstruct @PreDestroy

```java
public class OrderAllServiceImpl implements OrderAllService {
    @PostConstruct
    public void init(){
        System.out.println("bean init");
    }
    @Override
    public List<Product> getProductNameByOrderCode(String code) {
        //TODO
        return new ArrayList<>();
    }
    @PreDestroy
    public void destroy(){
        System.out.println("bean desory");
    }
}
```

## @InitilizingBean#afterPropertiesSet

```java
@Component
public class OrderProcessors implements InitializingBean {

  @Autowired
  private ApplicationContext applicationContext;

  private static OrderAllService OrderAllService;

  private static final List<OrderProcessor> PROCESSOR_LIST = new ArrayList<>();

  @Autowired
  public void setOrderAllService(OrderAllService OrderAllService) {
    OrderProcessors.OrderAllService = OrderAllService;
  }

  @Override
  public void afterPropertiesSet() throws Exception {
    log.info("init processors");
    // 按顺序添加处理器
    PROCESSOR_LIST.add(applicationContext.getBean(FirstProcessor.class));
    PROCESSOR_LIST.add(applicationContext.getBean(SecondProcessor.class));

  }}
```

# 初始化顺序

- 1.@PostConstruct
- 2.@InitializingBean#afterPropertiesSet
- 3.@Bean(initMethod=”X”)

# @Bean初始化与销毁方法和 bean 中方法执行的顺序

- 类的构造函数执行 —》自定义初始化方法执行 —》自定义 destroy 方法 —》 bean 销毁。



###### 来源：

https://github.com/mifunc/Spring-BeanInitialization
