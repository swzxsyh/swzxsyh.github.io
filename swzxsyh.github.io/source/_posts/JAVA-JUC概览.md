---
title: JAVA-J.U.C概览
date: 2022-07-04 01:27:03
tags:
---

# JUC

> `J.U.C`是`java.util.concurrent`的简写,里面提供了很多线程安全的集合。

## 常用工具类

- atomic（内部原理unSafe.   实现 ： 死循环）
  - AtomicInteger
  - AtomicDouble
  - AtomicLong
  - AtomicReference
  - LongAcc
- lock
  - AQS
  - `LOCK`
  - `Condition`
  - LockSupport
    - 两大方法：Park/unPark
    - 暂停线程方式
      - LockSupport.park();
      - Object.wait();
      - Thread.Sleep();
  - ReadWriteLock
  - ReentrantLock
    - 锁对变量加锁后，线程是否可再次执行判断是否可重入
- 工具
  - `CountdownLatch`
  - `CyclicBarrier`
  - Semaphore
  - `FutureTask`
  - `Callable`
- 集合
  - ConcurrentHashMap
  - CopyOnWriteArrayList
  - `BlockingQueue`
  - `BlockingDeque`
- 线程池
  - Executors



## 线程安全

> 通过加锁保证数据的一致性.也就是说当一个线程访问某个数据时,通过加锁操作对数据进行保护,其它线程在加锁期间不能对其访问

## 线程封闭

> 当多个线程访问共享变量时,需要通过加锁来保证数据同步,增加了程序的复杂性. 避免数据同步的一种方式是不共享变量,比如使用局部变量和ThreadLocal

## 线程调度

> 系统为线程分配CUP使用权的过程

- 协同式线程调度

> 线程的执行时间由线程自己控制,当自己执行完后,主动通知操作系统切换到另外一个线程上执行. 好处是实现简单,线程对自己的操作是可知道的,没有什么线程同步问题.缺点是线程执行时间不可控,如果一个线程有问题,可能会一致阻塞在那里.

- 抢占式线程调度

> 每个线程的执行时间有操作系统分配,线程的切换不由线程本身决定(Java中,Thread.yield()可以让出执行时间,但无法获取执行时间)线程执行时间系统可控,也不会有一个线程导致进程阻塞.

## java线程调度就是抢占式调度

> 可以通过设置线程的优先级让一些线程尽可能的先执行多执行(Java一共有10个线程优先级从Thread.MIN_PRIORITY至Thread.MAX_PRIORITY),在两个线程同时处于ready时,优先级越高越容易被执行.但优先级并不靠谱,因为Java线程时通过映射到原生线程来实现的,所以线程调度还是取决于操作系统.

## 状态转换

- 新建(New)创建后尚未启动的线程
- 运行(Runnable):Runnable包括操作系统中的Running和Ready. 处于此状态的线程有可能在运行,也有可能在等待CPU为它分配执行时间.线程创建后,其它线程调用了该线程的start方法,那么该线程就位于`可运行线程池中`,变得可运行,就差CPU分配执行时间,其它运行所需要的资源都已经获得.
- 无限期等待(Waiting):该状态下的线程不会被分配CPU执行时间,要等待被其它线程进行显示唤醒. 如没有设置timeout的Object.wait()方法和Thread.join()方法,以及LockSupport.park()方法
- 限时等待(Timed Waiting):该状态下的线程不会被分配CPU执行时间,只不过不需要被显示的唤醒,在一定时间后会被系统自动唤醒. 如Thread.sleep(),设置了timeout的Object.wait()和Thread.join(),LockSupport.parkNanos()以及LockSupport.parkUntil()方法
- 阻塞(Blocked):线程被阻塞了,与等待的区别是:阻塞线程在等待一个排它锁.

> 阻塞状态是因为某种原因放弃CPU使用权,暂时停止执行,直到线程进入就绪状态,才有机会转到运行状态.

- 结束(Terminated):线程执行完了或者异常退出了run()方法,该线程结束生命周期

## 阻塞常见的三种情况

1.等待阻塞(无限期等待):运行的线程执行wait()方法,该线程会释放占用的资源,JVM会把该线程放入`等待池`.进入这个状态后,线程不会自动唤醒,必须依靠其它线程调用notify()或notifyAll()方法才能会被唤醒.

2.同步阻塞:运行的线程在获取对象的同步锁时,若该同步锁被其它线程占用,则JVM会把该线程放入`锁池`.
3.其它阻塞(限时等待):运行的线程执行了join()或者sleep()方法,或者发起了I/O请求,JVM会把该线程置为阻塞状态,当sleep()状态超时,join()等待线程终止或者超时,I/O处理完成,该线程重新转入就绪状态.

## 同步容器

> 同步容器通过`synchronized`关键字修饰容器,保证同一时刻只有一个线程使用容器,从而使容器线程安全. `synchronized`的意思的同步.

1.Vector和ArrayList都实现了List接口,Vector对数组的操作和ArrayList都一样,区别在于Vector在可能出现线程安全的方法上都加了`synchronized`关键字修饰.

2.Stack是Vector的子类,Stack实现的是先进后出,在出栈入栈都进行了`synchronized`修饰.

3.HashTable:它实现了Map接口,操作和HashMap一样(区别:HashTable不能存null,HashMap键值都可以为null),HashTable的所有操作都加了`synchronized`修饰.

4.Collections提供了线程同步集合类

```
List list=Collections.synchronizedList(new ArrayList());Set set=Collections.synchronizedSet(new HashSet());Map map=Collections.synchronizedMap(new HashMap());
```

## 并发容器

> 并发容器是指允许多线程访问的容器,并保证线程安全.为了尽可能提高并发,Java并发工具包中采用多种优化方式来提高并发容器的执行效率,核心就是锁,CAS(无锁),COW(读写分离),分段锁.

1.CopyOnWriteArrayList

> CopyOnWriteArrayList相当于实现了线程安全的ArrayList,在对容器写入时,Copy出一份副本数组,完成操作后把副本数组的引用赋值给容器,底层是通过ReentrantLock来保证同步. 但它通过牺牲容器的一致性来换取容器的并发(在Copy期间读取的还是旧数据),所以不能在强一致的场景下使用.

2.CopyOnWriteArraySet

> CopyOnWriteArraySet和CopyOnWriteArrayList的原理一样,它是实现了CopyOnWrite机制的Set集合.

3.ConcurrentHashMap

> ConcurrentHashMap相当于实现了线程安全的HashMap,Key是无序的,并且key和value都不能为null,在JDK8之前,采用分段锁的机制来提高并发,只有在操作同一段键值对是才需要加锁.JDK8以后才用CAS算法提高容器的并发.

4.ConcurrentSkipListMap

> ConcurrentSkipListMap相当于实现了线程安全的TreeMap,key是有序的,key和value不允许为null,它采用跳跃表的来替代红黑树,原因是红黑树在插入或者删除节点时需要做旋转调整,导致要控制的粒度太大.而跳跃表使用的是链表,利用CAS算法实现高并发线程安全.

5.ConcurrentSkipListSet

> ConcurrentSkipListSet和ConcurrentListMap的原理一样,它是实现了线程安全的TreeSet

### 强一致性

> 系统中某个数据更新后,后续任何对该数据的读取都将获取到最新的值,在任意时刻，所有节点中的数据是一样的。对于关系型数据库，要求更新过的数据能被后续的访问都能看到，这是强一致性。

### 弱一致性

> 系统中某个数据被修改后,后续对该数据的读取有可能获得更新之后的值,可能获得更新前的数据,但经过不一致的窗口这段时间,后续对该数据的读取将获得更改之后的值.

### 最终一致性

> 是弱一致性的特殊形式,存储系统在保证没有更新的情况下,最总所有对该数据的访问都会得到更新后的数据.不保证在任意时刻任意节点上的同一份数据都是相同的，但是随着时间的迁移，不同节点上的同一份数据总是在向趋同的方向变化。





###### 来源：

https://www.bilibili.com/video/BV1G44y1q7qu

https://rumenz.com/rumenbiji/java-Multithreading.html

https://rumenz.com/rumenbiji/java-synchronized-concurrent-container.html
