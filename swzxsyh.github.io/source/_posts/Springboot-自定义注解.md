---
title: Springboot-自定义注解
date: 2022-07-07 00:07:35
tags:
---

# Springboot自定义注解 

## BeanPostProcessor的应用案例

- 使用@interface定义注解
- 使用BeanPostProcessor处理注解

> BeanPostProcessor为bean后置处理器. Spring启动过程中,所有的bean初始化的时候会调用bean的后置处理器.

## 自定义注解类

```java
import org.springframework.stereotype.Component;
import java.lang.annotation.*;

@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component
public @interface Test {
  String value() default "";
}
```

<!-- more -->

## BeanPostProcessor后置处理器处理自定义注解

```java
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.stereotype.Component;
import java.lang.reflect.Field;

@Component
public class BeanPostProcessorConfig  implements BeanPostProcessor {
  @Override
  public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
    Field[] arr=bean.getClass().getDeclaredFields();
    for(Field f:arr){
      Test a=f.getAnnotation(Test.class);
      if(null==a){
        continue;
      }
      f.setAccessible(true);
      try {
        f.set(bean,a.value());
      } catch (IllegalAccessException e) {
        e.printStackTrace();
      }
    }
    return bean;
  }
  @Override
  public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
    return bean;
  }
}
```

## 调用

```java
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@CrossOrigin //类上加
public class DemoController {

    @Test("test")
    private String name="test";

    @GetMapping("/")
    public String index() {
        System.out.println("hello "+name);
        return "{\"code\":200,\"msg\":\"ok\",\"data\":[\"JSON.IM\",\"json格式化\"]}";
    }
}
```
