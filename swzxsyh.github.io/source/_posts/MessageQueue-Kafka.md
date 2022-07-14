---
layout: post
title: MessageQueue-Kafka
date: 2022-07-02 17:02:54
tags:
---

# Kafka

## 简介：

 Kafka是一种高吞吐量、分布式、基于发布/订阅的消息系统，最初由LinkedIn公司开发，使用Scala语言编写，目前是Apache的开源项目。

跟RabbitMQ、RocketMQ等目前流行的开源消息中间件相比，Kakfa具有高吞吐、低延迟等特点，在大数据、日志收集等应用场景下被广泛使用

## 作用

- 解耦
- 流量削峰

## MQ模型

### JMS

- P2P

  使用队列（Queue）作为消息通信载体：满足**生产者与消费者模式，一条消息只能被一个消费者使用，未被消费的消息在队列中保留直到被消费或超时**。

  ![](./MessageQueue-Kafka/P2P.jpg)

- Pub/Sub

  发布订阅模型（Pub/Sub） 使用主题（Topic）作为消息通信载体，类似于广播模式,发布者发布一条消息，**该消息通过主题传递给所有的订阅者**，一条消息可以被多个消费者使用。

  **在一条消息广播之后才订阅的用户则是收不到该条消息的**。在发布 - 订阅模型中，如果只有⼀个订阅者，那它和队列模型就基本是⼀样的了。所以说，**发布 - 订阅模型在功能层⾯上是可以兼容点到点（P2P）模型的**

  ![](./MessageQueue-Kafka/Pub_Sub.jpg)

### AMQP

## MQ问题

- **系统可用性降低**：系统可用性在某种程度上降低，在加入MQ之前，不用考虑消息丢失或者说MQ挂掉等等的情况，但是，引入MQ之后就需要去考虑了
- **系统复杂性提高**：加入MQ之后，需要保证**消息没有被重复消费、处理消息丢失的情况、保证消息传递的顺序性**，消息服务器有没有宕机等问题
- **一致性问题**：消息队列可以实现异步，异步确实可以提高系统响应速度。但是，万一消息的真正消费者并没有正确消费消息就会导致数据不一致的情况了。

其实这些问题就是作为一个消息队列中间件所要面对的挑战，这个消息中间件该如何设计才能解决消息框架可能遇到的一系列问题：**故障转移恢复、数据一致性保证、数据可靠性保证**



## Kafka特性

高吞吐量、低延迟：kafka每秒可以处理几十万条消息，它的延迟最低只有几毫秒。每个topic可以分多个partition, consumer group 对partition进行consume操作。

可扩展性：kafka集群支持热扩展

持久性、可靠性：消息被持久化到本地磁盘，并且支持数据备份防止数据丢失

容错性：允许集群中节点失败（若副本数量为n,则允许n-1个节点失败）

高并发：支持数千个客户端同时读写

## 设计目标：

1.以时间复杂度O(1)的方式提供消息持久化能力（顺序写）

2.高吞吐率，单机支持每秒100K条以上消息的传输

3.支持kafka server间的消息分区，及[[分布式消费，同时保证每个partition内的消息顺序传输

4.同时支持离线数据处理和试试数据处理

5.Scale out：支持在线水平扩展

## 架构

![](./MessageQueue-Kafka/construct.jpg)

一个典型的 Kafka 集群中包含 Producer、broker、Consumer Group、Zookeeper 集群。

Kafka 通过 Zookeeper 管理集群配置，选举 leader，以及在 Consumer Group 发生变化时进行 rebalance。

Producer 使用 push 模式将消息发布到 broker，Consumer 使用 pull 模式从 broker 订阅并消费消息。

![](./MessageQueue-Kafka/640.png)

### 基本概念

- **Producer**：负责发布消息到kafka broker
- **Topic**：每条发布到kafka集群的消息都有一个类别，这个类别被称为Topic（物理上不同Topic的消息被拆分成分区分开存储，逻辑上一个Topic的消息虽然保存于一个或多个broker上，但用户只需指定消息的topic即可生产或消费数据而不必关心数据存于何处）。Kafka按照topic来分类消息。
- **Partition**：Topic的分区，一个Topic可以包含多个Partition，Topic消息保存在各个Partition上，每个Partition包含N个副本。一个非常大的Topic可以分布到多个Broker（即服务器）上，一个topic可以分为多个partition，每个partition是一个有序的队列， partition中的每条消息都会被分配一个有序的id（offset 分区偏移量）。kafka只保证按一个partition中的顺序将消息发给consumer，不保证一个topic的整体（多个partition间）的顺序。
- **Leader（领导者）【针对某个分区的Leader副本】**：Leader 负责指定分区的所有读取和写入的操作。每个分区都有一个服务器充当Leader。
- **Follower（追随者）【针对某个分区的Follower副本】**：跟随领导者指令的节点被称为Follower。如果领导失败，一个追随者将自动成为新的领导者。跟随者作为正常消费者，拉取消息并更新其自己的数据存储。**follower从不用来读取或写入数据**， 它们用于防止数据丢失。
- **Kafka Cluster（Kafka集群）**：Kafka有多个服务器被称为Kafka集群。可以扩展Kafka集群，无需停机。这些集群用于管理消息数据的持久性和复制。
- **Broker**：kafka集群包含一个或多个服务器，这种服务器被称为broker（等同于queue），负责消息存储和转发
- **offset**：消息在日志中的位置，可以理解是消息在partition上的偏移量
- **Consumer**：消息消费者，向kafka broker读取消息的客户端
- **Consumer Group**：消费者组。每个consumer属于一个特定的consumer group（可为每个consumer指定group name，若不指定则属于默认的group）。consumer group是kafka提供的可扩展且具有容错性的消费者机制。组内可以有多个消费者或消费者实例，它们共享一个公共的group ID。组内的所有消费者协调在一起来共享订阅主题的所有分区。

**`Kafka集群和Kafka服务器属于物理机器上的概念，而主题和分区属于发出去的消息的分类，一个纵向，一个横向，一个broker上可以有很多主题的分区，一个主题也可以在很多broker上放置分区，是多对多的关系`。**

### 基本术语

消息：kafka中数据单元被称为消息，也被称为记录

批次：为了提高效率，消息会分批次写入kafka，批次代指一组消息

分区：主题可以被分为若干个分区(partition)

偏移量：是一种元数据，它是一个不断递增的整数值，用来记录消费者发生重平衡时的位置，以便用来恢复数据

副本：消息的备份称为副本（Replica），副本的数量可以配置，kafka中定义了两类副本：领导者副本（Leader Replica）和追随者副本（Follower Replica），前者对外提供服务，后者被动追随

重平衡：Rebalance。消费者组内某个消费者实例挂掉后，其他消费者实例自动重新分配订阅主题分区的过程。

## Kafka工作流程和文件存储机制

### 工作流程

- 一个 Topic可以认为是一类消息，每个 topic 将被分成多个 Partion，每个 Partion在存储层面是`append log` 文件。Kafka 机制中，producer push 来的消息是追加（append）到 Partion中的，这是一种`顺序写磁盘的机制`，效率远高于随机写内存
- **任何发布到partition 的消息都会被追加到log文件的尾部**，每条消息在文件中的位置称为 offset（偏移量），offset 为一个 long 型的数字，它`唯一标记一条消息。Kafka只保证Partion内的消息有序，不能保证全局Topic的消息有序`
- 消费者组中的每个消费者，都会`实时记录自己消费到了哪个 offset`，以便出错恢复时，从上次的位置继续消费



#### **消息写入过程**

![消息写入过程](./MessageQueue-Kafka/writes.jpg)

Producer向同一主题的不同分区写消息，也即不停的在各个append log文件后顺序追加消息，每追加一个append log文件偏移量加一，只有单append log文件中有序



#### **整体消息的生产传递和消费的的流程**

![整体消息的生产传递和消费的的流程](./MessageQueue-Kafka/offset.jpg)

1. **Producer生产者定期向Kafka集群发送消息**，在发送消息之前，会对消息进行分类，即Topic, Kafka集群存储该Topic配置的分区中的所有消息。它确保消息在分区之间平等共享。如果生产者发送两个消息并且有两个分区，Kafka将在第一分区中存储一个消息，在第二分区中存储第二消息。
2. **Kafk接收生产者消息并转发给消费者**，消费者订阅特定主题，一旦消费者订阅Topic，Kafka将向消费者提供Topic下分区的当前offset，并且还将偏移保存在Zookeeper系统中。消费者通过与kafka集群建立长连接的方式，不断地从集群中拉取消息，然后可以对这些消息进行处理，一旦Kafka收到来自生产者的消息，它将这些消息转发给消费者。
3. **消费者将收到消息进行处理,一旦消息被处理**，消费者将向Kafka代理发送确认。消费者需要实时的记录自己消费到了哪个offset，便于后续发生故障恢复后继续消费。Kafka 0.9版本之前，consumer默认将offset保存在Zookeeper中，从0.9版本开始，consumer默认将offset保存在Kafka一个内置的topic中 一旦Kafka收到确认，它将offset更改为新值，并在Zookeeper中更新它。

以上流程将重复，直到消费者停止请求。消费者可以随时回退/跳到所需的主题偏移量，并阅读所有后续消息



## Producer

### 指定topic后Producer如何将消息发送到对应的Partition?

#### Producer消息发送流程


1. Producer将消息发送给leader
2. Leader将消息写入本地磁盘文件
3. Follwer 从leader pull消息
4. Follwer 将消息写入本地磁盘文件后向leader发送ack
5. Leader收到所有副本ack后向producer发送ack

![](./MessageQueue-Kafka/Kafka_Cluster.png)

#### Producer发送流程

![](./MessageQueue-Kafka/Sender_pic.png)

Kafka Producer：包含了核心资源（线程资源、网路资源），主要通过线程进行实现消息的异步发送、批处理机制，维护了跟各个broker的网络连接，可以通过网络连接将消息发送出去。

可以整个系统通过全局唯一的一个Kafka Producer来发送消息（多线程并发安全的），消息通过Producer Record进行封装，交给Kafka Producer发送

Producer Record : 代表一个要发送的消息。格式CRC、magic

Interceptors: 拦截器

Serializer：序列化器

Partitioner：分区器，用于确定消息将被路由到哪个分区。

Meta Data: broker集群元素据（集群有哪些Topics，Topic有哪些分区，Leader及Follower 属于哪个机器，ISR（用于保持跟leader同步）

Record Accumulator: 消息缓冲区，基于ButerBuffer 的内存缓冲池。一个Partition对应一个Deque。当有足够多的消息被打包成为batch后才能被发送出去，但如果一定时间范围内都没有足够多的消息则立即发送出去，可以通过linger.ms 进行指定。

Batch : 发送到同一分区的Record会打包成一个一个batch，再通过网络请求将多个batch打包成一个请求发送到对应的分区。默认大小16k(16384字节)。可以通过 batch.size 参数进行指定。

Buffer Pool : 内存缓冲池，创建批次时会申请内存池中的内存单元，在批次发送到服务端后又会归还给内存池异变进行复用。大小可以通过 buffer.memory指定，默认是 32 * 1024 * 1024 字节（32mb）。

Sender 线程：负责从缓冲区获取消息发送到缓冲区

Network Client：网络通信组件，实现通道的建立，读取消息、发送消息等功能

Selector：底层通过NIO方式，封装了channel 为kafka channel 将数据通过网络请求发送出去



#### Record Accumulator缓冲区

**Accumulator**维护了一个 ConcurrentMap\<TopicPartition, Deque\<RecordBatch>> ，key为TopicPartition， value 为 ArrayDeque\<ProducerBatch>。每一个分区都会对应一个Deque，每一个Deque里都会保存很多待发送的消息batch。

当有新的消息到来时，会先从ConcurrentMap中获取对应的Deque，Deque不存在时会创建一个Deque加入到map中。

获取到Deque后会尝试获取Deque中的batch，进行写入。

对于这种场景每一条消息都会对map的key-value进行读取，会高频的读取出来一个TopicPartition对应的Deque数据结构，来对这个队列进行入队出队等操作，所以对于这个map而言，高频的是其get操作而不是put，因此Kafka 采用了CopyOnWrite 的思想进行优化，避免更新key-value的时候阻塞住高频的读操作，实现无锁的效果，优化线程并发的性能。

得到**Deque**队列后，从队列中拿到一个可用的**batch**进行写入，如果没有可用的**batch**则会通过**Buffer Pool **分配一个**Byte buffer**，然后继续尝试加入到**Deque**中的队尾。

当队列中的**batch**达到一定数量后（缓存满了）就会发送出去，或者在队列中等待的时间达到**linger.ms**指定的时间后直接发送出去。因此调整**linger.ms**参数可以达到更好的均衡效果



发送流程

Sender 线程从缓冲区中拉取batch 组合成bathces 发送，batches会被创建为一个Request进行发送，因此也可以通过max.request.size指定request的大小，默认为1mb。

Request 创建后通过NetworkClient进行网络IO，先将request 按照 node（broker）节点进行缓存到InFightRequest中，然后将请求提交给Kafka selector 组件利用NIO 进行发送。

InFightRequest 是指以发送但还没收到响应的请求，在收到broker返回的响应后，会InFlightRequest队列中获取并删除队尾元素。当某个节点对应的InFlightRequest队列达到 一个连接最多允许没收到响应的数量（通过max.inflight.requests.per.connection 指定）后，请求便不能立刻发送出去，会阻塞一定时间。同时前一个请求没有发送完毕时，发送到同一个节点的请求不能进入InFlightRequest队列，须等待前一个请求发送完成

### 如何做到高吞吐、低延时？

1.、KafkaProducer是生产者的入口，也是主线程，它还维护sender子线程。

2、在主线程中，不断往RecordAccumulator中追加消息。

3、RecordAccumulator是一个消息的仓库，当有消息batch封箱完成时，KafkaProducer会唤醒Sender线程做消息的发送处理。

4、Sender首先把batch按照要发往的node分组，生成ClientRequest请求对象。

5、Sender再通过NetworkClient的send方法，把ClientRequest需要的资源准备好，如Channel，数据等。

6、Sender最后通过NetworkClient的poll方法，底层通过nio把准备好的请求最终发送出去。

7、Sender再统一处理response，进行重试或者回调。

## Kafka文件存储机制

每个partion是一个**append log** 文件，虽然我们已经把Topic物理上划分为多个Partion用来**负载均衡**，但即使是对一个Partition 而言，如果消息量过大的话也会有堵塞的风险，所以我们需要定期清理消息。

清理消息时如果只有一个Partion，那么就得全盘清除，这将对消息文件的维护以及已消费的消息的清理带来严重的影响。**所以我们需要在物理上进一步细分Partition**

- Kafka`以 segment 为单位将 partition 进一步细分`，每个 partition（目录）相当于一个巨型文件被平均分配到多个**大小相等的 segment**（段）数据文件中（每个 segment 文件中消息数量不一定相等）

这种特性也方便 old segment 的删除，即方便已被消费的消息的清理，提高磁盘的利用率，每个 partition 只需要支持顺序读写就行。

### Broker接收到消息后如何进行存储

#### 整体存储结构

![](./MessageQueue-Kafka/v2-8ec73050f44432cbb9821419ad126419_720w.jpg)

#### Broker 写入磁盘原理 -- Partition&Segment

> **一组index和log**，这就是一个**segment**的内容
>
> 命令规则为：**partition 全局的第一个 segment 从 0 开始**，后续每个 segment 文件名为上一个 segment 文件最后一条消息的 offset 值，数值大小为 64 位，20 位数字字符长度

![](./MessageQueue-Kafka/log.png)

#### Log Segment存储结构：

kafka是通过主题和分区来对消息进行分类的，所以在磁盘存储结构方面也是基于分区来组织的，即每个目录存放一个分区的数据，目录名为“**主题**-**分区号**”，如TopicA 包含两个分区Partition-0、 Partition-1，则对应的数据目录是TopicA-0、TopicA-1。

目录下会对应多个日志分段（Log Segment）。Log Segment文件由两部分组成，“.index” 和“.log”文件。

**.index文件**： 索引。索引文件使用稀疏索引的方式，避免对日志每条数据建索引，节省存储空间。从而在消费者消费消息时，broker根据消费者给定的offset，基于二分查找先在索引文件找到该offset对应的数据segment文件的位置，然后基于该位置（或往下）找到对应的数据。

**.log文件** : 消息数据

![](./MessageQueue-Kafka/index.png)

如上图，“.index” 索引文件存储大量的元数据，“.log” 数据文件存储大量的消息，索引文件中的元数据指向对应数据文件中 message 的物理偏移地址。其中以 “.index” 索引文件中的元数据 [917,17800] 为例，在 **“.log” 数据文件表示第 917 个消息，即在全局 partition 中表示 000000+917=917 个消息**，`该消息的segementoffset为3，全局offset为917，物理偏移地址为 17800（注意此物理偏移地址不是消息数量的offset，而是消息的内存存储偏移量 ）`

#### 顺序写入

当broker接收到producer发送过来的消息时，需要根据消息的主题和分区信息，将该消息写入到该分区当前最后的segment文件中，文件的写入方式是追加写。

由于是对segment文件追加写，故实现了对磁盘文件的顺序写，避免磁盘随机写时的磁盘寻道的开销，同时由于是追加写，故写入速度与磁盘文件大小无关

#### 页缓存 Page Cache

虽然消息写入是磁盘顺序写入，没有磁盘寻道的开销，但是如果针对每条消息都执行一次磁盘写入，则也会造成大量的磁盘IO，影响性能。

所以在消息写入方面，broker基于MMAP技术，即内存映射文件，将消息先写入到操作系统的页缓存中，由页缓存直接映射到磁盘文件，不需要在用户空间和内核空间直接拷贝消息，所以也可以认为消息传输是发送在内存中的。

由于是先将消息写入到操作系统的页缓存，而页缓存数据刷新同步sync到磁盘文件是由操作系统来控制的，即操作系统通过一个内核后台线程，每5秒检查一次是否需要将页缓存数据同步到磁盘文件，如果超过指定时间或者超过指定大小则将页缓存数据同步到磁盘。所以如果在刷新到磁盘文件之前broker机器宕机了，则会导致页缓存的数据丢失。

减少内存开销： Java对象的内存开销（overhead）非常大，往往是对象中存储的数据所占内存的两倍以上。

避免GC问题：Java中的内存垃圾回收会随着堆内数据不断增长而变得越来越不明确，回收所花费的代价也会越来越大。

简单可靠：OS会调用所有的空闲内存作为PageCache，并在其上做了大量的优化：预读，后写，flush管理等，这些都不用应用层操心，而是由OS自动完成。

## 生产者策略

- 使用**分区策略来提高系统可用性和进行负载均衡**【高可扩展】
- 使用**ACK应答机制**来保障数据的可靠性【副本同步策略、ISR、Exactly Once语义】保证的一系列策略来解决系统复杂性问题，例如保证**消息的不重不漏**【高并发】
- 使用**故障转移机制**【HW&LEO概念、故障同步机制、Leader选举】来**保证消息的数据一致性**，防止意外宕机丢数据导致不一致【高可用】

### 分区策略

Kafka 每个 topic 的 partition 有 N 个副本（replicas），其中 N（大于等于 1）是 topic 的复制因子（replica fator）的个数。Kafka 通过多副本机制实现故障自动转移，当 Kafka 集群中出现 broker 失效时，副本机制可保证服务可用。对于任何一个 partition，**它的 N 个 replicas 中，其中一个 replica 为 leader，其他都为 follower**，leader 负责处理 partition 的所有读写请求，follower 则负责被动地去复制 leader 上的数据。

![](./MessageQueue-Kafka/replica.jpg)

#### 分区的原因

为什么要分区呢？对于分布式系统的三高我们已经很熟悉了，我们再来强调一下：

- **高可扩展**：方便在集群中扩展，每个 Partition 可以通过调整以适应它所在的机器，而一个 topic，又可以有多个 Partition 组成，因此整个集群就可以适应任意大小的数据了
- **高并发**：可以提高并发，因为可以以 Partition 为单位读写了，可以并发的往一个Topic的多个Partion中发送消息
- **高可用**：当然有了高可用和高可扩展了，我们还希望整个集群稳定，并发的情况下消息不会有丢失现象，为了保证数据的可靠性，我们每个分区都有多个副本来保证不丢消息，如果 leader 所在的 broker 发生故障或宕机，对应 partition 将因无 leader 而不能处理客户端请求，这时副本的作用就体现出来了：一个新 leader 将从 follower 中被选举出来并继续处理客户端的请求

如上图所示展示的，我们分布式集群的特性才能体现出来，其实不光是Kafka，所有的分布式中间件，都需要满足以上的特性。

#### 分区的原则

producer 采用 push 模式将消息发布到 broker，每条消息都被 append 到 patition 中，属于顺序写磁盘（顺序写磁盘效率比随机写内存要高，保障 kafka 吞吐率）。producer 发送消息到 broker 时，既然分区了，我们怎么知道生产者的消息该发往哪个分区呢？producer 会根据分区算法选择将其存储到哪一个 partition。

```java
ProducerRecord(@NotNull String topic, Integer partition, Long timestamp, String key. String value, @Nullable Iterable <Header> headers!
ProducerRecord(@NotNull String topic, Integer partition, Long timestamp, String key, String value)
ProducerRecord(@NotNull String topic, Integer partition, String key. String value, @Nullable Iterable<Header> headers)
ProducerRecord(@NotNull String topic, Integer partition, String key, String value)
ProducerRecord(@NotNull String topic, String key, String value)
ProducerRecord(@NotNull String topic, String value)
```

从代码结构里我们可以看到实际上可以归纳为三种方法，也就是三种路由机制，决定消息被发往哪个分区，分别是：

1. 指明 partition 的情况下，**直接将指明的值直接作为 partiton 值；**
2. 没有指明 partition 值但有 key 的情况下，**将 key 的 hash 值与 topic 的 partition数进行取余得到 partition 值**
3. 既没有 partition 值又没有 key 值的情况下，**第一次调用时随机生成一个整数（后面每次调用在这个整数上自增），将这个值与 topic 可用的 partition 总数取余得到 partition值，也就是常说的 round-robin 算法**【轮询算法】

可以说分区策略对于Kafka来说是三高机制的基础，有了分区才能实现Kafka的高可扩展，在这样的构建模型之上我们来看看基于分区机制，Kafka如何实现**数据可靠性【高并发】和故障转移【高可用】**。

### ACK应答机制

为保证 producer 发送的ac数据，能可靠的发送到指定的 topic，topic 的每个 partition 收到producer 发送的数据后，都需要向 producer 发送 ack（acknowledgement 确认收到），如果producer 收到 ack，就会进行下一轮的发送，否则重新发送数据。

![](./MessageQueue-Kafka/ack.jpg)

Kafka 为用户提供了三种可靠性级别，**用户根据对可靠性和延迟的要求进行权衡**，当 producer 向 leader 发送数据时，可以通过 request.required.acks 参数来设置数据可靠性的级别：

1. request.required.acks = 0，producer 不停向leader发送数据，而不需要 leader 反馈成功消息，这种情况下数据传输效率最高，但是数据可靠性确是最低的。可能在发送过程中丢失数据，可能在 leader 宕机时丢失数据。【传输效率最高，可靠性最低】
2. request.required.acks = 1，这是默认情况，即：producer 发送数据到 leader，leader 写本地日志成功，返回客户端成功；此时 ISR 中的其它副本还没有来得及拉取该消息，如果此时 leader 宕机了，那么此次发送的消息就会丢失。【**传输效率中，可靠性中**】

![](./MessageQueue-Kafka/ack_sync.jpg)

1. request.required.acks = -1（all），producer 发送数据给 leader，leader 收到数据后要等到 ISR 列表中的所有副本都同步数据完成后（强一致性），才向生产者返回成功消息，如果一直收不到成功消息，则认为发送数据失败会自动重发数据。这是可靠性最高的方案，当然，性能也会受到一定影响。【**传输效率低，可靠性高**】，`同时如果在 follower 同步完成后，broker 发送 ack 之前，leader 发生故障，那么会造成数据重复`

![](./MessageQueue-Kafka/ack_repeat.jpg)

当 request.required.acks = -1时需要注意，如果要提高数据的可靠性，在设置 request.required.acks=-1 的同时，还需参数 `min.insync.replicas` 配合，如此才能发挥最大的功效。min.insync.replicas 这个参数用于设定 ISR 中的最小副本数，默认值为1，**当且仅当 request.required.acks 参数设置为-1时，此参数才生效。当 ISR 中的副本数少于 min.insync.replicas 配置的数量时，客户端会返回异常**：`org.apache.kafka.common.errors.NotEnoughReplicasExceptoin: Messages are rejected since there are fewer in-sync replicas than required`。通过将参数 min.insync.replicas 设置为 2，当 ISR 中实际副本数为 1 时（只有leader），将无法保证可靠性，**因为如果发送ack后leader宕机，那么此时该条消息就会被丢失**，所以应该拒绝客户端的写请求以防止消息丢失。在-1策略下有三个问题单独讨论一下：

### 副本同步策略

当 request.required.acks=-1时需要ISR中的全部副本都同步完成，才返回ACK，但是其实在最终确定这个方案之前还有一些别的方案，讨论核心是那么到底多少foller副本同步完成，才发送ack?

| 方案                        | 优点                                                   | 缺点                                              |
| --------------------------- | ------------------------------------------------------ | ------------------------------------------------- |
| 半数以上完成同步，就发送ack | 延迟低                                                 | 选举新leader时，容忍n台节点的故障，需要2n+1个副本 |
| **全部完成同步，才发送ack** | **选举新的leader时，容忍n台节点的故障，需要n+1个副本** | **延迟高**                                        |

现有的两种方案我们选择了第二种，第一种占用的机器资源过多，造成了大量的数据冗余，而网络延迟对于Kafka的影响并不大。

### ISR机制

​    ![在这里插入图片描述](./MessageQueue-Kafka/stickPicture.png)

生产者把消息发送到服务器的leader上，然后leader将消息同步给自己的follower。

kafka默认当所有follower都完成同步消息后再返回给生产者ACK。但考虑到这样一种场景：当leader有若干个follower，其中每次同步的时候都有一个follower因为故障迟迟不能与leader完成同步，那么leader就要一直等下去。。。

实际上，leader通过一个同步副本ISR（in-sync replic set）机制解决了这个问题。**ISR意味着和leader保持同步的follower集合**，当follower从leader完成同步消息之后，leader就会向follower发送ack，如果follower长时间没有响应ack，则会被踢出ISR，该时间阈值由replic.lag.time.max.ms指定（默认10秒）。当leader宕机之后，则会从ISR中选举出新的leader。

#### 选举策略

采用全量副本同步方案后，我们发送ack的时机确定如下：leader 收到数据，所有 follower 都开始同步数据，但是设想如下情况：有一个 follower，因为某种故障，迟迟不能与 leader 进行同步，那 leader 就要一直等下去，直到它完成同步，才能发送 ack。这个问题怎么解决呢？我们引入ISR的概念

- 所有的副本（replicas）统称为 Assigned Replicas，即 AR
- ISR 是 AR 中的一个子集，由 leader 维护 ISR列表，follower 从 leader 同步数据有一些延迟（由参数 replica.lag.time.max.ms **设置超时阈值**），超过阈值的 follower 将被剔除出 ISR， 存入 OSR（Outof-Sync Replicas）列表，新加入的 follower 也会先存放在 OSR 中
- **AR=ISR+OSR**，也就是所有**副本=可用副本+备用副本**。
- ISR列表包括：leader + 与leader保持同步的followers，Leader 发生故障之后，会从 ISR 中选举新的 leader

在这种机制下，ISR始终是动态保持稳定的集群，消息来了之后，leader先读取，然后推送到各个follwer里，保证ISR中各个副本处于同步状态，只要所有ISR中的follwer都同步完成即可发布ACK，leader挂掉后，立即能从ISR中选举新的leader来处理消息。

**Exactly Once语义**对于一些非常重要的信息，消费者要求数据既不重复也不丢失，即 **Exactly Once 语义**。其实以上讨论的三种策略可以如此归类语义：

1. 将服务器 ACK 级别设置为 0，可以保证生产者每条消息只会被发送一次，即 At Most Once 语义，极容易丢失数据。
2. 将服务器 ACK 级别设置为 1，可以理解为碰运气语义，正常情况下，leader不宕机且刚好宕机前将数据同步给了副本的话不会丢失数据，其它情况就会造成数据的丢失。
3. 将服务器的 ACK 级别设置为-1，可以保证 Producer 到 Server 之间不会丢失数据，即 At Least Once 语义，At Least Once **可以保证数据不丢失，但是不能保证数据不重复**

顾名思义，我们一定是需要在不丢数据的基础上去去重，在 0.11 版本以前的 Kafka，对此是无能为力的，只能保证数据不丢失，再在下游消费者对数据做全局去重。对于多个下游应用的情况，每个都需要单独做全局去重，这就对性能造成了很大影响。

**幂等性【partion Exactly Once】**

0.11 版本的 Kafka，引入了一项重大特性：幂等性。所谓的幂等性就是指 Producer 不论向 Server 发送多少次重复数据，Server 端都只会持久化一条。幂等性结合 At Least Once 语义，就构成了 Kafka 的 Exactly Once 语义。即：`At Least Once + 幂等性 = Exactly Once`

要启用幂等性，只需要将 Producer 的参数中 enable.idompotence 设置为 true 即可。Kafka的幂等性实现其实就是将原来下游需要做的去重放在了数据上游。开启幂等性的 Producer 在初始化的时候会被分配一个 PID，发往同一 Partition 的消息会附带 Sequence Number。而Broker 端会对<PID, Partition, SeqNumber>做缓存，当具有相同主键的消息提交时，Broker 只会持久化一条。**但是 PID 重启就会变化，同时不同的 Partition 也具有不同主键，所以幂等性无法保证跨分区跨会话的 Exactly Once。**

**生产者事务【topic Exactly Once】**

为了实现跨分区跨会话的事务以及防止PID重启造成的数据重复，需要引入一个Topic全局唯一的 Transaction ID，并**将 Producer获得的PID和Transaction ID绑定**。这样当Producer重启后就可以通过正在进行的TransactionID 获得原来的 PID。为了管理 Transaction，Kafka 引入了一个新的组件 Transaction Coordinator。Producer 就是通过和 Transaction Coordinator 交互获得 Transaction ID 对应的任务状态TransactionCoordinator 还负责将事务所有写入 Kafka 的一个内部 Topic，这样即使整个服务重启，由于事务状态得到保存，进行中的事务状态可以得到恢复，从而继续进行。

### 故障转移机制

在数据可靠性保障策略中我们了解到如何通过分区和副本，以及动态的ISR和ACK机制来确保消息的可靠，那么接下来深入探讨下，**故障发生的时候，我们如何将集群恢复正常**？首先需要明确两个概念：LEO和HW：

- **Base Offset**：是起始位移，该副本中第一条消息的offset，如下图，这里的起始位移是0，如果一个日志文件写满1G后（默认1G后会log rolling），这个起始位移就不是0开始了。
- **HW（high watermark）**：副本的高水印值，**replica中leader副本和follower副本都会有这个值，通过它可以得知副本中已提交或已备份消息的范围，leader副本中的HW，决定了消费者能消费的最新消息能到哪个offset**。如下图所示，HW值为8，代表offset为[0,8]的9条消息都可以被消费到，它们是对消费者可见的，而[9,12]这4条消息由于未提交，对消费者是不可见的。注意HW最多达到LEO值时，这时可见范围不会包含HW值对应的那条消息了，如下图如果HW也是13，则消费的消息范围就是[0,12]。
- **LEO（log end offset）**：日志末端位移，代表日志文件中下一条待写入消息的offset，**这个offset上实际是没有消息的。不管是leader副本还是follower副本，都有这个值。当leader副本收到生产者的一条消息，LEO通常会自增1**，而follower副本需要从leader副本fetch到数据后，才会增加它的LEO，最后**leader副本会比较自己的LEO以及满足条件的follower副本上的LEO，选取两者中较小值作为新的HW，来更新自己的HW值**。

![](./MessageQueue-Kafka/HW_commit.jpg)

而leader和副本之间LEO及HW的更新时机如下：

![](./MessageQueue-Kafka/HW_update.jpg)

- **remote LEO是保存在leader副本上的follower副本的LEO**，可以看出leader副本上保存所有副本的LEO，当然也包括自己的。remote LEO是保存在leader副本上的follower副本的LEO，可以看出leader副本上保存所有副本的LEO，当然也包括自己的。
- **follower LEO就是follower副本的LEO**，它的更新是在follower副本得到leader副本发送的数据并随后写入到log文件，就会更新自己的LEO

#### 标准写入流程

在了解故障转移机制前，我们先来看看标准的写入流程是什么样的，这样在故障的时候我们可以看到故障发生在哪些节点影响标准写入流程，以及故障转移机制如何处理使其恢复正常：

![](./MessageQueue-Kafka/write.jpg)

1. producer发送消息4、5给leader【之前提到过只有leader可以读写数据】，leader收到后更新自己的LEO为5
2. fetch尝试更新remote LEO，因为此时leader的HW为3，且follower1和follower2的最小LEO也是3，所以remote LEO为3
3. leader判读ISR中哪些副本还和自己保持同步，剔除不能保持同步的follower，得出follower1和follower2都可以
4. leader计算自己的HW，取所有分区LEO的最小值为HW为3
5. leader将消息4、5以及自己的HW发往follower1和follower2，follower1和follower2开始向自己的log写日志并更新消息4、5，但是follower1更新的快些，leo为5，而follower2更新的慢些，leo为4
6. fetch再次更新remote LEO，取所有follower中的最小LEO为4，然后更新Leader的HW为4
7. leader将自己的HW发往follower1和follower2，直到follower2同步完了更新自己的LEO为5，remote LEO为5，leaderHW为5，更新follower2中的HW为5则同步结束

实质上，`Leader的HW是所有LEO最短的offset，并且是消费者需要认定的offset，Follower的HW则是Leader的HW和自身LEO取最小值，也就是长度不能超过消费者认定的offset`Kafka 的复制机制既不是完全的同步复制，也不是单纯的异步复制。

- 同步复制要求所有能工作的 follower 都复制完，这条消息才会被 commit，这种复制方式受限于复制最慢的 follower，会极大的影响吞吐率。**也就是 request.required.acks = -1策略**
- 异步复制方式下，follower 异步的从 leader 复制数据，数据只要被 leader 写入 log 就被认为已经 commit，这种情况下如果 follower 都还没有复制完，落后于 leader 时，突然 leader 宕机，则会丢失数据，降低可靠性，**也就是 request.required.acks = 1策略**

而 Kafka 使用`request.required.acks = -1 + ISR` 的策略则在可靠性和吞吐率方面取得了较好的平衡，同步复制并干掉复制慢的副本，只同步ISR中的Follwer，

故障转移机制

当不同的机器宕机故障时来看看ISR如何处理集群以及消息，分为 follower 故障和leader故障：

- follower故障，follower 发生故障后会被临时踢出 ISR，待该 follower 恢复后，follower 会读取本地磁盘记录的上次的 follower HW，并将 log 文件高于follower HW 的【follower HW一定小于leader HW】部分截取掉，令副本的LEO与故障时的follower HW一致，然后follower LEO 开始从 leader 同步。等该 follower 的 LEO 大于等于该 Partition 的 的 HW【也就是leader的HW】，即 follower 追上 leader 之后，就可以重新加入 ISR 了。你可能会问为什么不从follower的LEO之后开始截呢？试想一下，如果follower故障离场后，leader也故障离场，一个LEO比故障follower的ISR follower当选为新leader，那么故障follower回归后会比新leader多消息，这显然造成了数据不一致。
- leader 故障，leader 发生故障之后，会从 ISR 中选出一个新的 leader之后，为保证多个副本之间的数据一致性，其余的 follower 会先将各自的 log 文件高于HW【也就是leader的HW】的部分截掉，然后从新的 leader同步数据。如果新leader的LEO就是HW，则直接接收新的消息即可，如果是其它某个Follower的LEO是HW，则从新Leader同步Leader的LEO-HW之间的消息给所有副本

总而言之，要以所有副本都同步好的**最新的HW为准（这样可以保证follower的消息永远是小于等于leader的）**。但这只是处理方法，并不能保证数据不重复或者不丢失，我们来看一种数据重复的案例：**Leader宕机**：考虑这样一种场景：acks=-1，部分 ISR 副本完成同步，此时leader挂掉，如下图所示：

![](./MessageQueue-Kafka/HW_leader_down.jpg)

1. follower1 同步了消息 4、5，follower2 同步了消息 4，HW为4。
2. leader宕机，由于还未收到follower2 同步完成的消息，所以没有给生产者发送ACK，与此同时 follower1 被选举为 leader，follower2从follower1开始同步数据。当然如果follower2被选为leader，那么follower就需要截断自己的消息5。
3. producer未收到ACK，于是重新发送，发送了给了新的leader(老的follower1)，但因为follower1其实已经同步了4、5，所以此时来的消息就是重复消息。

这样就出现了**数据重复**的现象，`所以HW&LEO机制只能保证副本之间保持同步，并不能保证数据不重复或不丢失，要想都保证，需要结合ACK机制食用`

#### Leader选举

在可能发生的故障中，当Leader挂了的时候我们需要选举新的leader，遵循如下策略：Kafka 在 ZooKeeper 中为每一个 partition 动态的维护了一个 ISR，这个 ISR 里的所有 replica 都与 leader 保持同步，**只有 ISR 里的成员才能有被选为 leader 的可能**。

当然也有 **极端情况**：当 ISR 中至少有一个 follower 时（ISR 包括 leader），Kafka 可以确保已经 commit 的消息不丢失，但如果某一个 partition 的所有 replica 都挂了，自然就无法保证数据不丢失了。这种情况下如何进行 leader 选举呢？通常有两种方案：

- 等待 ISR 中任意一个 replica 恢复过来，并且选它作为 leader **【高可靠性】**，如果一定要等待 ISR 中的 replica 恢复过来，不可用的时间就可能会相对较长。而且如果 ISR 中所有的 replica 都无法恢复了，或者数据丢失了，这个 partition 将永远不可用。
- 选择第一个恢复过来的 replica（并不一定是在 ISR 中）作为leader **【高可用性】**，选择第一个恢复过来的 replica 作为 leader，如果这个 replica 不是 ISR 中的 replica，那么，它可能并不具备所有已经 commit 的消息，从而造成消息丢失。

默认情况下，Kafka 采用第二种策略，即 unclean.leader.election.enable=true，也可以将此参数设置为 false 来启用第一种策略



## Kafka 副本同步

Kafka中主题的每个Partition有一个预写式日志文件，每个Partition都由一系列有序的、不可变的消息组成，这些消息被连续的追加到Partition中，Partition中的每个消息都有一个连续的序列号叫做offset，确定它在分区日志中唯一的位置。

**Last Commit Offset :** 消费者最新提交的offset

**High Watermark**：已经成功备份到其他 replicas 中的最新一条数据的 offset。也就是说 Log End Offset 与 High Watermark 之间的数据已经写入到该 partition 的 leader 中，但是还未成功备份到其他的 replicas 中。

**Log End Offset**：Producer 写入到 Kafka 中的最新一条数据的 offset。

![image](./MessageQueue-Kafka/prelog.png)

初始状态下，leader 和 follower 的 HW 和 LEO 都是 0。同时 leader 副本会缓存其他follower的 LEO（后续称为remote LEO），也会被初始化为 0。

这个时候，producer 没有发送消息。follower 会不断地向 leader 发送 fetch 请求拉取数据，但是因为没有数据，这个请求会被 leader 寄存，当在指定的时间之后会强 制 完 成 请 求 ， 这 个 时 间 配 置 是 (replica.fetch.wait.max.ms)，如果在指定时间内 producer有消息发送过来，那么 kafka 会唤醒 fetch 请求，让 leader继续处理。

![](./MessageQueue-Kafka/fetch.png)



### leader 副本收到请求以后

1. 把消息追加到 log 文件
4. 更新 leader 副本的 LEO。
5. 尝试更新 leader HW 值。这个时候由于 follower 副本还没有发送 fetch 请求，那么 leader 记录follower的 LEO （后续称为remote LEO）仍然是 0。leader 会比较自己的 LEO 以及 remote LEO 的值发现最小值是 0，与 HW 的值相同，所以不会更新 HW。

![](./MessageQueue-Kafka/getReq.png)

### follower 发送 fetch 请求

1. 读取 log 数据。

2. 更新 remote LEO=0 (follower 还没有写入这条消息，这个值是根据 follower 的 fetch 请求中的offset 来确定的)并尝试更新 HW。因为这个时候leader的 LEO 和 remote LEO 还是一致，所以仍然是 HW=0。把消息内容和当前分区的 HW 值发送给 follower 副本。

3. follower 副本收到 response 以后将消息写入到本地 log。

4. follower更新自己的LEO及 HW。本地的 LEO 和 leader 返回的 HW进行比较取小的值，所以仍然是 0。

 第一次交互结束以后，HW 仍然还是 0，这个值会在下一次follower 发起 fetch 请求时被更新。

![](./MessageQueue-Kafka/follower_fetch.png)

### follower 发第二次 fetch 请求

1. 读取 log 数据。
2. 更新 remote LEO=1， 因为这次 fetch 携带的 offset 是1。
3.  更新当前分区的 HW，这个时候 leader的 LEO =3，follower1 的LEO 为3、follower2 的LEO 为1，取较小值，所以 HW 的值更新为 1。
4. 把数据和当前分区的 HW 值返回给 follower 副本，这个时候如果没有数据，则返回为空。follower 副本收到 response 以后如果有数据则写本地日志，并且更新 LEO更新 follower 的 HW 值。

到目前为止，数据的同步就完成了，意味着消费端能够消费 HW之前的消息。

![](./MessageQueue-Kafka/follower_fetch_2.png)



### follower 发第三次 fetch 请求

1. 读取 log 数据

2. 更新 remote LEO=2， 因为这次 fetch 携带的 offset 的最小值是2，更新当前分区的 HW为2。这个时候 leader LEO 为3和 remote LEO 为2，取较小值，所以 HW 的值保持为 2。
3. 把数据和当前分区的 HW 值返回给 follower 副本，这个时候如果没有数据，则返回为空。follower 副本收到 response 以后如果有数据则写本地日志，并且更新 LEO更新 follower 的 HW 值。

到目前为止，数据的同步就完成了，意味着消费端能够消费offset=3之前的消息。

![](./MessageQueue-Kafka/follower_fetch_3.png)



### **LEO**、**HW**更新关键点

**Leader:**

1. Leader LEO：消息写入底层log后便发生更新
2. Leader remote LEO：需要比较本地的remote LEO和fetch offset的值，两者取较小
3. Leader HW：需要比较remote LEO和LEO的值，两者取较小

更新顺序：有数据写入底层日志LEO更新，其次会尝试更新remote LEO，再尝试更新HW

**Follower:**

1. Follower LEO：取决于response中是否有日志数据

2. Follower HW：response中的HW和LEO进行比较，两者取较小

3. 副本最后一条消息的offset与leader副本的最后一条消息的offset之间的差值不能超过指定的阈值replica.lag.time.max.ms 如果该follower在此时间间隔内一直没有追上过leader的所有消息，则该follower就会被剔除ISR列表。

具体来说是这样的一种情况，首先很多时候是leader 成功写入消息就完成对于producer的成功写入响应的，在这种情形下当完成第一轮写入，成功返回后follower 挂掉了，然后HW未更新，当重启时会做日志截断，所以实际上HW值是比leader小的，然后正要同步消息的时候，leader挂了，然后刚才重启的follower成为了leader，之前的leader 重启后就会更新HW值为最小值，所以就导致了刚才那条消息的丢失。通常就是这种轮着宕机轮着重启情况下才会出现的问题，虽然极端，但还是有这个风险。

## Consumer消费者

任何Consumer必须属于一个Consumer Group

Consumer Group组内多个的Consumer可以公用一个Consumer Id，组内所有的Consumer只能注册到一个分区上去消费，如图，Consumer Group 1的三个Consumer实例分别消费不同的partition的消息，即，TopicA-part0、TopicA-part1、TopicA-part2。一个Consumer Group只能到一个Topic上去消费。

partition内消息是有序的，Consumer通过pull方式消费消息。

Kafka不删除已消费的消息

![](./MessageQueue-Kafka/consumer.png)

### 消费者策略：消费方式、分区分配策略、offset的维护

### **两种消费方式**

消息有两种方式被投递，一种是broker推给消费者，一种是消费者从broker拉。这两种方式各自有优缺点：

- **push 模式很难适应消费速率不同的消费者** ，因为消息发送速率是由 broker 决定的。它的目标是尽可能以最快速度传递消息，但是这样很容易造成 consumer 来不及处理消息，典型的表现就是拒绝服务以及网络拥塞。
- **pull 模式则可以根据 consumer 的消费能力以适当的速率消费消息**。pull 模式不足之处是，如果 kafka 没有数据，消费者可能会陷入循环中，一直返回空数据

Kafka 采取的是pull 模式，它可简化 broker 的设计，consumer 可自主控制消费消息的速率，同时 consumer 可以自己控制消费：

- 控制消费方式——**既可批量消费也可逐条消费**，同时还能选择不同的提交方式从而实现不同的传输语义
- 超时返回机制——Kafka 的消费者在消费数据时会传入一个时长参数 timeout，如果当前没有数据可供消费，consumer 会等待一段时间之后再返回，这段时长即为 timeout

通过pull以及一定的策略可以满足Kafka的消费诉求。需要注意：

- 如果消费线程大于 patition 数量，则有些线程将收不到消息；
- 如果 patition 数量大于消费线程数，则有些线程多收到多个 patition 的消息；如果一个线程消费多个 patition，则无法保证你收到的topic消息的顺序，而一个 patition 内的消息是有序的。

这三点需要注意，消息的消费和分区个数的关系。

### Consumer 分区分配策略

一个 Consumer Group 中有多个 Consumer，一个 Topic 有多个 Partition，所以必然会涉及到 Partition 的分配问题，h或发生再均衡之后，也会涉及到分区重新分配问题。即确定哪个 Partition 由哪个 Consumer 来消费。

Kafka 有有三种分配策略：**RoundRobin， Range，Sticky**，默认为Range，当消费者组内消费者发生变化时，会触发分区分配策略（方法重新分配）。

- 目前我们还不能自定义分区分配策略，只能通过partition.assignment.strategy参数选择 range 或 roundrobin。**partition.assignment.strategy参数默认的值是range**。
- **同一个组内同一分区只能被一个消费者消费，可以理解，如果一个组内多个消费者消费同一个分区，那么该消费者组如何保证单分区消息的顺序性呢？**

无论是哪种策略，`当消费者组里的消费者个数的变化【增多或减少】或者订阅主题分区的增加都会触发重新分配`,这种将分区的所有权从**一个消费者移到另一个消费者称为**重新平衡（rebalance）

**什么情况下会发生消费者的重新负载均衡呢？**

1. 当consumer group 新增消费者

2. consumer group有消费者退出时，比如主机停机

3. topic新增分区时，分区的数量发生变化时； 

#### Range策略

Range分配策略是面向每个主题的，首先会对**同一个topic里面的分区按照序号进行排序，并把消费者线程按照字母顺序进行排序**。然后用分区数除以消费者线程数量来判断每个消费者线程消费几个分区。如果除不尽，那么前面几个消费者线程将会多消费一个分区。当然，这样的缺点就是对**每个组内的每个消费者分布不均匀**。

![](./MessageQueue-Kafka/distribute2.png)

Range 方式是按照主题来分的，不会产生轮询方式的消费混乱问题。

但是，如上方图2所示，Consumer0、Consumer1 同时订阅了主题 A 和 B，可能造成消息分配不对等问题，当消费者组内订阅的主题越多，分区分配可能越不均衡。

在一个消费者组中的消费者消费的是一个主题的部分分区的消息，而一个主题中包含若干个分区，一个消费者组中也包含着若干个消费者。当二者的数量关系处于不同的大小关系时，Kafka消费者的工作状态也是不同的。看以下三种情况：

1. **消费者数目<分区数目**：此时不同分区的消息会被均衡地分配到这些消费者。

2. **消费者数目=分区数目**：每个消费者会负责一个分区的消息进行消费。

3. **消费者数目>分区数目**：此时会有多余的消费者处于空闲状态，其他的消费者与分区一对一地进行消费。

在再均衡发生的时候，消费者无法读取消息，会造成整个消费者组有一小段时间的不可用；当分区被重新分配给另一个消费者时，消费者当前的读取状态会丢失，它有可能需要去刷新缓存，在它重新恢复状态之前会拖慢应用。因此也要尽量避免不必要的再均衡。



#### RoudRobin策略

RoudRobin策略也即轮询策略，**RoundRobin策略的原理是将消费组内所有消费者以及消费者所订阅的所有topic的partition按照字典序排序**，然后通过**轮询算法**逐个将分区以此分配给每个消费者，消费者组内分配分区个数最大差别为 1，是按照组来分的，可以解决多个消费者消费数据不均衡的问题

- 如果同一消费组内，所有的消费者订阅的消息都是相同的【也就是所有消费者订阅的topic数量相同】，那么 RoundRobin 策略的分区分配会是均匀的。

- 如果同一消费者组内，所订阅的消息是不相同的，那么在执行分区分配的时候，就不是完全的轮询分配，有可能会导致分区分配的不均匀。**如果某个消费者没有订阅消费组内的某个 topic，那么在分配分区的时候，此消费者将不会分配到这个 topic 的任何分区**。

  

前提是**同一个消费者组里的每个消费者订阅的主题必须相同**，当然也一定是相同的，如果不同也就没必要放到一个消费组里了。

Round Robin 轮询方式将分区所有作为一个整体进行 Hash 排序，消费者组内分配分区个数最大差别为 1，是按照组来分的，可以解决多个消费者消费数据不均衡的问题。

![](./MessageQueue-Kafka/distribute.png)

但是，当消费者组内订阅不同主题时，可能造成消费混乱，如上方图2所示，Consumer0 订阅主题 A，Consumer1 订阅主题 B,将 A、B 主题的分区排序后分配给消费者组，TopicB 分区中的数据可能分配到 Consumer0 中。

#### Sticky策略

这样的分区策略是从0.11版本才开始引入的，它主要有两个目的

- 分区的分配要尽可能的均匀，分配给消费者者的主题分区数最多相差一个
- 分区的分配要尽可能与上次分配的保持相同

举例进行分析：比如有3个消费者（C0，C1，C2），都订阅了2个主题（T0 和 T1）并且每个主题都有 3 个分区(p0、p1、p2)，那么所订阅的所有分区可以标识为T0p0、T0p1、T0p2、T1p0、T1p1、T1p2。此时使用Sticky分配策略后，得到的分区分配结果和RoudRobin相同:

| 消费者线程 | 对应消费的分区序号 |
| ---------- | ------------------ |
| CO         | T0p0,T1p0          |
| C1         | T0p1,T1p1          |
| C2         | T0p2,T1p2          |

虽然触发了再分配，但是记忆了上一次C0和C1的分配结果。这样的好处是发生分区重分配后，**对于同一个分区而言有可能之前的消费者和新指派的消费者不是同一个，对于之前消费者进行到一半的处理还要在新指派的消费者中再次处理一遍，这时就会浪费系统资源**。而使用Sticky策略就可以让分配策略具备一定的“粘性”，尽可能地让前后两次分配相同，进而可以减少系统资源的损耗以及其它异常情况的发生

| 消费者线程 | 对应消费的分区序号 |
| ---------- | ------------------ |
| CO         | T0p0,T0p2,T1p1     |
| C1         | T0p1,T1p0,T1p2     |

但是如果使用的是Sticky分配策略，再平衡后的结果会是这样：

| 消费者线程 | 对应消费的分区序号 |
| ---------- | ------------------ |
| CO         | T0p0,T1p0,T0p2     |
| C1         | T0p1,T1p1,T1p2     |

虽然触发了再分配，但是记忆了上一次C0和C1的分配结果。这样的好处是发生分区重分配后，**对于同一个分区而言有可能之前的消费者和新指派的消费者不是同一个，对于之前消费者进行到一半的处理还要在新指派的消费者中再次处理一遍，这时就会浪费系统资源**。而使用Sticky策略就可以让分配策略具备一定的“粘性”，尽可能地让前后两次分配相同，进而可以减少系统资源的损耗以及其它异常情况的发生

### **offset的维护**

在现实情况下，消费者在消费数据时可能会出现各种会导致宕机的故障问题，这个时候，如果消费者后续恢复了，它就需要从发生故障前的位置开始继续消费，而不是从头开始消费。所以消费者需要实时的记录自己消费到了哪个offset，便于后续发生故障恢复后继续消费。Kafka 0.9版本之前，consumer默认将offset保存在Zookeeper中，从0.9版本开始，consumer默认将offset保存在Kafka一个内置的topic中，该topic为`__consumer_offsets` 

同一个组里的，当动态扩展分区分配时新进入的消费者接着消费分区消息而不是重新消费。offset是按照：goup+topic+partion来划分的，这样保证组内机器有问题时能接着消费

### Zookeeper管理

在基于 Kafka 的分布式消息队列中，ZooKeeper 的作用有：Producer端注册及管理、Consumer端注册及管理以及Kafka集群策略管理 等。

![](./MessageQueue-Kafka/zk.jpg)

### Producer端注册及管理

在Producer端Zookeeper能够实现：注册并动态调整broker，注册并动态调整topic，Producers负载均衡。

**注册并动态调整Broker**

broker是注册在zookeeper中的，还记得在分布式集群搭建的时候，我们在zk的配置文件中添加的服务节点，就是用来注册broker的。

- **存放地址**：为了记录 broker 的注册信息，在 ZooKeeper 上，专门创建了属于 Kafka 的一个节点，其路径为 **/brokers**
- **创建节点**：Kafka 的每个 broker 启动时，都会到 ZooKeeper 中进行注册，告诉 ZooKeeper 其 broker.id，**在整个集群中，broker.id** 应该全局唯一，并在 ZooKeeper 上创建其属于自己的节点，其节点路径为`/brokers/ids/{broker.id}`；创建完节点后，Kafka 会将该 broker 的**broker.name 及端口号**记录到该节点；
- **删除节点**：该 broker 节点属性为临时节点，当 broker 会话失效时，ZooKeeper 会删除该节点，这样，我们就可以很方便的监控到broker 节点的变化，及时调整负载均衡等。

**注册并动态调整Topic**

在 Kafka 中，所有 topic 与 broker 的对应关系都由 ZooKeeper 进行维护，在 ZooKeeper 中，建立专门的节点来记录这些信息，其节点路径为 `/brokers/topics/{topic_name}`前面说过，为了保障数据的可靠性，每个 Topic 的 Partitions 实际上是存在备份的，并且备份的数量由 Kafka 机制中的 replicas 来控制。

**Producers负载均衡**

对于同一个 topic 的不同 partition，Kafka会尽力将这些 partition 分布到不同的 broker 服务器上，**这种均衡策略实际上是基于 ZooKeeper 实现的。**

- **监听broker变化**，producers 启动后也要到 ZooKeeper 下注册，创建一个临时节点来监听 broker 服务器列表的变化。由于ZooKeeper 下 broker 创建的也是临时节点，当 brokers 发生变化时，producers 可以得到相关的通知，从改变自己的 broker list。
- **监听topic变化**，topic 的变化以及broker 和 topic 的关系变化，也是通过 ZooKeeper 的 Watcher 监听实现的 当broker变化以及topic变化的时候，zookeeper能监听到，并控制消息和分区的分布。

### **Kafka集群策略管理**

除了生产者涉及的管理行为，在我们前面提到的故障转移机制以及分区策略等内容中相关的其它管理行为也是由Zookeeper完成的

- **选举leader**，Kafka 为每一个 partition **找一个节点作为 leader，其余备份作为 follower，如果 leader 挂了，follower 们会选举出一个新的 leader 替代，**继续业务
- **副本同步**，当 producer push 的消息写入 partition（分区) 时，**作为 leader 的 broker（Kafka 节点） 会将消息写入自己的分区，同时还会将此消息复制到各个 follower，实现同步。**
- **维护ISR，如果某个follower 挂掉，leader 会再找一个替代并同步消息**

所有的这些操作都是Zookeeper做的。

### **Consumer端注册及管理**

在Consumer端Zookeeper能够实现：注册并动态调整Consumer，Consumer负载均衡。

**注册并动态调整Consumer**

在消费者端ZooKeeper 做的工作有那些呢？

- 注册新的消费者分组，当新的消费者组注册到 ZooKeeper 中时，ZooKeeper 会创建专用的节点来保存相关信息，其节点路径为 `/consumers/{group_id}`，其节点下有三个子节点，分别为 [ids, owners, offsets]。- **ids 节点：记录该消费组中当前正在消费的消费者**，`记录分组下消费者`- **owners 节点：记录该消费组消费的 topic 信息**，`/consumers/[group_id]/owners/[topic]/[broker_id-partition_id]`，其中，`[broker_id-partition_id]`就是一个消息分区的标识，节点内容就是该 消息分区上消费者的Consumer ID，这样分区和消费者就能关联起来了。**关联分区和消费者**- **offsets 节点：记录每个 topic 的每个分区offset**，在消费者对指定消息分区进行消息消费的过程中，需要定时将分区消息的消费进度Offset记录到Zookeeper上，以便在该消费者进行重启或者其他消费者重新接管该消息分区的消息消费后，能从之前进度继续消息消费。Offset在Zookeeper中由一个专门节点进行记录，其节点路径为:`/consumers/[group_id]/offsets/[topic]/[broker_id-partition_id]`节点内容就是Offset的值，`记录消费者offset`，当然新版本的不记录在zookeeper中
- **注册新的消费者**，当新的消费者注册到 Kafka 中时，会在 `/consumers/{group_id}/ids`节点下创建临时子节点，并记录相关信息。
- **监听消费者分组中消费者的变化**，每个消费者都要关注其所属消费者组中消费者数目的变化，即监听 `/consumers/{group_id}/ids` 下子节点的变化。一但发现消费者新增或减少，就会触发消费者的负载均衡。其实不光是注册consumer，还包括对消费者策略的管理，例如Consumer负载均衡







#### 消费者组是怎么知道一个消费者可不可用呢？

 消费者通过向被指派为群组协调器的Broker发送信息来维持它们和群组的从属关系以及它们对分区的所有权关系。只要消费者以正常的时间间隔发送心跳，就被认为是活跃的，说明它还在读取分区里的消息。消费者会在轮询消息或提交偏移量时发送心跳。如果消费者停止发送心跳的时间足够长，会话就会过期，群组协调器认为它已经死亡，就会触发一次再均衡 。

1. 可以**session.timeout.ms**指定会话过期时间，**heartbeat.interval.ms**指定心跳时间，防止因为未能及时发送心跳，导致Consumer 超时被踢出消费者组。一般可以把 超时时间设置为 心跳间隔的 3倍。

2. 如果Consumer端如果无法在规定时间内消费完 poll 来的消息，那么就认为该消费者有问题，从而该消费者会自主离组，所以我们可以设置 **max.poll.interval.ms**比处理时间略长。 

#### Consumer 消息提交

当触发**再均衡（****rebalance****）**后，每个消费者可能会分配到新的分区，为了能够在在均衡之后继续之前的工作，因此消费者在消费的过程中需要记录自己消费了多少数据，即消费位置信息。再均衡后消费者需要读取每个partition最后一次提交的偏移量，然后从偏移量指定的地方继续处理。



如果提交的偏移量小于客户端处理的最后一个消息的偏移量，那么处于两个偏移量之间的消息就会被重复处理。



如果提交的偏移量大于客户端处理的最后一个消息的偏移量，那么处于两个偏移量之间的消息将会丢失。

![](./MessageQueue-Kafka/commit.png)

**偏移量提交那么消费者如何提交偏移量呢？**


 Kafka 支持自动提交和手动提交偏移量两种方式。

**自动提交：**只需要将消费者的 **enable.auto.commit** 属性配置为 true 即可完成自动提交的配置。 此时每隔固定的时间，消费者就会把 poll() 方法接收到的最大偏移量进行提交，提交间隔由 **auto.commit.interval.ms** 属性进行配置，默认值是 5s。


 使用自动提交是存在隐患的，假设我们使用默认的 5s 提交时间间隔，在最近一次提交之后的 3s 发生了再均衡，再均衡之后，消费者从最后一次提交的偏移量位置开始读取消息。这个时候偏移量已经落后了 3s ，所以在这 3s 内到达的消息会被重复处理。可以通过修改提交时间间隔来更频繁地提交偏移量，减小可能出现重复消息的时间窗，不过这种情况是无法完全避免的。基于这个原因，Kafka 也提供了手动提交偏移量的 API，使得用户可以更为灵活的提交偏移量。



**手动提交：**用户可以通过将 enable.auto.commit 设为 false，然后手动提交偏移量。基于用户需求手动提交偏移量可以分为两大类
 手动提交当前偏移量：即手动提交当前轮询的最大偏移量。
 手动提交固定偏移量：即按照业务需求，提交某一个固定的偏移量。
 而按照 Kafka API，手动提交偏移量又可以分为同步提交和异步提交。



## 零拷贝

Kafka两个重要过程都使用了零拷贝技术，且都是操作系统层面的狭义零拷贝，一是Producer生产的数据存到broker，二是 Consumer从broker读取数据。消息数据直接从 page cache 发送到网络 通常的文件读取需要经历如图的流程，有两次用户态与内核态之间内存的拷贝。



kafka使用零拷贝，避免消息在内核态和用户态间的来回拷贝。Producer生产的数据持久化到broker，采用mmap文件映射，实现顺序的快速写入；

Customer从broker读取数据，采用sendfile，将磁盘文件读到OS内核缓冲区后，直接转到socket buffer进行网络发送。

![](./MessageQueue-Kafka/copy.png)























## Kafka 工作原理

消息经过序列化后，通过不同的分区策略，找到对应的分区。

相同主题和分区的消息，会被存放在同一个批次里，然后由一个独立的线程负责把它们发到 Kafka Broker 上。

![](./MessageQueue-Kafka/worker.png)

分区的策略包括顺序轮询、随机轮询和 key hash 这 3 种方式，那什么是分区呢？

分区是 Kafka 读写数据的最小粒度，比如主题 A 有 15 条消息，有 5 个分区，如果采用顺序轮询的方式，15 条消息会顺序分配给这 5 个分区，后续消费的时候，也是按照分区粒度消费。

![](./MessageQueue-Kafka/partion.png)

由于分区可以部署在多个不同的机器上，所以可以通过分区实现 Kafka 的伸缩性，比如主题 A 的 5 个分区，分别部署在 5 台机器上，如果下线一台，分区就变为 4。

Kafka 消费是通过消费群组完成，同一个消费者群组，一个消费者可以消费多个分区，但是一个分区，只能被一个消费者消费。

![](./MessageQueue-Kafka/group.png)

如果消费者增加，会触发 Rebalance，也就是分区和消费者需要重新配对。

不同的消费群组互不干涉，比如下图的 2 个消费群组，可以分别消费这 4 个分区的消息，互不影响。

![](./MessageQueue-Kafka/diff.png)



### **Kafka可靠高效原因**

Kafka是如何保证高效读写数据的呢，有三点支持：**分布式读写、顺序写磁盘以及零拷贝技术**，其实前两点在之前的blog中也有提到

- **分布式读写**，我们提到的各种策略都是为了满足分布式的可靠高效读写
- **顺序写磁盘**，Kafka 的 producer 生产数据，要写入到 log 文件中，写的过程是一直追加到文件末端，为顺序写。同样的磁盘，顺序写能到 600M/s，而随机写只有 100K/s。这与磁盘的机械机构有关，顺序写之所以快，是因为其省去了大量磁头寻址的时间。
- **零拷贝技术**，简单来说就是数据不需要经过用户态，传统的文件读写或者网络传输，通常需要将数据从内核态转换为用户态。应用程序读取用户态内存数据，写入文件 / Socket之前，需要从用户态转换为内核态之后才可以写入文件或者网卡当中，而Kafka使用零拷贝技术让数据直接在内核态中进行传输。

通过以上这几种技术可以实现Kafka的高并发读写

## kafka为何快？

1.顺序读写

2.零拷贝

3.消息压缩

4.分批发送

## kafka零拷贝

对于缓存IO，每个读/写操作都有3次数据拷贝过程

读操作：磁盘-》内核缓冲区-》用户空间缓冲区-》应用程序内存

写操作：应用程序内存-》用户空间缓冲区-》socket缓冲区-》网络

零拷贝：指将数据直接从磁盘文件复制到网卡设备中，减少了内存和用户模式间的上下文切换。

## 如何保证消息不丢失

kafka为了保证数据的可靠性，在生产者层面做了两个实现：

一是在存储层面，即为每个partition设置了副本，分为leader和follower，发送的时候只发送到leader上，然后leader将消息数据同步到follower；

二是在发送层面，kafka要求，只有到leader回复了ack确认收到之后才会完成该条消息的投递，否则会重试







来源：

- 快递+研发部
- 知乎文档：https://zhuanlan.zhihu.com/p/366141522
