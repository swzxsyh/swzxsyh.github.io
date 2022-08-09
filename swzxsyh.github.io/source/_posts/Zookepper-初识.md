---
title: Zookepper 初识
date: 2020-06-16 01:51:22
tags:
---

一. 介绍zookeeper
目标
了解Zookeeper的概念
了解分布式的概念
学习路径
Zookeeper概述
Zookeeper的发展历程
什么是分布式
Zookeeper的应用场景
1.1 zookeeper概述
Apache ZooKeeper的系统为分布式协调是构建分布式应用的高性能服务。
ZooKeeper 本质上是一个分布式的小文件存储系统。提供基于类似于文件系统的目录树方式的数据存储，并且可以对树中的节点进行有效管理。从而用来维护和监控你存储的数据的状态变化。通过监控这些数据状态的变化，从而可以达到基于数据的集群管理。
ZooKeeper 适用于存储和协同相关的关键数据，不适合用于大数据量存储。

1.2 zookeeper被大量使用
Hadoop：使用ZooKeeper 做Namenode 的高可用。
HBase：保证集群中只有一个master，保存hbase:meta表的位置，保存集群中的RegionServer列表。
Kafka：集群成员管理，controller 节点选举。
1.3 什么是分布式
1.3.1 集中式系统
集中式系统，集中式系统中整个项目就是一个独立的应用，整个应用也就是整个项目，所有的东西都在一个应用里面。部署到一个服务器上。
布署项目时，放到一个tomcat里的。也称为单体架构

1.3.2 分布式系统
多台计算机构成
计算机之间通过网络进行通信
彼此进行交互
共同目标
1.3.3 小结
集中式：开发项目时都是在同一个应用里，布署到同一个tomcat，只有一个tomcat即可

分布：分多个工程开发，布署多个tomcat里

1.4 zookeeper的应用场景
1.4.1 注册中心
分布式应用中，通常需要有一套完整的命名规则，既能够产生唯一的名称又便于人识别和记住，通常情况下用树形的名称结构是一个理想的选择，树形的名称结构是一个有层次的目录结构。通过调用Zookeeper提供的创建节点的API，能够很容易创建一个全局唯一的path，这个path就可以作为一个名称。
Dubbo中使用ZooKeeper来作为其命名服务，维护全局的服务地址列表。

1.4.2 配置中心
​ 数据发布/订阅即所谓的配置中心：发布者将数据发布到ZooKeeper一系列节点上面，订阅者进行数据订阅，当数据有变化时，可以及时得到数据的变化通知，达到动态获取数据的目的。

ZooKeeper 采用的是推拉结合的方式。

推: 服务端会推给注册了监控节点的客户端 Wathcer 事件通知

拉: 客户端获得通知后，然后主动到服务端拉取最新的数据

1.4.3 分布式锁——非公平锁
分布式锁是控制分布式系统之间同步访问共享资源的一种方式。在分布式系统中，常常需要协调他们的动作。如果不同的系统或是同一个系统的不同主机之间共享了一个或一组资源，那么访问这些资源的时候，往往需要互斥来防止彼此干扰来保证一致性，在这种情况下，便需要使用到分布式锁。

1.4.4 分布式队列——公平锁
在传统的单进程编程中，我们使用队列来存储一些数据结构，用来在多线程之间共享或传递数据。分布式环境下，我们同样需要一个类似单进程队列的组件，用来实现跨进程、跨主机、跨网络的数据共享和数据传递，这就是我们的分布式队列。

1.4.5 负载均衡
负载均衡是通过负载均衡算法，用来把对某种资源的访问分摊给不同的设备，从而减轻单点的压力。

每台工作服务器在启动时都会去ZooKeeper的servers节点下注册临时节点，每台客户端在启动时都会去servers节点下取得所有可用的工作服务器列表，并通过一定的负载均衡算法计算得出一台工作服务器，并与之建立网络连接

1.4.6 小结
Zookeeper概述
Zookeeper的发展历程
什么是分布式 应用是布署多台服务器上(多个tomcat)
Zookeeper的应用场景
注册中心（房产中介）
配置中心（多台应用(服务) 修改配置文件，不需要重启）
分布式锁 多个应用（服务）同一时刻，只有一个服务能够执行某个操作
分布式队列：使得多进程、多服务间可以同步数据、传输数据、协同工作
负载均衡：使用多应用的调用频率比较平均
二.zookeeper环境搭建
目标

安装Zookeeper

学习路径

Zookeeper的发展历程
什么是分布式
Zookeeper的应用场景
2.1 前提
安装Docker

2.2安装zookeeper
2.2.1 下载

```bash
#Docker拉取镜像
$ docker pull zookeeper
#查看镜像文件
$ docker images  
REPOSITORY    TAG        IMAGE ID       CREATED      SIZE
zookeeper    latest     454af3da184c   6 days ago    252MB
```


2.2.2 修改配置文件

# 使用一个目录，创建zk配置文件/数据/日志目录

```bash
$ mkdir conf  data log
$ tree zk           
zk
├── conf
├── data
└── log
```

# 暂时启动zookeeper

```bash
$ docker run -d --name zk --restart always zookeeper
```

# 复制配置文件

```bash
$ docker cp -a zk:/conf/zoo.cfg ~/Program/zk/conf/zoo.cfg    
$ cat ~/Program/zk/conf/zoo.cfg    

dataDir=/data
dataLogDir=/datalog
tickTime=2000
initLimit=5
syncLimit=2
autopurge.snapRetainCount=3
autopurge.purgeInterval=0
maxClientCnxns=60
standaloneEnabled=true
admin.enableServer=true
server.1=localhost:2888:3888;2181
```

# 停止并删除未配置的zookeeper容器

```bash
$ docker stop zk && docker rm zk
```

# 指定保存数据的目录：data目录
# 如果需要日志，可以创建log文件夹，指定dataLogDir属性
2.2.3 启动zookeeper

```bash
$ docker run -d --name zk --restart always \  
-p 2181:2181 -p 2888:2888 -p 3888:3888 \
-v /Users/swzxsyh/Program/zk/conf/zoo.cfg:/conf/zoo.cfg \
-v /Users/swzxsyh/Program/zk/data:/data \
-v /Users/swzxsyh/Program/zk/log:/datalog \
zookeeper

#zookeeper客户端端口，跟随端口，选择端口
```



2.2.4 启动客户端测试


# 下载客户端，启动
$ ./zkCli.sh     
/usr/bin/java
2020-06-16 17:13:31,750 [myid:] - INFO  [main:ClientCnxn@1653] - zookeeper.request.timeout value is 0. feature enabled=
# 省略中间输出...
# 出现此行即说明连接成功
Welcome to ZooKeeper!
2020-06-16 17:13:31,757 [myid:localhost:2181] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1112] - Opening socket connection to server localhost/127.0.0.1:2181. Will not attempt to authenticate using SASL (unknown error)
JLine support is enabled
2020-06-16 17:13:31,834 [myid:localhost:2181] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@959] - Socket connection established, initiating session, client: /127.0.0.1:64028, server: localhost/127.0.0.1:2181
[zk: localhost:2181(CONNECTING) 0] 2020-06-16 17:13:31,896 [myid:localhost:2181] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1394] - Session establishment complete on server localhost/127.0.0.1:2181, sessionid = 0x100014a6eed0000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
[zk: localhost:2181(CONNECTED) 0] 
2.2.5 小结
pull镜像
创建data/conf/log目录
复制zoo.cfg文件并加载启动
三.zookeeper基本操作
目标

Zookeeper的客户端命令
Zookeeper的java的api操作
学习路径

Zookeeper的数据结构

节点的分类

持久性
临时性
客户端命令（创建、查询、修改、删除）

Zookeeper的java的api介绍（创建、查询、修改、删除）

Zookeeper的watch机制

NodeCache
PathChildrenCache
TreeCache
3.1 zookeeper数据结构
ZooKeeper 的数据模型是层次模型。层次模型常见于文件系统。

每个目录下面可以创建文件，也可以创建子目录，最终构成了一个树型结构。通过这种树型结构的目录，可以将文件分门别类的进行存放，方便我们后期查找。

层次模型和key-value 模型是两种主流的数据模型。ZooKeeper 使用文件系统模型主要基于以下两点考虑
文件系统的树形结构便于表达数据之间的层次关系。
文件系统的树形结构便于为不同的应用分配独立的命名空间（namespace 路径url）
ZooKeeper 的层次模型称作data tree。Datatree 的每个节点叫作znode（Zookeeper node）。不同于文件系统，每个节点都可以保存数据。每个节点都有一个版本(version)。版本从0 开始计数。



如图所示，data tree中有两个子树，用于应用1( /app1)和应用2（/app2）。

每个客户端进程pi 创建一个znode节点 p_i 在 /app1下， /app1/p_1就代表一个客户端在运行。

3.2 节点的分类
一个znode可以是持久性的，也可以是临时性的
持久性znode[PERSISTENT]，这个znode一旦创建不会丢失，无论是zookeeper宕机，还是client宕机。
临时性的znode[EPHEMERAL]，如果zookeeper宕机了，或者client在指定的timeout时间内没有连接server，都会被认为丢失。 -e
znode也可以是顺序性的，每一个顺序性的znode关联一个唯一的单调递增整数。这个单调递增整数是znode名字的后缀。
持久顺序性的znode(PERSISTENT_SEQUENTIAL):znode 处理具备持久性的znode的特点之外，znode的名称具备顺序性。 -s
临时顺序性的znode(EPHEMERAL_SEQUENTIAL):znode处理具备临时性的znode特点，znode的名称具备顺序性。-s
3.3 客户端命令
3.3.1 查询所有命令
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
[zk: localhost:2181(CONNECTED) 8] help
ZooKeeper -server host:port cmd args
addauth scheme auth
close 
config [-c] [-w] [-s]
connect host:port
create [-s] [-e] [-c] [-t ttl] path [data] [acl]
delete [-v version] path
deleteall path
delquota [-n|-b] path
get [-s] [-w] path
getAcl [-s] path
history 
listquota path
ls [-s] [-w] [-R] path
ls2 path [watch]
printwatches on|off
quit 
reconfig [-s] [-v version] [[-file path] | [-members serverID=host:port1:port2;port3[,...]*]] | [-add serverId=host:port1:port2;port3[,...]]* [-remove serverId[,...]*]
redo cmdno
removewatches path [-c|-d|-a] [-l]
rmr path
set [-s] [-v version] path data
setAcl [-s] [-v version] [-R] path acl
setquota -n|-b val path
stat [-w] path
sync path
3.3.2 查询根路径下的节点
1
2
[zk: localhost:2181(CONNECTED) 9] ls /zookeeper
[config, quota]
3.3.3 创建普通永久节点
1
2
3
4
5
#创建HelloZK节点，值为Hello,Zookeeper
[zk: localhost:2181(CONNECTED) 10] create /HelloZK "Hello,Zookeeper"
Created /HelloZK
[zk: localhost:2181(CONNECTED) 11] ls /HelloZK
[]
3.3.4 创建带序号永久节点
1
2
[zk: localhost:2181(CONNECTED) 13] create -s /HelloZK_SEQ "ZK With SEQUENCE"
Created /HelloZK_SEQ0000000001
3.3.5 创建普通临时节点
1
2
3
4
5
6
7
8
# -e:表示普通临时节点
[zk: localhost:2181(CONNECTED) 17] create -e /Hello_ZK_Normal "Normal Node"
Created /Hello_ZK_Normal
[zk: localhost:2181(CONNECTED) 19] ls /
[HelloZK, HelloZK_SEQ0000000001, Hello_ZK_Normal, zookeeper]
# 关闭客户端，再次打开查看 Hello_ZK_Normal 节点消失
[zk: localhost:2181(CONNECTED) 1] ls /
[HelloZK, HelloZK_SEQ0000000001, zookeeper]
3.3.6 创建带序号临时节点
1
2
3
4
5
6
7
# -e:表示普通临时节点
# -s:表示带序号节点
[zk: localhost:2181(CONNECTED) 2] create -e -s /Hello_ZK_SEQ_TEMP "Temp And Sequence"
Created /Hello_ZK_SEQ_TEMP0000000003
# 关闭客户端，再次打开查看 Hello_ZK_SEQ_TEMP 节点消失
[zk: localhost:2181(CONNECTED) 0] ls /
[HelloZK, HelloZK_SEQ0000000001, zookeeper]
3.3.7 查询节点数据
1
2
3
4
5
6
7
8
9
10
11
12
13
[zk: localhost:2181(CONNECTED) 7] get -s /HelloZK 
Hello,Zookeeper
cZxid = 0x2
ctime = Tue Jun 16 17:28:46 CST 2020
mZxid = 0x2
mtime = Tue Jun 16 17:28:46 CST 2020
pZxid = 0x2
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 15
numChildren = 0
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
# ­­­­­­­­­­­节点的状态信息，也称为stat结构体­­­­­­­­­­­­­­­­­­­
# 创建该znode的事务的zxid(ZooKeeper Transaction ID)
# 事务ID是ZooKeeper为每次更新操作/事务操作分配一个全局唯一的id，表示zxid，值越小，表示越先执行
cZxid = 0x4454 # 0x0表示十六进制数0
ctime = Thu Jan 01 08:00:00 CST 1970  # 创建时间
mZxid = 0x4454 						  # 最后一次更新的zxid
mtime = Thu Jan 01 08:00:00 CST 1970  # 最后一次更新的时间
pZxid = 0x4454 						  # 最后更新的子节点的zxid
cversion = 5 						  # 子节点的变化号，表示子节点被修改的次数
dataVersion = 0 					  # 表示当前节点的数据变化号，0表示当前节点从未被修改过
aclVersion = 0  					  # 访问控制列表的变化号 access control list
# 如果临时节点，表示当前节点的拥有者的sessionId
ephemeralOwner = 0x0				  # 如果不是临时节点，则值为0
dataLength = 13 					  # 数据长度
numChildren = 1 					  # 子节点的数量
3.3.8 修改节点数据
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
[zk: localhost:2181(CONNECTED) 9] set  /HelloZK "Modify HelloZK"

WATCHER::

WatchedEvent state:SyncConnected type:NodeDataChanged path:/HelloZK
[zk: localhost:2181(CONNECTED) 10] 
[zk: localhost:2181(CONNECTED) 10] get -s /HelloZK
Modify HelloZK
cZxid = 0x2
ctime = Tue Jun 16 17:28:46 CST 2020
mZxid = 0xc
mtime = Tue Jun 16 17:40:47 CST 2020
pZxid = 0x2
cversion = 0
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 14
numChildren = 0
3.3.9 创建子节点
1
2
3
4
5
[zk: localhost:2181(CONNECTED) 36] create /TestDelete
Created /TestDelete
[zk: localhost:2181(CONNECTED) 37] create /TestDelete/RMR
Created /TestDelete/RMR
[zk: localhost:2181(CONNECTED) 38] 
3.3.10 删除节点
1
2
3
[zk: localhost:2181(CONNECTED) 11] delete /HelloZK_SEQ0000000001
[zk: localhost:2181(CONNECTED) 12] ls /
[HelloZK, zookeeper]
3.3.11 递归删除节点
1
2
3
4
5
6
7
8
# 有子节点的使用delete会提示目录非空
[zk: localhost:2181(CONNECTED) 39] delete /TestDelete
Node not empty: /TestDelete
# 需用rmr命令删除，现已更新为deleteall
[zk: localhost:2181(CONNECTED) 12] rmr /TestDelete
The command 'rmr' has been deprecated. Please use 'deleteall' instead.
[zk: localhost:2181(CONNECTED) 13] ls /
[jsodjsd0000000011, sjdiosdjsoi, zookeeper]
3.3.12 查看节点状态
1
2
3
4
5
6
7
8
9
10
11
12
[zk: localhost:2181(CONNECTED) 2] stat /zookeeper
cZxid = 0x0
ctime = Thu Jan 01 08:00:00 CST 1970
mZxid = 0x0
mtime = Thu Jan 01 08:00:00 CST 1970
pZxid = 0x0
cversion = -2
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 0
numChildren = 2
3.3.13 日志的可视化
日志存储路径

1
~/Program/zk/log/version-2
日志都是以二进制文件存储的,需要使用命令行查看

1
2
3
4
5
6
7
8
# Docker拉取了最新镜像，需要4个jar包了
$ ls | grep jar  
log4j-1.2.17.jar
slf4j-api-1.7.25.jar
zookeeper-3.6.1.jar
zookeeper-jute-3.6.1.jar
# 然后使用命令行查看
$ java -classpath :./log4j-1.2.17.jar:slf4j-api-1.7.25.jar:zookeeper-3.6.1.jar:zookeeper-jute-3.6.1.jar org.apache.zookeeper.server.LogFormatter log.1 
3.3.14 小结
ls 查看
help查看所有命令
create 路径 数据 -s 代表有序 -e 代临时
get 路径 查询
set 路径 新的数据
delete 路径 单一路径，没有子节点
rmr 路径 递归删除
stat 路径 查看节点状态
日志，依赖4个jar包
3.4 zookeeper的Java Api介绍
3.4.1 ZooKeeper常用Java API
原生Java API

ZooKeeper 原生Java API位于org.apache.ZooKeeper包中

ZooKeeper-3.x.x. Jar 为官方提供的 java API

Apache Curator

Apache Curator是 Apache ZooKeeper的Java客户端库。

Curator.项目的目标是简化ZooKeeper客户端的使用。

ZkClient

开源的ZooKeeper客户端,zkclient-x.x.Jar也是在原生 api 基础之上进行扩展的开源 JAVA 客户端。

3.4.2 创建Java Maven工程，导入依赖
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>org.example</groupId>
  <artifactId>zookeeper</artifactId>
  <version>1.0-SNAPSHOT</version>
  <!--zookeeper的依赖-->

  <dependencies>
    <dependency>
      <groupId>org.apache.zookeeper</groupId>
      <artifactId>zookeeper</artifactId>
      <version>3.4.7</version>
    </dependency>
    <!--	zookeeper CuratorFramework 是Netflix公司开发一款连接zookeeper服务的框架，通过封装的一套高级API 简化了ZooKeeper的操作，提供了比较全面的功能，除了基础的节点的操作，节点的监听，还有集群的连接以及重试。-->
    <dependency>
      <groupId>org.apache.curator</groupId>
      <artifactId>curator-framework</artifactId>
      <version>4.0.1</version>
    </dependency>
    <dependency>
      <groupId>org.apache.curator</groupId>
      <artifactId>curator-recipes</artifactId>
      <version>4.0.1</version>
    </dependency>
    <!--测试-->
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
    </dependency>
  </dependencies>
</project>
3.4.3 CURD节点
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
91
92
93
94
95
96
97
98
99
100
101
102
103
104
105
106
107
108
109
110
111
112
113
114
115
116
117
118
119
120
121
122
123
124
public class TestZookeeper {
  //连接地址
  String url = "127.0.0.1:2181";
  //会话超时时间
  int sessionTimeoutMs = 1000;
  //连接超时时间
  int connectionTimeoutMs = 1000;
  //重试策略
  RetryPolicy retryPolicy = null;
  //创建客户端
  CuratorFramework client = null;

  String NodeName = null;

  @Before
  public void createLinkToZK() {
    //重试策略
    /**
     *  RetryPolicy： 失败的重试策略的公共接口
     *  ExponentialBackoffRetry是 公共接口的其中一个实现类
     *      参数1： 初始化sleep的时间，用于计算之后的每次重试的sleep时间
     *      参数2：最大重试次数
            参数3（可以省略）：最大sleep时间，如果上述的当前sleep计算出来比这个大，那么sleep用这个时间
     */
    retryPolicy = new ExponentialBackoffRetry(1000, 1);
    //创建客户端
    /**
     * 参数1：连接的ip地址和端口号
     * 参数2：会话超时时间，单位毫秒
     * 参数3：连接超时时间，单位毫秒
     * 参数4：失败重试策略
     */
    client = CuratorFrameworkFactory.newClient(url, sessionTimeoutMs, connectionTimeoutMs, retryPolicy);
    //启动客户端
    client.start();
  }

  @After
  public void closeLike() throws Exception {
    if (NodeName != null) {
      requireNode(NodeName);
    } else if (NodeName == null) {
      System.out.println("No Node");
    }
    //关闭客户端
    client.close();
  }


  //1. 创建一个空节点(a)（只能创建一层节点）
  @Test
  public void createOneLevelEmptyNode() throws Exception {
    NodeName = "/OneLevelEmptyNode";
    client.create().forPath(NodeName);
  }

  //2. 创建一个有内容的b节点（只能创建一层节点）
  @Test
  public void createOneLevelNodeWithMessage() throws Exception {
    NodeName = "/OneLevelNodeWithMessage";
    client.create().forPath(NodeName, "OneLevelNodeWithMessage".getBytes());
  }

  //3. 创建持久节点，同时创建多层节点
  @Test
  public void createMultilevelPersistentNode() throws Exception {
    NodeName = "/Multilevel/Persistent/Node";
    client.create().creatingParentsIfNeeded().forPath(NodeName, "MultilevelPersistentNode".getBytes());
  }

  //4. 创建带有的序号的持久节点
  @Test
  public void creatPersistentNode() throws Exception {
    //        NodeName = "/Persistent/Node";
    client.create().creatingParentsIfNeeded().withMode(CreateMode.PERSISTENT_SEQUENTIAL).forPath("/Persistent/Node", "PERSISTENT_SEQUENTIAL".getBytes());
  }

  //5. 创建临时节点（客户端关闭，节点消失），设置延时5秒关闭（Thread.sleep(5000)）
  @Test
  public void creatTempNode() throws Exception {
    client.create().creatingParentsIfNeeded().withMode(CreateMode.EPHEMERAL).forPath("/Temporary/Node", "Temporary Node".getBytes());
  }

  //6. 创建临时带序号节点（客户端关闭，节点消失），设置延时5秒关闭（Thread.sleep(5000)）
  @Test
  public void creatTempNodeWithSequenceNode() throws Exception {
    client.create().creatingParentsIfNeeded().withMode(CreateMode.EPHEMERAL_SEQUENTIAL).forPath("/TempNode/With/Sequence/Node", "creatTempNodeWithSequence".getBytes());
  }

  //修改节点描述
  @Test
  public void updateNodeMessage() throws Exception {
    NodeName = "/OneLevelNodeWithMessage";
    client.setData().forPath(NodeName, "Update Node Message".getBytes());
  }

  //节点数据查询
  public void requireNode(String s) throws Exception {
    byte[] bytes = client.getData().forPath(String.valueOf(s));
    System.out.println(new String(bytes));
  }

  //删除单个节点
  @Test
  public void deleteSingleNode() throws Exception {
    client.create().forPath("/testAddForDelete");
    client.delete().forPath("/testAddForDelete");
  }

  //删除多个节点
  @Test
  public void deleteMultiNode() throws Exception {
    client.create().creatingParentsIfNeeded().forPath("/DeleteMultiNode/deleteMultiNode", "Create Multi NodeForDelete".getBytes());
    client.delete().deletingChildrenIfNeeded().forPath("/DeleteMultiNode");
  }

  //强制删除
  @Test
  public void forceDelete() throws Exception {
    //NodeName="/forceDelete/forceDelete";
    client.create().creatingParentsIfNeeded().forPath("/forceDelete/forceDelete", "Create Multi NodeForDelete".getBytes());
    client.delete().guaranteed().deletingChildrenIfNeeded().forPath("/forceDelete");
  }
}
3.4.4 小结
Curator是Appache封装操作Zookeeper的客户端, 操作zookeer数据变得更简单

使用步骤：

创建重试策略

创建客户端 url:port

启动客户端

使用客户端对节点操作

– create forPath, creatingparent…….., withMode(持久，临时)

– setData 修改数据

– getData 查询数据

– delete 删除数据， deletingChildrenIfNeeded递归删除

关闭客户端

3.5 watch机制


3.5.1 什么是watch机制
​ zookeeper作为一款成熟的分布式协调框架，订阅-发布功能是很重要的一个。订阅发布功能，就是观察者模式。观察者会订阅一些感兴趣的主题，然后这些主题一旦变化了，就会自动通知到这些观察者。

 zookeeper的订阅发布也就是watch机制，是一个轻量级的设计。因为它采用了一种推拉结合的模式。一旦服务端感知主题变了，那么只会发送一个事件类型和节点信息给关注的客户端，而不会包括具体的变更内容，所以事件本身是轻量级的，这就是所谓的“推”部分。然后，收到变更通知的客户端需要自己去拉变更的数据，这就是“拉”部分。watche机制分为添加数据和监听节点。

 Curator在这方面做了优化，Curator引入了Cache的概念用来实现对ZooKeeper服务器端进行事件监听。Cache是Curator对事件监听的包装，其对事件的监听可以近似看做是一个本地缓存视图和远程ZooKeeper视图的对比过程。而且Curator会自动的再次监听，我们就不需要自己手动的重复监听了。

Curator中的cache共有三种

NodeCache（监听和缓存根节点变化） 只监听单一个节点(变化 添加，修改，删除)
PathChildrenCache（监听和缓存子节点变化） 监听这个节点下的所有子节点(变化 添加，修改，删除)
TreeCache（监听和缓存根节点变化和子节点变化） NodeCache+ PathChildrenCache 监听当前节点及其下的所有子节点的变化
3.5.2 NodeCache
介绍

NodeCache是用来监听节点的数据变化的，当监听的节点的数据发生变化的时候就会回调对应的函数。

增加监听

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
public class TestCuratorCache {
  //连接地址
  String url = "127.0.0.1:2181";
  //会话超时时间
  int sessionTimeoutMs = 1000;
  //连接超时时间
  int connectionTimeoutMs = 1000;
  //重试策略
  RetryPolicy retryPolicy = null;
  //创建客户端
  CuratorFramework client = null;

  @Before
  public void createLinkToZK() {
    //重试策略
    retryPolicy = new ExponentialBackoffRetry(1000, 1);
    //创建客户端
    client = CuratorFrameworkFactory.newClient(url, sessionTimeoutMs, connectionTimeoutMs, retryPolicy);
    //启动客户端
    client.start();
  }

  @After
  public void closeLike() throws Exception {

    //关闭客户端
    client.close();
  }

  @Test
  public void testNodeCache() throws Exception {
    client.create().forPath("/testNodeCache");

    /*
        *NodeCache(客户端, 被监听节点);
         */
    NodeCache nodeCache = new NodeCache(client, "/testNodeCache");
    /*
        * true  得到数据
        * false 不能获取节点数据
        */
    nodeCache.start(true);
    
    System.out.println(new String(nodeCache.getCurrentData().getData()));
    
    client.setData().forPath("/testNodeCache", "Update Node Cache".getBytes());
    nodeCache.getListenable().addListener(new NodeCacheListener() {
      @Override
      public void nodeChanged() throws Exception {
        String data = new String(nodeCache.getCurrentData().getData());
        Thread.sleep(1000 * 2);
        System.out.println(nodeCache.getCurrentData().getPath() + "  \t\t " + data);
      }
    });
    Thread.sleep(1000 * 4);
    client.delete().forPath("/testNodeCache");
  }
}
测试

3.5.3 PathChildrenCache
介绍

PathChildrenCache是用来监听指定节点 的子节点变化情况

增加监听

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
@Test
public void testPathChildrenCache() throws Exception {


  client.create().forPath("/testPathChildrenCache");
  /*
        * new PathChildrenCache(客户端, 节点 , 是/否得到数据);
         */
  PathChildrenCache pathChildrenCache = new PathChildrenCache(client, "/testPathChildrenCache", true);
  ///**
  // * NORMAL:  普通启动方式, 在启动时缓存子节点数据
  // * POST_INITIALIZED_EVENT：在启动时缓存子节点数据，提示初始化
  // * BUILD_INITIAL_CACHE: 在启动时什么都不会输出
  // *  在官方解释中说是因为这种模式会在start执行执行之前先执行rebuild的方法，而rebuild的方法不会发出任何事件通知。
  // */
  pathChildrenCache.start(PathChildrenCache.StartMode.POST_INITIALIZED_EVENT);

  System.out.println(pathChildrenCache.getCurrentData());

  client.create().forPath("/testPathChildrenCache/A");
  client.setData().forPath("/testPathChildrenCache/A", "Update Node Message".getBytes());
  pathChildrenCache.getListenable().addListener(new PathChildrenCacheListener() {
    @Override
    public void childEvent(CuratorFramework curatorFramework, PathChildrenCacheEvent pathChildrenCacheEvent) throws Exception {
      if (pathChildrenCacheEvent.getType() == PathChildrenCacheEvent.Type.CHILD_UPDATED) {

        System.out.println("CHILD_UPDATED Node: "+pathChildrenCacheEvent.getData().getPath());
        System.out.println("CHILD_UPDATED Node Date :"+new String(pathChildrenCacheEvent.getData().getPath()));
      } else if (pathChildrenCacheEvent.getType() == PathChildrenCacheEvent.Type.INITIALIZED) {
        System.out.println("Initialization");
      } else if (pathChildrenCacheEvent.getType() == PathChildrenCacheEvent.Type.CHILD_REMOVED) {
        System.out.println("CHILD_REMOVED Node: "+pathChildrenCacheEvent.getData().getPath());
        System.out.println("CHILD_REMOVED Node Date :"+new String(pathChildrenCacheEvent.getData().getPath()));
      } else if (pathChildrenCacheEvent.getType() == PathChildrenCacheEvent.Type.CHILD_ADDED) {
        System.out.println("CHILD_ADDED Node: "+pathChildrenCacheEvent.getData().getPath());
        System.out.println("CHILD_ADDED Node Date :"+new String(pathChildrenCacheEvent.getData().getPath()));
      } else if (pathChildrenCacheEvent.getType() == PathChildrenCacheEvent.Type.CONNECTION_SUSPENDED) {
        System.out.println("CONNECTION_SUSPENDED");
      } else if (pathChildrenCacheEvent.getType() == PathChildrenCacheEvent.Type.CONNECTION_RECONNECTED) {
        System.out.println("CONNECTION_RECONNECTED");
      } else if (pathChildrenCacheEvent.getType() == PathChildrenCacheEvent.Type.CONNECTION_LOST) {
        System.out.println("CONNECTION_LOST");
      }
    }
  });
client.delete().guaranteed().deletingChildrenIfNeeded().forPath("/testPathChildrenCache");
}
3.5.4 TreeCache
介绍

TreeCache有点像上面两种Cache的结合体，NodeCache能够监听自身节点的数据变化（或者是创建该节点），PathChildrenCache能够监听自身节点下的子节点的变化，而TreeCache既能够监听自身节点的变化、也能够监听子节点的变化。

添加监听

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
@Test
public void testTreeCache() throws Exception {


  client.create().forPath("/testTreeCache");
  //监听当前Node Data Tree
  TreeCache treeCache = new TreeCache(client, "/testTreeCache");
  treeCache.start();


  System.out.println(treeCache.getCurrentData("/testTreeCache"));

  treeCache.getListenable().addListener(new TreeCacheListener() {
    @Override
    public void childEvent(CuratorFramework curatorFramework, TreeCacheEvent treeCacheEvent) throws Exception {
      if (treeCacheEvent.getType() == TreeCacheEvent.Type.NODE_ADDED) {
        System.out.println("NODE_ADDED: "+treeCacheEvent.getData().getPath());

        client.delete().deletingChildrenIfNeeded().forPath("/testTreeCache/Test");
    
      } else if (treeCacheEvent.getType() == TreeCacheEvent.Type.NODE_REMOVED) {
        System.out.println("NODE_REMOVED: "+treeCacheEvent.getData().getPath());
    
      } else if (treeCacheEvent.getType() == TreeCacheEvent.Type.NODE_UPDATED) {
        System.out.println("NODE_UPDATED: "+treeCacheEvent.getData().getPath());
    
      } else if (treeCacheEvent.getType() == TreeCacheEvent.Type.INITIALIZED) {
        System.out.println("INITIALIZED");
      } else if (treeCacheEvent.getType() == TreeCacheEvent.Type.CONNECTION_SUSPENDED) {
        System.out.println("CONNECTION_SUSPENDED");
      } else if (treeCacheEvent.getType() == TreeCacheEvent.Type.CONNECTION_RECONNECTED) {
        System.out.println("CONNECTION_RECONNECTED");
      } else if (treeCacheEvent.getType() == TreeCacheEvent.Type.CONNECTION_LOST) {
        System.out.println("CONNECTION_LOST");
      }
    }
  });
  client.delete().guaranteed().deletingChildrenIfNeeded().forPath("/testTreeCache");
}
3.5.5 小结
Zookeeper：分布小文件存储系统，树形层级数据结构，路径唯一

动物管理员，管的是服务
应用：注册中心、配置中心、分布式锁、分布式队列、负载均衡
配置zoo.cfg dataPath, 2181

节点类型：持久化（有序与无序 -s），临时（-e 临时， -s 有序与无序) crud

api: Curator 创建重试策略->客户端(url ip:port)->启动->使用client操作crud->关闭

Watch: 监听节点数据变化，一旦生变更（添加、修改、删除）时，服务端通知客户端（addListener)

NodeCache: 听监听单一节点变化

PathChildrenCache: 监听节点下的子节点
TreeCache: NodeCache+PathChildrenCache

四.zookeeper集群搭建
目标

搭建Zookeeper集群

操作路径

了解集群

集群介绍
集群模式
集群原理及架构图

搭建集群（使用linux）

集群中Leader选举机制
测试集群

4.1 了解集群
4.1.1 集群介绍
Zookeeper 集群搭建指的是 ZooKeeper 分布式模式安装。 通常由 2n+1台 servers 组成 奇数。 这是因为为了保证 Leader 选举（基于 Paxos 算法的实现） 能或得到多数的支持，所以 ZooKeeper 集群的数量一般为奇数。

4.1.2 集群模式
伪分布式集群搭建
完全分布式集群搭建
4.2 架构图


集群工作的核心
事务请求（写操作） 的唯一调度和处理者，保证集群事务处理的顺序性；
集群内部各个服务器的调度者。
对于 create， setData， delete 等有写操作的请求，则需要统一转发给leader 处理， leader 需要决定编号、执行操作，这个过程称为一个事务。

Leader:Zookeeper(领导者):

集群工作的核心
事务请求（写操作） 的唯一调度和处理者，保证集群事务处理的顺序性；
集群内部各个服务器的调度者。
对于 create， setData， delete 等有写操作的请求，则需要统一转发给leader 处理， leader 需要决定编号、执行操作，这个过程称为一个事务。

Follower（跟随者）

处理客户端非事务（读操作） 请求，转发事务请求给 Leader；参与集群 Leader 选举投票 2n-1台可以做集群投票。

Observer:观察者角色

针对访问量比较大的 zookeeper 集群， 还可新增观察者角色。观察 Zookeeper 集群的最新状态变化并将这些状态同步过来，其对于非事务请求可以进行独立处理，对于事务请求，则会转发给 Leader服务器进行处理。
不会参与任何形式的投票只提供非事务服务，通常用于在不影响集群事务处理能力的前提下提升集群的非事务处理能力。

4.3 搭建过程
4.3.1 配置zookeeper-compose.yml
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
version: '2'
services:
    zoo1:
        image: zookeeper:3.4.14
        restart: always
        container_name: zoo1
        ports:
            - "2181:2181"
        environment:
            ZOO_MY_ID: 1
            ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888

    zoo2:
        image: zookeeper:3.4.14
        restart: always
        container_name: zoo2
        ports:
            - "2182:2181"
        environment:
            ZOO_MY_ID: 2
            ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888
     
    zoo3:
        image: zookeeper:3.4.14
        restart: always
        container_name: zoo3
        ports:
            - "2183:2181"
        environment:
            ZOO_MY_ID: 3
            ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888
这个配置文件会告诉 Docker 分别运行三个 zookeeper 镜像, 并分别将本地的 2181, 2182, 2183 端口绑定到对应的容器的2181端口上.
ZOO_MY_ID 和 ZOO_SERVERS 是搭建 ZK 集群需要设置的两个环境变量, 其中 ZOO_MY_ID 表示 ZK 服务的 id, 它是1-255 之间的整数, 必须在集群中唯一. ZOO_SERVERS 是ZK 集群的主机列表.

4.3.2 启动zookeeper
1
2
3
4
5
$ docker-compose -f zookeeper-compose.yml up -d  
Creating network "program_default" with the default driver
Creating zoo3 ... done
Creating zoo2 ... done
Creating zoo1 ... done
4.3.3 查看zookeeper状态
1
2
3
4
5
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                        NAMES
63dacd015bf9        zookeeper:3.4.14    "/docker-entrypoint.…"   6 minutes ago       Up 6 minutes        2888/tcp, 0.0.0.0:2181->2181/tcp, 3888/tcp   zoo1
2bfaa57664f9        zookeeper:3.4.14    "/docker-entrypoint.…"   6 minutes ago       Up 6 minutes        2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   zoo2
4ff61abb0d2f        zookeeper:3.4.14    "/docker-entrypoint.…"   6 minutes ago       Up 6 minutes        2888/tcp, 3888/tcp, 0.0.0.0:2183->2181/tcp   zoo3
4.4 leader选举
在领导者选举的过程中，如果某台ZooKeeper获得了超过半数的选票，则此ZooKeeper就可以成为Leader了。

服务器1启动，给自己投票，然后发投票信息，由于其它机器还没有启动所以它收不到反馈信息，服务器1的状态一直属于Looking(选举状态)。

服务器2启动，给自己投票，同时与之前启动的服务器1交换结果，

每个Server发出一个投票由于是初始情况，1和2都会将自己作为Leader服务器来进行投票，每次投票会包含所推举的服务器的myid和ZXID，使用(myid, ZXID)来表示，此时1的投票为(1, 0)，2的投票为(2, 0)，然后各自将这个投票发给集群中其他机器。
接受来自各个服务器的投票集群的每个服务器收到投票后，首先判断该投票的有效性，如检查是否是本轮投票、是否来自LOOKING状态的服务器

处理投票。针对每一个投票，服务器都需要将别人的投票和自己的投票进行PK，PK规则如下

　　　　· 优先检查ZXID。ZXID比较大的服务器优先作为Leader。

　　　　· 如果ZXID相同，那么就比较myid。myid较大的服务器作为Leader服务器

由于服务器2的编号大，更新自己的投票为(2, 0)，然后重新投票，对于2而言，其无须更新自己的投票，只是再次向集群中所有机器发出上一次投票信息即可，此时集群节点状态为LOOKING。

统计投票。每次投票后，服务器都会统计投票信息，判断是否已经有过半机器接受到相同的投票信息

服务器3启动，进行统计后，判断是否已经有过半机器接受到相同的投票信息，对于1、2、3而言，已统计出集群中已经有3台机器接受了(3, 0)的投票信息，此时投票数正好大于半数，便认为已经选出了Leader，

改变服务器状态。一旦确定了Leader，每个服务器就会更新自己的状态，如果是Follower，那么就变更为FOLLOWING，如果是Leader，就变更为LEADING

所以服务器3成为领导者，服务器1,2成为从节点。

4.5 测试集群
测试使用任何一个IP都可以获取

测试如果有个机器宕机，（./zkServer.sh stop），会重新选取领导者。

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
public class TestZookeeperCluster {

    CuratorFramework client = null;
    
    @After
    public void closeLike() throws Exception {
        //关闭客户端
        client.close();
    }
    
    @Test
    public void createNode() throws Exception {
        RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000, 1);
        CuratorFramework client = CuratorFrameworkFactory.newClient("127.0.0.1:2181", 3000, 3000, retryPolicy);
        client.start();
        client.create().creatingParentsIfNeeded().withMode(CreateMode.PERSISTENT).forPath("/createNode/Nodes");
    }
    
    @Test
    public void updateNode() throws Exception {
        //创建失败策略对象
        RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000, 1);
        client = CuratorFrameworkFactory.newClient("127.0.0.1:2182", 1000, 1000, retryPolicy);
        client.start();
        client.setData().forPath("/createNode/Nodes", "Update Node".getBytes());
        client.close();
    }
    
    @Test
    public void getData() throws Exception {
        RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000, 1);
        client = CuratorFrameworkFactory.newClient("127.0.0.1:2183", 1000, 1000, retryPolicy);
        client.start();
        byte[] bytes = client.getData().forPath("/createNode/Nodes");
        System.out.println(new String(bytes));
        client.close();
    }
    
    @Test
    public void deleteNode() throws Exception {
        RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000, 1);
        client = CuratorFrameworkFactory.newClient("127.0.0.1:2183", 1000, 1000, retryPolicy);
        client.start();
        client.delete().deletingChildrenIfNeeded().forPath("/createNode");
        client.close();
    }
}
4.6 小结
什么是集群：把具有相同功能应用布署多个到网络中，聚集一起，实现数据的同步，一旦有应用服务挂了，集群中的其它应用服务可以顶上，保证应用的正常运作

Zookeeper集群架构

Leader领导者 可以进行读写，写操作成功后会同步到各个从和观察者

Follower跟从者 只能读，如果有写操作时则转给Leader领导者处理 参与选举

Observer观察者 只能读，有写时也会转给Leader, 不参与Leader的选举

集群服务器个要为奇数2n+1，防止服务器down机，可以选举出新的leader

Leader先举机制

先投自己一票，票数相同时 票数>zxid>myid，其它zookeeper改为大者一票。集群中半数以上的票数才能成Leader