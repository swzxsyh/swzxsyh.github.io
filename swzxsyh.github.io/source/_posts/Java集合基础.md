---
title: Java集合基础
date: 2020-02-26 00:10:01
tags:
---

一.集合基础
1.1 集合概述
编程时如果要存储多个数据，使用长度固定的数组存储格式，不一定满足需求，耿适应不了变化的需求，此时应选择集合。

集合类的特点：提供一种存储空间可变的 存储模型，存储的数据容量可以发生改变
集合类非常多，首先学习:ArrayList

ArrayList:

可调整大小的数组实现
:是一种特定的数据类型，泛型
使用：
在所有出现的地方可以使用引用数据类型替换
例：ArrayList,ArrayList

1.2 ArrayList构造方法和添加方法

方法名	说明
public ArrayList()	创建一个空的集合对象
public boolean add(E e)	将指定的元素追加到此集合的末尾
public void add(int index,E element)	在此集合中的指定位置插入指定的元素
1.3 ArrayList集合常用方法

方法名	说明
public boolean remove(Object o)	删除指定的元素，返回删除是否成功
public E remove(int index)	删除指定索引处的元素，返回被删的元素
public E set(int index,E element)	修改指定索引处的元素，返回被修改的元素
public E get(int index)	返回指定索引处的元素
public int size()	返回集合中的元素的个数

```java
public class ArrayListDemo {
  public static void main(String[] args) {

    ArrayList<String> array = new ArrayList<>();

    Collections.addAll(array,"a","b","c");

    System.out.println(array);

    System.out.println(array.remove("b"));

    System.out.println(array.remove(1));

    System.out.println(array.set(0,"ccc"));

    System.out.println(array.get(0));

    System.out.println(array.size());
  }
}
```