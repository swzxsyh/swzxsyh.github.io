---
title: Java学习基础-NIO,AIO
date: 2020-03-27 00:52:02
tags:
---

一.Selector(选择器,多路复用器)
1.1 多路复用的概念
多路:多个服务器分别去监听多个端口

如果不使用”多路复用”,每个服务器都需要开许多线程处理每个端口的请求,如果在高并发下,会造成系统性能下降。
如果使用”多路复用”,可以把多个服务器注册到一个Selector,只需要开启一个线程即可处理服务器(在高并发下性能较高)

1.2 选择器Selector

什么是Selector
Selector也称为选择器,也叫多路复用器,可以让多个Channel注册到Selector上,然后监听各个Channel上发生的事件

Selector创建API
创建Selector的方式:
Selector selector = Selector.open();

将要交给选择器管理的通道注册到选择器:
Channel.configureBlocking(false);//channel是一个通道,并且必须是非阻塞通道
SelectionKey key = channel.register(selector,SelectionKey.OP_ACCEPT);

参数1:该通道注册到的选择器
参数2:选择器对何种事件感兴趣(服务器通道只能写SelectionKey.OP_ACCEPT,表示有客户端连接)
返回值:SelectionKey 是一个对象,该对象中包含了注册到选择器的通道

可以监听4中不同类型的事件,使用SelectionKey常量表示:
连接就绪–常量:SelectionKey.OP_CONNECT
接收就绪–常量:SelectionKey.OP_ACCEPT(ServerSocketChannel在注册时只能使用此项)
读就绪–常量:SelectionKey.OP_READ
写就绪–常量:SelectionKey.OP_WRITE

```java
public class SelectorDemo {
    public static void main(String[] args) throws IOException {
        //多个服务器,每个监听多个端口
        ServerSocketChannel server1 = ServerSocketChannel.open();
        server1.configureBlocking(false);
        server1.bind(new InetSocketAddress(8888));

        ServerSocketChannel server2 = ServerSocketChannel.open();
        server2.configureBlocking(false);
        server2.bind(new InetSocketAddress(9999));

        //获取Selector
        Selector selector = Selector.open();

        //将多个Server注册到同一个Selector
        server1.register(selector, SelectionKey.OP_ACCEPT);
        server2.register(selector, SelectionKey.OP_ACCEPT);
    }
}
```
1.3 Selector中的常用方法

Channel注册Selector的API
•获取所有已经成功注册到当前选择器的通道集合
public Set keys();

•表示所有已有客户端连接的通道的集合
public Set selectedKeys();

•如果目前没有客户端连接,该方法会阻塞。如果有客户端连接会返回本次连接的客户端数量
public int select();

代码演示
1.4 Selector实现多路连接(上)

```java
public class SocketChannelSelector_Demo {
    public static void main(String[] args) {
        new Thread(() -> {
            try (SocketChannel socket = SocketChannel.open()) {
                socket.connect(new InetSocketAddress("127.0.0.1", 8888));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();
        new Thread(() -> {
            try (SocketChannel socket = SocketChannel.open()) {
                socket.connect(new InetSocketAddress("127.0.0.1", 9999));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();
    }
}


public class ServerSelector_SelectionKey {
    public static void main(String[] args) throws IOException {
        //多个服务器,每个监听多个端口
        ServerSocketChannel server1 = ServerSocketChannel.open();
        server1.configureBlocking(false);
        server1.bind(new InetSocketAddress(8888));

        ServerSocketChannel server2 = ServerSocketChannel.open();
        server2.configureBlocking(false);
        server2.bind(new InetSocketAddress(9999));

        //获取Selector
        Selector selector = Selector.open();

        //将多个Server注册到同一个Selector
        server1.register(selector, SelectionKey.OP_ACCEPT);
        server2.register(selector, SelectionKey.OP_ACCEPT);

        //接收客户端连接
        Set<SelectionKey> keys = selector.keys();
        System.out.println(keys.size());

        Set<SelectionKey> selectionKeys = selector.selectedKeys();
        System.out.println(selectionKeys.size());

        int selectedCount = selector.select();
        System.out.println(selectedCount);
    }
}
```
1.5 Selector实现多路连接(下)

```java
public class SocketChannelSelector_Demo {
    public static void main(String[] args) {
        new Thread(() -> {
            try (SocketChannel socket = SocketChannel.open()) {
                socket.connect(new InetSocketAddress("127.0.0.1", 8888));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();
        new Thread(() -> {
            try (SocketChannel socket = SocketChannel.open()) {
                socket.connect(new InetSocketAddress("127.0.0.1", 9999));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();
    }
}


public class ServerSelector_SelectionKey {
    public static void main(String[] args) throws IOException, InterruptedException {
        //多个服务器,每个监听多个端口
        ServerSocketChannel server1 = ServerSocketChannel.open();
        server1.configureBlocking(false);
        server1.bind(new InetSocketAddress(8888));

        ServerSocketChannel server2 = ServerSocketChannel.open();
        server2.configureBlocking(false);
        server2.bind(new InetSocketAddress(9999));

        //获取Selector
        Selector selector = Selector.open();

        //将多个Server注册到同一个Selector
        server1.register(selector, SelectionKey.OP_ACCEPT);
        server2.register(selector, SelectionKey.OP_ACCEPT);

        //接收客户端连接
        Set<SelectionKey> keys = selector.keys();
        System.out.println(keys.size());
        while (true) {
            Set<SelectionKey> selectionKeys = selector.selectedKeys();
            System.out.println(selectionKeys.size());

            //此方法会阻塞
            int selectedCount = selector.select();
            System.out.println(selectedCount);

            //遍历已连接通道到集合
            Iterator<SelectionKey> it = selectionKeys.iterator();
            while (it.hasNext()) {
                //获取当前通道
                SelectionKey key = it.next();
                //从SelectionKey中获取通道对象
                ServerSocketChannel channel = (ServerSocketChannel) key.channel();

                //查看此通道是监听哪个端口
                System.out.println(channel.getLocalAddress());

                //取出连接到该服务器客户端到客户端通道
                SocketChannel accept = channel.accept();
                System.out.println(accept);
                //从连接到通道中把已经处理过到服务器通道移除
                it.remove();
            }
            Thread.sleep(1000 * 5);
            System.out.println();
        }
    }
}
```
1.6 Selecto多路信息接收测试

```java
public class ServerSelector_SelectionKey {
    public static void main(String[] args) throws IOException, InterruptedException {
        //多个服务器,每个监听多个端口
        ServerSocketChannel server1 = ServerSocketChannel.open();
        server1.configureBlocking(false);
        server1.bind(new InetSocketAddress(8888));

        ServerSocketChannel server2 = ServerSocketChannel.open();
        server2.configureBlocking(false);
        server2.bind(new InetSocketAddress(9999));

        //获取Selector
        Selector selector = Selector.open();

        //将多个Server注册到同一个Selector
        server1.register(selector, SelectionKey.OP_ACCEPT);
        server2.register(selector, SelectionKey.OP_ACCEPT);

        //接收客户端连接
        Set<SelectionKey> keys = selector.keys();
        System.out.println(keys.size());
        while (true) {
            Set<SelectionKey> selectionKeys = selector.selectedKeys();
            System.out.println(selectionKeys.size());

            //此方法会阻塞
            int selectedCount = selector.select();
            System.out.println(selectedCount);

            //遍历已连接通道到集合
            Iterator<SelectionKey> it = selectionKeys.iterator();
            while (it.hasNext()) {
                //获取当前通道
                SelectionKey key = it.next();
                //从SelectionKey中获取通道对象
                ServerSocketChannel channel = (ServerSocketChannel) key.channel();

                //查看此通道是监听哪个端口
                System.out.println(channel.getLocalAddress());

                //取出连接到该服务器客户端到客户端通道
                SocketChannel accept = channel.accept();
                System.out.println(accept);

                //与客户端进行交互的代码,接收客户端接收的信息
                ByteBuffer inBuf = ByteBuffer.allocate(1024);
                accept.read(inBuf);
                inBuf.flip();
                String msg = new String(inBuf.array(),0,inBuf.limit());
                System.out.println(channel.getLocalAddress()+msg);

                //从连接到通道中把已经处理过到服务器通道移除
                it.remove();
            }
            Thread.sleep(1000 * 5);
            System.out.println();
        }
    }
}
```
二.NIO2-AIO(异步非阻塞)
2.1 AIO概述和分类
什么是AIO:ASynchronized 异步非阻塞的IO

AIO的分类:
异步文件通道•AsynchronousFileChannel
异步客户端通道•AsynchronousSocketChannel
异步服务器通道•AsynchronousServerSocketChannel
异步UDP协议通道•AsynchronousDatagramChannel

AIO的异步:
a.建立连接时可以使用异步(调用连接时的方法,非阻塞,连接成功后会以方法的回调机制通知我们)
b.读取数据时,可以使用异步(调用read方法时,非阻塞,等数据接收到之后以方法调用的机制通知我们)

2.2 AIO异步非阻塞连接的建立

异步非阻塞的客户端通道
```java
public class AIO_SocketChannel {
    public static void main(String[] args) throws IOException {
        //创建异步客户端通道
        AsynchronousSocketChannel socketChannel = AsynchronousSocketChannel.open();

        //连接服务器,采用异步非阻塞方式
        //connect(服务器IP和端口号),附件(null),接口
        socketChannel.connect(new InetSocketAddress("127.0.0.1",8888),null, new CompletionHandler<Void, Object>() {
            @Override
            public void completed(Void result, Object attachment) {
                System.out.println("Successful");
            }

            @Override
            public void failed(Throwable exc, Object attachment) {
                System.out.println("Failed");
            }
        });

        System.out.println("Continue");
    while (true){

    }
    }
}
异步非阻塞的服务器通道


public class AIO_ServerSocketChannel {
    public static void main(String[] args) throws IOException {
        //创建异步服务器端通道
        AsynchronousServerSocketChannel serversocketChannel = AsynchronousServerSocketChannel.open();

        //绑定本地某个端口
        serversocketChannel.bind(new InetSocketAddress(8888));

        //接收异步客户端,采用异步非阻塞方式
        //accept附件(null),接口
        serversocketChannel.accept(null, new CompletionHandler<AsynchronousSocketChannel, Object>() {
            @Override
            public void completed(AsynchronousSocketChannel result, Object attachment) {
                System.out.println("Connect Client Successful");
            }

            @Override
            public void failed(Throwable exc, Object attachment) {
                System.out.println("Connect Client Failed");
            }
        });

        System.out.println("Server Continue");
        while (true) {

        }
    }
}
```
异步非阻塞建立连接

```java
public class AIO_SocketChannel {
    public static void main(String[] args) throws IOException {
        //创建异步客户端通道
        AsynchronousSocketChannel socketChannel = AsynchronousSocketChannel.open();

        //连接服务器,采用异步非阻塞方式
        //connect(服务器IP和端口号),附件(null),接口
        socketChannel.connect(new InetSocketAddress("127.0.0.1", 8888), null, new CompletionHandler<Void, Object>() {
            @Override
            public void completed(Void result, Object attachment) {
                System.out.println("Connect Server Successful");
            }

            @Override
            public void failed(Throwable exc, Object attachment) {
                System.out.println("Connect Server Failed");
            }
        });

        System.out.println("Client Continue");
        while (true) {

        }
    }
}

public class AIO_ServerSocketChannel {
    public static void main(String[] args) throws IOException {
        //创建异步服务器端通道
        AsynchronousServerSocketChannel serversocketChannel = AsynchronousServerSocketChannel.open();

        //绑定本地某个端口
        serversocketChannel.bind(new InetSocketAddress(8888));

        //接收异步客户端,采用异步非阻塞方式
        //accept附件(null),接口
        serversocketChannel.accept(null, new CompletionHandler<AsynchronousSocketChannel, Object>() {
            @Override
            public void completed(AsynchronousSocketChannel result, Object attachment) {
                System.out.println("Connect Client Successful");
                try {
                    System.out.println(result.getLocalAddress());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void failed(Throwable exc, Object attachment) {
                System.out.println("Connect Client Failed");
            }
        });

        System.out.println("Server Continue");
        while (true) {

        }
    }
}
```
2.3 AIO同步读写数据

```java
public class AIO_SocketChannel {
    public static void main(String[] args) throws IOException {
        //创建异步客户端通道
        AsynchronousSocketChannel socketChannel = AsynchronousSocketChannel.open();

        //connect(服务器IP和端口号),附件(null),接口
        socketChannel.connect(new InetSocketAddress("127.0.0.1", 8888), null, new CompletionHandler<Void, Object>() {
            @Override
            public void completed(Void result, Object attachment) {
                System.out.println("Connect Server Successful");

                //客户端给服务器发送数据
                ByteBuffer buffer = ByteBuffer.allocate(1024);
                buffer.put("I am AIO Client".getBytes());
                buffer.flip();
                socketChannel.write(buffer);
                try {
                    socketChannel.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void failed(Throwable exc, Object attachment) {
                System.out.println("Connect Server Failed");
            }
        });

        System.out.println("Client Continue");
        while (true) {

        }
    }
}


public class AIO_ServerSocketChannel {
    public static void main(String[] args) throws IOException {
        //创建异步服务器端通道
        AsynchronousServerSocketChannel serversocketChannel = AsynchronousServerSocketChannel.open();

        //绑定本地某个端口
        serversocketChannel.bind(new InetSocketAddress(8888));

        //接收异步客户端,采用异步非阻塞方式
        //accept附件(null),接口
        serversocketChannel.accept(null, new CompletionHandler<AsynchronousSocketChannel, Object>() {
            @Override
            public void completed(AsynchronousSocketChannel result, Object attachment) {
                System.out.println("Connect Client Successful");

                ByteBuffer buffer = ByteBuffer.allocate(1024);
                Future<Integer> future = result.read(buffer);
                try {
                    byte[] array = buffer.array();
                    System.out.println(Arrays.toString(array));

                    Integer len = future.get();
                    System.out.println(len);
                    //当调用future的get方法时,数据才写入到buffer中
                    //所以我们不能在调用get方法之前,调用flip,否则数据将无法写入
                    buffer.flip();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void failed(Throwable exc, Object attachment) {
                System.out.println("Connect Client Failed");
            }
        });

        System.out.println("Server Continue");
        while (true) {
        }
    }
}
```
2.4 AIO异步读写数据

```java
/**
 * AIO下的 异步客户端通道
 */
public class AIOSocketChannelDemo01 {
    public static void main(String[] args) throws IOException, InterruptedException {
        //1.创建 异步的客户端通道
        AsynchronousSocketChannel socketChannel = AsynchronousSocketChannel.open();
        //2.去连接服务器,采用异步非阻塞方法
        //connect(服务器的connectIP和端口号,附件(null),接口);
        socketChannel.connect(new InetSocketAddress("127.0.0.1", 8888), null, new CompletionHandler<Void, Object>() {
            @Override
            public void completed(Void result, Object attachment) {
                System.out.println("连接服务器成功...");
                //给服务器发送数据
                ByteBuffer buffer = ByteBuffer.allocate(1000);
                buffer.put("你好我是AIO客户端..".getBytes());
                buffer.flip();
                //异步的write(缓冲区,超时时间,时间单位,附件(null),回调接口);
                socketChannel.write(buffer, 10, TimeUnit.SECONDS, null, new CompletionHandler<Integer, Object>() {
                    @Override
                    public void completed(Integer result, Object attachment) {
                        System.out.println("数据成功发送...");
                        //释放资源
                        try {
                            socketChannel.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }

                    @Override
                    public void failed(Throwable exc, Object attachment) {
                        System.out.println("数据发送失败...");
                    }
                });


            }

            @Override
            public void failed(Throwable exc, Object attachment) {
                System.out.println("连接服务器失败...");
            }
        });

        System.out.println("程序继续执行....");
        Thread.sleep(5000);
    }
}


/**
 * AIO下的 异步服务器端通道
 */
public class AIOServerSocketChannelDemo01 {
    public static void main(String[] args) throws IOException, InterruptedException {
        //1.创建一个异步的服务器通道
        AsynchronousServerSocketChannel serverSocketChannel = AsynchronousServerSocketChannel.open();
        //2.绑定本地某个端口
        serverSocketChannel.bind(new InetSocketAddress(8888));
        //3.接收异步客户端,采用异步非阻塞方式
        //accpet(附件(nulll),接口);
        serverSocketChannel.accept(null, new CompletionHandler<AsynchronousSocketChannel, Object>() {
            @Override
            public void completed(AsynchronousSocketChannel socketChannel, Object attachment) {
                System.out.println("有客户端连接....");
                //从客户端中读取数据
                //异步的read(字节缓冲区,超时时间,时间单位,附件(null),回调接口)
                ByteBuffer buffer = ByteBuffer.allocate(1000);
                socketChannel.read(buffer, 10, TimeUnit.SECONDS, null, new CompletionHandler<Integer, Object>() {
                    @Override
                    public void completed(Integer result, Object attachment) {
                        System.out.println("数据读取完毕..");
                        System.out.println("接收到数据的长度:"+result);
                        System.out.println("接收到的数据是:" + new String(buffer.array(), 0, result));
                        //释放资源
                        try {
                            socketChannel.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }

                    @Override
                    public void failed(Throwable exc, Object attachment) {
                        System.out.println("读取数据失败...");
                    }
                });
            }

            @Override
            public void failed(Throwable exc, Object attachment) {
                System.out.println("客户端连接失败...");
            }
        });

        System.out.println("程序继续执行..");
        while (true) {
            Thread.sleep(1000);
        }

    }
}
```
总结：
Selector作用：
Selector可以让多个服务器注册到它上，完成多路复用功能

使用Selector选择器
注册：
channel.register(selector,SelectionKey.OP_ACCEPT);
方法：
//表示所有被连接到服务器通道的集合
public Set selectedKeys();
Set keys = selector.selectedKeys();

//获取所有已经成功注册到选择器的服务器通道集合
public Set keys();
Set keys = selector.keys();

//如果目前没有客户端连接,该方法会阻塞。如果有客户端连接会返回本次连接的客户端数量
public int select();
int count = selector.select();

AIO特点:
a.支持异步非阻塞连接 connect accept
b.支持异步非阻塞到读写数据
socketChannel.write(…);
socketChannel.read(…);

