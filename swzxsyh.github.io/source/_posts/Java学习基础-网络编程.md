---
title: Java学习基础-网络编程
date: 2020-03-24 00:50:55
tags:
---

一.网络编程入门
概述：在网络通信协议下，实现网络互连的不同计算机上运行的程序间可以交换的数据

1.1 软件架构介绍
C/S架构:Client/Server
B/S架构:Browser/Server

1.2 网络通信协议
•什么是网络通信协议:计算机必须遵循的规则
•TCP/IP协议
TCP协议:Transmission Control Protocol,传输控制协议
IP协议:Internet Protocol,因特网协议

1.3 Java中支持的常见协议
java.net包提供两个协议
TCP传输控制协议:面向连接的协议(数据传输之前必须先建立连接,通过三次握手建立连接)
优点:保存数据完整,安全
缺点:消耗性能

UDP用户数据协议:面向无连接协议(数据传输时,不需要关心对方是否存在,只负责传输)
优点:性能较高
缺点:不能保证完整与安全性

1.4 网络编程三要素
a.网络通信协议
b.IP地址:每台连接到互联网的计算机的唯一标识,由32位二进制组成
c.端口号:一台计算机上不同软件的标识
端口号:一共0-65535个,1024是本机发出口,其他为随机高端口

1.5 计算机小知识
•IP地址的分类
IPv4:由32位二进制组成,2^32个地址
IPv6:由128位二进制组成,2^128个地址

•IP地址的相关命令
ipconfig/ifconfig:查看本机IP
ping/ping6:查看网络是否畅通

•特殊的IP地址
127.0.0.1(localhost):本机回环地址

1.6 InetAddress类的基本使用
a.InetAddress类代表IP地址
b.获取本机IP地址
InetAddress.getLocalHost();
c.获取其他机器IP地址
InetAddress.getByName(“”);
d.成员方法
String getHostName();获得主机名
String getHostAddress();获得IP地址字符串



```java

public class Test_InetAddress {
  public static void main(String[] args) throws UnknownHostException {
    //获取本机IP地址
    InetAddress localHost = InetAddress.getLocalHost();
    System.out.println(localHost);
    //获取其他机器IP地址
    InetAddress byName = InetAddress.getByName("www.baidu.com");
    System.out.println(byName);

    //成员方法
    String hostName = byName.getHostName();
    System.out.println(hostName);
    String  address = byName.getHostAddress();
    System.out.println(address);
  }
}
```

二.TCP通信程序
2.1 TCP通信分为客户端和服务器
客户端:用户电脑
服务器端:服务商电脑

2.2 TCP中两个重要的类
a.Socket类,代表客户端(套接字)
b.ServerSocket类,代表服务器端(服务器套接字)

2.3 Socket类的介绍和使用
•构造方法
public Socket(String ip,int port);//服务器IP地址,服务器端口号
此构造会根据传入的参数自动连接服务器:
若连接成功,则对象正常创建
若连接失败,则直接抛出异常

```java
public class SocketDemo {
  public static void main(String[] args) throws IOException {
    Socket socket = new Socket("192.168.50.54",8080 );
    System.out.println(socket);
  }
}
```


•常用方法
public OutputStream getOutputStream();//获取连接通道中的输出流
public InputStream getInputStream();//获取连接通道中的输入流

public void shutDownOutput();//关闭连接通道中的输出流
public void shutDownInput();//关闭连接通道中的输入流

public void close();//关闭客户端对象

2.4 ServerSocket类的介绍和使用
•构造方法
public ServerSocket(int port);//指定服务器端使用的端口号

•常用的成员方法
public Socket accept();//接收连接到服务器的Socket对象,如果暂时没有客户端,该方法会阻塞
public Socket close();//关闭服务器对象

注意:服务器获取到客户端之后，也可以获得连接中的两个流，但是获取时是输入流还是输出流要相对服务器判断

2.5 简单的TCP通信实现(单向通信)
客户端给服务器发送信息，服务器不反馈。
客户端:
a.创建socket对象
b.获取输出流
c.调用输出流的write方法
d.释放资源
服务器:
a.创建ServerSocket对象
b.接收连接到的客户端对象
c.获取输入流
d.调用输入流的read方法
e.释放资源

UDP接收数据步骤:
①创建接收端的Socket对象(DatagramSocket)
DatagramSocket(int port)
②创建一个数据包，用于接收数据
DatagramPacket(byte[] buf,length)
③调用DatagramSocket对象的方法接收数据
void receive(DatagramPacket p)
④解析数据包，并把数据打印在控制台
byte[] getData()
int getLength()
⑤关闭接收端
void close()



```java

//TCP 方式
public class ServerSocketDemo_TCP {
  public static void main(String[] args) throws IOException {
    ServerSocket serverSocket = new ServerSocket(8888);
    System.out.println("Server running");
    Socket accept = serverSocket.accept();
    System.out.println("Client Coming");

    InputStream in = accept.getInputStream();

    byte[] bs = new byte[1024];
    int len = in.read(bs);
    System.out.println("Client Said"+new String(bs,0,len));

    in.close();
    serverSocket.close();
  }
}
//UDP方式
public class ServerSocketDemo_UDP {
  public static void main(String[] args) throws IOException {
    DatagramSocket ds = new DatagramSocket(8888);
    byte[] bys = new byte[1024];
    DatagramPacket dp = new DatagramPacket(bys,bys,length)

      ds.receive(dp);

    System.out.println(new String(dp.getData(),0,dp.getlength()));

    ds.close();
  }
}


public class SocketDemo {
  public static void main(String[] args) throws IOException {
    Socket socket = new Socket("127.0.0.1",8888 );
    System.out.println("Connect Successful");
    OutputStream out = socket.getOutputStream();

    out.write("I am Client".getBytes());
    System.out.println("Sent Successful");

    out.close();
    socket.close();
    System.out.println("Client close");
  }
}
```

2.6 简单的TCP通信实现(双向通信)
客户端给服务器发送信息，服务器接收后反馈。
客户端:
a.创建socket对象
b.获取输出流
c.调用输出流的write方法
===读取服务器回复的信息
d.获取输入流
e.调用输入流的read方法
f.释放资源

d.释放资源
服务器:
a.创建ServerSocket对象
b.接收连接到的客户端对象
c.获取输入流
d.调用输入流的read方法
====回信息
e.获取输出流
f.调用输出流的write方法
g.释放资源

```java
public class ServerSocketDemo {
  public static void main(String[] args) throws IOException {
    ServerSocket serverSocket = new ServerSocket(8888);
    System.out.println("Server running");
    Socket accept = serverSocket.accept();
    System.out.println("Client Coming");

    InputStream in = accept.getInputStream();

    byte[] bs = new byte[1024];
    int len = in.read(bs);
    System.out.println("Client Said"+new String(bs,0,len));

    OutputStream outputStream = accept.getOutputStream();
    outputStream.write("I am Server.".getBytes());

    outputStream.close();
    in.close();
    serverSocket.close();
  }
}


public class SocketDemo {
  public static void main(String[] args) throws IOException {
    Socket socket = new Socket("127.0.0.1",8888 );
    System.out.println("Connect Successful");
    OutputStream out = socket.getOutputStream();

    out.write("I am Client".getBytes());
    System.out.println("Sent Successful");

    InputStream in = socket.getInputStream();

    byte[] bs = new byte[1024];
    int len = in.read(bs);
    System.out.println("Server Said"+new String(bs,0,len));

    in.close();
    out.close();
    socket.close();
    System.out.println("Client close");
  }
}
```

三.文件上传
3.1 分析
客户端:
读取文件FileInputStream
发送数据getOutputStream
a.创建Socket
b.获取输出流
c.创建文件的输入流
d.循环:一边读文件，一边发送
e.添加一句代码，告诉服务器文件发送完毕
f.获取输入流
g.读取服务器回复的信息
h.释放资源

服务器:
读取数据getInputStream
写入文件FileOutputStream
a.创建ServerSocket
b.获取客户端
c.获取输入流
d.创建文件输出流
e.循环:一边读数据，一边写文件
f.获取输出流
g.给客户端回信息
h.释放资源

3.2 文件上传案例实现

```java
public class SocketDemo {
  public static void main(String[] args) throws IOException {
    Socket socket = new Socket("127.0.0.1", 8888);
    System.out.println("Connect Successful");
    OutputStream outputStream = socket.getOutputStream();

    FileInputStream fileInputStream = new FileInputStream("1.png");

    byte[] bs = new byte[1024];
    int len = 0;
    while ((len = fileInputStream.read(bs)) != -1) {
      outputStream.write(bs, 0, len);
    }
    socket.shutdownOutput();
    System.out.println("File send successfle");

    InputStream inputStream = socket.getInputStream();

    len = inputStream.read(bs);
    System.out.println(new String(bs,0,len));

    inputStream.close();
    fileInputStream.close();
    outputStream.close();
    socket.close();
    System.out.println("Client close");
  }
}


public class ServerSocketDemo {
  public static void main(String[] args) throws IOException {
    ServerSocket serverSocket = new ServerSocket(8888);
    Socket accept = serverSocket.accept();

    InputStream inputStream = accept.getInputStream();

    FileOutputStream fileOutputStream = new FileOutputStream(System.currentTimeMillis()+".png");

    byte[] bs = new byte[1024];
    int len = 0;
    while ((len = inputStream.read(bs)) != -1) {
      fileOutputStream.write(bs, 0, len);
    }

    OutputStream outputStream = accept.getOutputStream();
    outputStream.write("I am Server.".getBytes());

    outputStream.close();
    fileOutputStream.close();
    inputStream.close();
    accept.close();
    serverSocket.close();
  }
}


public class ServerSocketMultiDemo {
  public static void main(String[] args) throws IOException {
    ServerSocket serverSocket = new ServerSocket(8888);
    while (true) {
      Socket accept = serverSocket.accept();
      InputStream inputStream = accept.getInputStream();

      FileOutputStream fileOutputStream = new FileOutputStream(System.currentTimeMillis() + ".png");

      byte[] bs = new byte[1024];
      int len = 0;
      while ((len = inputStream.read(bs)) != -1) {
        fileOutputStream.write(bs, 0, len);
      }

      OutputStream outputStream = accept.getOutputStream();
      outputStream.write("I am Server.".getBytes());

      outputStream.close();
      fileOutputStream.close();
      inputStream.close();
      accept.close();
    }
  }
}


public class ServerSocketMultiDemo_Thread {
  public static void main(String[] args) throws IOException {
    ServerSocket serverSocket = new ServerSocket(8888);
    while (true) {
      Socket accept = serverSocket.accept();

      new Thread(() -> {
        try {
          InputStream inputStream = accept.getInputStream();

          FileOutputStream fileOutputStream = new FileOutputStream(System.currentTimeMillis() + ".png");

          byte[] bs = new byte[1024];
          int len = 0;
          while ((len = inputStream.read(bs)) != -1) {
            fileOutputStream.write(bs, 0, len);
          }

          OutputStream outputStream = accept.getOutputStream();
          outputStream.write("I am Server.".getBytes());
          outputStream.close();
          fileOutputStream.close();
          inputStream.close();
          accept.close();
        } catch (IOException e) {
          e.printStackTrace();
        }
      }).start();

    }
  }
}
```

3.3 模拟BS架构服务器



```java

public class ServerSocketDemo {
  public static void main(String[] args) throws IOException {
    ServerSocket serverSocket = new ServerSocket(8888);
    while (true) {
      Socket accept = serverSocket.accept();

      new Thread(() -> {
        try {

          InputStream inputStream = accept.getInputStream();

          BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
          String line = bufferedReader.readLine();

          String[] splits = line.split(" ");
          String substring = splits[1].substring(1);
          System.out.println(substring);

          FileInputStream fileInputStream = new FileInputStream(substring);
          OutputStream outputStream = accept.getOutputStream();

          byte[] bs = new byte[1024];
          int len = 0;
          outputStream.write("HTTP/1.1 200 OK\r\n".getBytes());
          outputStream.write("Content-Type:text/html\r\n".getBytes());
          outputStream.write("\r\n".getBytes());

          while ((len = fileInputStream.read(bs)) != -1) {
            outputStream.write(bs, 0, len);
          }

          outputStream.close();
          inputStream.close();
          accept.close();
        } catch (Exception e) {
          e.printStackTrace();
        }
      }).start();
      //        serverSocket.close();
    }
  }
}
```


总结:
TCP协议特点:面向有连接(先建立连接，后建立数据)
UDP协议特点:面向无连接(只需要发送数据，不需关心对方是否存在)
TCP协议两个常用名称
Socket:客户端类
•构造方法
public Socket(String ip,int port);//服务器IP地址,服务器端口号
•常用方法
public OutputStream getOutputStream();//获取连接通道中的输出流
public InputStream getInputStream();//获取连接通道中的输入流
public void shutDownOutput();//关闭连接通道中的输出流
public void shutDownInput();//关闭连接通道中的输入流
public void close();//关闭客户端对象

ServerSocket:服务器类
•构造方法
public ServerSocket(int port);//指定服务器端使用的端口号
•常用的成员方法
public Socket accept();//接收连接到服务器的Socket对象,如果暂时没有客户端,该方法会阻塞
public Socket close();//关闭服务器对象

TCP协议单双向传输数据
TCP协议下文件上传案例
上传:客户端将文件发送至服务器,服务器保存到硬盘
下载:
a.客户端读取本地文件
b.通过流输出发送给服务器
c.服务器读取输入流数据
d.保存到服务器本地

TCP协议到BS案例:
不需要写客户端，使用浏览器访问服务器，

