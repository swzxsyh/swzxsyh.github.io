---
title: Java学习基础-字节流、字符流、Properties
date: 2020-03-22 00:48:45
tags:
---

一.字符流
为什么要用字符流
字节流也是可以读取文本文件的,但是读取中文时可能会出现只读取其中的部分字节,因为中文不止由一个字节组成。
为了解决问题,引入了字符流,以字符为单位操作

字符输入流
顶层父类:Reader(抽象类)
共性方法:
public void close();//释放资源
public int read();//一次读一个char字符,返回字符ASCII码值,为int类型
public int read(char[] chs);//一次读一个char字符数组,返回值表示实际读取的字符个数

FileReader类的使用
文件的字符输入流(从文件中读取字符数据的)

•构造方法
public FileReader(String Path);
public FileReader(File file);

```java
public class Test_FileReader {
    public static void main(String[] args) throws Exception {
        FileReader fr = new FileReader("1.txt");
        /*
        创建对象
        判断文件是否存在,若存在,则不清空。若不存在,则返回错误FileNotFoundException
        绑定fr和1.txt文件
         */
    }
}
```


•读取一个字符


```java

public class Test_FileReader02 {
  public static void main(String[] args) throws Exception {
    FileReader fr = new FileReader("1.txt");
    //一次读一个字符
    //        int read = fr.read();
    //        System.out.println(read);
    //        System.out.println((char)read);
    //一次读取一个字符的标准循环代码
    int ch = 0;
    while ((ch = fr.read()) != -1) {
      System.out.println((char) ch);
    }

    /*(ch = fr.read()) != -1
    读取fr.read();
    赋值ch = 读到的字符
    判断ch != -1
     */

    fr.close();
  }
}
```

•读取一个字符数组

```java

public class Test_FileReader03 {
  public static void main(String[] args) throws Exception {
    FileReader fr = new FileReader("1.txt");

    //        char[] chs = new char[4];
    //        int len = fr.read(chs);
    //        System.out.println(len);
    //        System.out.println(new String(chs));
    char[] chs = new char[1024];

    int len = 0;
    while ((len = fr.read(chs)) != -1) {
      System.out.println(new String(chs, 0, len));
    }
    /*
    (len = fr.read(chs)) != -1
    读取fr.read();
    赋值 len = 实际读取的个数
    判断len != -1
    */

    fr.close();
  }
}
```

字符输出流
顶层父类:Writer(抽象类)
共性方法:
public void close();//释放资源
public int flush();//对于字符串游泳
public int write();//一次写一个char字符,返回字符ASCII码值,为int类型
public int write(char[] chs);//一次写一个char字符数组
public int write(char[] chs,int startIndex,int len);//一次写一个char字符数组的一部分

public write(String str);//直接写一个字符串
public write(String str,int startIndex,int len);//直接写一个字符串的一部分

FileWriter类的使用
文件的字符输出流(向文件中写字符数据)
•构造方法
public FileWriter(String Path);
public FileWriter(File file);

```java
public class TestFileWriter {
  public static void main(String[] args) throws IOException {
    FileWriter fw = new FileWriter("2.txt");
    /*
        创建对象fw
        判断文件是否存在,若存在则覆盖,若不存在则创建
        绑定fw和2.TXT
         */
  }
}
```


•写出字符数据的三组(五个)方法
public int write();//一次写一个char字符,返回字符ASCII码值,为int类型

public int write(char[] chs);//一次写一个char字符数组
public int write(char[] chs,int startIndex,int len);//一次写一个char字符数组的一部分

public write(String str);//直接写一个字符串
public write(String str,int startIndex,int len);//直接写一个字符串的一部分

```java
public class TestFileWriter02 {
  public static void main(String[] args) throws IOException {
    FileWriter fw = new FileWriter("2.txt");
    //写一个字符
    fw.write('a');
    fw.write('字');

    //写一个字符数组
    char[] chs ={'a','b','字','符'};
    fw.write(chs);

    fw.write(chs,0,2);

    fw.write("一二三四1234abcd");

    fw.write("一二三四1234abcd",0,3);

    fw.close();
  }
```
}
•关闭和刷新的区别
flush();只刷新缓冲区,不关闭流
close();不仅刷新缓冲区,之后还会关闭流,流不能继续使用。

```java
public class TestFileWriter03 {
  public static void main(String[] args) throws IOException {
    FileWriter fw = new FileWriter("3.txt");
    fw.write("PHP");

    //刷新缓冲区,将write的字符从Java缓冲区刷入3.txt
    fw.flush();
    fw.write("Python");
    fw.flush();

    fw.close();
    //fw.write("CPP");
    //报错java.io.IOException: Stream closed,流已关闭,无法写入
  }
```
}
•续写和换行
如何续写:
public FileWriter(String path,boolean append);//append表示是否续写
public FileWriter(File file,boolean append);//append表示是否续写

换行:

```java

public class TestFileWriter05_Return_Line {
  public static void main(String[] args) throws IOException {
    FileWriter fw = new FileWriter("3.txt");
    for (int i = 0; i < 10; i++) {
      fw.write("php"+"\n");
    }

    fw.close();
  }
```
}
二.IO流的异常处理 throws
JDK7之前的标准IO处理

```java
//IO流异常的标准处理方式(JDK 1.7之前)
public static void mtehod01() {
  FileReader fr = null;
  try {
    fr = new FileReader("1.txt");
    int read = fr.read();
    System.out.println(read);
    fr.close();
  } catch (IOException ioe) {
    ioe.printStackTrace();
  } finally {
    try {
      if (fr != null) {
        fr.close();
      }
    } catch (IOException ie) {
      ie.printStackTrace();
    }
  }
```
}
JDK7引入的IO处理
try-with-resource(和资源一起try)
格式:
try(创建资源的代码){

}catch(XxxException e){
e.printStackTrace();
}

```java
//IO流异常的标准处理方式(JDK 1.7引入)
public static void mtehod02() {
  try (FileReader fr = new FileReader("1.txt")){
    int read = fr.read();
    System.out.println((char)read);
  } catch (IOException ioe) {
    ioe.printStackTrace();
  }
}
```


三.Properties类
Properties类的介绍
Properties继承HashTable,而HashTable继承Dictionary,实现了Map接口,实际上Properties就是一个双列接口
a.Properties就是一个双列集合(Properties extends HashTable extend Dictionary implements Map)
b.Properties的键和值已经确定为String了

```java
public class Test_Properties {
  public static void main(String[] args) {
    //获取系统相关的键值对
    Properties properties = System.getProperties();
    System.out.println(properties);
  }
}
构造方法
  public Properties();//创建一个空的Properties对象
public static void main(String[] args){
  //创建一个空的Proerties对象
  Properties ps = new Properties();
  System.out.println(ps);
}
```

基本保存数据的方法
Map接口定义的方法:
增:put(键,值)
删:remove(键)
改:put(键,值)
查:get(键)
遍历的两个方法
Set<键的类型> keys = map.keySet();
Set<Map.Entry<K,V>> entrys = map.entrySet();
Properties具有Map接口中定义的方法,但是一般使用其特有方法
public Object setProperty(String key,String value);//添加键值对,和put功能一样,也能做修改使用
public String getProperty(String key);//以键找值,和get功能一样
public Set stringPropertyNames();//查找所有属性名的集合,和keySet功能一样

```java
public class Test_Properties02 {
  public static void main(String[] args) {
    //获取系统相关的键值对
    Properties properties = new Properties();
    System.out.println(properties);
    //增
    properties.setProperty("MI", "6888");
    properties.setProperty("HW", "8888");
    properties.setProperty("AP", "10888");
    System.out.println(properties);
    //改
    properties.setProperty("MI", "3888");
    System.out.println(properties);
    //获取
    String mi = properties.getProperty("MI");
    System.out.println(mi);
    //获取所有属性名(key)
    Set<String> strings = properties.stringPropertyNames();
    System.out.println(strings);
  }
}
```


与流相关的方法
Properties有两个流相关方法:一个叫保存,一个叫加载
public void store(OutputStream out,String Description);//保存Properties对象中的数据
public void store(Writer write,String Description);//保存Properties对象中的数据

public void load(InputStream in);//把Properties内容加载到当前对象
public void load(Reader read);//把Properties文件内容加载到当前对象



```java

public class Test_Properties04_Load {
  public static void main(String[] args) throws IOException {
    Properties properties = new Properties();
    properties.load(new FileInputStream("5.properties"));
    System.out.println(properties);

    Set<String> propertyNames = properties.stringPropertyNames();
    for (String propertyName : propertyNames) {
      System.out.println(propertyName + "=" + properties.get(propertyName));
    }
  }
}
```

注意:一般不会使用properties文件保存中文数据,否则需要额外编码转换

四.ResourceBundle工具
ResourceBundle类的介绍
ResourceBundle类实际上是一个抽象类,它的子类PropertyResourceBundle,可以读取以.properties为后缀的文件中的内容

ResourceBundle类对象的创建
public static ResourceBundle getBundle(String baseName);用于绑定指定的.properties文件
注意:
a.xxx.properties文件必须放在类的根路径下(src目录下)
b.给定参数适,只需要给文件名的名字,不需要写文件后缀

```java
public class ResourceBundleDemo {
  public static void main(String[] args) {
    ResourceBundle data = ResourceBundle.getBundle("data");
    System.out.println(data);
  }
}
ResourceBundle读取陪着文件操作
  public String getString(String key);

public class ResourceBundleDemo {
  public static void main(String[] args) {
    ResourceBundle resourceBundle = ResourceBundle.getBundle("data");
    System.out.println(resourceBundle);
    String username = resourceBundle.getString("username");
    String passwd = resourceBundle.getString("passwd");

    System.out.println(username+" "+passwd);
  }
}
```

总结:
Java四大流:
-字节输出流OutputStream:
子类:FileOutputStream
public void close();//关闭该流,释放资源
public void flush();//刷新缓冲区(主要字符流使用)
public void write(int b);//一次写一个字节,输入是int,但是只能写一个byte的大小,即最大127
public void write(byte[] bs);//一次写一个字节数组
public void write(byte[] bs,int startIndex,int len);//一次写这一个字节数组中的一部分

构造方法三件事:
创建输出流对象
若存在覆盖,若不存在创建
释放资源

-字节输入流InputStream:
子类:FileInputStream
public void close();//关闭该流,释放资源
public int read();//一次读一个字节
public int read(byte[] bs);//一次读一个字节数组,返回值表示实际读取的字节个数
public int read(byte[] bs,int startIndex,int len);//一次读一个字节数组的一部分(基本不用)

构造方法三件事:
创建输入流对象
若存在则读取,若不存在报错
释放资源

-字符输出流Writer:
子类:FileWriter
public void close();//释放资源
public void flush();//刷新缓冲区

public int write();//一次写一个char字符,返回字符ASCII码值,为int类型
public int write(char[] chs);//一次写一个char字符数组
public int write(char[] chs,int startIndex,int len);//一次写一个char字符数组的一部分
public write(String str);//直接写一个字符串
public write(String str,int startIndex,int len);//直接写一个字符串的一部分

构造方法三件事:
创建字符输出流对象
若存在覆盖,若不存在创建
释放资源

-字符输入流Reader:
public void close();//释放资源
public int read();//一次读一个char字符,返回字符ASCII码值,为int类型
public int read(char[] chs);//一次读一个char字符数组,返回值表示实际读取的字符个数

构造方法三件事:
创建字符输入流对象
若存在覆盖,若不存在创建
释放资源

打印地址和内容的有哪些
a.数组(除了char数组),都是打印地址
b.集合(Collection还是Map)都是打印内容
c.其他类的对象,打印出来的地址还是内容,要看释放重写toString

排序的工具类
对数组进行排序:Arrays.sort(array,new Comparator<数组元素类型>);//必须引用类型
对List集合排序:Collections.sort(,new Comparator<集合中元素对类型>);
对Set集合排序:
并不是所有的Set都能排序,TreeSet才能排序:TreeSet set = new TreeSet(new 比较器对象());
TreeSet排序:TreeSet set = new TreeSet(new 比较器对象());//或自己写排序算法:冒泡,选择,插入,希尔,快速,堆,归并…

Stream流和IO流没有关系

字节流可以操作任何文件(一切皆字节)
字符流只能操作文本文件(如果使用字符流操作图片、视频,那么结果是乱码)

线程池(保存线程的集合)
ExecutorService service = Executors.newFixedThreadPool(线程数);
线程池对象底层实际上有一个集合:
LinkedList ThreadList= new LinkedList();
for(int i = 0;i<线程数量;i++){
ThreadList.add(线程对象);
}
service.submit(任务对象);
//ThreadList.removeFirst(线程);执行完后执行ThreadList.addLast(线程);