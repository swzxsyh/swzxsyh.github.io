---
title: String、StringBuffer、StringBuilder的区别
date: 2022-07-07 01:54:49
tags:
---

1.String是字符串常量，用final修饰，StringBuffer和StringBuilder是字符串变量

2.StringBuffer中的方法都是用Synchrionzed修饰的，所以线程是安全的，StringBuilder不保证线程安全

3.运行速度上StringBuilder>StringBuffer>String

因为String对象是一个不断创建新对象不断回收的过程
