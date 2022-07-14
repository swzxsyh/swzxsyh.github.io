---
title: wait和sleep的区别
date: 2022-07-07 01:54:32
tags:
---

1.属于不同的类；sleep属于Thread类中的静态方法；wait属于Object类

2.是否释放锁；sleep不会释放锁；wait方法释放对象锁

3.使用位置；sleep可以在任何地方使用；wait只能在同步方法和同步代码块中使用

4.线程状态；sleep使线程进入阻塞状态；wait方法使线程进入等待队列，使用notify()、notifyAll()或等待制定时间来唤醒当前线程

5.异常捕获；sleep必须捕获异常，sleep过程中可能被其他对象调用的interrupt()从而产生interruptedException，如果不捕获，线程会异常终止，进入终止状态
