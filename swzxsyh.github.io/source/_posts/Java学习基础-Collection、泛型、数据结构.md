---
title: Java学习基础-Collection、泛型、数据结构
date: 2020-03-10 00:27:44
tags:
---

集合体系结构：
![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80-Collection%E3%80%81%E6%B3%9B%E5%9E%8B%E3%80%81%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E9%9B%86%E5%90%88%E4%BD%93%E7%B3%BB%E7%BB%93%E6%9E%84.svg)


一.Collection集合（所有集合的根接口）
是单列集合的顶层接口，它表示一组对象，这些对象也称为Collection的元素
JDK不提供此接口的任何直接实现，它提供了更具体的子接口(如Set和List)实现
创建Collection集合的对象
•多态的方式
•具体的实现类ArrayList

1.集合的介绍&集合和数组的区别
a.什么是集合
集合就是Java用来保存数据的容器。
b.学过的容器
数组，ArrayList
数组定义: 数据类型[] 变量名 = new 数据类型[数组的长度]
集合定义: ArrayList<数据类型> 变量名 = new ArrayList<数据类型>();
c.数组和集合区别在哪里
I.数组的长度固定，集合的长度可变
II.数组中的元素类型可以是基本类型，也可以是引用类型。
集合中的元素类型必须只能是引用类型，如果想保存基本类型，要写该基本类型对应的写包装类。
例如：
ArrayList arr = new ArrayList();

2.集合框架的继承体系

List接口特点：
有序，有索引，元素可以重复

Set接口特点：
无序，无索引，元素不可以重复

![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80-Collection%E3%80%81%E6%B3%9B%E5%9E%8B%E3%80%81%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E9%9B%86%E5%90%88%E6%A1%86%E6%9E%B6%E7%9A%84%E7%BB%A7%E6%89%BF%E4%BD%93%E7%B3%BB.svg)

3.Collection中的通用方法
增：增加
public boolean add(E e);添加元素，返回值表示是否添加成功。
删：删除
public boolean remove(E e);删除元素，返回值表示是否删除成功。
改：修改
无修改方法。
查：查询
无查询方法。
其他方法：
public boolean contains(Object obj);判断集合中是否包含某个元素。
public void clear();清空集合（把集合中的元素全部删除，不是把集合置为Null）
public boolean isEmpty();判断集合是否为空（指集合中没有元素，而非集合是否为Null）
public int size();返回集合中元素的个数
public Object[] toArray();将集合转成数组

方法名	说明
boolean add(E e)	添加元素
boolean remove(Object o)	从集合中移除指定元素
void clear()	清空集合中的元素
boolean contains(Object o)	判断集合中是否存在指定的元素
boolean isEmpty()	判断集合是否为空
int size()	集合的长度，也就是集合中的元素个数
public Object[] toArray();	将集合转成数组
二.Iterator迭代器（遍历集合）
1.集合迭代器的介绍与使用
a.迭代器（iterator）
用于遍历集合的对象（集合有无索引，均可使用迭代器来遍历，迭代器遍历集合时不需要索引）
•Iterator iterator():返回此集合中元素的迭代器，通过集合的iterator()方法得到
•迭代器是通过集合的iterator()方法得到的，所以说他是依赖于集合而存在的

b.迭代器的使用
    I.获取要遍历集合的迭代器对象
    II.调用迭代器对象.hasNext();boolean类型
    III.调用迭代器对象的.next();方法
1
2
3
4
5
6
7
8
9
10
        Iterator<String> it = cc.iterator();
//        boolean b = a.hasNext();
//        if (b) {
//            String next = a.next();
//            System.out.println(next);
//        }
        while(it.hasNext()){
            String ss = it.next();
            System.out.println(ss);
        }
•迭代器的注意事项（2个异常）
a.NoSuchElementException
出现原因：迭代器的hasNext返回false，再调用next方法，就会返回此异常
b.ConcurrentModificationException
出现原因：Java的迭代器规定，使用迭代器过程中，不能向集合中增删元素（不能影响集合的长度），否则就会抛出并发修改异常。

结论：
a.使用迭代器时，必须先判断，且判断结果为true，才能调用.next()方法
b.使用迭代器时，应该尽量只做遍历（绝对不允许直接向集合中增删元素），即使用单纯遍历功能

2.迭代器的原理
迭代器的底层使用指针原理，迭代器输出的是内存地址，在地址块中寻找下一个，超出后提出越界，即返回NoSuchElementException错误。同理，地址不可变，使用增删会提示ConcurrentModificationException错误

3.增强for循环
a.什么是增强for循环
实际上是一种简便格式（语法糖），简化数组和Collection集合的遍历，实际上是迭代器的简便格式
b.增强for循环的用法
for(数据类型 变量名:集合/数组){}
c.增强for循环本质使用的就是迭代器
证明：
a.源码
b.如果在使用增强for的过程中向集合添加或删除元素，和迭代器一样会抛出ConcurrentModificationException异常

注意：和使用迭代器一样，增强for就是用于单纯的遍历集合，不要在遍历集合的过程中增删元素

三.泛型
1.什么是泛型
泛型是JDK1.5的新特性，提供了编译时类型安全检测机制，该机制允许在编译时见到到非法到类型
它的本质是参数化类型，也就是说所操作的数据类型被指定为一个参数
参数化类型：就是将类型由原来的具体到类型参数化，然后在使用/调用时传入具体到类型

比如：
在JDK1.5之前，创建集合:ArrayList arr = new ArrayList();集合中可以保存任意对象
在JDK1.5时，创建集合:ArrayList<具体的引用类型> arr = new new ArrayList<具体的引用类型>();
这种参数类型可以用在类、方法和接口中，分别被称为泛型类，泛型方法，泛型接口

什么是泛型：
是一种不确定的类型，程序员使用时再确定下来
泛型的格式：
,一个泛型，如Element。这里的类型可以看作形参
<K,V>,两个泛型，暂不确定类型。这里的类型可以看作形参
将来具体调用的适合给定的类型可以看作是实参，并且实参的类型只能是引用数据类型

2.泛型的好处
a.避免了强制转型的麻烦
b.避免了类型转换的异常，将运行时期的ClassCastException，转移到了编译时期的编译失败

总之：JDK1.5之后，Java强烈推荐使用泛型

3.泛型的定义和使用
泛型可以定义在类、方法、接口上

•泛型类
泛型可以定义在类上

1
2
3
4
5
6
7
8
9
10
11
12
13
public class MyArrayList<E> {
    //就是把E当作某种类型使用
    private E ee;

    public E getEe() {
        return ee;
    }

    public void setEe(E ee) {
        this.ee = ee;
    }
}

泛型类的使用：

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
public class TestMyArrayList {
    public static void main(String[] args) {
        //使用泛型类，MyArrayList
        MyArrayList<String> arr = new MyArrayList<String >();
//        此时arr中集合对象没有E了，所有E都变成了String
        arr.setEe("Java");
        String ee = arr.getEe();
        System.out.println(ee);

//        使用泛型类，MyArrayList
        MyArrayList<Integer> arr1= new MyArrayList<Integer>();
        arr1.setEe(1);
        System.out.println(arr1.getEe());
    }
}
•泛型方法
泛型方法的定义：

1
2
3
4
5
public class Dog {
    public <E> void show(E num){
        System.out.println(num);
    }
}
泛型方法的使用：

1
2
3
4
5
6
7
8
9
10
public static void main(String[] args) {
    //create object
    Dog dd = new Dog();
    //use method
    dd.show("Java");
    dd.show(10);
    //严格的方式
    dd.<String>show("java");
    dd.<Integer>show(10);
}
•泛型接口
泛型定义在某个接口上

1
2
3
4
public interface MyInterface<E> {
    public abstract void show(E ee) ;
    public abstract void eat(E ee) ;
}
1
2
3
4
5
6
7
8
9
10
//a.定义一个实现类，实现该接口时，可以确定E的具体类型
public class MyClass implements MyInterface<String>{
    @Override
    public void show(String ee) {
    }

    @Override
    public void eat(String ee) {
    }
}
1
2
3
4
5
6
7
8
9
10
11
public class MyClass2<E> implements MyInterface<E>{
    @Override
    public void show(E ee) {
    }

    @Override
    public void eat(E ee) {
    }
}
    //此时实现类就是一个泛型类，创建该类对象时，可以确定泛型的具体类型

丢弃泛型（不正规）,此时泛型被丢弃，所有泛型变为Object

1
2
3
4
5
6
7
8
9
10
11
public class MyClass3 implements MyInterface{
    @Override
    public void show(Object ee) {
        
    }

    @Override
    public void eat(Object ee) {

    }
}
总结：在开发中，很少自定义泛型类、方法、接口，大概率是使用已定义好的泛型类，自行更改类型即可

4.泛型通配符
什么是泛型通配符：
当集合中泛型不确定类型时，可以使用泛型通配符，表示何种泛型均可

•类型通配符: •List:表示元素类型未知的List,它的元素可以匹配任何的类型
•这种带通配符的List仅表示它是各种泛型List的父类，并不能把元素添加进去

1
2
3
4
5
6
7
8
9
10
11
12
13
public static void main(String[] args) {
    ArrayList<String > arr1 = new ArrayList<String>();
    ArrayList<Integer> arr2 = new ArrayList<Integer>();
    ArrayList<Double> arr3 = new ArrayList<Double>();

    method(arr1);
    method(arr2);
    method(arr3);
}

public static void method(ArrayList<?> arr) {

}
5.泛型的上下限
<?>什么泛型都是OK的

如果不希望List<?>是任何泛型List的父类，只希望它代表某一类泛型List的父类，可以使用类型通配符的上线

,叫泛型的上限，表示该泛型必须是Animal本类或其子类(Dog,Cat); 可以理解为"" .叫泛型的下限，表示该泛型必须是Student本类或其父类(Person，Object) 可以理解为"
=Student>”

范例：

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
    public static void main(String[] args) {
        Collection<Integer> list1 = new ArrayList<Integer>();
        Collection<String > list2 = new ArrayList<String>();
        Collection<Number> list3 = new ArrayList<Number>();
        Collection<Object> list4 = new ArrayList<Object>();
        //Number是8种数值类型的父类
        //SuperClass:Object---subclass（String,Number)---subclass(Integer,Number)

        getElement1(list1);
//        getElement1(list2);String和Number不是super-sub关系，不行
        getElement1(list3);
//        getElement1(list4);Object最大，不行

//        getElement2(list1);Integer小于Number，不行
//        getElement2(list2);String和Number不是Super-sub关系，不行
        getElement2(list3);
        getElement2(list4);
    }

    public static void getElement1(Collection<? extends Number> collection ) {

    }

    public static void getElement2(Collection<? super Number> collection ) {

    }
}
四.数据结构
1.什么是数据结构
数据结构是计算机存储、组织数据的方式(容器保存数据的方式)。是指相互之间存在一种或多种特定关系的数据元素的集合

2.常见的4+1种数据结构
掌握前4种数据结构
•栈结构
可以看成只有一端开口的容器
入栈/压栈->[栈顶U栈底]->出栈/弹栈
入栈顺序：1 2 3
出栈顺序：3 2 1

特点：先进后出

•队列结构
两端均有开口的容器
入队->[队尾——队头]->出队

只能从队尾进

入队顺序：1 2 3 4
出队顺序：1 2 3 4

特点：先进先出FIFO(First In First Out)

•数组结构
数组结构是连续的一块区域，每个数组都有自己的索引

获取/修改元素：根据索引找到/修改元素即可

添加元素经过：
a.创建新数组
b.复制老数组数据
c.添加新的数据
d.销毁老的数据

删除元素经过：
a.创建新数组
b.复制老数组数据
c.删除指定的数据
d.销毁老的数据

特点：增删慢，查改快

•链表结构
在链表结构中，每一个元素称为node(节点/结点),每个node至少有两部分内容

单向链表结构
双向链表结构

数据域｜指针域（指向下一个node）
（指向上一个node）指针域｜数据域｜指针域 （指向下一个node）

![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80-Collection%E3%80%81%E6%B3%9B%E5%9E%8B%E3%80%81%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E9%93%BE%E8%A1%A8%E7%BB%93%E6%9E%84.svg)

获取/修改元素:从第一个元素开始往后查找(比数组结构慢)
增加/删除元素:在指针域直接添加/删除新node

特点：链表结构在内存中是可以分散的，增删快，查改慢

了解另一种数据结构
•树结构
树具有的特点:

每一个节点有零个或者多个子节点
没有父节点的节点称之为根节点，一个树最多有一个根节点。 3. 每一个非根节点有且只有一个父节点

![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80-Collection%E3%80%81%E6%B3%9B%E5%9E%8B%E3%80%81%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E6%A0%91%E7%BB%93%E6%9E%84.svg)

名词	含义
结点	指树中的一个元素
结点的度	节点拥有的子树的个数，二叉树的度不大于2
叶子结点	度为0的节点，也称之为终端结点
高度	叶子结点的高度为1，叶子结点的父节点高度为2，以此类推，根节点的高度最高
层	根节点在第一层，以此类推
父节点	若一个节点含有子节点，则这个节点称之为其子节点的父节点
子结点	子节点是父节点的下一层节点
兄弟结点	拥有共同父节点的节点互称为兄弟节点
二叉树：如果树中的每个节点的子节点的个数不超过2，那么该树就是一个二叉树。

![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80-Collection%E3%80%81%E6%B3%9B%E5%9E%8B%E3%80%81%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E4%BA%8C%E5%8F%89%E6%A0%91.svg)

二叉查找树：
二叉查找树的特点:

左子树上所有的节点的值均小于等于他的根节点的值
右子树上所有的节点值均大于或者等于他的根节点的值
每一个子节点最多有两个子树

![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80-Collection%E3%80%81%E6%B3%9B%E5%9E%8B%E3%80%81%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E4%BA%8C%E5%8F%89%E6%9F%A5%E6%89%BE%E6%A0%91.svg)

遍历获取元素的时候可以按照”左中右”的顺序进行遍历;
注意:二叉查找树存在的问题:会出现”瘸子”的现象，影响查询效率

![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80-Collection%E3%80%81%E6%B3%9B%E5%9E%8B%E3%80%81%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E4%BA%8C%E5%8F%89%E6%9F%A5%E6%89%BE%E6%A0%91%E5%AD%98%E5%9C%A8%E7%9A%84%E9%97%AE%E9%A2%98.svg)

二叉平衡树：
概述
为了避免出现”瘸子”的现象，减少树的高度，提高我们的搜素效率，又存在一种树的结构:”平衡二叉树” 规则:它的左右两个子树的高度差的绝对值不超过1，并且左右两个子树都是一棵平衡二叉树

![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80-Collection%E3%80%81%E6%B3%9B%E5%9E%8B%E3%80%81%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E4%BA%8C%E5%8F%89%E5%B9%B3%E8%A1%A1%E6%A0%91.svg)

如图所示，上图是一棵平衡二叉树，根节点10，左右两子树的高度差是1，而下图，虽然根节点左右两子树高度 差是0，但是右子树15的左右子树高度差为2，不符合定义，
所以右图不是一棵平衡二叉树。

![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80-Collection%E3%80%81%E6%B3%9B%E5%9E%8B%E3%80%81%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/svg.svg)

红黑树：

每一个节点或是红色的，或者是黑色的。
根节点必须是黑色
每个叶节点(Nil)是黑色的;(如果一个节点没有子节点或者父节点，则该节点相应的指针属性值为Nil，这些
Nil视为叶节点)
如果某一个节点是红色，那么它的子节点必须是黑色(不能出现两个红色节点相连的情况)
对每一个节点，从该节点到其所有后代叶节点的简单路径上，均包含相同数目的黑色节点;
红黑树的特点：
查询效率非常恐怖，增删速度非常慢

总结：
1.Collection集合根接口
I.集合继承体系
II.Collection中定义的通用方法
III.明白集合和数组的区别
2.迭代器
I.迭代器使用的三个步骤：获取迭代器，判断有没有下一个，取出下一个元素
II.增强for循环使用（底层使用就是迭代器）
III.迭代器和增强for使用过程，不能增删元素

3.泛型
I.泛型怎么写
II.泛型类、接口、方法怎么定义和使用
III.泛型通配符以及上下限
<?>代表任意泛型即可
<? extends X >上限
<? super Xxx>下限

4.数据结构
栈结构：先进后出
队列结构：先进先出
数组结构：增删慢，查改快
链表结构：增删快，查询慢

红黑树：查询效率非常高，增删速度非常慢