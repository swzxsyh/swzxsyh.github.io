---
title: JAVA-同步容器
date: 2022-07-05 01:24:15
tags:
---

# Java同步容器

> `ArrayList`,`HashSet`,`HashMap`都是线程非安全的,在多线程环境下,会导致线程安全问题,所以在使用的时候需要进行同步,这无疑增加了程序开发的难度。所以JAVA提供了`同步容器`。

## 同步容器

- ArrayList ===> Vector,Stack
- HashMap ===> HashTable(key,value都不能为空)
- Collections.synchronizedXXX(List,Set,Map)

`Vector`实现`List`接口，底层和`ArrayList`类似，但是`Vector`中的方法都是使用`synchronized`修饰，即进行了同步的措施。 但是，`Vector`并不是线程安全的。

`Stack`也是一个同步容器，也是使用`synchronized`进行同步，继承与`Vector`，是数据结构中的，先进后出。

`HashTable`和`HashMap`很相似，但`HashTable`进行了同步处理。

`Collections`工具类提供了大量的方法，比如对集合的排序、查找等常用的操作。同时也通过了相关了方法创建同步容器类

<!-- more -->

## Vector

```java
import java.util.List;
import java.util.Vector;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;
//线程安全
public class VectorExample1 {
  public static Integer clientTotal=5000;
  public static Integer thradTotal=200;
  private static List<Integer> list=new Vector<>();
  public static void main(String[] args) throws Exception{
    ExecutorService executorService = Executors.newCachedThreadPool();
    final Semaphore semaphore=new Semaphore(thradTotal);
    final CountDownLatch countDownLatch=new CountDownLatch(clientTotal);
    for (int i = 0; i < clientTotal; i++) {
      final Integer j=i;
      executorService.execute(()->{
        try {
          semaphore.acquire();
          update(j);
          semaphore.release();
        }catch (Exception e){
          e.printStackTrace();
        }
        countDownLatch.countDown();
      });
    }
    countDownLatch.await();
    executorService.shutdown();
    System.out.println("size:"+list.size());
  }
  private static void update(Integer j) {
    list.add(j);
  }
}
```

#### 同步容器不一定就线程安全

```java
import scala.collection.convert.impl.VectorStepperBase;
import java.util.List;
import java.util.Vector;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;
//线程不安全
public class VectorExample2 {
  public static Integer clientTotal=5000;
  public static Integer threadTotal=200;
  private static List<Integer> list=new Vector();
  public static void main(String[] args) {
    ExecutorService executorService = Executors.newCachedThreadPool();
    final Semaphore semaphore=new Semaphore(threadTotal);
    for (int i = 0; i < threadTotal; i++) {
      list.add(i);
    }
    for (int i = 0; i < clientTotal; i++) {
      try{
        semaphore.acquire();
        executorService.execute(()->{
          for (int j = 0; j < list.size(); j++) {
            list.remove(j);
          }
        });
        executorService.execute(()->{
          for (int j = 0; j < list.size(); j++) {
            list.get(j);
          }
        });
        semaphore.release();
      }catch (Exception e){
        e.printStackTrace();
      }
    }
    executorService.shutdown();
  }
}
```

#### 运行报错

```java
Exception in thread "pool-1-thread-2" java.lang.ArrayIndexOutOfBoundsException: Array index out of range: 36
  at java.util.Vector.get(Vector.java:751)
  at com.rumenz.task.VectorExample2.lambda$main$1(VectorExample2.java:38)
  at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
  at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
  at java.lang.Thread.run(Thread.java:748)
```

#### 原因分析

> `Vector`是线程同步容器,`size()`,`get()`,`remove()`都是被`synchronized`修饰的,为什么会有线程安全问题呢?
>
> `get()`抛出的异常肯定是`remove()`引起的,`Vector`能同时保证同一时刻只有一个线程进入,但是:

```java
//线程1
executorService.execute(()->{
  for (int j = 0; j < list.size(); j++) {
    list.remove(j);
  }
});
//线程2
executorService.execute(()->{
  for (int j = 0; j < list.size(); j++) {
    list.get(j);
  }
});
```

- 线程1和线程2都执行完`list.size()`,都等于200,并且`j=100`
- 线程1执行`list.remove(100)`操作,
- 线程2执行`list.get(100)`就会抛出数组越界的异常。

> 同步容器虽然是线程安全的,但是不代表在任何环境下都是线程安全的。



## HashTable

> 线程安全,`key`,`value`都不能为`null`。在修改数据时锁住整个`HashTable`,效率低下。初始`size=11`。

```java
import java.util.Hashtable;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;
//线程安全
public class HashTableExample1 {
  public static Integer clientTotal=5000;
  public static Integer threadTotal=200;
  private static Map<Integer,Integer> map=new Hashtable<>();
  public static void main(String[] args) throws Exception {
    ExecutorService executorService = Executors.newCachedThreadPool();
    final Semaphore semaphore=new Semaphore(threadTotal);
    final CountDownLatch countDownLatch=new CountDownLatch(clientTotal);
    for (int i = 0; i < clientTotal; i++) {
      final Integer j=i;
      try{
        semaphore.acquire();
        update(j);
        semaphore.release();
      }catch (Exception e){
        e.printStackTrace();
      }
      countDownLatch.countDown();
    }
    countDownLatch.await();
    executorService.shutdown();
    System.out.println("size:"+map.size());
  }
  private static void update(Integer j) {
    map.put(j, j);
  }
}
//size:5000
```



## Collections.synchronizedList线程安全

```java
import com.google.common.collect.Lists;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;
//线程安全
public class synchronizedExample {
  public static Integer clientTotal=5000;
  public static Integer threadTotal=200;
  private static List<Integer> list=Collections.synchronizedList(Lists.newArrayList());
  public static void main(String[] args) throws Exception{
    ExecutorService executorService = Executors.newCachedThreadPool();
    final Semaphore semaphore=new Semaphore(threadTotal);
    final CountDownLatch countDownLatch=new CountDownLatch(clientTotal);
    for (int i = 0; i < clientTotal; i++) {
      final Integer j=i;
      try{
        semaphore.acquire();
        update(j);
        semaphore.release();
      }catch (Exception e){
        e.printStackTrace();
      }
      countDownLatch.countDown();
    }
    countDownLatch.await();
    executorService.shutdown();
    System.out.println("size:"+list.size());
  }
  private static void update(Integer j) {
    list.add(j);
  }
}
//size:5000
```





## Collections.synchronizedSet线程安全

```java
import com.google.common.collect.Lists;
import org.assertj.core.util.Sets;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;
//线程安全
public class synchronizedSetExample {
  public static Integer clientTotal=5000;
  public static Integer threadTotal=200;
  private static Set<Integer> set=Collections.synchronizedSet(Sets.newHashSet());
  public static void main(String[] args) throws Exception{
    ExecutorService executorService = Executors.newCachedThreadPool();
    final Semaphore semaphore=new Semaphore(threadTotal);
    final CountDownLatch countDownLatch=new CountDownLatch(clientTotal);
    for (int i = 0; i < clientTotal; i++) {
      final Integer j=i;
      try{
        semaphore.acquire();
        update(j);
        semaphore.release();
      }catch (Exception e){
        e.printStackTrace();
      }
      countDownLatch.countDown();
    }
    countDownLatch.await();
    executorService.shutdown();
    System.out.println("size:"+set.size());
  }
  private static void update(Integer j) {
    set.add(j);
  }
}
//size:5000
```



## Collections.synchronizedMap线程安全

```java
import org.assertj.core.util.Sets;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;
public class synchronizedMapExample {
  public static Integer clientTotal=5000;
  public static Integer threadTotal=200;
  private static Map<Integer,Integer> map=Collections.synchronizedMap(new HashMap<>());
  public static void main(String[] args) throws Exception{
    ExecutorService executorService = Executors.newCachedThreadPool();
    final Semaphore semaphore=new Semaphore(threadTotal);
    final CountDownLatch countDownLatch=new CountDownLatch(clientTotal);
    for (int i = 0; i < clientTotal; i++) {
      final Integer j=i;
      try{
        semaphore.acquire();
        update(j);
        semaphore.release();
      }catch (Exception e){
        e.printStackTrace();
      }
      countDownLatch.countDown();
    }
    countDownLatch.await();
    executorService.shutdown();
    System.out.println("size:"+map.size());
  }
  private static void update(Integer j) {
    map.put(j, j);
  }
}
//size:5000
```

> `Collections.synchronizedXXX`在迭代的时候,需要开发者自己加上线程锁控制代码,因为在整个迭代过程中循环外面不加同步代码,在一次次迭代之间,其他线程对于这个容器的`add`或者`remove`会影响整个迭代的预期效果,这个时候需要在循环外面加上`synchronized(XXX)`。

## 集合的删除

- 如果在使用foreach或iterator进集合的遍历，
- 尽量不要在操作的过程中进行remove等相关的更新操作。
- 如果非要进行操作，则可以在遍历的过程中记录需要操作元素的序号，
- 待遍历结束后方可进行操作，让这两个动作分开进行

```java
import com.google.common.collect.Lists;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
public class CollectionsExample {
  private static List<Integer> list=Collections.synchronizedList(Lists.newArrayList());
  public static void main(String[] args) {
    list.add(1);
    list.add(2);
    list.add(3);
    list.add(4);
    //del1();
    //del2();
    del3();
  }
  private static void del3() {
    for(Integer i:list){
      if(i==4){
        list.remove(i);
      }
    }
  }
  //Exception in thread "main" java.util.ConcurrentModificationException
  private static void del2() {
    Iterator<Integer> iterator = list.iterator();
    while (iterator.hasNext()){
      Integer i = iterator.next();
      if(i==4){
        list.remove(i);
      }
    }
  }
  //Exception in thread "main" java.util.ConcurrentModificationException
  private static void del1() {
    for (int i = 0; i < list.size(); i++) {
      if(list.get(i)==4){
        list.remove(i);
      }
    }
  }
}
```

> 在单线程会出现以上错误，在多线程情况下，并且集合时共享的，出现异常的概率会更大，需要特别的注意。解决方案是希望在foreach或iterator时，对要操作的元素进行标记，待循环结束之后，在执行相关操作。

## 总结

> 同步容器采用`synchronized`进行同步,因此执行的性能会受到影响,并且同步容器也并不一定会做到线程安全。



###### 来源：

https://rumenz.com/rumenbiji/java-synchronization-container.html
