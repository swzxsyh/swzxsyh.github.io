---
title: Java 设计模式 初识
date: 2020-03-31 00:56:44
tags:
---

一.单例设计模式
1.1 单例设计模式介绍
a.在正常情况下，一个类可以创建多个对象
b.单例设计模式的作用介绍让某个类只能有一个对象

1.2 单例设计模式实现步骤
a.构造方法私有化(不让别人直接new对象)
b.在该类内部产生一个唯一的实例化对象,并且使用private static修饰(让别人无法直接访问)
c.提供一个public static的静态方法,该方法返回此静态对象(只能通过调用该方法调用对象)

1.3 单例设计模式的类型

懒汉式:
不立即创建本类的对象,当别人调用静态方法获取本类对象时，才创建

饿汉式:
先创建对象，当别人调用静态方法时，直接返回对象即可

1.4 饿汉单例设计模式

```java
//单例模式中的饿汉式
public class Dog {
  //1.私有化构造
  private Dog() {
  }
  //2.自定义一个对象
  private static final Dog dd = new Dog();

  //3提供一个静态方法，获取dd对象
  public static Dog getInstance() {
    return dd;
  }
}

public class SingleInstanceDemo {
  public static void main(String[] args) {
    //获取Dog对象
    for (int i = 0; i < 5; i++) {
      Dog dog = Dog.getInstance();
      System.out.println(dog);
    }
  }
}
```

输出：
com.test.Demo01_SingleInstance.Dog@61bbe9ba
com.test.Demo01_SingleInstance.Dog@61bbe9ba
com.test.Demo01_SingleInstance.Dog@61bbe9ba
com.test.Demo01_SingleInstance.Dog@61bbe9ba
com.test.Demo01_SingleInstance.Dog@61bbe9ba

1.5 懒汉单例设计模式

```java
//单例模式中的懒汉式
public class Cat {
  //1.私有化构造
  private Cat(){
  }
  //2.自定义一个对象
  private static Cat cc=null;

  //3提供一个静态方法，多线程
  //多线程情况下需要使用synchronized保证该方法的原子性
  //如果不加，可能会出现如下:
  //线程1进来，被线程2抢走
  //线程2进来，不能保证原子性
  public synchronized  static Cat getInstance(){
    if(cc == null){
      cc=new Cat();
    }
    return cc;
  }}

public class TestCat {
  public static void main(String[] args) {
    for (int i = 0; i < 5; i++) {
      Cat cc = Cat.getInstance();
      System.out.println(cc);
    }
  }
}
```
输出：
com.test.Demo02_Single_Instance_Sloth.Cat@61bbe9ba
com.test.Demo02_Single_Instance_Sloth.Cat@61bbe9ba
com.test.Demo02_Single_Instance_Sloth.Cat@61bbe9ba
com.test.Demo02_Single_Instance_Sloth.Cat@61bbe9ba
com.test.Demo02_Single_Instance_Sloth.Cat@61bbe9ba
二. 多例设计模式
2.1 多例设计模式多介绍
多例设计模式保证我们的类具有指定个数的对象

2.2 多例设计模式多实现步骤
a.私有化构造(不让别人直接new对象)
b.在该类内部产生一个private static修饰的集合(让别人无法直接访问)，用于保存自己创建的对象
c.使用静态代码块向集合中添加指定个数的对象
d.提供一个public static的静态方法,该方法返回此静态对象(只能通过调用该方法调用对象)

2.3 多例设计模式多代码实现

```java
//要求pig类使用多例设计模式
public class Pig {
  //1.定义一个变量，指定集合中对象的个数,常量建议大写
  private static final int COUNT = 4;
  //2.私有化构造
  private Pig(){
  }

  //3.创建一个集合
  private static ArrayList<Pig> list = new ArrayList<Pig>();

  //4.使用静态代码块
  static {
    //添加指定个数的对象
    for (int i = 0; i < COUNT; i++) {
      list.add(new Pig());
    }
  }

  //5.提供一个静态方法
  public static Pig getInstance(){
    return list.get(new Random().nextInt(COUNT));
  }
}

public class TestPig {
  public static void main(String[] args) {
    //1.获取Pig对象
    for (int i = 0; i < 10; i++) {
      Pig p1 = Pig.getInstance();
      System.out.println(p1);
    }
  }
}
```
输出：
com.test.Demo03_MultiInstance.Pig@511d50c0
com.test.Demo03_MultiInstance.Pig@511d50c0
com.test.Demo03_MultiInstance.Pig@511d50c0
com.test.Demo03_MultiInstance.Pig@511d50c0
com.test.Demo03_MultiInstance.Pig@511d50c0

com.test.Demo03_MultiInstance.Pig@5e2de80c
com.test.Demo03_MultiInstance.Pig@5e2de80c

com.test.Demo03_MultiInstance.Pig@610455d6
com.test.Demo03_MultiInstance.Pig@610455d6

com.test.Demo03_MultiInstance.Pig@60e53b93
三.动态代理
3.1 动态代理的介绍

什么是代理
被代理者没有能力或不愿意完成某件事，寻求一个可以完成此事的对象，这个对象就是代理

生活中的代理

代码中的代理案例
a.用户登录到我们的系统后，我们的系统会为其产生一个ArrayList集合对象，内部存储了一些用户信息
b.对象需要被传给后面的很多其它对象，但要求其它对象不能对这个ArrayList对象执行添加、删除、修改操作，只能 get()获取元素
c.分析：无法控制用户如何操作集合，可以给这个集合找一个代理，判断他的操作，如果是增删改相关，直接抛出异常。如果是获取相关，找到真正的被代理集合，获取数据。




```java
// 要求代理对象和被代理有一样的方法
// 代理对象中应该保存被代理对象
/* 代理对象中的方法：
   增删改，直接抛出异常
   获取，调用被代理对象的方法
*/   

package com.test.Demo04_Proxy;

import java.util.*;
import java.util.function.UnaryOperator;

//此类就是普通ArrayList的代理

//1.让代理对象实现被代理对象一样的接口，目的是让代理对象和被代理对象具有一样的方法
public class ArrayListProxy implements List<String> {
  //2.要在代理对象中保存一个被代理对象
  private ArrayList<String> list;
  public ArrayListProxy(ArrayList<String> list) {
    this.list = list;
  }

  //3.下面的一堆方法中，如果是不修改集合数据的方法，就调用List的方法
  //如果是修改集合的方法，直接抛出异常

  @Override
  public int size() {
    return list.size();
  }

  @Override
  public boolean isEmpty() {
    return list.isEmpty();
  }

  @Override
  public boolean contains(Object o) {
    return list.contains(o);
  }

  @Override
  public void replaceAll(UnaryOperator<String> operator) {
    throw new UnsupportedOperationException("不允许调用replaceAll方法");
  }

  @Override
  public Iterator<String> iterator() {
    throw new UnsupportedOperationException("不允许调用iterator方法");
  }

  @Override
  public Object[] toArray() {
    return list.toArray();
  }

  @Override
  public <T> T[] toArray(T[] a) {
    return list.toArray(a);
  }

  @Override
  public boolean add(String s) {
    throw new UnsupportedOperationException("不允许调用add方法");

  }

  @Override
  public boolean remove(Object o) {
    throw new UnsupportedOperationException("不允许调用remove方法");

  }

  @Override
  public boolean containsAll(Collection<?> c) {
    return false;
  }

  @Override
  public boolean addAll(Collection<? extends String> c) {
    throw new UnsupportedOperationException("不允许调用addAll方法");

  }

  @Override
  public boolean addAll(int index, Collection<? extends String> c) {
    throw new UnsupportedOperationException("不允许调用addAll方法");

  }

  @Override
  public boolean removeAll(Collection<?> c) {
    throw new UnsupportedOperationException("不允许调用removeAll方法");

  }

  @Override
  public boolean retainAll(Collection<?> c) {
    throw new UnsupportedOperationException("不允许调用retainAll方法");
  }

  @Override
  public void clear() {
    throw new UnsupportedOperationException("不允许调用clear方法");
  }

  @Override
  public String get(int index) {
    return list.get(index);
  }

  @Override
  public String set(int index, String element) {
    throw new UnsupportedOperationException("不允许调用set方法");
  }

  @Override
  public void add(int index, String element) {
    throw new UnsupportedOperationException("不允许调用add方法");
  }

  @Override
  public String remove(int index) {
    throw new UnsupportedOperationException("不允许调用remove方法");
  }

  @Override
  public int indexOf(Object o) {
    return list.indexOf(o);
  }

  @Override
  public int lastIndexOf(Object o) {
    return list.lastIndexOf(o);
  }

  @Override
  public ListIterator<String> listIterator() {
    throw new UnsupportedOperationException("不允许调用listIterator方法");
  }

  @Override
  public ListIterator<String> listIterator(int index) {
    throw new UnsupportedOperationException("不允许调用listIterator方法");
  }

  @Override
  public List<String> subList(int fromIndex, int toIndex) {
    return list.subList(fromIndex, toIndex);
  }
  @Override
  public void sort(Comparator<? super String> c) {
    throw new UnsupportedOperationException("不允许调用sort(Comparator<? super String>方法");
  }

  @Override
  public Spliterator<String> spliterator() {
    throw new UnsupportedOperationException("不允许调用spliterator方法");
  }}

public class TestProxy {
  public static void main(String[] args) {
    ArrayList<String> arr = new ArrayList<>();
    Collections.addAll(arr, "a", "18", "sz", "10000");
    //把集合arr先交给代理对象
    List<String> list = getArrayListProxy(arr);

    //操作
    list.add("");
  }

  public static List<String > getArrayListProxy(ArrayList<String > arr){
    //创建一个ArrayList代理
    ArrayListProxy arrayListProxy = new ArrayListProxy(arr);

    return arrayListProxy;
  }}
```

3.2 动态代理概述
动态代理和静态代理区别在于释放已经写好，上面案例就是静态代理，代理类ArrayListProxy已经编译时期定义好了
而动态代理，它的代理在运行时期通过代码动态生成。

动态代理作用：拦截对真实对象(被代理对象)方法对直接访问，增强/减弱 真实对象(被代理对象)方法对功能进行 增强/减弱

3.3 案例引出

```java

public class Dynamic_Proxy {
  public static void main(String[] args) {
    ArrayList<String> arr = new ArrayList<String>();
    Collections.addAll(arr, "a", "18", "sz", "10000");

    //使用arr这个集合，生成一个它的代理
    List<String> list = Collections.unmodifiableList(arr);
    /*
    unmodifiableList该方法返回的是arr的代理对象，类似于我们自己的ArraylistProxy对象
    但是unmodifiableList生产的代理对象，是通过动态方式在运行时期创建出来
     */

    //调用方法
    try {
      list.remove(1);
      list.set(1, "a");
      list.add("a");
    }catch (Exception e){
      e.printStackTrace();
    }finally {
      list.get(2);
    }
  }}
```

3.4 重点类方法
•java.lang.reflect.Proxy类:
这是 Java 动态代理机制的主类，它提供了一个静态方法来为一组接口的实现类动态地生 成代理类及其对象。

public static Object newProxyInstance(ClassLoader loader, Class[] interfaces, InvocationHandler h))

参数	作用
ClassLoader loader	类加载器，一般使用和被代理对象一样的类加载器
Class[] interfaces	被代理对象实现的所有接口的字节码数组文件
InvocationHandler h	处理类对象,用于拦截我们调用的所有方法，判断到底是否返回被代理对象的真实方法
•InvocationHandler接口的invoke方法及参数详解

InvocationHandler处理类，实际上它是一个接口
//invoke方法就是用于拦截我们调用的真实方法
public Object invoke(Object proxy, Method method, Object[] args);

参数	作用
Object proxy	代理对象
Method method	被拦截的方法
Object[] args	被拦截的方法参数，如果没有就是Null
3.5 动态代理综合案例




```java
public class Dynamic_Proxy_InAction {
  public static void main(String[] args) {
    ArrayList<String> arr = new ArrayList<String>();
    Collections.addAll(arr, "a", "18", "sz", "10000");

    List<String> list = unmodifiableList(arr);

    System.out.println(list.get(1));
    //        System.out.println(list.add("1"));方法不允许
    System.out.println(list.indexOf("18"));
  }

  public static List<String> unmodifiableList(List<String> arr) {
    //        Proxy.newProxyInstance(arr.getClass().getClassLoader(),arr.getClass().getInterfaces(),);
    List<String> list = 
      (List<String>) Proxy.newProxyInstance(Dynamic_Proxy_InAction.class.getClassLoader(),
                                            arr.getClass().getInterfaces(), 
                                            new InvocationHandler() {
                                              @Override
                                              //该方法就是用来拦截真实对象的方法
                                              public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                                                //                        System.out.println(method.getName());
                                                //                        return null;
                                                //获取方法名
                                                String name = method.getName();
                                                //假设需要拦截ADD,SET,REMOVE的方法
                                                if (name.startsWith("add") || name.startsWith("set") || name.startsWith("remove")) {
                                                  throw new UnsupportedOperationException("方法不允许");
                                                }
                                                Object result = method.invoke(arr, args);
                                                return result;
                                              }
                                            });
    return list;
  }
}
```

3.6 动态代理的优缺点总结

总结
优点	a.可以为任意接口实现类对象做动态代理(机制是由Java的反射技术生成的)
b.极大提高了开发效率
c.不改变被代理对象的代码
缺点	java的Proxy创建动态代理必须有接口，没有接口不行
可以通过调用第三方CGL iB对无接口的的对象进行动态代理

四.Lombok
4.1 下载Lombok
https://projectlombok.org/downloads/lombok.jar

4.2 安装Lombok
项目下建立lib文件夹，将lombok.jar拖入，并在IDE中查找Lombok插件安装并重启

4.3 Lombok常用注解

@Getter和@Setter
•作用:生成成员变量的get和set方法。
•写在成员变量上，指对当前成员变量有效。
•写在类上，对所有成员变量有效。
•注意:静态成员变量无效。

@ToString:
•作用:生成toString()方法。
•该注解只能写在类上。

@NoArgsConstructor和@AllArgsConstructor
•@NoArgsConstructor:无参数构造方法。
•@AllArgsConstructor:满参数构造方法。
•注解只能写在类上。

@EqualsAndHashCode
•作用:生成hashCode()和equals()方法。
•注解只能写在类上。

@Data
•作用: 生成setter/getter、equals、canEqual、hashCode、toString方法，如为final属性，则不会为 该属性生成setter方法。
•注解只能写在类上。

五.工厂设计模式
5.1 工厂模式概述
之前创建对象，都是new对象
而工厂模式，将创建对象的过程交给工厂执行，只需要从工厂中获取对象即可。

5.2 工厂模式作用
解决类与类之间的耦合问题

5.3 工厂模式实现步骤
a.提供一个所有类的父类/接口，例：提供一个Car接口
b.各种实现类都需要实现该接口，重写该接口中的方法
c.提供一个返回不同实现类对象的工厂

5.4 工厂模式实现代码

```java
public interface Car {
  void run();
}

public class Benz_Car implements Car{
  @Override
  public void run(){
    System.out.println("Benz Run");
  }
}

public class BMW_Car implements Car{
  @Override
  public void run(){
    System.out.println("BMW RUN");
  }
}

public class VW_Car implements Car{
  @Override
  public void run(){
    System.out.println("volk swagen run");
  }
}
//汽车工厂
public class Car_Factory {
  //定义方法，用于产汽车
  public static Car getACar(int id) {
    //返回一个真正的汽车对象
    if (id == 1) {
      return new VW_Car();
    } else if (id == 2) {
      return new Benz_Car();
    }else if(id == 3){
      return new BMW_Car();
    }else {
      throw new NoSuchIdCarException();
    }
  }}

public class TestCar {
  public static void main(String[] args) {
    //        Benz_Car bz = new Benz_Car();
    //        bz.run();
    //
    //        BMW_Car bmw = new BMW_Car();
    //        bmw.run();
    //
    //        VW_Car vw = new VW_Car();
    //        vw.run();
    Car aCar = Car_Factory.getACar(1);
    aCar.run();
  }
}
```


补充：可以使用配置文件，来替代具体代码中的ID值

//Car.properties
id = 3

```java
public class TestCar {
  public static void main(String[] args) {
    //从配置文件读取id
    Properties ps = new Properties();
    ps.load(new FileInputStream("Day23/Car.properties"));

    String id = ps.getProperty("id");
    int ID = Integer.parseInt(id);

    Car aCar = Car_Factory.getACar(ID);
    aCar.run();
  }}
```

总结：
单例设计模式的好处
可以让一个类只有一个对象：
饿汉式：直接在类内部定义本类对象并创建对象
懒汉式：在类内部定义本类对象，在getInstance方法中判断再创建对象

多例模式好处：
可以让一个类只有指定个数的对象
在类内部创建一个集合，用来保存多个本类的对象
一般来说都使用静态代码块向集合中添加固定个数的对象

动态代理模式作用：
在程序运行期间，为一个被代理对象动态创建一个代理对象
当调用代理对象的方法时，都会被拦截，拦截之后可以进行判断

使用Proxy的方法生成代理对象
Proxy.newProxyInstance(ClassLoader class,Class[ interfaces,InvocationHandler handler])

InvocationHandler接口
//invoke方法就是用于拦截的
//Method被调用的方法
//Object[] 被调用方法时的参数
public Object invoke(Object proxy, Method method, Object[] args);

在此方法中会自动判断，
如果满足条件，则正常调用：method.invoke(被代理对象,args)
如果不满足条件，则不调用，可以返回异常，也可以什么都不做

使用工厂模式编写程序