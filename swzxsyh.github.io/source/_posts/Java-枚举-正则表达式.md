---
title: Java 枚举&正则表达式
date: 2020-04-01 00:59:02
tags:
---

一.枚举
1.1 不使用枚举存在的问题

```java
public class TestPerson {
  public static void main(String[] args) {
    Person a = new Person("A","male");
    System.out.println(a);    Person person = new Person("B", "female");
    System.out.println(person);

    //此时由于性别为String类型,赋值任意字符串均可
    //但是性别也是应该有要求的
    //这就是不使用枚举可能出现的问题
  }}
```

1.2 枚举的作用与应用场景
什么是枚举:是一种特殊的类,把所有可能的情况一一列举出来

什么时候使用枚举：当某个数据的值是固定有限的,就可以使用枚举把其值一一列举出来

1.3 枚举的基本语法
定义枚举的格式
public enum 枚举名{
//枚举项
枚举项1,枚举项2,枚举项3;
}

枚举的入门案例


```java
public enum GenderEnum {
  Male,Female,Trans;
}

public class Person {
  private String name;
  //任何值都可以，数据不正常
  //private String gender;

  private GenderEnum gender;

  public Person() {
  }

  public Person(String name, GenderEnum gender) {
    this.name = name;
    this.gender = gender;
  }

  @Override
  public String toString() {
    return "Person{" +
      "name='" + name + '\'' +
      ", gender='" + gender + '\'' +
      '}';
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public GenderEnum getGender() {
    return gender;
  }

  public void setGender(GenderEnum gender) {
    this.gender = gender;
  }}

public class TestPerson {
  public static void main(String[] args) {
    Person a = new Person("A",GenderEnum.Male);
    System.out.println(a);
    Person person = new Person("B", GenderEnum.Female);
    System.out.println(person);
  }}
```

枚举的本质
枚举的本质其实就是一个类,本质其实是当前类的一个对象

```java
public enum GenderEnum {
  Male,Female,Trans;
  //既然枚举是一个类，那么就可以添加喜欢的成员变量和成员方法，甚至构造方法
}
//本质==>
public final class GenderEnum extends java.lang.Enum<GenderEnum>{
  public static final GenderEnum Male = new GenderEnum();
  public static final GenderEnum Female = new GenderEnum();
  public static final GenderEnum Trans = new GenderEnum();
  //构造方法是私有化的
  private GenderEnum(){}}
```

枚举本质是一个类，那么就可以在枚举中添加各种成员变量，成员方法，构造方法等
成员变量和成员方法和普通类没有区别
构造方法:
a.必须是私有的
b.使用时 枚举项(参数)

```java
public enum Sex {
  Male(10),Female(20),Yao(30);
  //既然枚举是一个类,那么我们就可以添加我们喜欢的成员变量和成员方法和构造方法
  private int age;
  public void showAge(){
    System.out.println(age);
  }

  private Sex(){}

  private Sex(int age){
    this.age = age;
  }
}
```

枚举的应用场景
```java
枚举表示性别：
  public enum Sex { 
  MAIL, FEMAIL; 
}
枚举表示方向:
public enum Orientation { 
  UP, RIGHT, DOWN, LEFT; 
}
枚举表示季度:
public enum Season { 
  SPRING, SUMMER, AUTUMN, WINTER; 
}
```


二.JDK8的其他新特性
2.1 方法引用
方法引用介绍
所谓方法引用，就是把已经存在的方法，直接拿过来使用。
当我们可以一个函数式接口赋值时，赋值该接口的实现类对象，也可以赋值该接口的匿名内部类对象，也可以赋值符合接口的Lambda表达式，也可以使用方法引用



```java
public class Dog {
  public static void bark(){
    System.out.println("Thread Dog Bark");
  }
  public void bark1(){
    System.out.println("Thread Dog Bark_1");
  }
}
public class Method_References_Demo {
  public static void main(String[] args) {
    //1.创建一个线程，使用实现的方法
    //a.使用接口的实现类对象，给Runnable接口类型赋值
    new Thread(new MyRunnable()).start();

    //b.使用接口的匿名内部类对象，给Runnable赋值
    new Thread(new MyRunnable() {
      @Override
      public void run() {
        System.out.println("Thread run...");
      }
    }).start();

    //C.使用lambda直接给Runnable接口类型赋值
    new Thread(() -> System.out.println("Thread run..."));

    //把已经存在的方法直接引用过来
    new Thread(Dog::bark).start();//通过类名引用静态方法
    Dog  dd = new Dog();
    new Thread(dd::bark1).start();//通对象名引用成员方法

  }}
class MyRunnable implements Runnable {
  @Override
  public void run() {
    System.out.println("Thread run...");
  }}
```

方法引用基本使用格式

表头	表头
通过类名引用其中的静态方法	类名::静态方法
通过对象引用其中的普通方法	对象名::普通方法名
通过类名引用其构造方法	类名::new Person o = new Person();
通过数组引用其构造方法	数据类型[]::new int[] arr = new int[10];
基于System.out.println这个方法引用的代码演示



```java
public class SystemOutPrintlnDemo {
  public static void main(String[] args) {
    List names = new ArrayList();
    Collections.addAll(names,"a","b","c");

    names.stream().forEach(new Consumer() {
      @Override
      public void accept(Object o) {
        System.out.println(o);
      }
    });

    names.forEach(new Consumer() {
      @Override
      public void accept(Object o) {
        System.out.println(o);
      }
    });
    names.forEach(o-> System.out.println(o));

    names.forEach(System.out::println);
  }}
```

2.2 Base64
什么是Base64
一种常见的编码方案

Base64内嵌类和方法

Decoder和Encoder
UrlDecoder和UrlEncoder
MimeDecoder和MimeDecoder

String encodeToString(byte[] bs); //编码  
byte[] decode(String str);//解码
代码演示

```java

public class Base64Demo {
  public static void main(String[] args) {
    //基于普通字符串的编码解码
    String encodeToString = Base64.getEncoder().encodeToString("HelloWorld".getBytes());
    System.out.println(encodeToString);

    byte[] bytes = Base64.getDecoder().decode(encodeToString);
    System.out.println(new String(bytes));

    //基于URL的编码解码
    String encodeToString_Url = Base64.getEncoder().encodeToString("www.Oracle.com/index.html".getBytes());
    System.out.println(encodeToString_Url);

    byte[] Url_bytes = Base64.getDecoder().decode(encodeToString_Url);
    System.out.println(new String(Url_bytes));

    //MIME类型的编码器和解码器
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < 10; i++) {
      UUID uuid = UUID.randomUUID();
      sb.append(uuid.toString());
    }
    String content = sb.toString();
    String MIMEEncode = Base64.getMimeEncoder().encodeToString(content.getBytes());
    System.out.println(MIMEEncode);

    byte[] MIMEDecode = Base64.getMimeDecoder().decode(MIMEEncode);
    System.out.println(MIMEDecode);

    String  MIMEEncode2 = Base64.getMimeEncoder(8, "-".getBytes()).encodeToString(content.getBytes());
    System.out.println(MIMEEncode2);

    byte[] MIMEDecode2 = Base64.getMimeDecoder().decode(MIMEEncode);
    System.out.println(MIMEDecode2);
  }}
```
三.正则表达式
3.1 正则表达式的概念及演示
什么是正则：正则是一个字符串，但是里面的内容表示某种规则(规则是有具体语法含义)

```java

public class Non_RegularExpression {
  public static void main(String[] args) {
    System.out.println("Input Number");
    String scanner = new Scanner(System.in).next();

    if (scanner.length() < 5 || scanner.length() > 15) {
      System.out.println("Illegal Number");
      return;
    }

    for (int i = 0; i < scanner.length(); i++) {
      char ch = scanner.charAt(i);
      if (ch < '0' || ch > '9') {
        System.out.println("Illegal Number");
        return;
      }
    }

    if (scanner.charAt(0) == '0') {
      System.out.println("Illegal Number");
      return;
    }

    System.out.println("Legal");
  }}
public class TestRegularExpression {
  public static void main(String[] args) {
    System.out.println("Input Number");
    String scanner = new Scanner(System.in).next();
    boolean matches = scanner.matches("[1-9]\\d{4,14}");
    System.out.println(matches);
  }}
```
3.2 正则表达式 - 字符类
表头	表头
[abc]	代表a或者b，或者c字符中的一个。
[^abc]	代表除a,b,c以外的任何字符。
[a-z]	代表a-z的所有小写字符中的一个。
[A-Z]	代表A-Z的所有大写字符中的一个。
[0-9]	代表0-9之间的某一个数字字符。
[a-zA-Z0-9]	代表a-z或者A-Z或者0-9之间的任意一个字符。
[a-dm-p]	a 到 d 或 m 到 p之间的任意一个字符。

```java
public class TestDemo02 {
    public static void main(String[] args) {
        String str = "aad";
        //1.验证str是否以h开头，以d结尾，中间是a,e,i,o,u中某个字符
        System.out.println("1." + str.matches("h[aeiou]d"));
        //2.验证str是否以h开头，以d结尾，中间不是a,e,i,o,u中的某个字符
        System.out.println("2." + str.matches("h[^aeiou]d"));
        //3.验证str是否a-z的任何一个小写字符开头，后跟ad
        System.out.println("3." + str.matches("[a-z]ad"));
        //4.验证str是否以a-d或者m-p之间某个字符开头，后跟ad
        System.out.println("4." + str.matches("[a-dm-p]ad"));
    }
}    
```

3.3 正则表达式 - 逻辑运算符
表头	表头
&&	与
|	非

```java
/**

 * 正则表达式逻辑运算符类
   */
   public class TestDemo03 {
   public static void main(String[] args) {
       String str = "bad";
       //1.要求字符串是否是除a、e、i、o、u外的其它小写字符开头，后跟ad
       System.out.println("1." + str.matches("[a-z&&[^aeiou]]ad"));
       //2.要求字符串是aeiou中的某个字符开头，后跟ad
       System.out.println("2." + str.matches("[a|e|i|o|u]ad"));
   }
   } 
```

3.4 正则表达式 - 预定义字符
表头	表头
.	匹配任何字符。
\d	任何数字[0-9]的简写;
\D	任何非数字[^0-9]的简写;
\s	空白字符:[ \t\n\x0B\f\r] 的简写
\S	非空白字符:[^\s] 的简写
\w	单词字符:[a-zA-Z_0-9]的简写
\w	非单词字符:[^\w]

```java
/**

 * 正则表达式-预定义字符
   */
   public class TestDemo04 {
   public static void main(String[] args) {
       String str = "had.";
       //1.验证str是否3位数
       System.out.println("1." + str.matches("\\d\\d\\d"));
       //2.验证手机号：1开头，第二位：3/5/8，剩下9位都是0-9的数字
       System.out.println("2." + str.matches("1[3|5|8]\\d\\d\\d\\d\\d\\d\\d\\d\\d"));
       //3.验证字符串是否以h开头，以d结尾，中间是任何字符 str = "had";//要验证的字符串
       System.out.println("3." + str.matches("h.d"));
       //4.验证str是否是：had.
       System.out.println("4." + str.matches("had\\."));
   }
   }    
   
```

3.5 正则表达式 - 数量词
   表头	表头
   X?	0次或1次
   X*	0次到多次
X+	1次或多次
X{n}	恰好n次
X{n,}	至少n次
X{n,m}	n到m次(n和m都是包含的)

```java

public class TestDemo05 {
  public static void main(String[] args) {
    String str = "234";
    //1.验证str是否是三位数字
    System.out.println("1."+str.matches("\\d{3}"));
    //2.验证str是否是多位数字
    System.out.println("2."+str.matches("\\d{2,}"));
    //3.验证str是否是手机号:
    System.out.println("3."+str.matches("1[3|6|8]\\d{9}"));
    //4.验证小数:必须出现小数点，但是只能出现1次
    System.out.println("4."+str.matches("\\d+\\.\\d+"));
    //5.验证小数:小数点可以不出现，也可以出现1次
    System.out.println("5."+str.matches("\\d+\\.?\\d+"));
    //6.验证小数:要求匹配:3、3.、3.14、+3.14、-3.
    System.out.println("6."+str.matches("[+-]\\d+\\d?\\d*"));
    //7.验证qq号码:
    // 1).5--15位;
    // 2).全部是数字;
    // 3).第一位不是0
    System.out.println("7."+str.matches("[1-9]\\d{4,14}"));}
}
```


3.6 正则表达式 - 分组括号()


```java
public class TestDemo06 {
  public static void main(String[] args) {
    String str = "DG8FV-B9TKY-FRT9J-99899-XPQ4G";
    //验证这个序列号:分为5组，每组之间使用-隔开，每组由5位A-Z或者0-9的字符组成
    System.out.println(str.matches("([A-Z0-9]{5}-){4}[A-Z0-9]{5}"));}
}
```
3.7 String的split方法
public String[] split(String regex)//用regex正则表达式的符号作为”分隔符”来切割字符串。

```java

public class TestDemo07 {
  public static void main(String[] args) {
    String str = "18 4 567 99 56";
    String[] split = str.split(" +");

    for (String num:split
        ) {
      System.out.println(num);
    }
  }}
```
3.8 String类的replaceAll方法
public String replaceAll(String regex,String newStr)//将当前字符串的旧串替换为新串，其他旧串可以使用正则匹配

```java
public class TestDemo08 {
  public static void main(String[] args) {
    //将下面字符串中的"数字"替换为"*"
    String str = "jfdk432jfdk2jk24354j47jk5l31324";
    System.out.println(str.replaceAll("\\d", "*"));
    //将所有相邻数字只替换成一个*
    System.out.println(str.replaceAll("\\d+", "*"));

    String newstr = "jjjjjjjjjfddddddk43222222222jfddddddddddkkkkkkkkkk2jk24354j47jk5l31324";
    System.out.println(newstr.replaceAll( "(.)\\1+" ,   "$1"));
  }}
```
总结：
定义枚举

定义：
public enum 枚举名{
//枚举项
枚举项1,枚举项2,枚举项3;
}

枚举名 变量名 = 枚举名.枚举项1;

方法的引用
集合对象.foreach(System.out::println)

Base64对基本数据，URL和MIME类型进行编码
public String encodeToString(byte[] bs); //编码
public byte[] decode(String str);//解码

正则表达式作用：”匹配”字符串

正则表达式对字符类
[abc] [^abc] [a-z] [A-Z] [0-9] [a-zA-Z0-9] [a-dm-p]

正则表达式的逻辑运算符类
&& |

正则表达式的预定义字符类
. \d \D \s \S \w \W

正则表达式的分组
(…){2}

String的split方法中使用正则表达式

String的replaceAll方法中使用正则表达式