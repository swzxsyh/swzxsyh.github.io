---
layout: post
title: Spring-事务失效
date: 2022-07-02 19:21:01
tags:
---

# Spring-事务失效

## 访问权限问题

例如：private修饰的方法，Spring要求被代理的方法必须是public的

## 方法用final修饰

## 方法内部调用：同一个类中a方法调用有事务注解的b方法

Spring在扫描Bean的时候会自动为标注了@Transactional注解的类生成一个代理类（proxy）,当有注解的方法被调用的时候，实际上是代理类调用的，代理类在调用之前会开启事务，执行事务的操作，但是同类中的方法互相调用，相当于this.B()，此时的B方法并非是代理类调用，而是直接通过原有的Bean直接调用，所以注解会失效。

- 解决方法：
  - 1）将B方法移到另一个service中	
  - 2）在service中注入自己	
  - 3）通过aopContent类：在该service类中调用AopContent.currentProx()获取代理对象

## 类未被spring管理

## 多线程调用

## 表不支持事务

## 未开启事务
