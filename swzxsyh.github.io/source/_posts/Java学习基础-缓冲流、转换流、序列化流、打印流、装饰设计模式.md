---
layout: post
title: Java学习基础-缓冲流、转换流、序列化流、打印流、装饰设计模式
date: 2020-03-23 00:49:57
tags:
---

一.缓冲流
1.1 缓冲流的介绍
缓冲流也叫高效流,是对之前的四个基本流的增强(性能,方法一模一样),会创建缓冲区,减少硬盘IO读写,提高速度。

1.2 缓冲Buffered流的分类
缓冲字节输入流:BufferedInputStream –> 普通的字节输入流IntputStream的增强
缓冲字节输出流:BufferedOutputStream –> 普通的字节输出流OutputStream的增强
缓冲字符输入流:BufferedReader –> 对普通的字符输入流Reader的增强
缓冲字符输出流:BufferedWriter –> 对普通的字符输出Writer流的增强

1.3 字节缓冲流的介绍和使用
•字节缓冲流的构造
public BufferedInputStream(InputStream in);//缓冲流的构造需要接收普通字节流
public BufferedOutputStream(OutputStream in);//缓冲流的构造需要接收普通字节流

•字节缓冲流的高效测试

```java
public class Buffered_Demo01 {
  public static void main(String[] args) throws Exception {
    copy01();
    copy02();
  }

  public static void copy01() throws IOException {
    BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream("1.txt"));
    BufferedInputStream bis = new BufferedInputStream(new FileInputStream("2.txt"));

    long start = System.currentTimeMillis();

    int b = 0;
    while ((b = bis.read()) != -1) {
      bos.write(b);
    }
    long end = System.currentTimeMillis();

    System.out.println(end - start);

    bis.close();
    bos.close();
  }

  public static void copy02() throws IOException {
    FileOutputStream fos = new FileOutputStream("1.txt");
    FileInputStream fis = new FileInputStream("2.txt");

    long start = System.currentTimeMillis();

    int b = 0;
    while ((b = fis.read()) != -1) {
      fos.write(b);
    }
    long end = System.currentTimeMillis();

    System.out.println(end - start);

    fos.close();
    fis.close();
  }
}
```
更快的方式:使用缓冲流的同时,使用一次读取一个字节数组的方式

1.4 字符缓冲流的介绍和使用
•字符缓冲流的构造
public BufferedWriter(Writer w);//缓冲流的构造需要接收普通字符流
public BufferedReader(Reader r);//缓冲流的构造需要接收普通字符流

字符缓冲流也是对普通字符类对性能增强

•字符缓冲流的2个特有方法
BufferedWriter是对普通Writer的增强
多了一个特有方法:向文件中写一个换行符(根据系统而定)
public void newLine();

```java

public class Buffered_R_W {
  public static void main(String[] args) throws IOException {
    BufferedWriter bw = new BufferedWriter(new FileWriter("1.txt"));
    for (int i = 0; i < 10; i++) {
      bw.write("Java");
      bw.newLine();
    }

    bw.close();
    //先开后关,不用即关
  }
}
```
BufferedReader是对普通Reader的增强
多了一个特有方法:一次读取一行内容
public void ReadLine();

```java

public static void main(String[] args) throws IOException {
  BufferedReader bf = new BufferedReader(new FileReader("1.txt"));
  String s = bf.readLine();
  System.out.println(s);

  //一次读取一行的标准循环代码
  String line = "";//用来保存每次读取的一行数据
  while ((line = bf.readLine()) != null) {
    System.out.println(line);
  }
  //(line = bf.readLine()) != null
  /*
读取bf.readLine();
赋值line = 读到一行数据
判断line != null;
 */

  bf.close();
}
```


注意:一次读取一行的标准循环不会因为有一行是(null字符串/空行)而停止,只有读取到文件的末尾,没有内容时返回null才停止

1.5 总和练习:文本排序

读取文件并排序



```java

public class TestDemo {
  public static void main(String[] args) throws Exception {
    List<String> arr = new ArrayList<String>();
    BufferedReader bf = new BufferedReader(new FileReader("6.txt"));

    String line = "";
    while ((line = bf.readLine()) != null) {
      arr.add(line);
    }
    bf.close();

    Collections.sort(arr, (o1, o2) -> o1.charAt(0) - o2.charAt(0));

    BufferedWriter bw = new BufferedWriter(new FileWriter("new.txt"));

    for (String s : arr) {
      bw.write(s);
      bw.newLine();
    }

    bw.close();
  }
}
```

二.转换流
2.1 编码和解码
编码:把字符 —> 字节,比如’a’–>97(0110 0001)
解码:把字节 —> 字符,比如97(0110 0001)–>’a’

2.2 字符集
字符集:就是一个系统所支持的所有字符(文字、标点、数字,图形符号等)的集合

2.3 字符编码
字符编码:是指字符和二进制一一对应的一套规则,比如字符’a’对应的码值是 97

常见的字符集和字符编码

字符集		编码
ASCII 字符集	—>	ASCII编码,规定ASCII字符集中所有的字符 都占一个字节
GBK 字符集	—>	GBK编码,规定所有中文字符都占2个字节(这两个字节是负数)
ISO-8859-1字符集	—>	西欧国家字符集(以后使用Tomcat7以前默认就是使用ISO-8859-1)
Unicode字符集	—>	UTF-8,规定所有的中文字符都占3个字节
2.4 编码引出的问题
IDEA默认使用UTF-8，Windows默认使用GBK编码，以下例子会导致读取出3个字符



```java

public class TestDemo {
  public static void main(String[] args) throws Exception {
    FileReader fr = new FileReader("GBK.txt");
    int ch = fr.read();
    System.out.println((char)ch);

    fr.close();
  }
}
```

解决方法：
硬编码方式：
a.把文件编码改为UTF-8和IDEA一致
b.把IDEA编码改成GBK文件一致
软编码方式：转换流

2.5 使用转换流InputStreamReader解决读取中文的问题
转换输入流: InputStreamReader extends Reader

•构造方法
public InputStreamReader(InputStream in,String charsetName);//使用指定编码读文件
public InputStreamReader(InputStream in);//使用IDE默认编码读取文件

•使用InputStreamReader读取不同编码的文件

```java
public class TestDemo02_InputStreamReader {
  public static void main(String[] args) throws Exception {
    InputStreamReader isr = new InputStreamReader(new FileInputStream("utf8.txt"), "UTF-8");
    int ch = isr.read();
    System.out.println((char)ch);

    ch = isr.read();
    System.out.println((char)ch);

    ch = isr.read();
    System.out.println((char)ch);

    isr.close();
  }
}
```
2.6 使用转换流OutputStreamWriter解决读取中文的问题
转换输出流:OutputStreamWriter extends Writer

•构造方法
public OutputStreamWriter(OutputStream out,String charsetName);//写文件时指定编码
public OutputStreamWriter(OutputStream out);//使用IDE默认编码

•输出指定编码的中文

```java

public class TestDemo03_OutputStreamWriter {
  public static void main(String[] args) throws Exception {
    //        OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream("newGBK.txt"), "GBK");
    OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream("newutf8.txt"), "UTF-8");
    osw.write("你好");

    osw.close();
  }
}
```

2.7 转换流的理解(转换流是字节与字符之间的桥梁)
InputStreamReader:读取字节，解码为字符，根据编码(UTF-8或GBK)去读2个或3个字节，然后根据编码(UTF-8或GBK)解码为字符
OutputStreamWriter:写出字符，编码为字节，根据编码(UTF-8或GBK)把字符编码为2个或3个字节，然后写到对应文件中

2.8 练习:转换文件编码
将GBK文件转换为UTF-8文件
分析:
a.先把GBK文件中的内容读取出来(GBK)
b.再把数据写入到UTF-8文件中



```java

public class TestDemo {
  public static void main(String[] args) throws Exception {
    InputStreamReader isr = new InputStreamReader(new FileInputStream("newGBK.txt"), "GBK");
    OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream("coyt_to_UTF8.txt"), "UTF-8");

    int ch = 0;
    while ((ch = isr.read()) != -1) {
      osw.write(ch);
    }

    osw.close();
    isr.close();
  }
}
```

三.序列化流
3.1 什么是序列化流
对象序列化：就是将对象保存到磁盘中，或者在网络中传输对象。
这种机制就是使用一个字节序列表示一个对象，该字节序列包含：对象的类型，对象的数据和对象中存储的属性等信息。
字节序列写到文件后，相当于文件中持久保存了一个对象的信息。
反之，该字节序列还可以从文件中读取回来，重构对象，对他进行反序列化

序列化流:写出对象的流
ObjectOutputStream

反序列化流:读取对象的流
ObjectInputStream

3.2 ObjectOutputStream介绍和使用
•构造方法
public ObjectOutputStream(OutputStream out);//需要接收一个普通的字节输出流

•序列化操作的前提
想要实现序列化，必须实现java.io.Serializable,否则NotSerializableException报错

该接口中没有方法，该接口一般作为标记接口

•序列化操作(代码演示)



```java
1
  public class Dog implements java.io.Serializable{}

public class TestDemo {
  public static void main(String[] args) throws Exception {
    ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("Dog.txt"));
    Dog dd = new Dog(10, "a");
    oos.writeObject(dd);

    oos.close();
  }
}
```

注意:不需要查看Dog.txt文件，编码无法查看，需要反序列化读取

3.3 ObjectInputStream介绍和使用
•构造方法
public ObjectInputStream(InputStream in);//需要接收一个普通的字节输入流

•反序列化操作(代码演示)



```java

public class TestDemo_ObjectInputStream {
  public static void main(String[] args) throws Exception {
    ObjectInputStream ois = new ObjectInputStream(new FileInputStream("Dog.txt"));
    Dog obj = (Dog)ois.readObject();
    System.out.println(obj);

    ois.close();
  }
}
```

3.4 反序列化操作的两种异常演示
a.ClassNotFoundException 类没有找到的异常
出现原因:
序列化之后，反序列化之前，删除了用来序列化的类

b.InvalidClassException 无效类异常
出现原因:
序列化之后，反序列化之前，修改了用来序列化的类

c.实际上序列化流通过serialVersionUID来识别的

3.5 练习:如果需要序列化多个对象怎么操作
注意:序列化流一个文件只适合序列化一个对象
分析:
a.把要序列化的多个对象，保存到一个集合对象
b.将这个集合作为对象，序列化到文件中
c.从文件中将整个集合反序列化
d.遍历集合把里面的对象一一打印出来

```java
public class TestDemo {
  public static void main(String[] args) throws Exception {
    write();
    read();
  }

  public static void write() throws Exception {
    ArrayList<Dog> dogs = new ArrayList<Dog>();
    dogs.add(new Dog(1, "a", 4));
    dogs.add(new Dog(2, "b", 5));
    dogs.add(new Dog(3, "c", 6));

    ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("Dogs.txt"));
    oos.writeObject(dogs);
    oos.close();
  }

  public static void read() throws IOException, ClassNotFoundException {
    ObjectInputStream ois = new ObjectInputStream(new FileInputStream("Dogs.txt"));

    ArrayList<Dog> dogs = (ArrayList<Dog>) ois.readObject();
    ois.close();
    for (Dog dog : dogs) {
      System.out.println(dog);
    }

  }
}
```

四.打印流
4.1 打印流的介绍
a.输出System.out.println();实际上就是调用了打印流的方法
b.打印流PrintStream类
c.打印流中重载了各种数据类型的print和println方法，打印数据时非常方便
d.打印流不会抛出IOException

4.2 PrintStream的构造和常用方法
构造方法:
public PrintStream(String Path);//直接指定路径
public PrintStream(File file);//直接指定文件
public PrintStream(OutputStream out);//先给一个输出流，绑定什么对象就打印到什么对象

成员方法:
public void print(各种类型);//不带换行的打印
public void println(各种类型);//带换行的打印

4.3 修改打印流的流向

```java
public class TestPrintStream02 {
  public static void main(String[] args) throws FileNotFoundException {
    PrintStream ps1 = new PrintStream("p.txt");
    ps1.println("Hallo");

    System.setOut(ps1);

    System.out.println("Java");

  }
}
```

五.装饰设计
什么是设计模式:为了解决一系列问题，总结出来的一套方案

5.1 装饰模式的作用
装饰模式指的是在不改变原类，不实用继承的基础上，动态地扩展一个对象的功能。

5.2 装饰者设计模式的4个基本步骤
•装饰类(自己定义的新类)和被装饰类(原类)必须实现相同的接口
•在装饰类中必须传入被装饰类的引用
•在装饰类中对需要的扩展方法进行扩展
•在装饰类中对不需要的扩展方法调用被装饰类中的同名方法

5.3 代码实现

```java
//相同接口
public interface SingStar {
  void sing();
  void dance();
}

//被装饰类
public class Singer implements SingStar{
  @Override
  public void sing(){
    System.out.println("aaaaa");
  }
  @Override
  public void dance(){
    System.out.println("bbbbb");
  }
}

//装饰类
public class Wrapper implements SingStar{
  private Singer SG;
  public Wrapper(Singer SG) {
    this.SG = SG;
  }

  @Override
  public void sing(){
    System.out.println("ccc");
    SG.sing();
  }
  @Override
  public void dance(){
    SG.dance();
  }
}


//调用同名方法
public class TestDemo {
  public static void main(String[] args) {
    Singer sg = new Singer();
    Wrapper wrapper = new Wrapper(sg);
    wrapper.sing();
    wrapper.dance();
  }
}
```

六.commons-io工具包
6.1 commons-io的介绍和下载
是Apache提供的库

工具	功能描述
org.apache.commons.io	有关Streams、Readers、Writers、Files的工具类
org.apache.commons.io.input	输入流相关的实现类，包含Reader和InputStream
org.apache.commons.io.output	输出流相关的实现类，包含Writer和OutputStream
org.apache.commons.io.serialization	序列化相关的类
下载commons-io.zip
a.解压
b.模块下创建lib文件夹，将commons-io.jar复制进去
c.选择common-io.jar，选则add as library，加载

6.2 常用API介绍
•复制文件API

•复制文件夹API

```java
public class Commons_IO_TestDemo {
  public static void main(String[] args) throws IOException {
    //1.IOUitls.copy,适合复制2GB以下的文件
    IOUtils.copy(new FileInputStream("1.txt"),new FileOutputStream("copy_1_common.txt"));
    //1.IOUitls.copy,适合复制2GB以下的文件
    IOUtils.copyLarge(new FileInputStream("1.txt"),new FileOutputStream("copy_1_common_Large.txt"));
    //FileUtils复制文件到文件夹
    FileUtils.copyFileToDirectory(new File("1.txt"), new File("copy_1_common_FileUtil.txt"));
    //FileUtils复制文件夹到文件夹
    FileUtils.copyDirectoryToDirectory(new File("/Users/swzxsyh/Downloads/c9-python-getting-started"),new File("/Users/swzxsyh/Desktop"));
  }
}
```


总结:
1.缓冲流
字节缓冲流(BufferedOutputStream和BufferedInputStream),没有特有方法,性能比普通流更高

字符缓冲流(BufferedWriter和BufferedReader),有特有方法,性能比普通流更高
    BufferedWriter: 
        public void newLine();
    BufferedReader:
        public String readLine();
2.转换流
转换输出流： 可以指定编码写文件
OutputStreamWriter
public OutputStreamWriter(OutputStream out,String 指定的编码);
转换输入流： 可以指定编码读文件
InputStreamReader
public InputStreamReader(InputStream in,String 指定的编码);

转换输入流(可以指定编码读文件):
InputStreamWriter
public InputStreamReader(InputStream out,String charsetName);//写文件时指定编码

3.序列化流
序列化流: 写对象
ObjectOutputStream
public void writeObject(对象);//该对象的类必须实现java.io.Serializable接口
反序列化流: 读对象
ObjectInputStream
public Object readObject();

4.打印流
PrintStream ps = new PrintStream(String path/File file/OutputStream out);
方法:
print(各种数据类型);
println(各种数据类型);
5.装饰设计模式
步骤:
a.被装饰类和装饰类实现同一个接口
b.装饰类内部必须含有被装饰类的引用
c.在装饰类中对需要装饰的方法进行装饰
d.在装饰类中对不需要装饰的方法调用原对象的方法

6.commons-io【重点】
IOUtils 复制文件(2G以上和2G以下)
FileUtils 复制文件和复制文件夹