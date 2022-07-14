---
title: 事务Transaction
date: 2022-07-04 00:20:42
tags:
---

# 事务

## ACID

- Atomicity

  原子性（Atomicity）：事务中的操作要么都做，要么都不做。

- Consistency
  一致性（Consistency）：系统必须始终处在强一致状态下
  
- Isolation
  隔离性（Isolation）：一个事务的执行不能被其他事务所干扰
  
- Durability

  持续性（Durability）：一个已提交的事务对数据库中数据的改变是永久性的

  

## BASE

### 概念
- Basically Avaliable
  基本可用（Basically&nbsp;Available）：系统能够基本运行、一直提供服务
- Soft-state
  状态（Soft-state）：系统不要求一直保持强一致状态
- Eventual consistency
  最终一致性（Eventual&nbsp;consistency）：系统需要在某一时刻后达到一致性要求

### 主要实现方式

- 两阶段型
  分布式事务两阶段提交，对应技术上的XA、JTA/JTS。这是分布式环境下事务处理的典型模式
- 补偿型
  TCC型事务（Try/Confirm/Cancel）可以归为补偿型；TCC思路是:尽早释放锁；在Try成功的情况下，如果事务要回滚，Cancel将作为一个补偿机制，回滚Try操作；
  TCC各操作事务本地化，且尽早提交&nbsp;(放弃两阶段约束)；当全局事务要求回滚时，通过另一个本地事务实现“补偿”行为；
  TCC是将资源层的两阶段提交协议转换到业务层，成为业务模型中的一部分；
- 异步确保型
  将一些同步阻塞的事务操作变为异步的操作，避免对数据库事务的争用，典型例子是热点账户异步记账、批量记账的处理
- 最大努力通知型
  交易的消息通知与失败重试（例如商户交易结果通知重试、补单重试）

### 模式分类

- 异步确保
- 重试与幂等
- 可补偿操作
