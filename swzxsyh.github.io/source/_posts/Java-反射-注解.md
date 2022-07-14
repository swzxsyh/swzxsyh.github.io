---
title: Java 反射 & 注解
date: 2020-03-28 00:55:02
tags:
---

一.反射
1.1 类加载器

类的加载
当程序要使用某个类时,如果该类还未被加载到内存中,则系统会通过类的加载,类的连接,类的初始化这三个步骤对类进行初始化。如果不出意外,JVM将会连续完成这三个步骤,使用有时也把这三个步骤统称为类加载或类初始化。
类的加载：
•就是将class文件读入内存,并为之创建一个java.lang.Class对象(字节码文件对象,在Heap区)
•任何类被使用时,系统都会为之建立一个java.lang.Class对象
类的连接：
•验证阶段：用于检验被加载的类是否有正确的内部结构,并合其他类协调一致
•准备阶段：负责为类变量分配内存,并社长默认初始化值
•解析阶段：将类的二进制数据中的符合引用替换为直接引用
类的初始化：
•在该阶段,主要就是对类变量进行初始化

类的初始化时机：
•假如类还未被加载和连接,则程序先加载并连接该类
•假如该类的父类还未被初始化,则先初始化其直接父类
•假如类中有初始化语句,则系统依次执行这些初始化语句
注意：在执行第二个步骤时,系统对直接父类的初始化步骤也遵循初始化步骤1-3

类的初始化时机
a.创建类的实例
b.调用类的静态变量,或为静态变量赋值
c.调用类的静态方法
d.初始化某个类的子类
e.直接使用java命令来运行某个主类
f.使用反射方式来强制创建某个类或接口对应的java.lang.Class对象

类加载器的作用和分类
类加载器将类加载到内存

类加载器的作用：
•负责将.class文件加载到内存中,并为之生成对应的java.lang.Class对象

JVM类加载机制
•全盘负责：当一个类加载器负责加载某个Class时,该Clas所依赖的和引用的其他Class也将由该类加载器负责载入,除非显示使用另一个类加载器来载入
•父类委托：当一个类加载器负责加载某个Class时,先让父类加载器试图加载该Class,只有在父类加载器无法加载该类时才尝试从自己的类路径中加载该类
•缓存机制：保证所有加载过的Class都会被缓存,当程序需要使用某个Class对象时,类加载器先从缓存去中搜索该Class,只有当缓存区中不存在该Class对象时,系统才会读取该类对应的二进制数据,并将其转换成Class对象,存储到缓存区

类加载器有三种:
ClassLoader：是负责加载类的对象
•启动类加载器(Bootstrap ClassLoader):用于加载系统类库\bin目录下的class,例如: rt.jar。
•扩展类加载器(Extension ClassLoader):用于加载扩展类库\jre\lib\ext目录下的class。
•应用程序类加载器(Application ClassLoader):用于加载我们自定义类的加载器。

ClassLoader：中的两种方法
•static ClassLoader getSystemClassLoader();返回用于委派的系统类加载器
•ClassLoader getParent();返回父类加载器进行委派

```java
public class ClassLoaderDemo {
  public static void main(String[] args) {
    ClassLoader  classLoader = String.class.getClassLoader();
    System.out.println(classLoader);
    ClassLoader classLoader1 = ClassLoaderDemo.class.getClassLoader();
    System.out.println(classLoader1);
  }}
```

双亲委派机制
当某个类加载器需要加载一个类时,它并不是直接加载,而是把加载需求交给父级类加载器,最终请求会到达启动类加载器,启动类加载器会判断是否可以加载该类,如果加载不了,在交给扩展类加载器,扩展类加载器判断是否可以加载,如果加载不了,再交给程序类加载器
双亲委派机制主要作用:就是让一个类只会被加载一次,确保一个类在内存中只有它一个。

1.2 什么是反射
是指在运行时去获取一个类的变量和方法信息。然后通过获取到的信息(字节码文件对象)来创建对象，调用方法的一种机制。由于这种方法的动态性，可以 极大增强程序的灵活性，程序不需要在编译时期将完成确定，在运行期仍能完成扩展

1.3 反射在实际开发中的应用
•开发IDE
•框架的设计与底层原理的学习

1.4 反射中万物皆对象的概念
一个类变异之后的字节码文件Class对象
Class对象中的成员变量:Field对象
Class对象中的成员方法:Method对象
Class对象中的构造方法:Constructor对象
创建对象–>newInstance对象
调用/执行–>invoke对象

反射语法与正常语法是反过来的,例如:
创建对象:
正常语法:new 构造方法(参数);
反射语法:构造方法对象.new Instance(参数);

调用方法:
正常语法:对象名.成员方法名(参数);
反射语法:成员方法对象.invoke(对象名,参数);

1.5 反射的第一步获取字节码文件对象(Class对象)



```java
public class GetClassDemo {
  public static void main(String[] args) throws ClassNotFoundException {
    //获取一个类Class对象的三种方式
    //1.通过类的一个静态成员 class
    Class clazz1 = Dog.class;
    System.out.println(clazz1);
    //2.通过该类的一个对象,获取该类的Clazz对象
    Dog dd = new Dog();
    Class clazz2 = dd.getClass();
    System.out.println(clazz2);

    //通过反射强制加载该类,并获取该类的Class对象
    Class clazz3 = Class.forName("com.test.Demo02_GetClass.Dog");
    System.out.println(clazz3);

    /*以上是三种获取Dog类Class对象的方式,并不是获取三个Class对象,实际上它们获取的是同一个Class对象*/
    System.out.println(clazz1 == clazz2);
    System.out.println(clazz2 == clazz3);
    System.out.println(clazz1 == clazz3);
  }
```
}
1.6 Class对象中的三个常用方法
public String getName();//获取全限定类名
public String getSimple();//获取类名
public Object getInstance();//创建Class对象所代表的那个类的对象,底层实际上使用的是该类的无参构造



```java

public class ClassMethodDemo {
  public static void main(String[] args) throws IllegalAccessException, InstantiationException {
    Class clazz = Dog.class;
    //获取全限定类名
    String name = clazz.getName();
    System.out.println(name);

    //获取类名
    String simpleName = clazz.getSimpleName();
    System.out.println(simpleName);

    //创建Class对象所代表的那个类的对象,底层实际上使用的是Dog的无参构造
    Dog dog = (Dog) clazz.newInstance();
    System.out.println(dog);
  }
```
}
输出:
com.test.Demo03_ClassMethod.Dog
Dog
Dog{name=’null’, legs=0}

1.7 通过反射获取构造方法 && 使用构造方法创建对象

反射获取构造方法
Constructor getConstructor(Class… parameterTypes); //获取单个pulic构造
Constructor getDeclaredConstructor(Class… parameterTypes); //获取单个”任意”修饰符构造
Constructor[] getConstructors(); //获得类中的所有构造方法对象,获得public修饰符构造(返回数组)
Constructor[] getDeclaredConstructors();//获得类中的所有修饰符构造方法对象(返回数组)



```java


public class GetConstructorDemo {
  public static void main(String[] args) throws NoSuchMethodException {
    Class clazz = Dog.class;
    System.out.println(clazz);

    Constructor con1 = clazz.getConstructor();
    System.out.println(con1);

    //获取单个pulic构造
    //        Constructor con2 = clazz.getConstructor(String.class, int.class);
    //        System.out.println(con2);
    //获取单个"任意"修饰符构造
    Constructor deccon = clazz.getDeclaredConstructor(String.class, int.class);
    System.out.println(deccon);

    Constructor[] cons = clazz.getConstructors();
    System.out.println(cons.length);
    for (Constructor con : cons) {
      System.out.println(con);
    }

    Constructor[] deccons = clazz.getDeclaredConstructors();
    System.out.println(deccons.length);
    for (Constructor con : deccons) {
      System.out.println(con);
    }
  }
}
```
使用构造方法创建对象
语法:
构造方法对象.newInstance(参数);

```java
@Test
public void test02() throws Exception {
  Class clazz = Dog.class;
  System.out.println(clazz);

  Constructor con1 = clazz.getConstructor();
  System.out.println(con1);

  //使用构造创建对象
  Dog dog = (Dog) con1.newInstance();
  System.out.println(dog);
}
```

如果是私有构造怎么办
私有构造必须设置暴力权限,然后才能正常使用,否则会抛出IllegalAccessException异常

```java
@Test
public void test01() throws Exception {
  Class clazz = Dog.class;
  System.out.println(clazz);

  Constructor con1 = clazz.getConstructor();
  System.out.println(con1);

  Constructor con2 = clazz.getDeclaredConstructor(String.class,int.class);
  System.out.println(con2);

  //使用构造创建对象
  Dog dog = (Dog) con1.newInstance();
  System.out.println(dog);

  //私有构造,不能直接使用,因为没有权限
  //设置暴力访问权限
  con2.setAccessible(true);

  Dog dog2 = (Dog) con2.newInstance("a", 1);
  System.out.println(dog2);
```
}
1.8 通过反射获取成员方法 && 调用成员方法

反射获取成员方法
public Method get Method(String name,Class…args);//获取public方法
public Method get getDeclaredMethod(String name,Class…args);//获取 任意修饰 方法
public Method[] get Methods();//获取所有的public成员,包括父类继承的
public Method[] get getDeclaredMethods();//获取所有任意修饰方法,不包含父类继承的

```java
public class GetConstructorDemo {
  @Test
  public void test01() throws Exception {
    Class clazz = Dog.class;
    //获取单个public成员方法
    Method eat = clazz.getMethod("eat");
    System.out.println(eat);

    Method eat1 = clazz.getMethod("eat", String.class, String.class);
    System.out.println(eat1);

    Method eat3 = clazz.getDeclaredMethod("eat", String.class);
    System.out.println(eat3);

    System.out.println();

    //获取所有的 public 成员方法,包含父类
    Method[] methods = clazz.getMethods();
    System.out.println(methods.length);
    for (Method method : methods) {
      System.out.println(method);
    }

    System.out.println();

    //获取所有的 任意修饰 成员方法,但是不包含父类
    Method[] decmethods = clazz.getDeclaredMethods();
    System.out.println(decmethods.length);
    for (Method method : decmethods) {
      System.out.println(method);
    }
  }
}
```

调用成员方法
语法格式:
成员方法对象.invoke(对象名,参数);

```java
public class GetConstructorDemo {
  @Test
  public void test01() throws Exception {
    Dog dd = new Dog();
    Class clazz = dd.getClass();
    //获取单个public成员方法
    Method eat = clazz.getMethod("eat");
    System.out.println(eat);

    Method eat1 = clazz.getMethod("eat", String.class, String.class);
    System.out.println(eat1);

    //使用成员方法
    eat.invoke(dd);

    eat1.invoke(dd," a"," b");
  }}
```

如果是私有成员方法怎么调用
私有成员方法必须设置暴力权限,然后才能正常使用,否则会抛出IllegalAccessException异常

```java
@Test
public void test02() throws Exception {
  Dog dd = new Dog();
  Class clazz = dd.getClass();
  //获取单个public成员方法
  Method eat = clazz.geMethod("eat");
  System.out.println(eat);

  Method eat1 = clazz.getMethod("eat", String.class, String.class);
  System.out.println(eat1);

  Method eat2 = clazz.getDeclaredMethod("eat", String.class);
  System.out.println(eat1);

  //使用成员方法
  eat.invoke(dd);

  eat1.invoke(dd," a"," b");

  //设置暴力访问权限,否则会抛出IllegalAccessException异常
  eat2.setAccessible(true);
  eat2.invoke(dd,"a");
}
```
1.9 通过反射获取成员属性

二.注解
2.1 什么是注解
•注解是JDK1.5的新特性
•注解是一种标记,是类的组成部分,可以给类携带一些额外的信息
•标记(注解)可以用在各种地方(包,类,构造方法,普通方法,成员变量,局部变量…)
•注解主要是给编译器或JVM看的,用于完成某些特定功能

2.2 注解的三个作用
a.给程序带入一些参数
b.编译检查
c.给框架使用,作为框架的配置文件

2.3 常见的注解介绍
@author:用于标识作者
@version:用于标识对象的版本号
@Override:用于标识该方法是重写的
@deprecated:用于标识过期的API
@Test:用于单元测试的注解

2.4 自定义注解
自定义类:public class 类名
自定义接口:public interface 接口
自定义枚举:public enum 枚举名
自定义注解:public @interface 注解名

格式:
public @interface 注解名{

}

2.5 给自定义注解添加属性
格式:
public @interface 注解名{
//注解内部只有属性,没有别的
数据类型 属性名();
数据类型 属性名()[default 默认值];
}

注解中并不是所有数据类型都可以的
只能是以下三大类型:
a.八大基本类型(byte,short,char,int,long,float,double,boolean)
b.引用类型(String,Class,注解类型,枚举类型)
c.以上12种具体类型的一维数组

2.6 自定义注解练习
创建时选中Annocation

```java
public @interface Book {
  String value();
  double Price() default 100;

  String[] atuhors();
}
```

2.7 使用注解时的注意事项
使用格式:
@注解名(属性名=属性值,属性名=属性值)



```java

@Book(value = "A", Price = 150.0, authors ={"a","b"})

public class TestDemo {
    @Book(value = "B", Price = 160.0, authors ={"c","d"})
private int age;
private String name;

public TestDemo() {
}

@Book(value = "C", Price = 170.0, authors ="e")

public TestDemo(int age, String name) {
    this.age = age;
    this.name = name;
}

public void show(int age) {
    String name = "a";
    System.out.println(age);
}}
```


注意:
a.使用注解时的每个属性都必须有值(有默认值可以不再赋值,没有默认值的必须赋值)
b.如果是数组,需要使用{}把值包起来,如果数组的值只有一个,那么{}可以省略

2.8 自定义注解中的特殊属性名value
a.如果注解中只有一个属性,并且名字叫做value,那么使用时可以直接写属性的值,省略属性名
b.如果注解中有value之外的其他属性,那么其他属性都有默认值,且使用注解时只给value赋值,那么也可以直接写属性的值,省略属性名



```java
public @interface Book {
  //特殊属性value
  String value();double Price() default 100.0;}
```





```java
public class TestDemo {
  private int age;
  private String name;
  public TestDemo() {
  }

  @Book("a")
  public TestDemo(int age, String name) {
    this.age = age;
    this.name = name;
  }

  public void show(int age) {
    String name = "a";
    System.out.println(age);
  }}
```


2.9 注解的注解–元注解
Java官方提供的注解,用来修饰或定义注解的注解

两个元注解
@Target 元注解
作用:用来标识注解的使用位置,如果没有标识,那么注解在各种地方都可以使用
取值:
可以使用ElementType枚举类中的值,常用如下:
TYPE,类,接口
FIELD, 成员变量
METHOD, 成员方法
PARAMETER, 方法参数
CONSTRUCTOR, 构造方法
LOCAL_VARIABLE, 局部变量

```java
//使用元注解来修饰定义的注解
@Target(ElementType.LOCAL_VARIABLE)
public @interface MyAnno {

public class TestDemo {
    private int age;
    private String name;
}
public TestDemo() {
}

public TestDemo(int age, String name) {
    this.age = age;
    this.name = name;
}

public void show(int age) {
    //使用定义的注解
    @MyAnno
    String name = "a";
    System.out.println(age);
}
```


@Retention 元注解
作用:用来标识注解的声明周期(有效范围)
取值:
可以使用RetentionPolicy枚举类中的值,常用如下:

方法名	说明
SOURCE	只作用在源码阶段,编译生成的字节码文件后消失
CLASS	在源码阶段、编程成字节码文件阶段存在,运行阶段不存在
RUNTIME	在源码阶段,字节码文件阶段,运行阶段都存在

```java
@Retention(RetentionPolicy.CLASS)
@Target(ElementType.LOCAL_VARIABLE)
public @interface MyAnno {
}
```


2.10 注解的解析

什么是注解解析
提供代码获取出来某个注解中的属性值

注解解析的步骤
a.获取注解所在类的Class对象
b.获取注解所在的对象(可能Field,Method,Constructor)
c.判断获取的对象中是否有该注解存在
d.如果有要的注解,取出注解即可
e.从注解中取出属性值即可

与之相关的API:
Annotation:注解类,Java中所有定义的注解的父类
AnnotatedElement:该接口定义了与注解解析相关的方法
Field,Method,Constructor,Class等类都是实现了AnnotatedElement接口

public boolean isAnnotationPresent(Class annotationClass);//判断是否存在某个注解
Annotion getAnnotation(Class annotationClass);//获取指定类型的注解
Annotation[] getAnnotations();//获取所有注解,包含父类继承的
Annotation[] getDeclaredAnnotations()//获取所有注解,只包含本类的

注解解析的代码实现


```java
@Retention(RetentionPolicy.RUNTIME)
public @interface Student {
  int Age();String Name();

  String[] bys();
}

public class TestStudent {
  @Student(Age = 1, Name = "a", bys = "c")
  public void show() {

  }}


public class TestDemo {
  public static void main(String[] args) throws Exception {
    Class clazz = TestStudent.class;
    Method showMethod = clazz.getMethod("show");
    if (showMethod.isAnnotationPresent(Student.class)) {
      Student anno = showMethod.getAnnotation(Student.class);
      int age = anno.Age();
      String name = anno.Name();
      String[] bys = anno.bys();

      System.out.println(age+" "+name+" "+bys.toString());

      System.out.println("Y");
    } else {
      System.out.println("N");
    }
  }}
```

2.11 注解解析案例

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface MyTest {
}

public class Demo {
  @MyTest
  public void test01(){
    System.out.println("a");
  }

  @MyTest
  public void test02(){
    System.out.println("b");
  }
}

public class TestMyTest {
  public static void main(String[] args) throws Exception {
    Class clazz = Demo.class;    Method[] methods = clazz.getMethods();

    for (Method method : methods) {
      if (method.isAnnotationPresent(MyTest.class)) {
        method.invoke(new Demo());
      }else {
        System.out.println("N Annotation");
      }
    }
  }}
```


总结:
反射技术获取Class字节码对象
Class clazz = 类名.class;
Class clazz = 对象名.getClass();
Class clazz = Class.forName(“包名”,”类名”);

通过反射技术怄气构造方法对象,并创建对象
获取构造:
public Constructor getConstructor(参数的类型.class,…)//获取单个 public 构造
public Constructor getDeclareConstructor(参数的类型.class,…)//获取单个 任意修饰 构造
public Constructor[] getConstructors()//获取所有个 public 构造
public Constructor[] getDeclareConstructors()//获取所有 任意修饰 构造
使用构造:
构造方法对象.newInstance(实际参数);
如果是私有构造:
必须在使用之前设置暴力权限->构造方法对象.getAccessable(true);

反射获取成员方法对象,并调用方法
public Method getMethod(String name,参数的类型.class,…)//获取单个 public 方法
public Method getDeclareMethod(String name,参数的类型.class,…)//获取单个 任意修饰 方法
public Method[] getMethods()//获取所有个 public 方法,包括父类继承的
public Method[] getDeclareMethods()//获取所有 任意修饰 方法,不包含父类的

使用方法:
成员方法对象.invoke(对象名,方法的实际参数);
如果是私有方法:
必须在使用之前设置暴力权限->成员方法对象.getAccessable(true);

通过反射获取属性对象,并能够给对象的属性赋值和取值

注解的作用:
a.给程序带入参数
b.编译检查
c.给框架做配置文件

自定义注解和使用注解:
自定义注解:
public @interface 注解名{
数据类型 属性名();
数据类型 属性名() default 默认值;
数据类型[] 属性名() default {默认值1,默认值2,…};

}
数据类型限定:
a.八大基本类型(byte,short,char,int,long,float,double,boolean)
b.引用类型(String,Class,注解类型,枚举类型)
c.以上12种具体类型的一维数组

特殊属性:
value
a.如果注解中只有一个属性,并且名字叫做value,那么使用时可以直接写属性的值,省略属性名
b.如果注解中有value之外的其他属性,那么其他属性都有默认值,且使用注解时只给value赋值,那么也可以直接写属性的值,省略属性名

元注解及其作用:
@Target
@Retension

解析注解并获取注解中的数据
写代码把某个注解上的那些属性值打印出来

注解解析的步骤
a.获取注解所在类的Class对象
b.获取注解所在的对象(可能Field,Method,Constructor)
c.判断获取的对象中是否有该注解存在
d.如果有要的注解,取出注解即可
e.从注解中取出属性值即可