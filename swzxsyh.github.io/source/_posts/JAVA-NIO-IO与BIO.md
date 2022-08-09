---
title: JAVA-NIO,IO与BIO
date: 2022-07-05 01:02:11
tags:
---

# JAVA-NIO,IO与BIO

![](./JAVA-NIO-IO与BIO/IO.jpg)



## 概念：

1.BIO：同步阻塞式IO，数据的读写必须阻塞在一个线程内等待其完成

适用于活动连接数不高的场景

2.NIO：同步非阻塞式IO

## NIO与IO的区别

1.NIO流是非阻塞IO，而IO是阻塞式IO

2.IO面向流，而NIO棉线缓冲区（buffer）

3.通道，NIO通过channel（通道）进行读写

4.选择器，NIO中选择器（Selectors），而IO没有，NIO通过选择器来处理通道
