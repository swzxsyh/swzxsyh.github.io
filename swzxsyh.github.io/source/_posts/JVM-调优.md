---
title: JVM-调优
date: 2022-07-04 16:33:18
tags:
---

# 参数调优

- -Xms堆初始值

  默认值：物理内存的1/64(<1GB)

- -Xmx

  堆最大值，默认值：物理内存的1/4(<1GB)

- -Xmn

  新生代堆最大可用值，一般设置为整个堆的1/3-1/4

  新生代大小官网推荐的大小是`3/8`, 如果设置太小，比如`1/10会`导致`Minor GC` 与`Major GC`次数增多。

- -XX+PrintGC

  每次处罚GC的时候打印相关日志

- -XX:SurvivorRatio

  设置新生代中eden区和from/to空间的比例关系n/1

- -XX:MaxTenuringThreshold=n

  其中 n 的大小为区间为 [0,15], 如果高于 15，JDK7 会默认 15，JDK 8 会启动报错

<!-- more -->

**内存溢出解决办法**

设置堆内存大小

**错误原因: java.lang.OutOfMemoryError: Java heap space**

解决办法:设置堆内存大小 -Xms1m -Xmx70m -XX:+HeapDumpOnOutOfMemoryError

设置栈内存大小

错误原因: java.lang.StackOverflowError

栈溢出 产生于递归调用，循环遍历是不会的，但是循环方法里面产生递归调用， 也会发生栈溢出。

解决办法:设置线程最大调用深度

-Xss5m 设置最大调用深度



# GC调优

大多数情况下对 Java 程序进行GC调优, 主要关注两个目标：响应速度、吞吐量

- **响应速度(Responsiveness)** 响应速度指程序或系统对一个请求的响应有多迅速。比如，用户订单查询响应时间，对响应速度要求很高的系统，较大的停顿时间是不可接受的。调优的重点是在短的时间内快速响应
- **吞吐量(Throughput)** 吞吐量关注在一个特定时间段内应用系统的最大工作量，例如每小时批处理系统能完成的任务数量，在吞吐量方面优化的系统，较长的GC停顿时间也是可以接受的，因为高吞吐量应用更关心的是如何尽可能快地完成整个任务，不考虑快速响应用户请求

GC调优中，GC导致的应用暂停时间影响系统响应速度，GC处理线程的CPU使用率影响系统吞吐量

## GC事件分类

根据垃圾收集回收的区域不同，垃圾收集主要通常分为Young GC、Old GC、Full GC、Mixed GC

- 新生代（Young Generation）

新生代又叫年轻代，大多数对象在新生代中被创建，很多对象的生命周期很短。每次新生代的垃圾回收（又称Young GC、Minor GC、YGC）后只有少量对象存活，所以使用复制算法，只需少量的复制操作成本就可以完成回收

新生代内又分三个区：一个Eden区，两个Survivor区(S0、S1，又称From Survivor、To Survivor)，大部分对象在Eden区中生成。当Eden区满时，还存活的对象将被复制到两个Survivor区（中的一个）。当这个Survivor区满时，此区的存活且不满足晋升到老年代条件的对象将被复制到另外一个Survivor区。对象每经历一次复制，年龄加1，达到晋升年龄阈值后，转移到老年代

- 老年代（Old Generation）

在新生代中经历了N次垃圾回收后仍然存活的对象，就会被放到老年代，该区域中对象存活率高。老年代的垃圾回收通常使用“标记-整理”算法

### Young GC

新生代内存的垃圾收集事件称为Young GC(又称Minor GC)，当JVM无法为新对象分配在新生代内存空间时总会触发 Young GC，比如 Eden 区占满时。新对象分配频率越高, Young GC 的频率就越高

Young GC 每次都会引起全线停顿(Stop-The-World)，暂停所有的应用线程，停顿时间相对老年代GC的造成的停顿，几乎可以忽略不计

### Old GC 、Full GC、Mixed GC

- **Old GC**，只清理老年代空间的GC事件，只有CMS的并发收集是这个模式 
- **Full GC**，清理整个堆的GC事件，包括新生代、老年代、元空间等
- **Mixed GC**，清理整个新生代以及部分老年代的GC，只有G1有这个模式

## 内存分配策略

Java提供的自动内存管理，可以归结为解决了对象的内存分配和回收的问题，前面已经介绍了内存回收，下面介绍几条最普遍的内存分配策略

- **对象优先在Eden区分配** 大多数情况下，对象在先新生代Eden区中分配。当Eden区没有足够空间进行分配时，虚拟机将发起一次Young GC
- **大对象直接进入老年代** JVM提供了一个对象大小阈值参数(-XX:PretenureSizeThreshold，默认值为0，代表不管多大都是先在Eden中分配内存)，大于参数设置的阈值值的对象直接在老年代分配，这样可以避免对象在Eden及两个Survivor直接发生大内存复制
- **长期存活的对象将进入老年代** 对象每经历一次垃圾回收，且没被回收掉，它的年龄就增加1，大于年龄阈值参数(-XX:MaxTenuringThreshold，默认15)的对象，将晋升到老年代中
- **空间分配担保** 当进行Young GC之前，JVM需要预估：老年代是否能够容纳Young GC后新生代晋升到老年代的存活对象，以确定是否需要提前触发GC回收老年代空间，基于空间分配担保策略来计算：

Young GC之后如果成功(Young GC后晋升对象能放入老年代)，则代表担保成功，不用再进行Full GC，提高性能；如果失败，则会出现“promotion failed”错误，代表担保失败，需要进行Full GC

- **动态年龄判定** 新生代对象的年龄可能没达到阈值(MaxTenuringThreshold参数指定)就晋升老年代，如果Young GC之后，新生代存活对象**达到相同年龄所有对象大小**的总和大于任一Survivor空间(S0 或 S1总空间)的一半，此时S0或者S1区即将容纳不了存活的新生代对象，年龄大于或等于该年龄的对象就可以直接进入老年代，无须等到MaxTenuringThreshold中要求的年龄

另外，如果Young GC后S0或S1区不足以容纳：未达到晋升老年代条件的新生代存活对象，会导致这些存活对象直接进入老年代，需要尽量避免

## CMS常见问题

#### 最终标记阶段停顿时间过长问题

CMS的GC停顿时间约80\%都在最终标记阶段(Final Remark)，若该阶段停顿时间过长，常见原因是新生代对老年代的无效引用，在上一阶段的并发可取消预清理阶段中，执行阈值时间内未完成循环，来不及触发Young GC，清理这些无效引用

通过添加参数：-XX:+CMSScavengeBeforeRemark。在执行最终操作之前先触发Young GC，从而减少新生代对老年代的无效引用，降低最终标记阶段的停顿，但如果在上个阶段(并发可取消的预清理)已触发Young GC，也会重复触发Young GC



# 日志分析

### 设置 JVM GC 格式日志的主要参数包括如下 8 个：

```bash
-XX:+PrintGC 输出简要GC日志
-XX:+PrintGCDetails 输出详细GC日志
-Xloggc:gc.log  输出GC日志到文件
-XX:+PrintGCTimeStamps 输出GC的时间戳（以JVM启动到当期的总时长的时间戳形式）
-XX:+PrintGCDateStamps 输出GC的时间戳（以日期的形式，如 2013-05-04T21:53:59.234+0800）
-XX:+PrintHeapAtGC 在进行GC的前后打印出堆的信息
-verbose:gc-XX:+PrintReferenceGC 打印年轻代各个引用的数量以及时长
```

###  -XX:+PrintGC 与 - verbose:gc

如果想开启 GC 日志的信息，可以通过设置如下的参数任一参数：

```bash
-XX:+PrintGC
-XX:+PrintGCDetails
-Xloggc:gc.log
```

### -XX:+PrintGCDetails

```bash
[GC (Allocation Failure) [PSYoungGen: 53248K->2176K(59392K)] 58161K->7161K(256000K), 0.0039189 secs] [Times: user=0.02 sys=0.01, real=0.00 secs]
```

1、`GC` 表示是一次 YGC（Young GC）

2、`Allocation Failure` 表示是失败的类型

3、PSYoungGen 表示年轻代大小

4、`53248K->2176K` 表示年轻代占用从`53248K`降为`2176K`

5、`59392K`表示年轻带的大小

6、`58161K->7161K` 表示整个堆占用从`53248K`降为`2176K`

7、`256000K`表示整个堆的大小

8、 0.0039189 secs 表示这次 GC 总计所用的时间

9、`[Times: user=0.02 sys=0.01, real=0.00 secs]` 分别表示，用户态占用时长，内核用时，真实用时。

## 二、CMS GC 日志详细分析

```bash
[GC (CMS Initial Mark) [1 CMS-initial-mark: 19498K(32768K)] 36184K(62272K), 0.0018083 secs] [Times: user=0.01 sys=0.00, real=0.01 secs]
[CMS-concurrent-mark-start]
[CMS-concurrent-mark: 0.011/0.011 secs] [Times: user=0.02 sys=0.00, real=0.00 secs]
[CMS-concurrent-preclean-start]
[CMS-concurrent-preclean: 0.001/0.001 secs] [Times: user=0.00 sys=0.00, real=0.01 secs]
[CMS-concurrent-abortable-preclean-start]
 CMS: abort preclean due to time [CMS-concurrent-abortable-preclean: 0.558/5.093 secs] [Times: user=0.57 sys=0.00, real=5.09 secs]
[GC (CMS Final Remark) [YG occupancy: 16817 K (29504 K)][Rescan (parallel) , 0.0021918 secs][weak refs processing, 0.0000245 secs][class unloading, 0.0044098 secs][scrub symbol table, 0.0029752 secs][scrub string table, 0.0006820 secs][1 CMS-remark: 19498K(32768K)] 36316K(62272K), 0.0104997 secs] [Times: user=0.02 sys=0.00, real=0.01 secs]
[CMS-concurrent-sweep-start]
[CMS-concurrent-sweep: 0.007/0.007 secs] [Times: user=0.01 sys=0.00, real=0.01 secs]
[CMS-concurrent-reset-start]
[CMS-concurrent-reset: 0.000/0.000 secs] [Times: user=0.00 sys=0.00, real=0.00 secs]
```

CMS 日志分为两个 STW(stop the world)

分别是`init remark`（1） 与 `remark`（7）两个阶段。一般耗时比 YGC 长约 10 倍（个人经验）。

（1）、`[GC (CMS Initial Mark) [1 CMS-initial-mark: 19498K(32768K)] 36184K(62272K), 0.0018083 secs][Times: user=0.01 sys=0.00, real=0.01 secs]`

会 STO(Stop The World)，这时候的老年代容量为 32768K， 在使用到 19498K 时开始初始化标记。耗时短。

（2）、`[CMS-concurrent-mark-start]`

并发标记阶段开始

（3）、`[CMS-concurrent-mark: 0.011/0.011 secs] [Times: user=0.02 sys=0.00, real=0.00 secs]`

并发标记阶段花费时间。

（4）、`[CMS-concurrent-preclean-start]`

并发预清理阶段，也是与用户线程并发执行。虚拟机查找在执行并发标记阶段新进入老年代的对象 (可能会有一些对象从[新生代](https://www.baidu.com/s?wd=新生代&tn=24004469_oem_dg&rsv_dl=gh_pl_sl_csd)晋升到老年代， 或者有一些对象被分配到老年代)。通过重新扫描，减少下一个阶段” 重新标记” 的工作，因为下一个阶段会 Stop The World。

（5）、`[CMS-concurrent-preclean: 0.001/0.001 secs] [Times: user=0.00 sys=0.00, real=0.01 secs]`

并发预清理阶段花费时间。

（6）、`[CMS-concurrent-abortable-preclean-start] CMS: abort preclean due to time [CMS-concurrent-abortable-preclean: 0.558/5.093 secs][Times: user=0.57 sys=0.00, real=5.09 secs]`

并发可中止预清理阶段，运行在并行预清理和重新标记之间，直到获得所期望的 eden 空间占用率。增加这个阶段是为了避免在重新标记阶段后紧跟着发生一次垃圾清除

（7）、`[GC (CMS Final Remark) [YG occupancy: 16817 K (29504 K)][Rescan (parallel) , 0.0021918 secs][weak refs processing, 0.0000245 secs][class unloading, 0.0044098 secs][scrub symbol table, 0.0029752 secs][scrub string table, 0.0006820 secs][1 CMS-remark: 19498K(32768K)] 36316K(62272K), 0.0104997 secs] [Times: user=0.02 sys=0.00, real=0.01 secs]`

会 STW(Stop The World)，收集阶段，这个阶段会标记老年代全部的存活对象，包括那些在并发标记阶段更改的或者新创建的引用对象

（8）、`[CMS-concurrent-sweep-start]`

并发清理阶段开始，与用户线程并发执行。

（9）、`[CMS-concurrent-sweep: 0.007/0.007 secs] [Times: user=0.01 sys=0.00, real=0.01 secs]`

并发清理阶段结束，所用的时间。

（10）、`[CMS-concurrent-reset-start]`

开始并发重置。在这个阶段，与 CMS 相关数据结构被重新初始化，这样下一个周期可以正常进行。

（11）、`[CMS-concurrent-reset: 0.000/0.000 secs] [Times: user=0.00 sys=0.00, real=0.00 secs]`

并发重置所用结束，所用的时间。









来源：

https://blog.csdn.net/zhangcongyi420/article/details/89060802

https://rumenz.com/rumenbiji/jvm-gc-format.html
