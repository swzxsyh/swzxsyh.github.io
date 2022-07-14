---
title: Java学习基础-常用API
date: 2020-03-06 00:26:11
tags:
---
一. Object类
1.1 Object介绍
Object类是所有类的父类，所有对象（包括数组）都具有该类中的11种方法。

构造方法：
public Object();

为什么之前说子类的构造方法默认访问的是父类的无参构造方法，因为它们的顶级父类只有无参构造方法

如果一个类我们没有指定其父类，那么默认继承Object

```java
public class Dog /*extends Object*/{
}
```


1.2 toString方法
作用：返回该对象的字符串表示（调用的对象）
默认字符串表示的形式：
包名.类名@地址值
com.test.Demo01.Dog@61bbe9ba

在实际开发中，我们通常会重写toString方法，将本类返回的地址值改回返回对象的内容

```java
@Override
public String toString() {
  return "Dog{" +
    "age=" + age +
    ", name='" + name + '\'' +
    '}';
}

public static void main(String[] args) {
  Dog dd = new Dog(10,"a");
  String  ss = dd.toString();
  System.out.println(ss);
}
```



Dog{age=10, name=’a’}
Dog{age=20, name=’b’}

注意：重写toString方法之后，当调用对象的toString方法时，返回的不再是地址值，而是具体的属性值。
实际上，不需要手动调用toString方法，可以简写为：

```java
Dog d = new Dog();
System.out.println(d);
```


打印变量d，会自动调用d.toString()，其实就是打印toString方法值的返回值

总结：

```java
System.out.println(ss2.toString());
//等同于
System.out.println(ss2);
```


1.3 equals方法
作用：判断其他对象是否是此对象“相等”。
默认比较的是两个对象的地址值
equals源码：

```java
public boolean equals(Object obj) {
    return (this == obj);
}
```


在实际开发中， 也会重写equals方法，将本来的比较地址值改为比较内容（属性值）

```java
@Override
public boolean equals(Object o) {
  //合法性判断
  /*
    this --- age1
    o    --- age2
    */
  //比较地址是否相同
  if (this == o) return true;
  //判断参数是否为null
  //getClass判断是否来自同一个类(对比字节码Class文件)
  if (o == null || getClass() != o.getClass()) return false;
  //向下转型
  Cat cat = (Cat) o;
  //判断时，必须当前对象的age和比较对象的age相同，切当前name和比较对象name相同，才返回true
  return age == cat.age &&
    Objects.equals(name, cat.name);
}
```


方法名	说明
public String toString();	返回对象的字符串形式表示。建议所有子类重写该方法，IDE自动生成
public boolean equals(Object obj);	比较对象是否相等，默认比较地址，重写可以比较内容，IDE自动生成
1.4 native本地方法
有native修饰的方法，称为本地方法，不是用Java写的，是使用底层C/C++写的。

```java
public native int hashCode()
```


1.5 扩展（equals和==的区别）
对于基本类型：
== 比较的是数值
没有equals方法
对于引用类型：
== 比较的是地址值
equals默认情况下比较的是地址值，@override后，就按照重写的比较规则比较（一般比较属性值）

1.6 Objects类
Objects类，称之为工具类（内部所有的方法都是静态的）
在Objects中有一个方法：
public static boolean equals(Object a, Object b);
用于判断两个对象是否“相等”，并避免类空指针异常，该方法源码如下：

```java
public static boolean equals(Object a, Object b){
  return( a == b ) || ( a != null && a.equals(b));
}
```

二. Date 类
2.1 Date类的介绍
包：java.util.Date
作用：代表某一个时间点，可以精确到毫秒

2.2 Date类的构造方法

方法名	说明
public Date();	创建一个Date对象，并初始化，代表当前的系统时间，精确到毫秒。
public Date(long date);	创建一个Date对象，代表距离国际基准设计millis后的时间。
2.3 Date类的常用方法

方法名	说明
public void getTime();	获取当前Date对象距离基准时间(1910-1-1 00:00:00)的毫秒值。
public void setTime(long date);	设置时间，修改当前Date对象距离基准时间的毫秒值
三. DateFormat类
3.1 DateFormat类的作用
让时间/日期和具体的文本直接来回转换

SimpleDateFormat是一个具体的类，用于以区域设置敏感的方式格式化和解析日前。

日前和时间格式由日期和时间模式字符串指定，在日期和时间模式字符串中，从’A’到’Z’以及从’a’到’z’引号的字母被解释为表示日期或时间字符串的组件的模式字母

格式化：将 Date对象 转成具体的 时间文本字符串
解析：将 时间字符串 转回 Date对象

3.2 DateFormat类的构造方法
DateFormat is an abstract class for date/time

DateFromat是抽象类，使用其子类（SimpleDateFormat）
public SimpleDateFormat(String pattern,
DateFormatSymbols formatSymbols);
这里的pattern表示我们想要的时间字符串格式/模式

方法名	说明
public SimpleDateFormat();	构造一个SimpleDateFormat，使用默认模式和日期格式
public SimpleDateFormat(String pattern);	构造一个SimpleDateFormat使用给定的模式和默认的日期格式
Letter	Date or Time Component	Presentation	Examples
G	Era designator	Text	AD
y	Year	Year	1996; 96
Y	Week year	Year	2009; 09
M	Month in year (context sensitive)	Month	July; Jul; 07
L	Month in year (standalone form)	Month	July; Jul; 07
w	Week in year	Number	27
W	Week in month	Number	2
D	Day in year	Number	189
d	Day in month	Number	10
F	Day of week in month	Number	2
E	Day name in week	Text	Tuesday; Tue
u	Day number of week (1 = Monday, …, 7 = Sunday)	Number	1
a	Am/pm marker	Text	PM
H	Hour in day (0-23)	Number	0
k	Hour in day (1-24)	Number	24
K	Hour in am/pm (0-11)	Number	0
h	Hour in am/pm (1-12)	Number	12
m	Minute in hour	Number	30
s	Second in minute	Number	55
S	Millisecond	Number	978
z	Time zone	General time zone	Pacific Standard Time; PST; GMT-08:00
Z	Time zone	RFC 822 time zone	-0800
X	Time zone	ISO 8601 time zone	-08; -0800; -08:00
主要：
y – 年
M – 月
d – 日
H – 时
m – 分
s – 秒

3.3 DateFormat类的成员方法

方法名	说明
public String format(Date date);	格式化方法，将日期格式化成日期/时间字符串
public Date parse(String date);	解析方法，从给定字符串的开始解析文本以及生成日期

```java
public static void main(String[] args) throws ParseException {
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
  Date now = new Date();
  String nowStr = sdf.format(now);
  System.out.println(nowStr);
  Date date = sdf.parse("2020年04月07日 11:18:09");
  System.out.println(date);
}
```


四. Calendar类
4.1 Calendar的介绍和获取对象方式：
概述：
Calendar为某一时刻和一组日历字段直接的转换提供了一些方法，并为操作日历字段提供了一些方法

作用：表示某个时间点
获取对象的方式：
创建其子类GregorianCalendar类的对象（目前不使用）

使用Calendar的静态方法【推荐方式】：
Calendar c = Calendar.getInstance();创建一个子类对象，返回

注意：在Calendar类中，月份（0-11），代表我们的（1-12）

4.2 Calendar类中常见的方法

方法名	说明
public int get(int field);	返回给定日历字段的值
public abstract void add(int field,int amount);	根据日历的规则，将指定的时间量添加或减去给定的日历字段
public final void set(int year,int month,int date);	设置当前的日历年月日



```java
public static void main(String[] args) {
  //获取一个Calendar对象
  Calendar c = Calendar.getInstance();//多态形式
  System.out.println(c);
  //获取Calendar对象中的某个数值
  int year = c.get(Calendar.YEAR);
  System.out.println("Year:"+year);

  int month = c.get(Calendar.MONTH );
  System.out.println("Month: "+month);

  int day = c.get(Calendar.DAY_OF_MONTH);
  System.out.println("Day: "+day);
}

public static void main(String[] args) {
  //获取一个Calendar对象
  Calendar c = Calendar.getInstance();
  System.out.println(c);
  //修改Calendar对象中某个成员的值
  c.set(Calendar.YEAR,3000);
  c.set(Calendar.MONTH,3);
  c.set(Calendar.DAY_OF_MONTH,20);
  print(c);
  //增加Calendar对象中某个成员的值
  c.add(Calendar.YEAR,20);
  c.add(Calendar.MONTH,3);
  c.add(Calendar.DAY_OF_MONTH,20);
  print(c);
}
```

注意：
a.Calender类中，month从0-11，我们是1-12
b.时间日期，也有大小之分，时间越靠后，我们认为其越大

五. Math类
5.1 Math类的介绍
Math中主要包含了一些数学运算相关的方法
Math类中这些方法都是静态的（通过类名就可以直接调用,Math当作一个工具类）

5.2 常用方法

```java
public static double abs(double d);//求绝对值
public static double ceil(double d);//向上取整
public static double floor(double d);//向下取整
public static int round(float d);//四舍五入到整数

public static int max(int a,int b);//返回两个int值中的较大值
public static int min(int a,int b);//返回两个int值中的较小值
public static double pow(double a,double b);//求次幂,返回a的b次幂的值

public static double random();//返回值为double的正值，[0.0,1.0]
```


注意：
ceil只要有小数部分不是0，就向整数位进1
floor无论如何，小数部分不要，只要整数部分
Math.ceil(3.0);==> 3.0
Math.floor(3.0);==> 3.0

六. System
6.1 System类的介绍
The System class contains several useful class fields and methods. It cannot be instantiated.
System类中包含几个静态到变量和静态到方法，且该类不能被实例化（无法被创建对象）

方法名	说明
public static void exit(int status);	终止当前运行的Java虚拟机，非0表示异常终止
public static long currentTimeMillis();	返回当前时间(以毫秒为单位)
System源码表示构造被私有化，故而无法创建对象
源码：

```java
/** Don't let anyone instantiate this class */
private System() {
}
```

6.2 System类到常见用法

1
public static void exit(int status);
作用：退出Java虚拟机

1
public static long currentTimeMillis()
作用：获取当前系统毫秒值

```java
long start_new = System.currentTimeMillis();

StringBuilder s1 = new StringBuilder();
for (int i = 0; i < 5000; i++) {
  s1.append(i);
}

long end_new = System.currentTimeMillis();

System.out.println("time:"+(end_new-start_new));
```

总结：
1.Object：所有类的父类
toString：默认返回的字符串表示，包名.类名@地址名
开发中一般会重写toString，返回对象的内容（command+n自动生成）
注意：实际上不需要手动调用toString方法，因为在使用对象时，编译器会自动调用toString()方法

equals默认比较的是两个对象的地址值，在开发中一般会@override，比较两个对象的内容（属性值）

2.Date & DateFormat

构造方法：
public Date();//当前系统时间
public Date(long millins);//距离基准时间millis毫秒后的时间

成员方法：
public long getTime();//获取当前Date对象距离基准时间的毫秒值
public long setTime(long millins);//设置当前Date对象距离基准时间的毫秒值

SimpleDateFormat<子类> extends DateFormat<抽象类>
构造方法：
public SimpleDateFormat(String 模式/格式);//“yyyy-MM-dd HH:mm:ss”

成员方法：
格式化：
public String format(Date date);
解析：
public Date parse(String time);

3.Calendar
获取对象：
Calendar c = Calendar.getinstance();//返回Calendar的子类对象
成员方法：
public void get(int field);
public void set(int field,int value);
public void add(int field,int value);

4.Math
Math类中方法都是静态的
public static double abs(double d);
public static double ceil(double d);
public static double floor(double d);
public static double rount(double d);
public static double pow(double d);

5.System
System类中方法都是静态的
public static void exit(0);//退出JVM
public static long currentTimeMills();//获取当前时间的毫秒值（用于计算某段代码的运行时间）