---
title: Spring-PostProcessor && Aware
date: 2022-07-07 01:14:45
tags:
---

# PostProcessor &amp;&amp; Aware

## BeanDefinitionRegistiyPostProcessor

- 获取BeanDefinition
- 删除BeanDefinition
- 替换，BeanDefinitionBuilder.build().register.regist() 设置自己的Bean定义/实现类

## BeanFactoryPostProcessor

- 对BeanFactory本身的设置

## BeanPostProcessor

- 解析自定义注解

## ApplicationContextAware

- 存储全局ApplicationContext

## BeanFactoryAware
