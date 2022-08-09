---
title: Java学习基础-类和对象
date: 2020-02-26 00:12:04
tags:
---

一. Debug概述
Debug是程序员使用的程序调试工具，他可以用于查看程序的执行流程，也可以用来追踪程序执行过程来调试程序。
Debug操作流程：
Debug调试，又被称为断点调试，断点其实是一个标记，告诉我们从哪里开始查看。
执行流程：
①如何加断点
选择设置断点的代码行，在行号左边的区域单击鼠标左键即可
②如果运行加了断点的程序
在代码区域右键Debug执行
③看哪里
看debug和console窗口
④点哪里
点step info(F7)这个箭头，也可以直接按F7，执行完点stop结束
⑤如何删除断点
选择要删除的断点，单击鼠标左键即可

Debug的使用：
•查看循环求偶数和的执行流程。
•查看方法调用的执行流程

注意:如果数据来自于键盘，一定要记住输入数据，不然造成阻塞

二.类和对象
2.1 什么是对象：万物皆对象
2.2 什么是面向对象：关注具体的事物信息
2.3 什么是类：类是对现实生活中一类具有共同属性和行为的事物的抽象

类的特点：
•类是对象的数据类型
•类是具有相同属性和行为的一组对象集合

2.4 什么是对象的属性
属性：对象的各种特征，每个对象的每个属性都有特定的值
2.5 什么是对象的行为
行为：对象能够执行的操作
2.6 类和对象的关系
类：类是对现实生活中一类具有共同属性和行为的事物抽象
对象：是能够看得到摸得到的真实存在的实体

类是对象的抽象
对象是类的实体

2.7 类的定义
类的重要性：是Java程序的重要组成单位
类是什么：类是对现实生活中一类具有共同属性和行为的事物抽象，确定对象将会拥有的属性和行为

类的组成：属性 和 行为
•属性：在类中通过成员变量来体现（类中方法外的变量）
•行为：在类中通过成员方法来体现（和前面的方法相比去掉static关键字即可）

类的定义步骤:
①定义类
②编写类的成员变量
③编写类的成员方法



```java

public class 类名{
  //成员变量
  变量1的数据类型 变量1；
    变量2的数据类型 变量2；
    //成员方法
    方法1；
    方法2；
}
```

2.8 对象的使用
创建对象：
•格式： 类名 对象名 = new 类名()；
•范例： Phone p = new Phone();

使用对象：
a.使用成员变量
•格式：对象名.变量名
•范例：p.brand

b.使用成员方法
•格式：对象名.方法名()
•范例：p.call()

三.对象内存图
3.1 对象内存图（单个对象）
例子




```java
public class StudentTest01{
  public static void main(String[] args){
    Student s = new Student();
    System.out.println(s);
    System.out.println(s.name+","+s.age);
    s.name = "a";
    s.age = 1;
    System.out.println(s.name+","+s.age);

    s.study();
    s.doHomework();
  }
}
```

栈内存:
main
Student s 地址值（假设为）001
s.study();
方法:study,
调用者s(001)，执行完毕后就销毁
s.doHomework();
方法:doHomework,
调用者s(001)，执行完毕后就销毁

堆内存:
new Student 001
name “a”
age 1

3.2 对象内存图（多个对象）

```java
public class StudentTest01{
  public static void main(String[] args){
    Student s1 = new Student();
    System.out.println(s1);

    System.out.println(s1.name+","+s1.age);
    s1.name = "a";
    s1.age = 1;
    System.out.println(s1.name+","+s1.age);

    s1.study();
    s1.doHomework();

    Student s2 = new Student();
    System.out.println(s2);

    System.out.println(s2.name+","+s2.age);
    s2.name = "b";
    s2.age = 2;
    System.out.println(s2.name+","+s2.age);

    s2.study();
    s2.doHomework();
  }
}
```
栈内存:
main
Student s1 地址值（假设为）001
s1.study();
方法:study,
调用者s(001)，执行完毕后就销毁
s1.doHomework();
方法:doHomework,
调用者s(001)，执行完毕后就销毁

Student s2 地址值（假设为）002
s2.study();
方法:study,
调用者s(001)，执行完毕后就销毁
s2.doHomework();
方法:doHomework,
调用者s(001)，执行完毕后就销毁

============================
堆内存:
new Student 001
name “a”
age 1

new Student 002
name “b”
age 2

3.2 对象内存图（多个对象指向相同）

```java
public class StudentTest01{
  public static void main(String[] args){
    Student s1 = new Student();

    s1.name = "a";
    s1.age = 1;
    System.out.println(s1.name+","+s1.age);

    //将s1赋值给s2
    Student s2 = s1;
    System.out.println(s2);

    s2.name = "b";
    s2.age = 2;
    System.out.println(s1.name+","+s1.age);
    System.out.println(s2.name+","+s2.age);
  }
}
```
栈内存:
main
Student s1 地址值（假设为）001

Student s2 地址值（假设为）001

============================
堆内存:
new Student 001
name “a”
age 1

//s2
new Student 001
name “b”
age 2

输出：
a,1
b,2
b,2

结论：当两个对象指向相同（地址值相同时），其中一个对象修改了堆内存的内容，另一个对象访问时，内容也是改变过的

四.成员变量和局部变量
4.1 什么是成员变量和局部变量
成员变量：类中方法外的称为成员变量
局部变量：在方法中的变量

4.2 成员变量和局部变量的区别

区别	成员变量	局部变量
类中位置不同	类中方法外	方法内或方法声明上
内存中位置不同	堆内存	栈内存
声明周期不同	随着对象的存在而存在，随着对象的消失而消失	随着方法的调用而存在，随着方法的调用完毕而消失
初始化值不同	有默认的初始化值	没有默认的初始化值，必须先定义，才能使用
五.封装
5.1 private关键字
•是一个权限修饰符
•可以修饰成员（成员变量和成员方法）
•作用是保护成员不被别的类使用，被 private 修饰的成员只有在本类中才能访问

针对private修饰的成员变量，如果需要被其他类使用，提供相应的操作
•提供”get变量名()”方法，用于获取成员变量的值，方法用public修饰
•提供”set变量名(参数)”方法，用于设置成员变量的值，方法用public修饰

5.2 private关键字的使用
一个标准类的编写：
•把成员变量用private修饰
•提供对应的getXxx()/setXxx()方法

5.3 this关键字

①this修饰的变量用于指代成员变量

方法的形参如果与成员变量同名，不带this修饰的变量指的是形参，而不是成员变量
放到的形参没有与成员变量同名，不带this修饰的变量指的是成员变量
②什么时候使用this

解决局部变量隐藏成员变量
③this：代表所在类的对象引用

记住：方法被哪个对象引用，this就代表哪个对象
5.4 this内存原理

```java
public class StudentDemo(){
  Student s1 = new Student();
  s1.setName("a");

  Student s2 = new Student();
  s2.setName("b");
}
```
栈内存：
方法main
Student s1 假设内存地址001

方法：setName
参数：name：”a”
调用者：s1(001)
this: s1(001)
使用完毕销毁

Student s2 假设内存地址002
参数：name：”b”
调用者：s1(002)
this: s1(002)
使用完毕销毁

堆内存：
new Student 001
name a
age 1

new Student 002
name b
age 2

5.5 封装
a.封装概述
是面向对象的三大特征之一(封装，继承，多态)
是面向对象编程语言对客观实际的模拟，客观世界里成员变量都是隐藏在对象内部的，外部是无法操作的

b.封装原则
将类的某些信息隐藏在类内部，不允许外部程序直接访问，而是通过该类提供的方法来实现对隐藏信息的操作和访问
成员变量private,提供对应的getXxx()/setXxx()方法

c.封装的好处
通过方法来控制成员变量的操作，提高了代码的安全性
把代码用方法进行封装，提高了代码的复用性

六.构造方法
6.1 构造方法概述
构造方法是一种特殊的方法
作用：创建对象
格式：
public class 类名{
修饰符 类名(参数){

}
}
功能：主要是完成对象数据的初始化

6.2 构造方法的注意事项
①构造方法的创建

如果没有定义构造方法，系统将给出一个 默认的 无参数构造方法
如果定义了构造方法，系统将不再提供默认的构造方法
②构造方法的重载

如果自定义来带参构造方法，还要使用无参构造方法，将必须再写一个无参数构造方法
③推荐的使用方式

无论是否使用，都手工书写无参数构造方法
6.3 标准类的制作
①成员变量

使用private修饰
②构造方法
提供一个无参构造方法
提供一个带多个参数的构造方法
③成员方法
提供每一个成员变量对应的setXxx()/getXxx()
提供一个显示对象信息的show()
④创建对象并为其成员变量赋值的两种方式
无参构造方法创建后使用setXxx()赋值
使用带参构造方法直接创建带有属性值的对象