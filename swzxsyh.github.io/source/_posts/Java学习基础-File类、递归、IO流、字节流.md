---
title: Java学习基础-File类、递归、IO流、字节流
date: 2020-03-19 00:47:36
tags:
---


一.File类
1.1 File类的作用
File类可以表示文件或文件夹,是文件和目录的抽象表示
•文件和目录是可以通过File封装成对象的
•对于File而言，其封装的并不是一个真正存在的文件，仅仅是一个路径名。将来通过具体的操作把这个路径转换为具体存在的。

1.2 File类的构造

方法名	说明
public File(String path);	通过将给定的路径名字符串转换为抽象路径名来创建新的File实例
public File(String parent,String child);	从父路径名字符串和子路径名字符串创建新的File实例
public File(File parent,String child);	从父抽象路径名和子路径名字符串创建新的File实例

```java

public class FileDemo01 {
  public static void main(String[] args) {
    File f1 = new File("/Users/u/Desktop/12306Bypass/Logs/2019-01-03.txt");

    System.out.println(f1);

    File f2 = new File("/Users/u/Desktop","12306Bypass/Logs/2019-01-03.txt");
    System.out.println(f2);

    File parent = new File("/Users/u/Desktop");
    File f3 = new File(parent,"12306Bypass/Logs/2019-01-03.txt");
    System.out.println(f3);
  }
}
```

1.3 File类的获取方法
public String getAbsolutePath();//获取该File对象的绝对路径
public String getPath();//获取该File对象构造时,传入的对象
public String getName();//获取该File对象的代表的文件或文件夹的名字
public long length();//获取该File对象的文件字节



```java

public class FileDemo02 {
  public static void main(String[] args) {
    File f1 = new File("~/Desktop/12306Bypass/Logs/2019-01-03.txt");
    //getAbsolutePath
    String absolutePath = f1.getAbsolutePath();
    System.out.println(absolutePath);

    //getPath
    String path = f1.getPath();
    System.out.println(path);

    //name
    String name = f1.getName();
    System.out.println(name);

    //length
    long length = f1.length();
    System.out.println(length+" byte");

  }
}
```

注意:length方法只能获取文件大小,不能获取文件夹大小

1.4 相对路径和绝对路径
绝对路径:以盘符开头的路径,一个完整的路径
例如:/Users/u/Desktop”,”12306Bypass/Logs/2019-01-03.txt

相对路径:以当前项目的根目录为起始的路径

```java

public class FileDemo03 {
  public static void main(String[] args) {
    File f1 = new File("/Users/u/Desktop/12306Bypass/Logs/2019-01-03.txt");
    File f2 = new File("2019-01-04.txt");

    String absolutePath = f2.getAbsolutePath();
    System.out.println(absolutePath);
  }
}
```
1.5 File类的判断方法
•public boolean exists();//判断该File对象代表的文件和文件夹是否存在
•public boolean isDirectory();//判断该File对象代表的是否是文件夹
•public boolean isFile();//判断该File对象代表的是否是文件

```java

public class FileDemo04 {
  public static void main(String[] args) {
    File file = new File("/Users/u/Desktop/12306Bypass/Logs/2019-01-03.txt");
    boolean b = file.exists();
    System.out.println(b);

    boolean directory = file.isDirectory();
    System.out.println(directory);

    boolean file1 = file.isFile();
    System.out.println(file1);
  }
```
}
1.6 File类的创建删除方法
public boolean mkdrir();//创建单级文件夹,返回值表示是否成功
public boolean mkdrirs();//创建多级文件夹,返回值表示是否成功

public boolean createNewFile();//创建文件,返回值表示是否成功

public boolean delete();//删除该File对象或文件夹,返回值表示是否成功

```java

public class FileDemo05 {
  public static void main(String[] args) throws IOException {
    File file = new File("2.txt");
    boolean newFile = file.createNewFile();
    System.out.println(newFile);
    boolean mkdir = file.mkdir();
    System.out.println(mkdir);

    File file2 = new File("a/b/c/2.txt");
    boolean mkdirs = file2.mkdirs();
    System.out.println(mkdirs);

    File file1 = new File("2.txt");
    boolean delete = file1.delete();
    System.out.println(delete);

    File file3 = new File("a/b/c/2.txt");
    boolean delete1 = file3.delete();
    System.out.println(delete1);
    File file4 = new File("a/b/c/2.txt");
    boolean delete2 = file4.delete();
    System.out.println(delete2);

  }
}
```


注意:
a.mkdir 和 mkdirs的区别
b.delete方法要么删文件,要么删文件夹,不能删除空文件夹

1.7 File类的遍历目录方法
public String[] list();//列出当前文件夹下所有直接的文件和文件夹的名字
public File[] listFiles();//列出当前文件夹下所有直接的文件和文件夹的File对象【重要】

```java

public class FileDemo06 {
  public static void main(String[] args) {
    File file = new File("a");
    String[] list = file.list();
    for (String filename : list
        ) {
      System.out.println(filename);
    }
    File[] files = file.listFiles();
    for (File filearr : files) {
      System.out.println(filearr);
    }
  }
}
```

注意:list和listFiles只能列出直接的子文件或子文件夹

二.递归
2.1 什么是递归
递归不是Java语言独有（基本上所有语言都可以递归）
递归就是:在方法中调用该方法本身

```java
public class Recurrence {
  public static void main(String[] args) {
    method();
  }
  public static void method() {
    System.out.println("method");
    //调用自己
    method();
  }
}
```

无限递归（死递归）出现这个错误 StackOverflowError 栈溢出错误

如果要使用递归,必须保证递归有出口（结束条件）

```java

public class Recurrence {
  public static void main(String[] args) {
    method1(10);
  }
  //有出口递归
  public static void method1(int n) {
    System.out.println("method1 "+n);
    //调用自己
    if(n == 0){
      return;//递归出口
    }
    method1(n-1);

  }
  //    public static void method() {
  //        System.out.println("method");
  //        //调用自己
  //        method();
  //    }
}
```


注意:就算递归有出口,也要保证递归在运行到出口之前次数也不能太多（太多也会爆栈）

使用递归三大步骤:
a.先定义一个方法
b.找规律调用自己
c.让递归有出口（结束条件）

2.2 递归求和案例
测试案例:求1-n的和
开发中不要用递归来求和,只用循环

```java

public class Recurrence02 {
  public static void main(String[] args) {
    int sum = getSum(10);
    System.out.println(sum);
    int Recurrence_getSum = Recurrence_getSum(100);
    System.out.println(Recurrence_getSum);
  }

  //使用递归
  public static int Recurrence_getSum(int n) {
    if (n == 1) {
      return 1;
    }
    return Recurrence_getSum(n - 1) + n;
  }

  //使用循环
  public static int getSum(int n) {
    int sum = 0;
    for (int i = 1; i <= n; i++) {
      sum += i;
    }
    return sum;
  }
}
```
2.3 递归求阶乘案例

```java

public class Recurrence03_getFactorial {
  public static void main(String[] args) {
    int sum = getFactorial(10);
    System.out.println(sum);
    int recurrenceGetSum = Recurrence_getFactorial(10);
    System.out.println(recurrenceGetSum);
  }

  //使用递归
  public static int Recurrence_getFactorial(int n) {
    if (n == 1) {
      return 1;
    }
    return Recurrence_getFactorial(n - 1) * n;
  }

  //使用循环
  public static int getFactorial(int n) {
    int Factorial = 1;
    for (int i = 1; i <= n; i++) {
      Factorial *= i;
    }
    return Factorial;
  }
}
```
2.4 文件搜索案例

```java

public class Recurrence04_File {
  public static void main(String[] args) {
    File fileDir = new File("/Users/u/Downloads/a/b");
    findTxtFile(fileDir);
  }

  public static void findTxtFile(File file) {
    File[] files = file.listFiles();

    for (File filearr : files) {
      if (filearr.getName().endsWith(".java") && filearr.isFile()) {
        System.out.println(filearr);
      }else if(filearr.isDirectory()){
        findTxtFile(filearr);
      }
    }
  }
}
```

三.IO流的概述
3.1 什么是IO流
I:Input输入流,数据从外部设备到程序中,”读流”
O:Outpur输出流,数据从程序写到外部设备,”写流”
流:一种抽象概念,数据传输的总称。数据在设备间的传输称为流，流的本质是数据传输

Java中流的流向都是以内存角度而言的

3.2 IO流的分类
a.根据流的方向分类
输入流:读数据(Input–>Read)
输出流:写数据(Output–>Write)

b.根据流中的数据类型分类
字节流:byte
字符流:char

以上两种分类可以综和为四大类
字节输入流,字节输出流,字符输入流,字符输出流

3.3 Java中的四大IO流(其他流都是这四个之一的子类)
字节输入流:InputStream(顶层父类,抽象类)
字节输出流:OutputStream(顶层父类,抽象类)

字符输入流:Reader(顶层父类,抽象类)
字符输出流:Writer(顶层父类,抽象类)

技巧：Java中所有的流，都会是以上四个流中某一个的子类，且具体的流的命名是非常有规范的:功能名+父类名
如:
FileWriter,向文件中写出字符为单位的数据
FileInputStream,从文件中读取以字节为单位的数据

四.字节流
4.1 万物皆对象和IO流一切皆字节
万物皆字节对象:现实生活中的任何东西，我们在Java中都可以使用一个对象表示
IO流中的一切皆字节：电脑所有的数据，最终都是由字节组成的(二进制)

4.2 字节输出流
顶层父类(抽象类)
共性方法:
public void close();//关闭该流，释放资源
public void flush();//刷新缓冲区(主要字符流使用)

public void write(int b);//一次写一个字节，输入是int，但是只能写一个byte的大小，即最大127
public void write(byte[] bs);//一次写一个字节数组
public void write(byte[] bs,int startIndex,int len);//一次写这一个字节数组中的一部分

4.4 FileOutputStream类的使用
文件的字节输出流(向文件中写字节数据)

•构造方法
public FileOutputStream(String path);//必须传入文件的路径
public FileOutputStream(File file);//必须传入文件的File对象

public FileOutputStream(String path);//必须传入文件的路径

```java

public class Demo08_FileOutputStream {
  public static void main(String[] args) throws FileNotFoundException {
    FileOutputStream fos = new FileOutputStream("1.txt");
    /*
    创建文件
    判断文件是否存在，如果存在，则清空该文件，若不存在，则创建文件
    让fos与1.txt绑定
    */
  }
}
```

•写字节数据的三个方法


```java
public class FileOutputStream_Demo02 {
  public static void main(String[] args) throws IOException {
    FileOutputStream fos = new FileOutputStream("1.txt");
    fos.write(97);
    fos.write(57);
    fos.write(55);

    byte[] bs1 ={100,101,102};
    fos.write(bs1);

    byte[] bytes = "HelloWorld".getBytes();
    fos.write(bytes);
    byte[] bs2 ={100,101,102};
    fos.write(bs2,1,1);//数组，下标，个数
  }
}
```

•如何追加续写
public FileOutputStream(String path,boolean append);//append表示是否追加
public FileOutputStream(File file,boolean append);//append表示是否追加




```java
public class FileOutputStream_Demo03 {
  public static void main(String[] args) throws IOException {
    FileOutputStream fos = new FileOutputStream("1.txt",true);
    fos.write(97);
  }
}
```

•如何换行

```java

public class FileOutputStream_Demo04 {
  public static void main(String[] args) throws IOException {
    FileOutputStream fos = new FileOutputStream("1.txt",true);
    for (int i = 0; i < 10; i++) {
      fos.write("java \n".getBytes());
    }
  }
}
```

•flush
public void flush();//对于字节输出流没用

•close
public void close();//关闭该流，释放资源
一个流使用完毕，及时释放流，别的程序就可以使用该资源

```java
public class FileOutputStream_Demo04 {
  public static void main(String[] args) throws IOException {
    FileOutputStream fos = new FileOutputStream("1.txt", true);
    for (int i = 0; i < 10; i++) {
      fos.write("java \n".getBytes());
    }

    fos.close();

    while (true) {
    }
    //程序不会停止，但是流已关闭，可以对文件进行增删改操作
  }
}
```

4.4 字节输入流InputStream
顶层父类(抽象类)
共性方法:
public void close();//关闭该流，释放资源
public int read();//一次读一个字节
public int read(byte[] bs);//一次读一个字节数组，返回值表示实际读取的字节个数
public int read(byte[] bs,int startIndex,int len);//一次读一个字节数组的一部分(基本不用)

4.5 FileInputStream的作用
文件的字节输入流(向文件中读字节数据)
•构造方法
public FileInputputStream(String path);//必须传入文件的路径
public FileInputStream(File file);//必须传入文件的File对象

public FileInputStream(String path);//必须传入文件的路径

```java
public class FileInputStream_Demo01 {
    public static void main(String[] args) throws Exception {
        FileInputStream fis = new FileInputStream("1.txt");
        /*
        创建文件对象
        判断文件是否存在，如果存在，无动作
        若不存在，则直接抛出异常FileNotFoundException
        让fis与1.txt绑定
        */
    }
}
```


•读取一个字节\

```java
public class FileInputStream_Demo02 {
  public static void main(String[] args) throws Exception {
    FileInputStream fis = new FileInputStream("1.txt");
    int read = fis.read();
    System.out.println(read);//97
    System.out.println((char)read);//a

    //一次读取一个字节的标准循环代码
    int b = 0;
    while ((b = fis.read()) != -1) {
      System.out.println(b);
      System.out.println((char)b);
      /*
    (b = fis.read()) != -1
    先读 fis.read()
    赋值 b=读取字节
    判断 b!=-1
     */

      //释放资源
      fis.close();
    }
  }
}
```

•读取一个字节数组

```java
public class FileInputStream_Demo03 {
  public static void main(String[] args) throws Exception {
    FileInputStream fis = new FileInputStream("1.txt");
    //读取字节数组
    byte[] bs = new byte[20];//实际开发中，一般写1024byte即1KB，或其整数倍

    //        int len = fis.read(bs);
    //
    //        System.out.println(len);
    //
    //        System.out.println(Arrays.toString(bs));
    //        System.out.println(new String(bs,0,len));
    int len =0;
    while ((len = fis.read(bs))!=-1){
      System.out.println(new String(bs,0,len));
    }
    /*
    (len = fis.read(bs))!=-1
    先读  fis.read(bs)
    赋值  len = 实际读取读个数
    判断  len !=-1
     */

    //释放资源
    fis.close();
  }
}
```

4.6 字节流练习复制图片
•复制文件的过程
FileInputStream->一次读一个数组，写一个数组->FileOutputStream

•代码实现

```java
public class Copy_File {
  public static void main(String[] args) throws Exception {
    FileInputStream fis = new FileInputStream("1.txt");
    FileOutputStream fos = new FileOutputStream("copy.txt");

    byte[] bs = new byte[1024];
    int len = 0;
    while ((len = fis.read(bs)) != -1) {
      //为了防止最后一次读取时，写入多余的数据
      fos.write(bs,0,len);
    }

    //原则:先开后关
    fos.close();
    fis.close();
  }
}
```

总结:
File创建方式:
public File(String path);
public File(String parent,String child);
public File(File parent,String child);

File常见方法:
public String getAbsolutePath();
public String getPath();
public String getName();
public long length();

public boolean exists();
public boolean isDirectory();
public boolean isFile();

public boolean mkdrir();
public boolean mkdrirs();
public boolean createNewFile();

public boolean delete();

public String[] list();
public File[] listFiles();

绝对路径和相对路径:
绝对路径:盘符开头
相对路径:当前目录的根目录

递归含义:
方法内部调用方法本身

递归为什么出现内存溢出:
方法不断入栈，栈满则溢出
IO流的分类和功能:
输入流,输出流,字节流(byte单位),字符流(char单位)

字节输出流FileOutputStream写出数据到文件:
public void write(int b);
public void write(byte[] bs);
public void write(byte[] bs,int startIndex,int len);

字节输入流FileInputStream读取文件数据:
public int read();
public int read(byte[] bs);

