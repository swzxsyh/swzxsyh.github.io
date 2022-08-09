---
title: Java学习基础-常用API、引用类型小结
date: 2020-03-07 00:27:02
tags:
---

一.BigInteger类
BigInteger类
java.math.BigInteger类，用于大整数计算(理论上整数位数是不受限制的)

BigInteger的构造方法

1
public BigInteger(String num);//创建一个大整数
BigInteger的成员方法
BigInteger不能直接使用+-*/进行计算，而是要通过方法进行计算

```java
public BigInteger add(BigInteger value);//求和
public BigInteger subtract(BigInteger value);//求差
public BigInteger multiply(BigInteger value);//求积
public BigInteger divide(BigInteger value);//求商
```


二.BigDecimal类
使用基本类型会出现精度差
计算机计算小数时，总是存在不精确的情况

BigDecimal类的介绍
提供了算数、缩放操作、舍入、比较、散列和格式转换的操作。提供了更加精确的数据计算方式。

BigDecimal的构造方法

```java
public BigDecimal(double d);
public BigDecimal(String d);[推荐]

//BigDecimal的成员方法
public BigDecimal add(BigDecimal value);//求和
public BigDecimal subtract(BigDecimal value);//求差
public BigDecimal multiply(BigDecimal value);//求积
public BigDecimal divide(BigDecimal value);//求商（能除尽）
//注意：如果除不尽，会抛出异常java.lang.ArithmeticException
//此时，可以使用另一个divide方法的重载
public BigDecimal divide(BigDecimal value,int 保留位数,oundingMode.roundingMode);
//范例
BigDecimal divide = bd1.divide(new BigDecimal("0.3"), 5, RoundingMode.HALF_UP);
```

三.Array类
3.1 Arrays类的介绍
Arrarys是专门操作数组的工具类（方法都是静态的）

工具类的设计思想：
•构造方法用private修饰
•成员用public static修饰

3.2 Array类的常用方法

方法名	说明
public static void sort(int[] a);	对数组进行从小到大的排序
public static String toString(int[] a);	将一个数组的元素拼成一个大的字符串
extend：
sort方法对于数值类型的数组排序时，按照数值的从小到大进行排序。
sort方法对于char类型的数组排序时，按照字符码值的从小到大进行排序。
sort方法对于String类型的数组排序时，首先比较首字母的码值，如果相等，再比较次字母的码值，依次类推，从小到大进行排序。

四.包装类
4.1 包装类的作用
Java提供了两个类型，基本类型和引用类型，基本类型效率高，但是引用类型可操作性高，把基本类型包装成引用类型，就是包装类。
包装类就是基本类型对应的引用类型，全称叫基本数据类型的包装类（简称包装类）

基本类型包装类概述：将基本数据类型封装成对象的好处在于可以在对象中定义更多的功能方法操作该数据
常用操作之一：用于基本数据类型与字符串之间的转换

基本类型	引用类型
byte	Byte
short	Short
*char	Character
*int	Integer
long	Long
float	Float
double	Double
boolean	Boolean
4.2 Integer包装类介绍
Integer是int基本类型的包装类

4.3 Integer类的构造方法和静态方法
构造方法：

1
2
public Integer(int value);//过时
public Integer(String value);//过时
静态方法：

方法名	说明
public static Integer valueof(int value);	返回表示指定的int值类型的Integer实例
public static Integer valueof(String value);	返回一个保存指定值的Integer对象String
范例：

```java
Integer i1 = new Integer(10);
System.out.println(i1);

Integer i2 = new Integer("11");
System.out.println(i2);

Integer i3 = Integer.valueOf(12);
System.out.println(i3);

Integer i4 = Integer.valueOf("13");
System.out.println(i4);

```
4.4.1 拆箱和装箱
基本类型和对应的包装类是可以相互转换的。

装箱：把基本类型———转换成————>对应包装类
拆箱：包装类———转换成————>对应的基本类型

例如：

```java
//装箱操作
Integer i1 = new Integer(10);
Integer i3 = Integer.valueOf(12);

//拆箱操作
int value = i1.intValue();
```


4.4.2 自动拆箱和装箱*[JDK 5中引入该操作]

```java
Integer i =4；//底层已经调用Integer.valueOf()方法自动帮助进行装箱操作

int value  = i;//底层调用i.intValue()自动帮助我们进行拆箱操作
```


注意:在使用保证类类型时，如果做操作，最好先判断是否为null
推荐：只要是对象，在使用前将必须进行不为null的判断

题：
Integer a = 10;//装一次
a++;//拆一次 装一次
自动装箱2次
自动拆箱1次

4.5 基本类型与字符串之间的转换

```java
•基本类型转换成String

  int num = 10；

  a.直接加一个" "
  String s = num + " ";

b.通过String的静态方法valueOf
  String s = String.valueof(num);
•String转换成基本类型
  String num = "100";
方式一：
  a.
  先使用Integer的构造方法
  Integer i = new Integer(num);
b.
  接着拆箱调用intValue方法拆箱
  int number = i.intValue();
或不调用intValue方法自动拆箱接口
  int number = i
  方式二：
  直接调用包装类的parseXxx(String s)解析字符串方法
  int number = Integer.parseInt(num);
•字符串无法解析成基本类型失败时的异常
  Exception in thread "main" java.lang.NumberFormatException
```


五.String类常用方法
String的构造方法：
直接赋值：
String s = “java”;
构造方法：
String s = new String(“java’);

char[] chs = {“j”,”a”,”v”,”a”};
String s = new String(chs);

byte[] bs = {97,98,99,100};
String s = new String(bs);//最终结果是ASCII码对应的字符
```java
public static void main(String[] args) {
    String s = "Hello,World";
    //1.concat 拼接
    String s1 = s.concat("+Java");
    System.out.println(s1);//Hello,World+Java

    //contains 判断是否包含某个小字符串
    boolean b1 = s.contains("o");
    boolean b2 = s.contains("world");
    System.out.println(b1);//true
    System.out.println(b2);//false

    //endswith 是否以该字符结尾
    boolean b3 = s.endsWith("ld");
    boolean b4 = s.endsWith("lo");
    System.out.println(b3);//true
    System.out.println(b4);//false

    //startwith 是否以该字符开头
    boolean b5 = s.startsWith("He");
    boolean b6 = s.startsWith("Wo");
    System.out.println(b5);//true
    System.out.println(b6);//false


    //indexOf查找目标字符串在当前字符串第一次出现的索引
    int index1 = s.indexOf("o");
    System.out.println(index1);//4
    int php = s.indexOf("php");
    System.out.println(php);// -1

    //lastdexOf查找目标字符串在当前字符串最后一次出现的索引
    int index2 = s.lastIndexOf("o");
    System.out.println(index2);//7
    int delphi = s.lastIndexOf("delphi");
    System.out.println(delphi);// -1

    //replace 将当前字符串中的目标字符串替换为另外一个字符串
    String replace = s.replace("Hello", "Halo");
    System.out.println(replace);//Halo,World
    String replace1 = s.replace("php", "Halo");
    System.out.println(replace1);//Hello,World

    //substring 指定
    String subs = s.substring(2);
    System.out.println(subs);//llo,World
    String subs1 = s.substring(2,5);
    System.out.println(subs1);//llo,截取到5之前，不包含5

    //toCharArry 将字符转换成char Array
    char[] chs = s.toCharArray();
    System.out.println(chs);//Hello,World
    System.out.println(Arrays.toString(chs));//[H, e, l, l, o, ,, W, o, r, l, d]

    //toLowerArry 转成小写
    String s2 = s.toLowerCase();
    System.out.println(s2);//hello,world

    //toUpperArry 转成大写
    String s3 = s.toUpperCase();
    System.out.println(s3);//HELLO,WORLD


    String ss = "   Hello     ,World   ";
    //trim 去除字符串两端的空格
    String trim = ss.trim();
    System.out.println(trim);//Hello     ,World


    String sss = "a,b,c,d,e,f";
    //split 切割字符串
    String[] split = sss.split(",",7);
    String s4 = Arrays.toString(split);
    System.out.println(s4);//[a, b, c, d, e, f]
    System.out.println(split[0]);//a
    System.out.println(split[1]);//b
    System.out.println(split[2]);//c
    System.out.println(split[3]);//d
    System.out.println(split[4]);//e
    System.out.println(split[5]);//f
}
```
六.引用类型使用小结
6.1 类名作为方法参数和返回值
主要是（类，抽象类，接口，以及多态）复习

基本类型：

```java
public void show(int a){

}
public int method(){

}
```


普通类,也可以作为方法的参数和返回

```java
public void show(Dog g){

}
public Dog method{

}
```


抽象类，也可以作为方法的参数和返回

```java
public void show(Animal a){
  //Animal a = 任意一个子类对象
}
public Animal method{

}
```


接口，也可以作为方法的参数和返回

```java
public void show(Flyable a){
  //Flyable f = 该接口的任意一个实现类对象
}
public Flyable method(){

}
```


总结：
a.当基本类型作为方法的参数和返回值时，调用方法和返回数据时，返回该基本类型的值即可
b.当引用类型作为方法的参数和返回值时，调用方法和返回数据时，返回该引用类型的对象/子类对象/实现类对象

```java
public static void main(String[] args) {
  killPerson(new Person(18,"a"));
  Person pp = birthPerson();
  System.out.println(pp);
}
public static void killPerson(Person p){
  System.out.println("ppp");
  System.out.println(p);

}

public static Person birthPerson() {
  return new Person(3,"bbb");

}
```
总结：当方法的参数或者返回值是普通类时，我们要传入或返回对象的是该类的对象

6.2 抽象类作为方法参数和返回值

```java
public static void main(String[] args) {
  show(new Dog());
  show(new Cat());
  Animal an = BirthAnimal();
  an.eat();
  an.bark();
}
public static void show(Animal an){
  an.eat();
  an.bark();
}
public static Animal BirthAnimal(){
  //        return new Dog();
  return new Cat();
}
```
总结：当方法的参数或者返回值是抽象类时，我们要传入或返回对象的是该类的子类对象

6.3 接口作为方法参数和返回值

```java
public static void main(String[] args) {
  showFly(new Bird());
  showFly(new Plane());
  Flyable fa = getfly();
  fa.fly();
}
//定义方法，使用Flyable接口
public static void showFly(Flyable fa){
  fa.fly();
}
public static Flyable getfly(){
  //        return new Plane();
  return new Bird();
}
```
总结：当方法的参数或者返回值是接口时，我们要传入或返回对象的是该类的实现类对象

6.4 类名作为成员变量的，其实引用类型也可以作为类的成员变量

```java
public class Student{
  int age;
  String name;
  Dog dog;
  Animal an;
  Flyable fa;
}
```
总结：当普通类作为成员变量，给该成员变量赋值时，赋值普通类的对象
6.5 抽象类作为成员变量

```java
public class Student {
  int age;
  String name;
  Animal an;
}
public static void main(String[] args) {
  Student ss =new Student();
  ss.age = 1;
  ss.name = "s";
  ss.an = new Dog();

}
```

总结：当抽象类作为成员变量时，当给该成员变量赋值，赋值给该成员类的子类对象

6.6接口作为成员变量

```java
public class Student {
  private int age;
  private String name;

  public int getAge() {
    return age;
  }

  public void setAge(int age) {
    this.age = age;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Flyable getFa() {
    return fa;
  }

  public void setFa(Flyable fa) {
    this.fa = fa;
  }

  private Flyable fa;
}

public class TestDemo11 {
  public static void main(String[] args) {
    Student ss = new Student();
    ss.setAge(1);
    ss.setName("a");
    ss.setFa(new Bird());

  }
}
```
总结：当接口作为成员变量时，当给该成员变量赋值，赋值给该成员类的实现类对象

总结
1.BigInteger
2.BigDecimal
add subtract multiply divide

3.Arrays工具类*
public static void sort(int[] arr);默认对数组进行升序排序
public static String toString(int[] arr);将数组的所有元素拼在一起成一个大字符串返回

4.包装类*
a.八种基本类型对应的引用类型
b.装箱和拆箱（JDK5之后，自动拆装箱）
Integer i = 10;
int j =1;

5.String **
构造方法和常用的13个成员方法

6.引用类型的使用总结
引用类型作为方法的参数和返回值
引用类型作为成员变量

如果引用类型是普通类，那么用到该普通类的普通类对象
如果引用类型是抽象类，那么用到该抽象类的子类对象
如果引用类型是接口，那么用到该接口的实现类对象

