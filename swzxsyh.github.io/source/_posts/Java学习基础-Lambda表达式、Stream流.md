---
title: Java学习基础-Lambda表达式、Stream流
date: 2020-03-19 00:48:14
tags:
---

一.Lambda表达式
1.1 函数式编程的思想
尽量简单的格式简化面对对象的复杂语法。
面对对象是以何种形式去做，而函数式编程思想强调是拿什么东西做什么事，而不是强调以何种形式去做。

1.2 冗余的Runnable代码

```java
public class TestRUNNABLEDEMO {
  public static void main(String[] args) {
    Thread t1 = new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println(Thread.currentThread().getName()+"RUNNABLE");
      }
    });

    t1.start();

    //为了避免创建一个新类，不得不创建匿名内部类
    //为了迎合面向对象的语法，只能使用Runnable的实现类
    //重写时，方法必须和接口中一模一样
    //真正需要的其实就是任务代码
  }
}
```
1.3 函数式编程Lambda的体验

```java
Thread t2 =new Thread(()->{
  System.out.println(Thread.currentThread().getName()+"RUNNABLE");
});

t2.start();
```


1.4 Lambda标准格式介绍
(参数列表) -> {方法体; return 返回值;}

详情介绍:
| | |
|———-|:———————————————————————-:|
| (参数列表) | 相当于方法的参数，如果没有参数，那么只写小括号即可(),注意小括号不能省略 |
| -> | 固定用法，代码拿着前面的参数，做什么事 |
| {} | 大括号中先写计算过程，如果有返回值return返回值;如果没有返回值，return语句可以省略 |

1.5 Lambda的参数和返回值



```java

public class Test_ComparatorDemo {
  public static void main(String[] args) {
    Integer[] num = {4, 5, 61, 7, 8, 9, 34, 56, 345};
    Arrays.sort(num);
    System.out.println(Arrays.toString(num));

    Arrays.sort(num, new Comparator<Integer>() {
      @Override
      public int compare(Integer o1, Integer o2) {
        return o1 - o2;
      }
    });
    System.out.println(Arrays.toString(num));

    public class Test_ComparatorDemo {
      public static void main(String[] args) {
        Integer[] num = {4, 5, 61, 7, 8, 9, 34, 56, 345};
        //使用Lambda表达式改写上方冗余代码
        Arrays.sort(num, (Integer o1, Integer o2) -> {
          return o2 - o1;
        });
        System.out.println(Arrays.toString(num));
      }
    }

    public class Test_ComparatorDemo {
      public static void main(String[] args) {
        Dog[] dog = new Dog[4];
        dog[0] = new Dog(1, "a", 2);
        dog[1] = new Dog(2, "b", 2);
        dog[2] = new Dog(3, "c", 3);
        dog[3] = new Dog(4, "d", 4);
        Arrays.sort(dog, new Comparator<Dog>() {
          @Override
          public int compare(Dog o1, Dog o2) {
            return o1.age - o2.age;
          }
        });

        for (Dog d : dog) {
          System.out.println(d);
        }

        System.out.println();
      }


      public class Test_ComparatorDemo {
        public static void main(String[] args) {
          Dog[] dog = new Dog[4];
          dog[0] = new Dog(1, "a", 2);
          dog[1] = new Dog(2, "b", 2);
          dog[2] = new Dog(3, "c", 3);
          dog[3] = new Dog(4, "d", 4);

          Arrays.sort(dog,(Dog o1,Dog o2)->{return o2.age-o1.age;});
          for (Dog d : dog) {
            System.out.println(d);
          }
        }
      }
```

1.6 Lambda的省略格式
a.参数类型可以省略
b.如果参数只有一个，那么小括号可以省略
c.如果{}中的代码可以写成一句代码，那么”{}”，”return”关键字和”;”可以同时省略(不能只省略一部分)

```java
new Thread(()->{System.out.println(Thread.currentThread().getName()+"RUNNABLE");}).start();

new Thread(()->System.out.println(Thread.currentThread().getName()+"RUNNABLE")).start();

Arrays.sort(num, (Integer o1, Integer o2) -> {return o2 - o1;});

Arrays.sort(num, (o1, o2) -> o2 - o1);


Arrays.sort(dog, (Dog o1, Dog o2) -> {
  return o2.age - o1.age;
});

Arrays.sort(dog, (o1, o2) -> o2.age - o1.age);
```


1.7 强烈注意：Lambda的使用前提
a.Lambda只能用于替换有且仅有一个抽象方法的接口的匿名内部类对象，这种接口称为函数式接口
b.Lambda具有上下午推断的功能，所以才会出现Lambda的省略格式

二.Stream流
2.1 引入：传统的集合操作

```java
public class TestDemo {
  public static void main(String[] args) {
    List<String > list = new ArrayList<String >();
    Collections.addAll(list,"zaa","wdt","xcs","zd","lf");

    ArrayList<String > z = new ArrayList<String>();
    for (String name:list){
      if(name.startsWith("z")){
        z.add(name);
      }
    }

    ArrayList<String > Three = new ArrayList<String>();
    for (String name:list){
      if(name.length()==3){
        Three.add(name);
      }
    }

    System.out.println(z);
    System.out.println(Three);
  }
}
```

2.2 循环遍历的弊端分析
Lambda注重于做什么，传统的面向对象注重于怎么做

```java
for (String name:list){
  if(name.startsWith("z")){
    z.add(name);
  }
}
```


为了解决面向对象的语法复杂形式，引入了一种新的技术:Stream 流式思想

2.3 Stream的优雅写法

1
list.stream().filter(s -> s.startsWith("x")).filter(s -> s.length() == 3).forEach(s -> System.out.println(s));
Stream流的使用
•生成流
通过数据源(集合，数组等)生成流 list.stream();
•中间操作
•终结操作
一个流只能有一个终结操作，当这个操作执行完后，无法再被操作。

2.4 流式思想的概述

2.5 三种获取流的方式
a.Collection集合获取流
Stream s = 集合对象.stream();

b.Map集合不能直接获取流，但是可以间接获取流
map.keySet().stream();获取map的键
map.values().stream();获取map的值流
map.entrySet().stream();获取map的键值对流

c.数组获取流
Stream<数组中元素的类型> A =Stream.of(数据类型…变量名);



```java

public static void main(String[] args) {
  //获取各种容器的流
  //单列集合
  ArrayList<String> list = new ArrayList<String >();
  Stream<String > s1 = list.stream();
  HashMap<String ,Integer> map = new HashMap<String, Integer>(16);
  //键流
  Stream<String> keyStream = map.keySet().stream();
  //值流
  Stream<Integer> valueStream = map.values().stream();
  //键值对流
  Stream<Map.Entry<String,Integer>> entryStream = map.entrySet().stream();

  Integer[] arr = {10,20,30,40};
  Stream<Integer> num =  Stream.of(arr);
  Stream<Integer> nums = Stream.of(11,22,33,44);
}
```

2.6 Stream流中的常用方法
•逐个处理:forEach



```java

public class StreamDemo02 {
  public static void main(String[] args) {
    Stream<Integer> s1 = Stream.of(11, 22, 33, 44);
    //        s1.forEach(new Consumer<Integer>() {
    //            @Override
    //            public void accept(Integer integer) {
    //                System.out.println(integer);
    //            }
    //        });
    s1.forEach(integer -> System.out.println(integer));
  }
}
```

•统计个数:count

```java
public static void main(String[] args) {
  Stream<Integer> s1 = Stream.of(11, 22, 33, 44);
  long count = s1.count();
  System.out.println(count);
}
```

•过滤:filter

```java
//        s1.filter(new Predicate<Integer>() {
//            @Override
//            public boolean test(Integer integer) {
////                if (integer>100000) {
////                    return true;
////                }
//                return integer>1000;
//            }
//        });
Stream<Integer> integerStream = s1.filter(integer -> integer > 1000);
integerStream.forEach( );
```


•取前几个:limit

```java
Stream<Integer> limit = s1.limit(3);
limit.forEach(System.out::println);

```

•跳过前几个:skip

```java
Stream<Integer> skip = s1.skip(2);
skip.forEach(System.out::println);
```


•映射方法:map

```java

//        Stream<String> str = s6.map(new Function<Integer, String>() {
//            @Override
//            public String apply(Integer integer) {
//               return String.valueOf(integer);
//            }
//        });
Stream<String> str = s6.map(s -> String.valueOf(s));
str.forEach(s -> System.out.println(s));
```
mapToInt(ToIntFunction mapper):返回一个IntStream其中包含将给定函数应用于此流的结果

```java
int result = list.stream().mapToInt(Integer::parseInt).sum;
System.out.println(result);
```


•静态方式合并流:concat

```java
public static Stream<T> concat(Stream<T> s1,Stream<T> s2);

Stream<String > s7 = Stream.of("a","b");
Stream<String > s8 = Stream.of("c","d");

Stream<String > ss = Stream.concat(s7, s8);
ss.forEach(s-> System.out.println(s));
```


•静态方式合并流:distinct –返回该流的不同元素(根据Object.equals(Object))组成的流

```java
public static Stream<T> concat(Stream<T> s1,Stream<T> s2);

Stream<String > s7 = Stream.of("a","b","d");
Stream<String > s8 = Stream.of("c","d","a");

Stream<String > ss = Stream.concat(s7, s8).distinct().forEach(System.out::println);
```


•sorted():返回由此流的元素组成的流，根据自然顺序排序

```java
public static Stream<T> concat(Stream<T> s1,Stream<T> s2);

Stream<String > s7 = Stream.of("a","b");
Stream<String > s8 = Stream.of("c","d");

Stream<String > ss = Stream.concat(s7, s8).sorted((s1,s2)->{
  int num = s1.len()-s2.length();
  int num2 = num==0?s1.compareTo(s2):sum;
  return sum2;
}).forEach(System.out::println);
```



•sorted(Comparator comparator):返回由该流的元素组成的流，根据提供的comparator进行排序

注意：
a.如果是两个以上流的合并，需要多次两两合并
有filter,limit,skip,map,concat

b.如果两个流的泛型不一致也可以合并，合并之后新流的泛型是他们的共同父类
有forEach,count

2.7 练习：集合元素的处理(Stream方式)



```java

public class StreamDemo04_Lambda {
  public static void main(String[] args) {
    List<String> s1 = new ArrayList<String>();
    List<String> s2 = new ArrayList<String>();
    Collections.addAll(s1, "aa", "abc", "abcd");
    Collections.addAll(s2, "ba", "cd", "ccc", "abcd");

    Stream<String> a = s1.stream().filter(s -> s.length() == 3).limit(3);

    Stream<String> b = s2.stream().filter(s -> s.startsWith("a")).skip(2);

    Stream<String> ss = Stream.concat(a, b);

    Stream<Person> personStream = ss.map(s -> new Person(s));

    personStream.forEach(System.out::println);

  }
}
```

2.8 总结：函数拼接和终结方法
函数拼接方法：
调用该方法之后，返回还是一个流对象。
由于这种方法返回的还是流对象，因此支持链式编程

终结方法：
调用该方法之后，返回值不是流或无返回值
由于终结方法返回的不是流对象，因此不支持链式编程，并且当某个流调用终结方法之后，该流就关闭了，不能继续调用其他方法

2.9 收集Stream的结果

可以把流收集到集合中:调用流的collect方法即可
可以把流收集到数组中:调用toArray()方法即可



```java

public class StreamDemo03 {
  public static void main(String[] args) {
    Stream<Integer> s1 = Stream.of(1, 2, 3, 4, 5);
    Stream<Integer> s2 = Stream.of(1, 2, 3, 4, 5);
    Stream<Integer> s3 = Stream.of(1, 2, 3, 4, 5);
    //收集到集合
    List<Integer> collect = s1.collect(Collectors.toList());
    System.out.println(collect);

    //收集到Set
    Set<Integer> collect1 = s2.collect(Collectors.toSet());
    System.out.println(collect1);

    //收集到数组
    Object[] objects = s3.toArray();

    for(Object obj:objects){
      System.out.println(obj);
    }
  }
}
```

注意:
a.一个流只能收集一次（第二次会报错）
b.如果收集到数组，默认是Object数组；

总结：
1.Lambda
标准格式:(参数列表)->{方法体;return 返回值;}
省略格式:
参数类型可省略
只有一个参数，小括号可省略
如果{}中只有一句代码，那么{} ; return可省略
2.Stream流
a.集合或者数组获取流的方法
Stream s = 集合.stream();//单列集合
Stream s = Stream.of(数组/可变参数); //数组获取流
b.调用流的各种方式
filter limit skip map count foreach concat