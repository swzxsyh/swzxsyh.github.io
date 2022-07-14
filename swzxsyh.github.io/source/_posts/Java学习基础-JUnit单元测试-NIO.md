---
layout: post
title: Java学习基础-JUnit单元测试,NIO
date: 2020-03-26 00:51:30
tags:
---

一.Junit单元测试
1.什么是单元测试
I.单元,在Java中的一个单元可以指某个方法,或某个类
II.测试,写一段代码单元进行测试

Junit是专门为单元测试提供的一个第三方框架
作用:让一个普通方法独立运行(替代main方法)

2.Junit的使用步骤
•下载
junit.org (Jetbrains IDEA开发工具中自带)

•具体使用步骤
a.编写一个被测试类(业务类)
b.编写测试类
c.在测试类中使用Junit单元测试框架

•运行测试
在需要独立运行的方法上加注解 @Test

```java
//业务类
public class Dog {
  public int getSum(int a, int b, int c) {
    int sum = a + b + c;
    return sum;
  }
}

public class TestDog {
  @Test
  public void testDog01(){
    Dog dd = new Dog();
    int sum = dd.getSum(1, 2, 3);
    System.out.println(sum);
  }

  @Test
  public void testDog02(){
    Dog dd = new Dog();
    int sum = dd.getSum(11, 22, 33);
    System.out.println(sum);
  }
}
```

3.单元测试中的其他四个注解
•Junit4.x

注解	作用
@Before	表示该方法会自动在”每个”@Test方法之前执行(每次执行)
@After	表示该方法会自动在”每个”@Test方法之后执行(每次执行)
@BeforeClass	表示该方法会自动在”所有”@Test方法之前执行,必须为静态类(只执行一次)
@AfterClass	表示该方法会自动在”所有”@Test方法之后执行,必须为静态类(只执行一次)
注意:@BeforeClass和@AfterClass必须在静态方法中使用




```java
public class TestDog {
  @AfterClass
  public static void testDog02(){
    Dog dd = new Dog();
    int sum = dd.getSum(1, 2, 3);
    System.out.println(sum);
  }

  @Test
  public void testDog01(){
    Dog dd = new Dog();
    int sum = dd.getSum(11, 22, 33);
    System.out.println(sum);
  }

  @BeforeClass
  public static void testDog03(){
    Dog dd = new Dog();
    int sum = dd.getSum(111, 222, 333);
    System.out.println(sum);
  }
}
```

•Junit5.x

@BeforeEach ———— 相当于@Before
@AfterEach ———— 相当于@After
@BeforeAll ———— 相当于@BeforeClass
@AfterAll ———— 相当于@AfterClass

注意:@BeforeAll和@AfterAll也必须修饰静态方法

Assert.assertEquals(“异常信息”,”得到的结果”,”预期的结果”)
作用:比较”得到的结果”和”预期的结果”
如果一样:什么都不做
如果不一样:抛出异常,并封装异常信息

二.NIO介绍
1.阻塞与非阻塞
阻塞:完成某个任务时,任务没有结束之前,当前线程无法继续向下执行
非阻塞:完成某个任务时,不需要等待任务结束,当前线程立即可以向下继续执行,后期再通过其他代码获取任务结果

2.同步与异步
同步:
同步可能是阻塞的,也可能是非阻塞的
同步阻塞:完成某个任务时,任务没有结束之前,当前线程无法继续向下执行
同步非阻塞:完成某个任务时,不需要等待任务结束,当前线程立即可以向下继续执行,后期再通过其他代码获取任务结果

异步:
异步一般来说都是非阻塞
异步非阻塞:完成某个任务时,不需要等待任务结束,当前线程立即可以向下继续执行,后期不需要写其他代码获取任务结果,任务完成后自动会通过其他机制把结果传递回来

3.BIO,NIO,AIO介绍

名称	介绍	名称
BIO(传统IO):	同步阻塞的IO	Block IO
NIO:	同步阻塞与同步非阻塞,由Buffer(缓冲区),Channel(通道),Selector(迭代器)组成	New IO
NIO2(AIO):	异步非阻塞IO	A Synchronized
三.NIO-Buffer类介绍
1.Buffer的介绍和种类
•什么是Buffer
Buffer称为缓冲区,本质是一个数组

•Buffer的一般操作步骤
a.写入缓冲区(把数据保存到数组中)
b.调用flip方法(切换缓冲区的写模式为读模式)
c.读缓冲区(把数组中的数据读取出来)
d.调用clear(清空缓冲区)或compact(清除缓冲区中的已读取过的数据数据)方法

•Buffer的种类

名称	介绍
ByteBuffer	字节缓冲区(字节数组)最常用
CharBuffer	字符缓冲区(字符数组)
DoubleBuffer	Double缓冲区(小数数组)
FloatBuffer	Float缓冲区(小数数组)
IntBuffer	整型缓冲区(整型数组)
LongBuffer	长整型缓冲区(长整型数组)
ShortBuffer	短整型缓冲区(短整型数组)
2.byteBuffer的三种创建方式
public static allocate(int capacity);//在堆区中申请一个固定大小的ByteBuffer缓冲区
public static allocateDirect(int capacity);//在系统的内存中申请一个固定大小字节的ByteBuffer缓冲区
public static wrap(byte[] arr);//把一个字节数组直接包装成ByteBuffer缓冲区

```java

public class ByteBuffer01 {
  public static void main(String[] args) {
    //allocate,间接缓冲区
    // 在JVM堆中,创建或销毁更快
    ByteBuffer buffer1 = ByteBuffer.allocate(10);
    //allocateDirect,直接缓冲区
    // 直接在操作系统中申请,操作缓冲区角度,效率更高
    ByteBuffer buffer2 = ByteBuffer.allocateDirect(10);

    //wrap,间接缓冲区,与buffer1相同
    byte[] bs = new byte[1024];
    ByteBuffer buffer3 = ByteBuffer.wrap(bs);
  }
}
```

3.byteBuffer的三种添加数据方式
public ByteBuffer put(byte b);//添加单个字节
public ByteBuffer put(byte b,bs);//添加字节数组
public ByteBuffer put(byte b,bs,int startIndex,int len);//添加一个字节数组中的一部分



```java

public class ByteBuffer02 {
  public static void main(String[] args) {
    ByteBuffer buffer1 = ByteBuffer.allocate(10);
    System.out.println(Arrays.toString(buffer1.array()));
    //[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    buffer1.put((byte) 10);
    System.out.println(Arrays.toString(buffer1.array()));
    //[10, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    buffer1.put((byte) 20);
    buffer1.put((byte) 30);
    System.out.println(Arrays.toString(buffer1.array()));
    //[10, 20, 30, 0, 0, 0, 0, 0, 0, 0]
    byte[] bs = {40,50,60};
    ByteBuffer put = buffer1.put(bs);
    System.out.println(Arrays.toString(buffer1.array()));
    //[10, 20, 30, 40, 50, 60, 0, 0, 0, 0]
    byte[] new_bs = {70,80,90};
    buffer1.put(new_bs,0,2);
    System.out.println(Arrays.toString(buffer1.array()));
    //[10, 20, 30, 40, 50, 60, 70, 80, 0, 0]

    //        byte[] break_bs = {40,50,60};
    //        ByteBuffer break_put = buffer1.put(break_bs);
    //        System.out.println(Arrays.toString(buffer1.array()));
    //BufferOverflowException
  }
}
```

4.byteBuffer的容量-capacity
什么是容量(capacity):
是指Buffer最多包含的元素个数,并且Buffer一旦创建,容量无法更改
public int capacity();//获取Buffer容量

```java
public class ByteBuffer03 {
  public static void main(String[] args) {
    ByteBuffer buffer = ByteBuffer.allocate(10);
    int capacity = buffer.capacity();
    System.out.println(capacity);
  }
}
```


5.byteBuffer的限制-limit
什么是限制:是指第一个不能操作的元素索引,取值范围(0-capacity)
限制的作用:相当于人为”修改”缓冲区的大小,实际上缓冲区大小没有改变,只是元素的个数改变了



```java

public class ByteBuffer04_limit {
  public static void main(String[] args) {
    ByteBuffer buffer = ByteBuffer.allocate(10);
    System.out.println(Arrays.toString(buffer.array()));
    //[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    int limit = buffer.limit();
    System.out.println(limit);

    buffer.limit(3);
    byte[] bs = {10,20,30,40};//BufferOverflowException
    buffer.put(bs);
    System.out.println(Arrays.toString(buffer.array()));

  }
}
```

6.byteBuffer的位置-position
什么是位置:将要写入/读取的元素的索引,取值范围(0-capacity/limit,有最大值position但是无法操作)



```java

public class ByteBuffer05_position {
  public static void main(String[] args) {
    ByteBuffer buffer = ByteBuffer.allocate(10);
    System.out.println(buffer.capacity());//10
    System.out.println(buffer.limit());//10
    System.out.println(buffer.position());//0

    byte[] bs ={10,20,30,40,50};
    buffer.put(bs);
    System.out.println(Arrays.toString(buffer.array()));
    //[10, 20, 30, 40, 50, 0, 0, 0, 0, 0]
    System.out.println(buffer.position());//5

    buffer.position(3);
    buffer.put((byte)101);
    System.out.println(Arrays.toString(buffer.array()));
    //[10, 20, 30, 101, 50, 0, 0, 0, 0, 0]
    System.out.println(buffer.position());//4
  }
}
```

7.byteBuffer的标记-mark
什么是标记:给当前的position记录下来,当调用reset(重置)时,position会回到标记,取值范围(0-position)



    
    public class ByteBuffer06_mark {
        public static void main(String[] args) {
        ByteBuffer buffer = ByteBuffer.allocate(10);
    
        buffer.put((byte)10);
        buffer.put((byte)20);
        buffer.put((byte)30);
        buffer.mark();
        buffer.put((byte)40);
        buffer.put((byte)50);
    
        System.out.println(Arrays.toString(buffer.array()));
        //[10, 20, 30, 40, 50, 0, 0, 0, 0, 0]
            buffer.reset();
        buffer.put((byte)98);
        buffer.put((byte)99);
        buffer.put((byte)100);
    
        System.out.println(Arrays.toString(buffer.array()));
        //[10, 20, 30, 98, 99, 100, 0, 0, 0, 0]
        }
    }


8.byteBuffer的其他方法
public int remaining();//获取position与limit之间的元素数
public boolean isReadyOnly();//获取当前缓冲区是否可读
public boolean isDirect();//获取当前缓冲区是否为直接缓冲区
public boolean clear();//还原缓冲区的初始状态

将position设置0
将limit置为capacity
丢弃标记
public Buffer flip();//切换读写模式(缩小范围)

将limit设置为当前position位置
将当前position位置设置为0
丢弃标记
public Buffer rewind();//重绕缓冲区

将position置为0
limit不变
丢弃标记
四.Channel(通道)
1.Channel介绍和类
什么是Channel:Channel是一个类,new出对象,可以通过它读写数据,和IO流类似,最大的不同在于IO流有Input/Output之分,但是Channel没有输入输出之分,都是Channel

•为所有的原始类型提供(Buffer)缓存支持;
•字符集编码解决方案(Charset);
•Channel : 一个新的原始I/O抽象;
•支持锁和内存映射文件的文件访问接口;
•提供多路(non-bloking)非阻塞式的高伸缩性网路I/O。

Channel的分类:

名称	介绍
FileChannel	文件通道
DatagramChannel	UDP协议通道,通过UDP协议收发数据
SocketChannel	TCP协议中客户端通道,给客户端写数据
ServerSocketChannel	TCP协议中服务器端通道,给服务器写数据
2.FileChannel类的基本使用



```java

public class FileChannel01 {
  public static void main(String[] args) throws Exception {
    //创建文件对象
    File srcFile = new File("Danboard.jpg");
    File destFile = new File("copy.jpg");
    //创建输入输出流
    FileInputStream fis = new FileInputStream(srcFile);
    FileOutputStream fos = new FileOutputStream(destFile);

    //通道
    FileChannel inChannel = fis.getChannel();
    FileChannel outChannel = fos.getChannel();

    //复制文件
    ByteBuffer buffer = ByteBuffer.allocate(1024);
    int len = 0;
    while ((len=inChannel.read(buffer))!=-1){
      //切换模式
      buffer.flip();
      //读缓冲区数据
      outChannel.write(buffer);
      //清空
      buffer.clear();
    }
    outChannel.close();
    inChannel.close();
    fos.close();
    fis.close();
  }
}
```

3.FileChannel结合MappedByteBuffer实现高效读写

读取硬盘文件到内存–>内存复制一份文件–>副本写入到硬盘



```java

public class FileChannel_RandomAccessFile {
  public static void main(String[] args) throws Exception {
    //创建文件
    //Read Only/Read Write
    RandomAccessFile srcFile = new RandomAccessFile("Danboard.jpg", "r");
    RandomAccessFile destFile = new RandomAccessFile("copy.jpg", "rw");

    //获取通道
    FileChannel inchannel = srcFile.getChannel();
    FileChannel outchannel = destFile.getChannel();

    //获取文件大小
    long size = inchannel.size();

    //建立映射缓冲区
    //map(模式,开始索引,字节数）
    MappedByteBuffer inmap = inchannel.map(FileChannel.MapMode.READ_ONLY, 0, size);
    MappedByteBuffer outmap = outchannel.map(FileChannel.MapMode.READ_WRITE, 0, size);

    //复制
    for (int i = 0; i < size; i++) {
      byte b = inmap.get(i);
      outmap.put(i,b);
    }

    inchannel.close();
    outchannel.close();
  }
}
```

只适用于复制2G以下的文件,如果是2G以上的文件,分多次复制

4.SocketChannel和ServerSocketChannel的实现连接

ServerSocketChannel的创建(阻塞方式)



```java

//创建阻塞的服务器通道
public class ServerSocketChannel_Demo {
  public static void main(String[] args) throws IOException {
    //创建ServerSocketChannel
    ServerSocketChannel open = ServerSocketChannel.open();
    //绑定端口
    open.bind(new InetSocketAddress(8888));
    //后续代码
    SocketChannel accept = open.accept();
  }
}
```

ServerSocketChannel的创建(非阻塞方式)



```java

public class ServerSocketChannel_Demo02_NIO {
  public static void main(String[] args) throws IOException {
    //创建ServerSocketChannel
    ServerSocketChannel open = ServerSocketChannel.open();
    //设置为同步非阻塞的服务器通道
    open.configureBlocking(false);
    //绑定端口
    open.bind(new InetSocketAddress(8888));
    //后续代码
    SocketChannel accept = open.accept();
  }
}

public class ServerSocketChannel_Demo02_NIO {
    public static void main(String[] args) throws IOException, InterruptedException {
        //创建ServerSocketChannel
        ServerSocketChannel open = ServerSocketChannel.open();
        //设置为同步非阻塞的服务器通道
        open.configureBlocking(false);
        //绑定端口
        open.bind(new InetSocketAddress(8888));
        while (true) {
            //后续代码
            SocketChannel accept = open.accept();
            if (accept != null) {
                System.out.println("Y");
            } else {
                Thread.sleep(2000);
                System.out.println("N");
            }
        }
    }
}
```

SocketChannel的创建

```java

// 阻塞式客户端
public class SocketChannelDemo {
  public static void main(String[] args) throws IOException {
    //创建SocketChannel对象
    SocketChannel socketChannel = SocketChannel.open();
    //连接服务器
    boolean connect = socketChannel.connect(new InetSocketAddress("127.0.0.1", 8888));
    // 相当于socketChannel.bind(new InetSocketAddress("127.0.0.1",8888));

    System.out.println(connect);
  }
}

public class SocketChannelDemo02_NIO {
  public static void main(String[] args) throws IOException, InterruptedException {
    //创建SocketChannel对象
    SocketChannel socketChannel = SocketChannel.open();
    //设置为同步非阻塞的客户端通道
    socketChannel.configureBlocking(false);

    while (true) {
      try {
        //连接服务器
        boolean connect = socketChannel.connect(new InetSocketAddress("127.0.0.1", 8888));
        // 相当于socketChannel.bind(new InetSocketAddress("127.0.0.1",8888));

        if (connect) {
          System.out.println("Y");
        }
      } catch (Exception e) {
        e.printStackTrace();
        Thread.sleep(1000 * 2);
      }

    }
  }
}
```


5.SocketChannel和ServerSocketChannel的实现通信



```java

public class SocketChannelDemo {
  public static void main(String[] args) throws IOException, InterruptedException {
    SocketChannel open = SocketChannel.open();
    boolean connect = open.connect(new InetSocketAddress("127.0.0.1", 8888));
    if(connect){
      System.out.println("Y");
      ByteBuffer wrap = ByteBuffer.wrap("Client".getBytes());
      open.write(wrap);
      ByteBuffer buffer = ByteBuffer.allocate(1024);
      int len = open.read(buffer);
      buffer.flip();
      System.out.println(new String(buffer.array(),0,len));
    }

    //释放资源
    open.close();
  }
}
public class ServerSocketChannelDemo {
  public static void main(String[] args) throws IOException {
    //创建ServerSocketChannel
    ServerSocketChannel open = ServerSocketChannel.open();
    ServerSocketChannel bind = open.bind(new InetSocketAddress(8888));
    SocketChannel accept = bind.accept();
    ByteBuffer bytebuffer = ByteBuffer.allocate(1024);
    int read = accept.read(bytebuffer);

    bytebuffer.flip();
    String str = new String(bytebuffer.array(), 0, read);

    System.out.println(str);
    ByteBuffer buffer = ByteBuffer.allocate(1024);
    buffer.put("Server".getBytes());
    buffer.flip();
    accept.write(buffer);

    //释放资源
    open.close();
    accept.close();
  }
}
```

总结:
Junit单元测试
a.第三方单元测试框架
b.@Test将一个普通方法可以独立运行
c.@Before,@After,@BeforeClass,@AfterClass

阻塞:任务没有执行完毕，线程无法向下继续推行
非阻塞:无论任务是否执行完毕，线程继续向下执行

同步:
同步可能是阻塞的,也可能是非阻塞的
同步阻塞:完成某个任务时,任务没有结束之前,当前线程无法继续向下执行
同步非阻塞:完成某个任务时,不需要等待任务结束,当前线程立即可以向下继续执行,后期再通过其他代码获取任务结果

异步:
异步一般来说都是非阻塞
异步非阻塞:完成某个任务时,不需要等待任务结束,当前线程立即可以向下继续执行,后期不需要写其他代码获取任务结果,任务完成后自动会通过其他机制把结果传递回来

创建和使用ByteBuffer
创建:
public static allocate(int capacity);//在堆区中申请一个固定大小的ByteBuffer缓冲区
public static allocateDirect(int capacity);//在系统的内存中申请一个固定大小字节的ByteBuffer缓冲区
public static wrap(byte[] arr);//把一个字节数组直接包装成ByteBuffer缓冲区
使用:
public ByteBuffer put(byte b);//添加单个字节
public ByteBuffer put(byte b,bs);//添加字节数组
public ByteBuffer put(byte b,bs,int startIndex,int len);//添加一个字节数组中的一部分
public int capacity();//获取Buffer容量
buffer.limit();
buffer.position();
buffer.mark();
public int remaining();//获取position与limit之间的元素数
public boolean isReadyOnly();//获取当前缓冲区是否可读
public boolean isDirect();//获取当前缓冲区是否为直接缓冲区
public boolean clear();//还原缓冲区的初始状态
public Buffer flip();//切换读写模式(缩小范围)
public Buffer rewind();//重绕缓冲区

使用MappedByteBuffer实现高效读写
使用文件对象 RandomAccessFile 不能使用普通File

使用ServerSockerChannel和SocketChannel实现连接并收发信息
ServerSockerChannel服务器端，可以是同步阻塞的也可以是非同步阻塞的
SocketChannel客户端，可以是同步阻塞的也可以是非同步阻塞的
通过configureBlocking方式可以设置阻塞或非阻塞

