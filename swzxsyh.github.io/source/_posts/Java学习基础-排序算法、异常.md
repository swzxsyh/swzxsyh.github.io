---
title: Java学习基础-排序算法、异常
date: 2020-03-14 00:42:13
tags:
---

一.选择排序
1.1 选择排序概述
核心思想：选中第一个元素，取出以后的元素依次和选中的元素进行比较，大的往后走，小的往前走，接着选中第二个元素同样操作，依此类推

1.2 选择排序图解

1.3 选择排序代码实现

```java
public static void main(String[] args) {
  int[] arr = {5, 4, 7, 1, 8, 2, 3, 6, 9};
  //外层循环，控制选中的元素
  for (int i = 0; i < arr.length - 1; i++) {
    //内存循环，控制元素的比较
    for (int j = i + 1; j < arr.length; j++) {
      //比较arr[i] arr[j]
      if (arr[i] > arr[j]) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
      }
    }
  }
  System.out.println(Arrays.toString(arr));
}
```


二.二分查找
2.1 普通查找和二分查找
普通查找：给定数组，从数组中找到某个元素的索引
int[] arr = {4,5,6,1,7,2,8,9};
找出7出现的索引，只能从前往后找。
二分查找：给定的数组，必须是有自然顺序的，从数组中找某个元素出现的索引
int[] arr = {1,3,5,6,8,9,10,12};
找出8出现的索引，我们依然可以从前到后遍历，但是效率低。从中间开始，根据中间值的大小，可以让查找范围缩小一般

2.2 二分查找图解

a.首先定义两个遍历
int left = 0;
int right = arr.length-1

循环{
b.获取中间索引
int middle = (left+right/2)
c.获取middle索引元素和目标值比较
if (arr[middle] > key) {
right = middle = 1;
} else if (arr[middle] < key) {
left = middle + 1;
} else {
return middle;
}
}

2.3 二分查找代码实现

```java

public static void main(String[] args) {
  int[] arr = {10, 20, 30, 40, 50, 60, 70, 88, 90};
  //查找元素
  int key = 20;
  //调用方法
  int index = Binary_Search(arr, key);
  System.out.println(index);

  int key_1 = 200;
  int index_1 = Binary_Search(arr, key_1);
  System.out.println(index_1);
}

//二分查找
public static int Binary_Search(int[] arr, int key) {
  //开始和结束索引
  int min = 0;
  int max = arr.length - 1;
  while (min <= max) {
    //获取中间索引
    int middle = (min + max) / 2;
    //比较中间索引的元素和key
    if (arr[middle] > key) {
      max = middle - 1;
    } else if (arr[middle] < key) {
      min = middle + 1;
    } else {
      return middle;
    }
  }
  return -1;
}
```


三.异常
3.1 什么是异常
异常：写程序或者运行程序过程中遇到的非正常返回

3.2 异常的继承关系
所有异常和错误的根类：Throwable
|-Error 错误类
|-Exception 异常类
|–RuntimeException
|–非RuntimeException

Error:严重问题，不需要处理
Exception:称为异常类，它表示程序本身可以处理的问题
•RuntimeException:在编译期不检查，出问题后，需要修改代码解决
•非RuntimeException:编译期将必须处理，否则程序不能通过编译，更不能正常运行

3.3 异常中常用的三个方法-Throwable的成员方法

方法名	说明
public void printStackTrace();	以深红色在控制台打印异常的详细信息（包括异常类型，异常的原因，异常的位置）【最常用】
public String getMessage();	返回此throwable的详细消息字符串
public String toString();	获取异常的类型和异常的描述信息
打印方法如下：

```java
public static void main(String[] args) {
  try{}
  int[] arr ={1,2,3};
  System.out.println(arr[3]);
}catch(ArrayIndexOutOfBoundsException e){
  System.out.println(e.getMessage());
  System.out.println(e.toString());
  e.printStackTrace();
  //        Exception in thread "main" java.lang.ArrayIndexOutOfBoundsException: 3
  //        at com.test.Demo03_Exception01.TestException.main(TestException.java:6)
}
}
```


3.4 异常的分类
•编译时的异常
写好代码之后，运行代码之前出现的异常
编译时异常：Exception以及Exception的子类(RuntimeException除外)

•运行时的异常
运行代码时出现的异常
运行时异常：RuntimeException以及其子类

编译时异常和运行时异常的区别：
Java中的异常被分为两大类：编译时异常和运行时异常，也被称为受检异常和非受检异常
所有的RuntimeException类及其子类被称为运行时异常，其他的异常都是编译时异常

3.5 JVM异常产生过程 - 默认处理方案
如果程序出现问题，且未做任何处理，最终JVM会做出默认的处理

把异常名称，异常原因以及异常出现的位置等信息输出在控制台
程序停止执行
四.异常处理
Java中异常相关的五个关键字
throw
throws
try…cache
finally

4.1 抛出异常throw
a.throw是什么：throw是一个关键字
b.什么时候使用到throw：想要向上抛出异常时，使用throw关键字
c.使用格式：throw 异常对象
d.案例演示



```java

public static void main(String[] args) {
  int[] arr = {1, 2, 3, 4, 5, 6};
  int element = getElement(arr);
  System.out.println(element + "\n");
  int[] new_arr = {1, 2, 3};
  int new_element = getElement(new_arr);
  System.out.println(new_element);
  /*
Exception in thread "main" java.lang.ArrayIndexOutOfBoundsException: Out of Array
    at com.test.Demo03_Exception01.TestException02.getElement(TestException02.java:18)
    at com.test.Demo03_Exception01.TestException02.main(TestException02.java:10)
*/
}

public static int getElement(int[] arr) {
  //自己判断数组是否有3索引
  if (arr.length < 4) {
    throw new ArrayIndexOutOfBoundsException("Out of Array");
  }
  //获取数组中索引为3的元素
  int number = arr[3];
  return number;
}
```

4.2 Objects中非空判断方法
public static T requireNonNull(T obj);方法内部帮助我们判断是否为null

查看源码：

```java
public static <T> T requireNonNull(T obj) {
  if (obj == null)
    throw new NullPointerException;
  return obj;
}
```


4.3 遇到异常的两种处理方式
如果遇到编译时异常，可以使用以下两种方式处理
如果我们遇到运行时异常，编译时期不用处理，运行后根据异常信息修改代码即可

4.4.1 throws声明抛出异常
a.声明异常的格式
throws关键字是给方法使用的，为该方法做出声明，声明该方法内部有编译时异常，调用者需要使用该异常格式：

public void 方法名(参数列表)throws XxxException{
代码（如果代码有异常）
}

b.案例演示

```java
public static void main(String[] args) throws FileNotFoundException{
  ReadFiles("1.txt");

}

//throws关键字是给方法用的，为该方法做出声明，声明该方法内部有编译时异常，调用者需要处理该异常
public static void ReadFiles(String name) throws FileNotFoundException {
  //假设硬盘上有一个1.txt文件
  if (("1.txt").equals(name)) {
    System.out.println("Successful");
  } else {
    //抛出异常
    throw new FileNotFoundException("No File:" + name);
  }
}
```


4.4.2 try-cache捕获异常
a.捕获异常的格式
格式：
try {
可能出现异常的代码
} catch (XxxException e) {
//处理异常
e.printStackTrace();//直接打印（开发阶段）
save(e);//将异常保存到异常日志
}

执行流程：
程序从try里面的代码开始执行
出现异常，会自动生成一个异常类对象，该异常对象被提交给Java Runtime系统
当Java Runtime系统接收到异常对象时，会到catch中去找匹配的异常类，找到后进行异常的处理
执行完毕后，程序还可以继续往下执行

b.案例演示

```java

try {
  ReadFiles("1.txt");
}catch (Exception e){
  System.out.println("Has Exception");
  e.printStackTrace();
}
System.out.println();

try {
  ReadFiles("2.txt");
}catch (Exception e){
  System.out.println("Has Exception");
  e.printStackTrace();
}
System.out.println("Continue");
}
//throws关键字是给方法用的，为该方法做出声明，声明该方法内部有编译时异常，调用者需要处理该异常
public static void ReadFiles(String name) throws FileNotFoundException {
  //假设硬盘上有一个1.txt文件
  if (("1.txt").equals(name)) {
    System.out.println("Successful");
  } else {
    //抛出异常
    throw new FileNotFoundException("No File:" + name);
  }
}
```
c.捕获到异常之后，如何查看异常的信息
I.直接带你出来，调用e.printStackTrace();//一般开发阶段
II.可以先保存起来，比如保存到异常日志。e.save();//用户使用阶段

4.5 finally代码块
a.finally代码块的格式
finally一般不能单独使用，配合try…catch使用
try {
可能出现异常的代码
} catch (XxxException e) {
//处理异常
e.printStackTrace();//直接打印（开发阶段）
save(e);//将异常保存到异常日志
}finally{
写在finally中的代码，不论是否有异常，都会执行
}
b.finally代码块的作用
写在finally中的代码，不论是否有异常，都会执行
一般用于写释放资源，关闭连接等代码

c.案例演示

```java
try {
  ReadFiles("2.txt");
}catch (Exception e){
  System.out.println("Has Exception");
  e.printStackTrace();
}finally {
  xxx.close();
}
```


7.异常的注意事项
•运行时异常被抛出可以不处理，不需要throws声明，也不需要try…catch捕获
•如果父类的方法抛出了多个异常，子类覆盖（重写）父类方法时，只能抛出相同的异常或者它的子集（即少于父类方法）
•父类方法没有抛出异常，子类在重写该方法时，必须也不能抛出异常
•当多异常分别处理时，捕获处理，前面的类不能是后面类的父类
I.每个异常单独try…catch(一般不使用)
try{
method1();
}catch(1 e1){
}
try{
method2();
}catch(2 e2){

}
II.所有异常一起try，但是分开catch(偶尔使用)
try{
method1();
method2();
}catch(1 e1){

}catch(2 e2){

}
注意事项：要求前面的异常必须是子类异常，后面的异常必须是父类异常

III.所有异常一起try，一个catch【经常使用】
try{
method1();
method2();
method3();
}catch(Exception e1){

}

•在try/catch后可以追加finally代码块，其中的代码一定会被执行，通常用于资源回收。

五.自定义异常
5.1 为什么要定义异常
a.什么叫做自定义异常：自定义一个异常类，然后在适当时创建异常对象，并抛出
b.为什么要自定义异常：JDK提供的异常类不可能描述开发中所有问题

5.2 自定义异常的步骤
a.形似：创建一个类，类名必须叫XxxException
b.神似：继承Exception或RuntimeException
c.一般来说需要提供两个构造，无参构造+带有String参数的构造

```java
public class MyException extends RuntimeException {
  //无参构造
  public MyException() {}

  //带有异常信息的构造
  public MyException(String message) {
    //保存message参数
    super(message);
  }
}
```
5.3 自定义异常的练习
模拟操作，若用户名已存在，则抛出异常
a.JDK不带该异常，所以要自动抛出
b.

```java

public class TestDemo {
  public static void main(String[] args) {
    String name = new Scanner(System.in).nextLine();
    try {
      register(name);
    } catch (RegisterException e) {
      e.printStackTrace();
    }
  }
  public static void register(String name) throws RegisterException {
    ArrayList<String> usernames = new ArrayList<>();
    Collections.addAll(usernames, "a", "b", "c");

    if (usernames.contains(name)) {
      throw new RegisterException("UserName Repeat");
    } else {
      System.out.println("Regeist Successful");
    }
  }
}
```


总结：
a.选择排序的执行过程
for (int i = 0; i < arr.length - 1; i++) {
for (int j = i + 1; j < arr.length; j++) {
if (arr[i] > arr[j]) {
int temp = arr[i];
arr[i] = arr[j];
arr[j] = temp;
}
}
}
b.二分查找
public static int Binary_Search(int[] arr, int key) {
int min = 0;
int max = arr.length - 1;
while (min <= max) {
int middle = (min + max) / 2;
if (arr[middle] > key) {
max = middle - 1;
} else if (arr[middle] < key) {
min = middle + 1;
} else {
return middle;
}
}
return -1;
}
c.能分辨程序中的异常和错误的区别
所有异常和错误的根类：Throwable
|-Error 错误类 一般是硬件引起，程序员一般无法处理
|-Exception 异常类，异常一般是由程序编写不当造成的，程序员有能力处理
|–编译时异常 Exception以及其子类（RuntimeException除外）
|–运行时异常 RuntimeException以及其子类
d.三个常见的运行时异常
ArrayIndexOutOfBoundsException
NullPointerException
ClassPathException向下转型时出现的类型转换异常
e.使用try…catch关键字处理异常
try{

}catch()XxxException e{
e.printStackTrace();
}
f.使用throws关键字处理异常
throws给方法用的，表名抛出异常，该调用的调用者要处理异常
public void 方法名(参数列表) throws Exception(){}
g.自定义异常