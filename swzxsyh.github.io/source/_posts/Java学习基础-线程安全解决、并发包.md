---
title: Java学习基础-线程安全解决、并发包
date: 2020-03-16 00:43:34
tags:
---

一.synchronized关键字
1.1 AtomicInteger不足之处
回顾：可以保证对”变量”操作是原子性的（有序性，可见性）

无法解决：多行代码的原子性

1.2 多行代码的原子性安全问题——卖票案例



```java

public class TicketTask implements Runnable {
  int count = 100;
  @Override
  public void run() {
    while (true) {
      if (count > 0) {

        try {
          Thread.sleep(10);
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
        System.out.println("Sold" + count);
        count--;
      } else {
        break;
      }
    }
  }
}


public class TestDemo {
  public static void main(String[] args) {
    TicketTask tt = new TicketTask();
    Thread t1 = new Thread(tt);
    Thread t2 = new Thread(tt);
    Thread t3 = new Thread(tt);

    t1.start();
    t2.start();
    t3.start();
    //线程出现安全问题
    //可能出现重复票据
    //还可能出现0甚至-1这种非法数据
  }
}
```

重复数据原因：当一个线程执行完卖票后，还没来得及对票数-1，就被其他线程抢走了CPU，导致其他线程也卖出了一样的票
非法数据原因：当剩下最后一张票时，多个线程都经过了if判断，进入卖票的代码块中，依次卖出1，0，-1张票

1.3 synchronized关键字介绍
a.synchronized是什么：synchronized是Java的关键字
b.synchronized作用：可以让多句代码具有原子性（当某个线程执行多句代码的过程中不被其他线程打断）

1.4 解决方法1:同步代码块
synchronized(锁对象){
需要同步的代码（需要保持原子性的代码）
}

```java
public class TicketTask implements Runnable {
  int count = 100;
  Object obj = new Object();
  @Override
  public void run() {
    while (true) {
      synchronized (obj) {
        if (count > 0) {
          System.out.println("Sold" + count);
          count--;
        } else {
          break;
        }
      }
    }
  }
}


public class TestDemo {
  public static void main(String[] args) {
    TicketTask tt = new TicketTask();
    Thread t1 = new Thread(tt);
    Thread t2 = new Thread(tt);
    Thread t3 = new Thread(tt);

    t1.start();
    t2.start();
    t3.start();
  }
}
```

1.5 解决方法2:同步方法
格式：
public synchronized void 方法名(){

}

```java

public class TicketTask implements Runnable {
  int count = 100;
  @Override
  public void run() {
    while (true) {
      sellTicket();
    }
  }

  public synchronized void sellTicket() {//默认当前任务对象
    if (count > 0) {
      System.out.println("Sold" + count);
      count--;
    }
  }
}

public class TestDemo {
  public static void main(String[] args) {
    TicketTask tt = new TicketTask();
    Thread t1 = new Thread(tt);
    Thread t2 = new Thread(tt);
    Thread t3 = new Thread(tt);

    t1.start();
    t2.start();
    t3.start();
  }
}
```

注意：
a.同步代码块和同步方法原理差不多，到底是同步代码块的同步锁需要自己指定，而同步方法的同步锁默认使用当前对象this
b.同步代码块可以是static的，如果同步方法是static的，默认使用当前类的字节码文件(.class文件)作为锁对象。

1.6 解决方法3：Lock锁
Lock是一个接口，我们需要使用其实现类ReentrantLock
ReentrantLock的API:
public ReentrantLock();
public void lock();//加锁
public void unlock();//解锁
格式：
ReentrantLock lock = new ReentrantLock();
lock.lock();//加锁
lock.unloc();//解锁

解决代码：





```java
public class TicketTask implements Runnable {
  int count = 100;
  //创建一个lock锁
  Lock lock = new ReentrantLock();
  @Override
  public void run() {
    while (true) {
      lock.lock();
      if (count > 0) {
        try {
          Thread.sleep(10);
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
        System.out.println("Sold" + count);
        count--;
      } else {
        break;
      }
      lock.unlock();
    }
  }
}

public class TestDemo {
  public static void main(String[] args) {
    TicketTask tt = new TicketTask();
    Thread t1 = new Thread(tt);
    Thread t2 = new Thread(tt);
    Thread t3 = new Thread(tt);

    t1.start();
    t2.start();
    t3.start();
  }
}
```

二.并发包
什么是并发包：这是JDK提供的，包含一个在高并发情况使用集合或工具，

2.1 CopyOnWriteArrayList
arraylist线程是不安全的(ArrayIndexOutOfBoundsException)，需要CopyOnWriteArrayList

```java
public class Mythread extends Thread{
  //    public static List<Integer> list = new ArrayList<>();//ArrayIndexOutOfBoundsException
  public static List<Integer> list = new CopyOnWriteArrayList<>();

  @Override
  public void run() {
    for (int i = 0; i < 10000; i++) {
      list.add(i);
    }
    System.out.println("Done");
  }
}

public class TestArrayList {
  public static void main(String[] args) throws InterruptedException {
    Mythread mt1 = new Mythread();
    Mythread mt2 = new Mythread();
    mt1.start();
    mt2.start();

    Thread.sleep(1000);
    System.out.println(Mythread.list.size());
  }
}
```
2.2 CopyOnWriteArraySet

```java

public class TestHashSet {
  public static void main(String[] args) throws InterruptedException {
    MyThread mt1 = new MyThread();
    mt1.start();

    for (int i = 10000; i < 20000; i++) {
      MyThread.set.add(i);
    }

    Thread.sleep(1000);
    System.out.println(MyThread.set.size());
  }
}

public class Mythread extends Thread {
  //    public static List<Integer> list = new ArrayList<>();
  public static List<Integer> list = new CopyOnWriteArrayList<>();
  @Override
  public void run() {
    for (int i = 0; i < 10000; i++) {
      list.add(i);
    }
    System.out.println("Done");
  }
}
```

2.3 ConcurrentHashMap




```java

public class MyThread extends Thread {
  //public static HashMap<Integer,Integer> map = new HashMap<Integer, Integer>();
  //    public static Map<Integer, Integer> map = new Hashtable<Integer, Integer>();
  public static ConcurrentHashMap<Integer, Integer> map = new ConcurrentHashMap<Integer, Integer>();
  @Override
  public void run() {
    long start = System.currentTimeMillis();
    for (int i = 0; i < 100000; i++) {
      map.put(i, i);
    }
    long end = System.currentTimeMillis();
    System.out.println("Done "+(end-start));
  }
}

public class TestHashMap {
  public static void main(String[] args) throws InterruptedException {
    //        MyThread mt1 = new MyThread();
    //
    //        mt1.start();
    //
    //        for (int i = 10000; i < 20000; i++) {
    //            MyThread.map.put(i,i);
    //        }
    for (int i = 0; i < 1000; i++) {
      new MyThread().start();
    }
    Thread.sleep(1000*20);
    System.out.println(MyThread.map.size());
  }
}
```

小结：
HashMap线程不安全(多线程不能操作同一个HashMap)
Hashtable线程安全(多线程可以操作同一个HashMap)，但是效率低
ConcurrentHashMap 线程安全的，并且效率较高

•为什么Hashtable效率低：Hashtable锁定整个哈希表，一个操作正在进行时
•为什么ConcurrentHashMap效率高：局部锁定(CAS)，只锁定链表(桶)。对当前元素锁定时，它元素不锁定。

2.4 CountDownLatch
•CountDownLatch的作用:允许当前线程，等待其他线程完成某种操作之后，当前线程继续执行
•CountDownLatch的API
构造方法:
public CountDownLatch(int count);//初始化，需要传入计数器，需要等待的线程数
成员方法:
public void await() throws InterruptedException();//让当前线程等待
public void countDown()//计数器减1

•CountDownLatch使用案例
需求：
线程1需要执行打印:A和C，线程2要执行打印B
需要结果：线程1打印A，线程2打印B，之后线程A打印C，输出A B C





```java
public class MyThread1 extends Thread {
  private CountDownLatch latch;
  public MyThread1(CountDownLatch latch) {
    this.latch = latch;
  }

  @Override
  public void run() {
    System.out.println("A");
    try {
      latch.await();
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
  }
}

public class MyThread2 extends Thread {
  private CountDownLatch latch;
  public MyThread2(CountDownLatch latch) {
    this.latch = latch;
  }

  @Override
  public void run() {
    System.out.println("B");
    latch.countDown();
    System.out.println("D");
  }
}

public class TestCountDownLatch {
  public static void main(String[] args) {
    //创建CountDownLatch
    CountDownLatch latch = new CountDownLatch(1);
    MyThread1 mt1 = new MyThread1(latch);
    MyThread2 mt2 = new MyThread2(latch);

    mt1.start();
    mt2.start();
  }
}
```

2.5 CyclicBarrier
•CyclicBarrier的作用:让多个线程都到达了某种要求之后，新的任务才能执行
•CyclicBarrier的API
构造方法：
public CycliBarrier(int parties,Runnable barrierAction);
//parties【需要多少线程】，Runnable barrierAction)【所有线程都满足要求了，执行任务】

成员方法：
public int await();//当所有线程都到达了，需要调用await

•CyclicBarrier使用案例





```java
public class PersonThread extends Thread {
  private CyclicBarrier cb1;
  public PersonThread(CyclicBarrier cb1){
    this.cb1 = cb1;
  }

  @Override
  public void run() {
    try {
      Thread.sleep((int) (Math.random()) * 1000);
      System.out.println(Thread.currentThread().getName() + "Done");
      cb1.await();
    } catch (InterruptedException | BrokenBarrierException e) {
      e.printStackTrace();
    }
  }

}

public class TestPersonThread {
  public static void main(String[] args) {
    CyclicBarrier cb1 = new CyclicBarrier(5,new Runnable(){
      @Override
      public void run() {
        System.out.println("Done");
      }
    });
    PersonThread pt1 = new PersonThread(cb1);
    PersonThread pt2 = new PersonThread(cb1);
    PersonThread pt3 = new PersonThread(cb1);
    PersonThread pt4 = new PersonThread(cb1);
    PersonThread pt5 = new PersonThread(cb1);

    pt1.start();
    pt2.start();
    pt3.start();
    pt4.start();
    pt5.start();
  }
}
```

2.6 Semaphore
•Semaphore的作用:用于控制并发线程的数量

•Semaphore的API：
构造方法：
public Semaphore(int permits);//参数permit表示最多有多少个线程并发执行
成员方法：
public void acquire();//获取线程许可证
public void release();//释放线程许可证

•Semaphore使用案例





```java
public class MyThread extends Thread{
  private Semaphore semaphore;
  public MyThread(Semaphore semaphore){
    this.semaphore= semaphore;
  }
  @Override
  public void run() {
    try {
      semaphore.acquire();
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
    System.out.println(Thread.currentThread().getName()+" "+System.currentTimeMillis());
    try {
      Thread.sleep(1000*new Random().nextInt(6));
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
    //        System.out.println(Thread.currentThread().getName());
    System.out.println(Thread.currentThread().getName()+" "+System.currentTimeMillis());
    semaphore.release();
  }
}

public class TestDemo {
  public static void main(String[] args) {
    Semaphore semaphore = new Semaphore(3);

    for (int i = 0; i < 10; i++) {
      new MyThread(semaphore).start();
    }
  }
}
```

2.7 Exchanger
•Exchanger的作用:用于线程间的数据交换

•Exchanger的API：
构造方法：
public Exchanger();

成员方法：
public exchanger();//参数发送给别的线程的数据，返回值返回的数据

•Exchanger使用案例




```java

public class MyThread1 extends Thread {
  private Exchanger<String> exchanger;
  public MyThread1(Exchanger<String> exchanger) {
    this.exchanger = exchanger;
  }

  @Override
  public void run() {
    System.out.println("MyThread-1 send to Thread-2");

    String result = null;

    try {
      result = exchanger.exchange("Get Thread-1");
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
    System.out.println("Thread1 Get:"+result);
  }
}

public class MyThread2 extends Thread {
  private Exchanger<String > exchanger;
  public MyThread2(Exchanger<String > exchanger){
    this.exchanger=exchanger;
  }

  @Override
  public void run() {
    System.out.println("MyThread-2 send to Thread-1");

    String result = null;

    try {
      result = exchanger.exchange("Get Thread-2");
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
    System.out.println("Thread2 Get:"+result);
  }
}

public class TestDemo {
  public static void main(String[] args) {
    Exchanger<String> exchanger = new Exchanger<String>();

    MyThread1 mt1 = new MyThread1(exchanger);
    MyThread2 mt2 = new MyThread2(exchanger);

    mt1.start();
    mt2.start();
  }
}
```

总结：
使用同步代码块解决线程安全问题
synchronized(锁对象){
需要同步的代码（需要保证原子性的代码）
}
使用同步方法解决线程安全问题
public synchronized void 方法名(){
需要同步的代码（需要保证原子性的代码）
}
使用Lock锁解决线程安全问题
Lock lock = new ReentrantLock();
lock.lock();
需要同步的代码（需要保证原子性的代码）
lock.unlock();

说明volatile关键字和synchronize关键字区别
volatile能解决有序性和可见性
原子类 能解决变量的原子性(有序性和可见性)
synchronized 能解决多句代码的原子性（有序性和可见性）

描述CopyOnWriteArrayList类作用
代替多线程的情况，线程安全的ArrayList集合

描述CopyOnWriteArraySet类作用
代替多线程的情况，线程安全的HashSet集合

描述ConcurrentHashMap类作用
代替多线程的情况，线程安全的HashMap集合，比HashTable效率更高

描述CountDownLatch类作用
可以运行一个线程等待另一个线程执行完毕后再继续执行

描述CycliBarrrier类作用
让一组线程都到达某中调节后再执行某个任务

描述Semaphore类作用
控制多线程并发的最大数量

描述Exchanger类作用
用于线程间的通信（数据交换）