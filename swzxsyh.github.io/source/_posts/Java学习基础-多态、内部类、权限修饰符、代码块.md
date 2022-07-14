---
title: Java学习基础-多态、内部类、权限修饰符、代码块
date: 2020-03-04 00:25:11
tags:
---


一. 多态
面向对象三大特征：封装，继承，多态
1.1 多态定义：
a.严格的定义：同一个动作，具有不同的表现形式
b.不严格定义：同一个对象，具有不同的形态

1.2 多态的前提
a.必须有继承关系，或者实现关系
b.必须有方法的重写
c.有父类引用指向子类对象
只有满足以上三个前提，才有多态

1.3 多态的体现
语言表达：父类类型的变量 指向了子类类型的变量（地址）
代码表达：

1
Parent P = new Sub();
范例：
1
Animal A = new Dog();(假设Dog已经继承了Animal，并重写了某个方法)
1.4 多态调用方法的特点
a.多态调用方法时，编译阶段看父类
b.多态调用方法时，运行阶段看子类
总结：多态调用方法的特点是编译看父，运行看子

多态成员访问特点:
•成员变量:编译看父，执行看父
•成员方法:编译看父，执行看子

为什么成员变量和成员方法访问不一样
•因为成员方法有重写，成员变量没有

1.5 多态的好处

```java
public class TestDemo02 {
  public static void main(String[] args) {
    Dog dogname = new Dog();
    Feed_Animal(dogname);
    Cat catname = new Cat();
    Feed_Animal(catname);
  }

  public static void Feed_Animal(Animal an){
    System.out.println("Come to Eat");
    an.eat();

  }
}
```

总结：多态提供了代码的扩展性/灵活性
具体体现：定义方法时，使用父类类型作为参数，将来在使用时，使用具体的子类型参与操作

1.6 多态的弊端
多态调用特点：编译看父，运行看子
弊端：使用多态时，只能调用子父类都有的方法，不能调用子类独有的方法

1.7 多态弊端的解决方法-向下转型

```java
//向上转型(把子类类型转换成父类类型)：
Animal an = new Dog();
dd.eat();
Dog dd = new Animal();

//向下转型（把父类类型转回子类类型）：
Dog dog = (Dog) dd;
dog.sleep(;)
```


1.8 转型可能出现的异常
ClassCastException 类型转换异常
当多态一个子类是A，向下转型是另一个子类B时，会出现转换异常。

1.9 instanceof 关键字介绍
可以判断一个对象，是否是我们指定类的对象

boolean b = 对象名 instanceof 

```java
public static void main(String[] args) {
  Animal an = new Cat();
  an.eat();

  if(an instanceof Dog){
    Dog dd = (Dog)an;
    dd.Housekeeping();
  }
  if(an instanceof Cat){
    Cat cc = (Cat)an;
    cc.catchMouse();
  }
```
二. 内部类
2.1 什么是内部类
所谓的内部类就是在一个类A内部定义一个另外一个类B，此时类B内部类，类A外部类

按照内部类在类中定义的位置不同，可以分为如下两种形式
•在类的成员位置：成员内部类
•在类的局部位置：局部内部类

创建格式：
外部类名.内部类名 对象名 = 外部类对象.内部类对象；
范例：Outer.Inner oi = new Outer().new Inner();




```java
public class Human {
  int age;
  String name;
  //    内部类
  //    成员内部类
  class Heart{
    int JumpCount;
    public void Jump(){
      System.out.println("Heart Jump");
    }
  }
  //    局部内部类
  public void Show(){
    class xxx{    }
  }
}
```


成员内部类有两个特点：
a.在成员内部类中可以无条件访问外部类的任何成员(包括私有)
b.外部类要访问内部类的成员，必须创建对象

在测试类中创建成员内部类对象写法：

```java
public static void main(String[] args) {
  //创建外部类对象
  Human H1 = new Human();
  //Java 规定想要创建内部类的对象，必须先创建外部类的对象，然后通过外部类对象才能创建内部类对象
  Human.Heart HH1 = new Human().new Heart();
  //也可以这么写
  Human.Heart HH2 = H1.new Heart();
}

public class Outer{
  private int num = 10;
  private class Inner{
    public void show(){
      System.out.println(num)
    }
  }
  public void method(){
    Inner i = new Inner();
    i.show();
  }
}

public class OuterDemo{
  public static void main(String[] args) {
    Outer o = new Outer();
    o.method();
  }
}
```

局部内部类：
局部内部类是在方法中定义的类，所有外交无法直接使用，需要在方法内部创建对象并使用
该类可以直接访问外部类的成员，也可以访问方法内的局部变量




```java
public class Outer{
  private int num = 10;}
public void method(){
  int num2 = 20;
  class Inner{
    public void show(){
      System.out.println(num)
        System.out.println(num2)
    }
  }
  Inner i = new Inner();
  i.show();
}

public class OuterDemo{
    public static void main(String[] args) {
        Outer o = new Outer();
        o.method();
    }
}
```

2.3 内部类编译之后的字节码文件
内部类编译之后的字节码文件名：
外部类名$内部类名
范例：
Human$Heart.class

2.4 匿名内部类
•什么是匿名内部类
概念：局部内部类的简化形式，简化到不需要内部类的名字

•前提：存在一个类或接口，这里的类可以是具体类也可以是抽象类

•匿名内部类的作用
匿名内部类可以帮助我们快速的创建一个父类的子类对象或者一个接口的实现类对象

•本质：是一个继承了该类或者实现类该类接口的子类匿名对象

•格式：
new 类名或接口名(){
重写方法；
};

范例：

```java
new Inter(){
  public void show(){}
}
```

•匿名内部类的使用特点1



```java

public class TestDemo06 {
  public static void main(String[] args) {
    //使用匿名内部类
    Animal dd = new Animal(){
      @Override
      public void eat() {
        System.out.println("Dog eat");
      }

      @Override
      public void sleep() {
        System.out.println("Cat eat");
      }
    };

    dd.eat();
    dd.sleep();

    Animal pp = new Animal() {
      @Override
      public void eat() {
        System.out.println("Pig eat");
      }

      @Override
      public void sleep() {
        System.out.println("Pig sleep");
      }
    };
    pp.eat();
    pp.sleep();      
  }
}
```



•匿名内部类的使用特点2

```java
//定义接口
public interface Flyable {
  public abstract void fly();
}


//创建实现类
public class Bird implements Flyable{
  @Override
  public void fly() {
    System.out.println("Bird Fly");
  }
}

public class TestDemo {
  public static void main(String[] args) {
    Bird bd = new Bird();
    bd.fly();
    //Anonymous

    //        new Flyable(){
    //            @Override
    //            public void fly() {
    //                System.out.println("bird fly");
    //            }
    //        };
    Flyable fae = new Flyable(){
      @Override
      public void fly() {
        System.out.println("bird fly");
      }
    };
    fae.fly();
    //调用方法
    /*
        method(new Bird());
  method(new Flyable() {
        @Override
        public void fly() {
            System.out.println("Fly Fly");
        }
    });*/
  }

  public static void method(Flyable ff) {
    ff.fly();
  }
}
```


总结匿名内部类的格式：

```java
父类名/接口名 对象名 = new 父类名/接口名(){
    //重写父类或接口中所有的抽象方法
};
```


三. 权限修饰符
Java中一共有4中常见的权限修饰符

1

```java
public class Student {
    public int size;
    protected int grade;
    int age;
    private int height;
}
```


public	protected	（空的）	private
同一类中	√	√	√	√
同一类中（子类与无关类）	√	√	√	X
不同包的子类	√	√	X	X
不同包中的无关类	√	X	X	X
一般来说：
···成员方法和构造方法是public修饰符的
···成员变量是private修饰的
在极个别的情况下，构造方法也可能是private(单例设计模式)

四.代码块
什么叫做代码块：由一对大括号扩起来的一句或多句代码，就是一个代码块

4.1 构造代码块
格式：




```java
public class 类名{
  //代码
  {

  }
}
```


构造代码块什么时候执行
每次调用构造方法创建对象之前执行

```java
public class Dog {
  int age;
  String name;
  public void bark(){
    System.out.println("Doge");
  }
  //构造方法
  public Dog(){
    System.out.println("Mtehod");
  }

  //构造代码块
  {
    System.out.println("This is Code Block");
  }
}


public class TestDemo09 {
  public static void main(String[] args) {
    //Create Dog Object
    Dog dd = new Dog();
    dd.bark();
  }
}
```
//输出
This is Code Block
Mtehod
Doge
4.2 静态代码块
格式：

```java
public class 类名{
  static{
    //静态代码块
  }
}
```

随着类到加载而执行，且只执行一次，优先于构造方法执行

Demo：





```java
public class Pig {
  int age;
  String name;
  public void sleep(){
    System.out.println("Pig sleep");
  }
  public Pig(){
    System.out.println("Pig Pig");
  }
  static {
    System.out.println("This is Static Code Block");
  }
}

public class TestDemo10 {
  public static void main(String[] args) {
    Pig pgg = new Pig();
    pgg.sleep();
    //只要使用Pig类，就会加载到内存，即时立即执行静态代码块
    Pig pgg2 = new Pig();
  }
}
```
输出：
This is Static Code Block
Pig Pig
Pig sleep
Pig Pig


总结：
多态的前提：
a.必须有extend或impelement
b.必须有方法的重写

多态的格式：
父类类型 对象名 = new 子类类型();
接口类型 对象名 = new 实现类类型();

多态调用方法时的特点：编译看父，运行看子
好处：提高代码的扩展性
弊端：多态只能调用子父类共有的方法，无法调用子类特有的方法

向上转型：把子类类型 赋值给 父类类型


Animal an = new Dog();
向下转型：必须有向上转型，才能向下转型


Dog dd = (Dog)an;
关键字:instanceof


if(an instanceof Dog){
    Dog dd = (Dog)an;
}
内部类概念：在一个类的内部定义另一个类

匿名内部类：


父类/接口 = new 父类/接口(){
    //重写父类或接口中的所有抽象方法
};
修饰符的作用：
public
protected
空的
private

代码块：
构造代码块：
格式：
类中方法外一个大括号


{

}
每次执行

静态代码块：
类中方法外一个static大括号


static{

}
仅执行一次