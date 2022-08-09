---
layout: post
title: JAVA面试思路
date: 2022-07-02 17:09:01
tags:
---

# 通用问题

## JAVA

- 提问走向 -- 优点、缺点、匹配点

  - 各自优缺点，项目为何选用某一种

    - List

      ArrayList、LinkedList

    - Map

      HashMap、LinkedHshMap、TreeMap、ConcurrentHashMap

    - JUC

    - GC

## SQL

- CURD
  - 多次Create
    - 幂等性
  - 批量Delete
    - 如何删除大量数据，分批次？另起Job删？
  - 并发Update
    - 保证变更顺序，避免对账异常
  - 海量Require
    - 索引相关

## Middleware

### Register

### MQ

- 各自优缺点、为何选型

### Cache

### Config

### Job

### RPC

- 集群、分布式特性
  - 集群
  - 分布式
    - CAP
    - 不同Middleware复合CAP中的哪一部分，以及优缺点

### SpringBoot如何与中间件集成



## DesignPattern

- Spring、Middleware使用哪些设计模式

- 是否Singleton
  - 配置类一般是Singleton
- 是否线程安全

# 业务问题

## 业务量

- UV -- 独立访问量
- PV
- QPS
  - 每小时最大UV / 3600 = QPS
- TPS

- 访问量激增时如何搭建高并发系统
  - 页面缓存
  - Nginx Cache
  - Load Balance
  - Server Cache
  - 读写DB
  - 分库分表

## 链路

- 上下游
- 优化、重构
  - 读多写少、写多读少
  - 实时性要求

## 难点

- 思路
- 影响力



###### 来源：

https://www.bilibili.com/video/BV1KU4y1L7JA

https://github.com/alibaba/spring-cloud-alibaba/issues/1909
