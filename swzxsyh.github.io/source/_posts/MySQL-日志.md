---
layout: post
title: MySQL-日志
date: 2022-06-30 23:09:21
tags:
---

# 日志

## undo log（回滚日志）

undo log是MVCC实现的一个重要依赖，undo log与redo log一起构成了Mysql事务日志，事务中的每一次修改，innodb都会先记录对应的undo log记录

undo log主要用于数据修改的回滚，undo log记录的是逻辑日志

当delete一条记录时，undo log中会记录一条对应的insert记录，反之亦然，当update一条记录时，它记录一条对应相反的update记录，如果update的是主键，则是对先删除后插入的两个事件的反向逻辑操作的记录。

这样，在事务回滚时，我们就可以从undo log中反向读取相应的内容，同时，我们也可以根据undolog中记录的日志读取到一条被修改后数据的原值

正是依赖undo log，innodb实现了ACID中的C-Consistency，即一致性

## redo log（重做日志）

- 刷盘时机
  通过 innodb_flush_log_at_trx_commit配置,同时后台会有一个线程每个1秒将redo log buffer 的日志刷盘
  - 事务提交时不刷盘
    ​可能会丢失1秒数据
  - 事务提交时刷盘(默认策略)​
  - 事务提交时写入page cache
    ​服务器宕机会有1秒数据损失
- 事务执行过程中不断写入（存储引擎层）
- 两阶段提交
  - 为防止写入binlog时异常导致主从之间的数据不一致，redo log提交采用两阶段提交的方式，分为prepare和commit阶段，提交binlog时，一起提交redolog​
  - 使用两阶段提交后，写入binlog异常，根据redo log恢复数据时，发现redo log处于prepare阶段，没有相应的binlog，会回滚事务​
  - 当提交redolog时异常，恢复数据时，能根据事务id找到对应的binlog 会继续提交事务

## bin log（归档日志）

### 概念

binlog即二进制日志，存储数据库更改的“事件”，创建表、更改表结构、更改表数据的的SQL语句，查询SQL不会存储在里面

Mysql有两层结构，

第一层：server层，里面包含：连接器、查询缓存、解析器、执行器；

第二层：存储引擎层，例如innodb、MyIsam、Memory等多个存储引擎

binlog位于server层

### 内容

binlog文件都有什么

参考：https://www.cnblogs.com/fengtingxin/p/11104758.html

binlog文件包含两种类型：

日志索引文件（文件后缀.index）用于记录所有的二进制文件

日志文件（文件后缀.0000*）记录数据库所有的DDL和DML（除了查询语句）的语句事件

### 格式

- statment
  会记录原始的SQL语句，某些情况下导致数据不一致，如使用了NOW()函数，从服务器执行的时候，就变成了从服务器的执行时间了
  
- row
  
  以行数据维度记录的日志：行改动前、改动后的数据
  
  记录的是数据
  
  - 优点：记录的内容精确、详细
  - 缺点：数据量大
  
- mixed
  混合模式，会判断是否会造成数据不一致

- 事务执行时，会写入binlog cache中，事务提交后，写入binlog 文件
- 刷盘时机 -- 可由sync_binlog 控制
    - 调用write，写入page cache 由操作系统调用fsync落盘。机器宕机会造成binlog丢失
    - 设置为1时，每次提交事务都会调用fsync刷盘
    - 设置为N，可在积累N个事务后调用fsync刷盘
- 事务提交后写入（Server层）
