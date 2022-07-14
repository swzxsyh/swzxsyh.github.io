---
title: Java学习基础-线程池、死锁、线程状态、等待与唤醒
date: 2020-03-18 00:44:09
tags:
---

一.线程池方式
1.1 线程池的思想
需要使用线程时，会临时创建一个线程，然后启动。而线程的创建，以及使用完毕后的销毁，都需要消耗性能的。
因此，
先创建好线程，在需要使用时直接使用，使用完毕后归还，等待下次继续使用，即线程池思想。

1.2 线程池的概念
线程池：其实就是一个容纳多个线程对象的容器，其中的线程可以反复使用，省去了频繁创建/销毁线程对象的操作，无需反复创建线程而消耗过多资源。

1.3 线程池的使用
线程池的顶层接口:
java.util.concuttrent.Executor

线程池的子接口:
java.util.concurrent.ExcutorService

线程池的工具类:其作用是帮助我们创建一个线程池对象(即ExcutorService的实现类对象)
java.util.concuttrent.Executors

工具类中的静态方法:创建一个线程池对象
public static ExecutorService newFixedThreadPool(int nThreads);//用于创建一个具有指定线程个数的线程池对象

如何向线程池中提交任务：
调用ExecutorService接口中规定的方法
public Future submit(Runnable task);//向线程池中提交无返回值的任务 public Future submit(Callable task);//向线程池中提交有返回值的任务，返回Future类型(封装线程执行完毕后结果的那个对象)

1.4 线程池的练习

```java
public class ThreadPool {
  public static void main(String[] args) throws ExecutionException, InterruptedException {
    //使用多态接收
    ExecutorService service = Executors.newFixedThreadPool(3);


    //向线程池中提交无返回值的任务
    //        for (int i = 0; i < 10; i++) {
    service.submit(new Runnable() {
      @Override
      public void run() {
        System.out.println(Thread.currentThread().getName() + " Done");
      }
    });
    //        }

    //向线程池中提交有返回值的任务
    Future<Integer> future = service.submit(new Callable<Integer>() {
      @Override
      public Integer call() throws Exception {
        int sum = 0;
        for (int i = 1; i < 101; i++) {
          sum+=i;
        }
        return sum;
      }
    });
    Integer result = future.get();//get方法具有阻塞功能，会等待任务执行完毕后再返回结果
    System.out.println(result);

    //如果想要整个进程停止,那么需要关闭线程池
    service.shutdown();
  }
}
```
二.死锁
2.1 什么是死锁
在多线程中，有多把锁，最后导致所有的线程都在等待中，造成的现象，称为死锁

2.2 产生死锁的条件
a.至少有2个线程
b.至少有2个锁对象
c.至少有synchronized嵌套

2.3 死锁演示

```java
public static void main(String[] args) {

  //2个锁对象
  Object obj1 = new Object();
  Object obj2 = new Object();

  //2个线程
  new Thread(new Runnable() {
    @Override
    public void run() {
      while (true) {
        //必须有synchronized嵌套
        synchronized (obj1) {
          System.out.println("Thread 1 get obj1 and want obj2");
          //方式一：sleep，不释放锁
          //                    try {
          //                        Thread.sleep(500);
          //                    } catch (InterruptedException e) {
          //                        e.printStackTrace();
          //                    }
          synchronized (obj2) {
            System.out.println("Thread 1 get obj2,execute");
            System.out.println(Thread.currentThread().getName() + "Done");
          }
        }
      }
    }
  }).start();

  new Thread(new Runnable() {
    @Override
    public void run() {
      while (true) {
        synchronized (obj2) {
          System.out.println("Thread 2 get obj2 and want obj1");
          //                    try {
          //                        Thread.sleep(500);
          //                    } catch (InterruptedException e) {
          //                        e.printStackTrace();
          //                    }
          synchronized (obj1) {
            System.out.println("Thread 2 get obj1,execute");
            System.out.println(Thread.currentThread().getName() + "Done");
          }
        }
      }
    }
  }).start();
}
```
注意：如果出现了死锁，无解。只能尽量避免死锁

三.线程状态
3.1 线程的六种状态(A thread state. A thread can be in one of the following states:)
•新建状态-NEW
A thread that has not yet started is in this state.
刚创建，且未调用strat方法的状态

•运行状态-RUNNABLE
A thread executing in the Java virtual machine is in this state.
处于新建状态的线程start方法之后
可运行状态(就绪)
可运行状态(运行)
注意：只有新建状态的线程才能调用start()

•受(锁)阻塞状态-BLOCKED
A thread that is blocked waiting for a monitor lock is in this state.
状态进入：
线程运行过程中，遇到同步方法，线程需要锁对象，但是锁对象已被其他线程持有
状态返回：
其他线程释放锁，当前线程抢到锁，才能从锁阻塞回到可运行状态

•限时等待状态-TIMED_WAITING
A thread that is waiting for another thread to perform an action for up to a specified waiting time is in this state.
状态进入：
线程指定到代码调用Thread.slee(毫秒值)，线程就处于限时等待状态
状态返回：
sleep时间到了，返回RUNNABLE状态

•永久等待-WAITING
A thread that is waiting indefinitely for another thread to perform a particular action is in this state.
状态进入：
当前线程必须持有锁对象
调用锁对象的wait()方法
此时线程就会进入永久等待，进入之前，当前线程会自动释放锁对象
状态返回：
其他线程要持有锁(必须锁刚刚进入无限等待的线程释放的锁)
调用锁对象的notify()方法

注意：被唤醒的线程是没有锁对象的，会进入锁阻塞，直到其他线程释放锁对象，才能进入可运行状态

•TERMINATED
A thread that has exited is in this state.
当线程任务执行完毕，已退出的线程状态(消亡状态)
注意：处于消亡状态的线程，不能再调用start方法

![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80-%E7%BA%BF%E7%A8%8B%E6%B1%A0%E3%80%81%E6%AD%BB%E9%94%81%E3%80%81%E7%BA%BF%E7%A8%8B%E7%8A%B6%E6%80%81%E3%80%81%E7%AD%89%E5%BE%85%E4%B8%8E%E5%94%A4%E9%86%92/thread.svg)

四.等待唤醒机制
4.1 等待唤醒机制(Wait和Notify)

```java
public class TestWating {
  public static void main(String[] args) throws InterruptedException {

    //creat lock
    Object lock = new Object();

    //create thread
    new Thread(new Runnable() {
      @Override
      public void run() {
        synchronized (lock) {
          //get in code block
          System.out.println("Thread A get into Wating");
          System.out.println("Thread A Get Lock");
          try {
            lock.wait();
          } catch (InterruptedException e) {
            e.printStackTrace();
          }
          //wake back to task
          System.out.println("A Wake");
        }
      }
    }).start();

    Thread.sleep(1000);

    //New Threak wake up Thread A
    new Thread(new Runnable() {
      @Override
      public void run() {
        //Same lock Object
        synchronized (lock) {
          System.out.println("Thread B Got Lock");
          System.out.println("Thread B Wake A Up");
          lock.notify();
          for (int i = 0; i < 10; i++) {
            System.out.println(i);
          }
        }
      }
    }).start();
  }
}
```
注意：
a.只有线程进入了线程等待，其他线程调用了notify()才有作用，否则也可以调用刚，但是没有任何作用
b.锁对象.notify方法只能唤醒一个锁对象，具体哪一个是随机的
c.锁对象.notifyAll方法可以唤醒多个线程，谁抢到锁谁执行

4.2 生产者与消费者
生产者与消费者是一个十分经典的多线程协作模式，弄懂生产者消费者问题能对多线程编程的理解更加深刻
所谓生产者消费者问题，实际上包含了两类线程:
•一类是生产者线程用于生产数据
•一类是消费者线程用于消费数据

为了解耦生产者和消费者的关系，通常会采用共享的数据区域，将像是一个仓库
•生产者生产数据之后直接放置在共享区域中，并不需要关系消费者行为
•消费者只需要从共享数据区其获取数据，并不需要关系生产者行为

生产者 —> 共享数据区 <— 消费者

(代码演示)
需求：
生产者消费案例
需要两个线程，线程1包子铺线程，赋值生产包子。线程2吃货线程，赋值吃包子。
如果没有包子，那么吃货线程等待，包子铺线程执行，执行完后唤醒吃货线程。
如果没有包子，那么包子铺线程等待，吃货线程执行，执行完后唤醒包子铺线程。

```java
public class TestDemo {
  public static void main(String[] args) throws InterruptedException {

    ArrayList<String> arr = new ArrayList<String>();
    arr.add("first");

    Thread t1 = new Thread(new Runnable() {
      @Override
      public void run() {
        synchronized (arr) {
          while (true) {

            if (arr.size() > 0) {
              try {
                System.out.println("Bread presence");
                arr.wait();
              } catch (InterruptedException e) {
                e.printStackTrace();
              }
            }
            System.out.println("Add Bread");
            arr.add("bread");
            System.out.println("Bread Done");
            arr.notify();
          }}

      }
    });

    Thread t2 = new Thread(new Runnable() {
      @Override
      public void run() {
        while (true) {

          synchronized (arr) {
            if (arr.size() == 0) {
              try {
                System.out.println("No bread");
                arr.wait();
              } catch (InterruptedException e) {
                e.printStackTrace();
              }
            }
            System.out.println("Ate bread");
            arr.remove(0);
            System.out.println("Call Boss");
            arr.notify();
          }}
      }
    });
    t1.start();
    t2.start();
  }
}
```
五.定时器
5.1 什么是定时器
可以让某个线程在某个时间做指定的任务，或某个时间以后指定时间间隔中反复做某个任务

5.2 定时器Timer的使用
•构造方法
public Timer();//构造一个定时器

•成员方法
public void schedule(TimerTask task,long delay);//在指定时间之后，执行指定任务
public void schedule(TimerTask task,long delay,long period);//在指定时间之后，开始周期性执行任务，时间间隔period毫秒
public void schedule(TimerTask task,Date time);//在指定的时间点，执行指定的任务
public void schedule(TimerTask task,Date time,long period);//在指定时间第一次执行任务，之后周期性执行任务，间隔period毫秒

•案例演示

```java
public class TestTimer {
  public static void main(String[] args) {
    Timer t1 = new Timer();
    Timer t2 = new Timer();
    Timer t3 = new Timer();
    Timer t4 = new Timer();

    t1.schedule(new TimerTask() {
      @Override
      public void run() {
        System.out.println("Timer 1 Done");
      }
    },1000);

    t2.schedule(new TimerTask() {
      @Override
      public void run() {
        System.out.println("Timer 2 Done");
      }
    },1000,1000);

    Calendar cc = Calendar.getInstance();
    cc.add(Calendar.SECOND,10);
    Date date = cc.getTime();


    t3.schedule(new TimerTask() {
      @Override
      public void run() {
        System.out.println("Timer 3 Done");
      }
    }, date);

    t4.schedule(new TimerTask() {
      @Override
      public void run() {
        System.out.println("Timer 4 Done");
      }
    },date,1000 );

    t2.cancel();
    t4.cancel();
  }
}
```
总结：
1.线程池
a.怎么创建
ExecutorService service = Executos.newFixedThreadPool(int 线程个数);
b.提交任务
service.submit(Runnalbe task);//提交无返回任务
Future future = service.submit(Callable task);//提交有返回任务
通过future.get()该方法会阻塞，直到线程执行完毕，返回结果
c.关闭线程池
service.shutDown();

2.死锁
a.多个线程
b.多把锁
c.嵌套反方向获取锁

死锁只能避免，出现即无法解决

3.线程的状态
a.NEW(新建状态)
b.RUNNABLE(可运行状态)
c.TERMIINATED(消亡状态)
d.BLOCKED(阻塞状态)
e.TIMED_WATING(限时等待状态)
f.WATING(无限等待状态)*

怎么进入WATING
I.当前线程获取锁对象
II.调用锁对象.wait()方法
III.进入WATING之前自动释放锁对象
怎么唤醒
I.其他线程持有锁对象（必须刚刚释放的同一把锁）
II.调用锁对象的.notify()方法
III.WATING线程醒来，进入BLOCKED状态，直到再次获取对象状态

4.TImer
四个方法
public void schedule(TimerTask task,long delay);//在指定时间之后，执行指定任务
public void schedule(TimerTask task,long delay,long period);//在指定时间之后，开始周期性执行任务，时间间隔period毫秒
public void schedule(TimerTask task,Date time);//在指定的时间点，执行指定的任务
public void schedule(TimerTask task,Date time,long period);//在指定时间第一次执行任务，之后周期性执行任务，间隔period毫秒