---
title: Java学习基础-字符串
date: 2020-02-26 00:14:38
tags:
---

一.API
1.1 API (Application Programming Interface) 概述：应用程序编程接口

Java API：指的就是JDK中提供的各种功能的Java类
这些类将底层的实现封装了起来，可以通过帮助文档来学习这些API如何使用

1.2 如何使用帮助文档：
①打开使用版本的JDK文档
②索引框输入要查询的类
③查看类在哪个包下
④看类的描述
⑤看构造方法
⑥看成员方法

注意：调用方法时，如果方法有明确的返回值，可以用变量接收

二. String
2.1 String 概述：
String类在java.lang 包下，使用时不需要导入包。

String类代表字符串，Java程序中所有的字符串文字(例如”abc”)都被实现为此类的实例
也就是说，Java程序中所有的双引号字符串，都是String类的对象

字符串的特点:

字符串不可变，它们的值在创建后不能被更改
虽然String值不可变，但是它们可以被共享
字符串效果上相当于字符数组(char[] ,JDK8及之前是字符数组，JDK9之后是字节数组),但是底层原理是字节数组(byte[] )
2.2 String的常用构造方法：

方法名	说明
public String()	创建一个空白字符串对象，不含任何内容
public String(char[] chs)	根据字符组的内容，来创建字符串对象
public String(byte[] bys)	根据字节组的内容，来创建字符串对象
String s = “abc”	直接赋值的方式创建字符串对象，内容就是abc

```java
public class AIO_ServerSocketChannel {
  public static void main(String[] args){
    String s1 = new String();
    System.out.println(s1);//无内容，因为未赋值

    char[] chs = {'a','b','c'};
    String s2 = new String(chs);
    System.out.println(s2);//abc

    byte[] bys = {97,98,99};
    String s3 = new String(bys);
    System.out.println(s3);//abc,因为使用的是ASCII码

    String s4 = "abc"
      System.out.println(s4);//abc
  }
}
```
推荐直接使用赋值方式得到字符串对象

2.3 String对象的特点
1)通过new创建的字符串对象，每一次new都会申请一个内存空间，虽然内容相同，但是地址值不同

char[] chs ={‘a’,’b’,’c’};
String s1 = new String(chs);
String s2 = new String(chs);
在上述代码中，JVM会熟悉创建一个字符数组，然后每次new的时候都会有一个新的地址，只不过s1和s2参考的字符串内容都是相同的

2)以 “” 方式给出的字符串，只要字符序列相同(顺序和大小写)，无论在程序代码中出现几次，JVM都只会建立一个String对象，并在字符串池中维护

String s3 = “abc”;
String s4 = “abc”;
在上述代码中，针对第一行代码，JVM会建立一个String对象放在字符串池中，并给s3参考；
第二行让s4直接参考字符串池中的String对象，也就是说它们本质上还是同一个对象

内存过程：

```java
public static void main(String[] args){
  char[] chs ={'a','b','c'};
  String s1 = new String(chs);
  String s2 = new String(chs);
  System.out.println(s1 == s2);//false

  String s3 = "abc";
  String s4 = "abc";
  System.out.println(s3 == s4);//true
  System.out.println(s1 == s3);//false
}
```
栈内存：
方法main
char[] chs 假设地址001
String s1 假设地址002
String s2 假设地址003
String s3 假设地址004
String s4 假设地址004

堆内存：
new char[3]
001
0 ‘a’
1 ‘b’
2 ‘c’

new String()
002
ref 001

new String()
003
ref 001

常量池
004 abc 赋值给s3与s4

2.4 字符串的比较
使用 == 做比较

基本类型：比较的是数据值是否相同
引用类型：比较的是地址值是否相同
字符串是对象，它比较内容是否相同，是通过一个方法来实现的，这个方法叫:equals()

public boolean equals(Object anObject);将此字符串与指定对象进行比较。由于比较的是字符串对象，所以参数直接传递一个字符串
遍历字符串，首先要能够获取到字符串中的每一个字符

public char charAt(int index);返回指定索引处的char值，字符串的索引也是从0开始的
遍历字符串，获取字符串的长度
public int length();返回此字符串的长度
数组的长度：数组名.length
字符串的长度：字符串对象.length()
遍历字符串通用格式：
1
2
3
for(int i=0;i<s.length();i++ ){
    s.charAt(i);//就是指定索引处的字符值
}
•大写字母：ch>=’A’ && ch <= ‘Z’
•小写字母：ch>=’a’ && ch <= ‘z’
•数字：ch>=’0’ && ch <= ‘9’

2.5 通过帮助文档查看String中的方法

方法名	说明
public boolean equals(Object anObject)	比较字符串的内容，严格区分大小写(用户名&密码)
public char charAt(int Index)	返回索引处的char值
public int length()	返回此字符串的长度
三. StringBuilder
3.1 概述
StringBuilder是一个可变的字符串类，可以把它当作一个容器。
这里的可变指的是StringBuilder对象中的内容是可变的

String和StringBuilder的区别：

String：内容是不可变的
StringBuilder：内容是可变的
如果对字符串String进行拼接操作，每次拼接都会构建一个新的String对象，耗费时间与内存空间。
因此使用StringBuilder可类可以解决这个问题。

3.2 StringBuilder的构造方法

方法名	说明
public StringBuilder()	创建一个空白可变字符串对象，不含任何内容
public StringBuilder(String str)	根据字符串内容，创建可变字符串对象
public StringBuilder(int Capacity)	构造一个没有字符的字符串构建器，以及由capcacity参数指定的初始容量
public StringBuilder(CharSequence seq)	构造一个字符串构建器，其中包含与指定的CharSequence相同的字符
3.3 StringBuilder的添加和反转方法

方法名	说明
public StringBuilder append(任意类型)	添加数据，并返回数据本身
public StringBuilder reserve()	返回相反的字符序列
```java
public class SBDemo01{
  public static void main(String[] args){
    StringBuilder sb = new StringBuilder();

    sb.append("a").append("b");//链式编程
    System.out.println(sb);//ab

    sb.reserve();
    System.out.println(sb);//ba
  }
}
```
3.4 StringBuilder 和 String 相互转换
a.从StringBuilder转换为String
public String toString();通过toString()就可以实现把StringBuilder转换为String

b.从String转换为StringBuilder
public StringBuilder(String s);通过构造方法就可以把String转换为StringBuilder

```java
public class SBDemo01{
  public static void main(String[] args){
    StringBuilder sb = new StringBuilder();

    sb.append("abc");
    String s = sb.toString(s);

    String t = "hello";
    StringBuilder new_sb = new StringBuilder(s);
  }
}
```
3.5 通过帮助文档查看 StringBuilder 中的方法

方法名	说明
public StringBuilder append(任意类型)	添加数据，并返回数据本身
public StringBuilder reserve()	返回相反的字符序列
public String toString()	通过toString()就可以实现把StringBuilder转换为String
