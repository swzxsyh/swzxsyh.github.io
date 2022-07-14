---
title: Synchronized和Lock的区别
date: 2022-07-07 01:54:21
tags:
---

1.来源：synchironized是java的一个关键字；Lock是一个接口

2.异常是否释放锁：synchronized异常会释放锁，因此不会死锁；Lock必须手动释放锁

3.是否响应中断：synchronized只能等待锁释放；Lock可以用interrupt来中断

4.是否知道锁状态：synchronized不能获取到；Lock可以通过tryLock来知道

5.可重入：Lock可以通过ReadWriteLock来实现可重入锁

6.性能：竞争不激烈，两者性能差不多；竞争激烈Lock大于Sync

7.调度上：sync使用object的wait、notify、notifyall等调度；Lock使用condition进行调度

**synchronized和lock的用法区别**

synchronized：在需要同步的对象中加入此控制，synchronized可以加在方法上，也可以加在特定代码块中，括号中表示需要锁的对象。

lock：一般使用ReentrantLock类做为锁。在加锁和解锁处需要通过lock()和unlock()显示指出。所以一般会在finally块中写unlock()以防死锁。

synchironized实现原理

1.同步方法：采用ACC_SYNCHRONIZED标记符来实现同步

方法级的同步是隐式的，同步方法的常量池中会有一个ACC_SYNCHRONIZED标志。当某个线程要访问这个方法时，会检查是否有这个标志，

2.作用在代码块：采用monitorenter和monitorexit两个指令实现同步
