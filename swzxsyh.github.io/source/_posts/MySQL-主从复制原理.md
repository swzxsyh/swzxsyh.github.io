---
layout: post
title: MySQL-主从复制原理
date: 2022-07-02 18:47:44
tags:
---

mysql主从复制原理：

1.从库生成两个线程，一个IO线程一个SQL线程

2.IO线程会去请求主库binlog，并将得到的binlog写到本地的relay-log（中继日志）文件中

3.主库会生成一个log dump线程，用来给从库IO线程传送binlog

4.SQL线程会读取relay-log文件中的日志，并解析成SQL逐一执行
