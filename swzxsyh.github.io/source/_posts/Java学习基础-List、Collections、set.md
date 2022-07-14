---
title: Java学习基础-List、Collections、set
date: 2020-03-11 00:37:30
tags:
---

一.List接口
1.1 List接口的特点
a.List接口 继承 Collection接口
b.List接口的特点：
有序的（Java中的有序不是指自然顺序，而是指存取元素的顺序是一致的，什么顺序存就怎么取）
有索引的
元素可重复的(存储的元素可以重复)

1.2 List接口中常用的方法以及常用实现类
a.List接口继承Collection接口，所以已经有了collection中的8个（7个常见+iterator）
b.List接口还有自己的特有方法（4个）：
增：add(int index,E e)
删：remove(int index,E e)
改：set(int index,E e)
查：get(int index,E e)
c.List接口有哪些实现类
ArrayList[]
LinkedList[]
Vector[]

1.3 ArrayList的数据结构以及使用
a.ArrayList集合的方法(7个collection+1个迭代器+4个List接口中的)
特有方法：无
b.ArrayList集合底层采用的是数组结构，特点：查改快，增删慢
c.使用ArrayList

```java
public static void main(String[] args) {
  ArrayList<String> arr = new ArrayList<String>();
  arr.add("Java1" );
  arr.add("Java2" );
  arr.add("Java3" );
  arr.add(2, "99");
  System.out.println(arr);

  arr.remove(3);
  System.out.println(arr);

  arr.set(1, "11");
  System.out.println(arr);

  System.out.println(arr.get(2));
}
```
List的并发修改异常
并发修改异常：ConcurrentModificationException
•ConcurrentModificationException
产生原因：
•迭代器遍历的过程中，通过集合对象修改了集合中元素的长度，造成类迭代器获取元素中判断欲求修改值和实际修改值不一致
解决方案：
•用for循环遍历，然后用集合对象做对应的操作即可(get方法)

ListIterator：列表迭代器
•通过List集合的listIterator()方法得到，它是List集合特有的迭代器
•用于允许程序员沿任一方向遍历列表的列表迭代器，在迭代期间修改列表，并获取列表中迭代器的当前位置

ListIterator中的常用方法
•E next();返回迭代中的下一个元素
•boolean hasNext();如果迭代器具有更多元素，则返回true
•E previous();返回迭代中的上一个元素
•boolean hasPrevious();如果此列表迭代器在相反方向遍历列表时具有更多元素，则返回true
•void add(E e);将指定的元素插入列表

1.4 LinkedList的数据结构以及使用
a.LinkedList的方法(7个collection+1个迭代器+4个List接口中的)
有特有方法：
public void addFirst(E e);//添加元素到集合首
public void addLast(E e);//添加元素到集合尾
public E getFirst(E e);//获取集合的首元素
public E getLast(E e);//获取集合的尾元素
public E removeFirst(E e);//删除集合的首元素
public E removeLast(E e);//删除集合的尾元素

public void pop(E e);//删除集合中的首元素，底层就是removeFirst
public void push(E e);//添加集合中的首元素，底层就是addFirst
源码：

```java
public E pop() {
  return removeFirst();
}

public void push(E e) {
  addFirst(e);
}
```


b.LinkedList底层采用的是链表结构，特点：查改慢，增删快
c.使用LinkedList

```java
LinkedList<String> list = new LinkedList<String >();
list.add("a");
list.add("b");
list.add("c");

System.out.println(list);

list.addFirst("1");
list.addLast("10");

System.out.println(list);

System.out.println(list.getFirst());
System.out.println(list.getLast());

list.removeFirst();
System.out.println(list);

list.removeLast();
System.out.println(list);

list.pop();
System.out.println(list);

list.push("2");
System.out.println(list);

```
1.5 LinkedList的源码分析
a.LinkedList底层采用的是链表结构（双向列表）

b.LinkedList这个类有两个成员变量
Node first;记录了开始结点
Node last;记录了结束结点

c.结点类Node，它是LinkedList的内部类

```java
private static class Node<E> {
    E item;//该节点的数据域
    Node<E> next;//指针域，指向下一个结点
    Node<E> prev;//指针域，指向上一个结点
```


d.LinkedList的add方法
I.将新增的结点，添加到last之后
II.并且将size++，总元素个数加一

```java
public boolean add(E e) {
    linkLast(e);
    return true;
}
```


e.LinkedList的get方法
I.先查找指定索引的结点，（从前往后找，从后往前找）
II.找到结点后，获取结点的数据栈，然后返回

完整版：
•LinkedList的成员变量源码分析:

```java
public class LinkedList<E> extends AbstractSequentialList<E>
  implements List<E>, Deque<E>, Cloneable, java.io.Serializable {
  transient int size = 0;
  /**
     * 存储第一个节点的引用
     */
  transient Node<E> first;
  /**
     * 存储最后一个节点的引用
     */
  transient Node<E> last;
  //......
  //......
}
```


•LinkedList的内部类Node类源码分析:

```java
public class LinkedList<E> extends AbstractSequentialList<E>
  implements List<E>, Deque<E>, Cloneable, java.io.Serializable {
  //......
  private static class Node<E> {
    E item;//被存储的对象
    Node<E> next;//下一个节点
    Node<E> prev;//前一个节点

    //构造方法
    Node(Node<E> prev, E element, Node<E> next) {
      this.item = element;
      this.next = next;
      this.prev = prev;
    }
  }
  //......
}
```
•LinkedList的add()方法源码分析:

```java
public boolean add(E e) {
  linkLast(e);//调用linkLast()方法 
  return true;//永远返回true
}

void linkLast(E e) {
  final Node<E> l = last;//一个临时变量，存储最后一个节点
  final Node<E> newNode = new Node<>(l, e, null);//创建一个Node对象 
  last = newNode;//将新Node对象存储到last
  if (l == null)//如果没有最后一个元素，说明当前是第一个节点
    first = newNode;//将新节点存为第一个节点 else
  l.next = newNode;//否则不是第一个节点，就赋值到当前的last的next成员 
  size++;//总数量 + 1
  modCount++;//
}
```
•LinkedList的get()方法:

```java
public E get(int index) {
  checkElementIndex(index);//检查索引的合法性(必须在0-size之间)，如果不合法，此方法抛出异常
  return node(index).item;
}

Node<E> node(int index) {//此方法接收一个索引，返回一个Node
  // assert isElementIndex(index);
  if (index < (size >> 1)) {//判断要查找的index是否小于size / 2，二分法查找
    Node<E> x = first;// x = 第一个节点——从前往后找
    for (int i = 0; i < index; i++)//从0开始，条件:i < index，此循环只控制次数
      x = x.next;//每次 x = 当前节点.next; 
    return x;//循环完毕，x就是index索引的节点。
  } else {
    Node<E> x = last;// x = 最后一个节点——从后往前找
    for (int i = size - 1; i > index; i--)//从最后位置开始，条件:i > index
      x = x.prev;//每次 x = 当前节点.prev; 
    return x;//循环完毕，x就是index索引的节点
  }
}
```
二.Collections类
2.1 Collections的介绍
Collections不是collection！
作用：Collections是一个集合的工具类，该类中有一堆静态方法，专门操作集合

2.2 Collections常用功能
public static void shuffle(List list);//随机打乱集合中元素的顺序 public static void sort(List list);//将集合中的元素进行升序排序

扩展：Collections的sort方法，默认是对集合中对元素进行升序排序
如果集合的泛型是数值类型，那么按照数值的大小升序
如果集合的泛型是Character类型，那么按照字母的码值排序
如果集合的泛型是String类型，那么按照字母首字母排序，若一样，次字母排序，依次类推
提示：Collections.sort方法结论和Array.sort()是一样的

```java
public static void main(String[] args) {
  ArrayList<Integer> arr = new ArrayList<Integer>();

  arr.add(1);
  arr.add(2);
  arr.add(3);
  arr.add(5);
  arr.add(9);
  arr.add(8);
  arr.add(7);
  arr.add(6);
  arr.add(4);

  System.out.println(arr);

  Collections.sort(arr);
  System.out.println(arr);

  Collections.shuffle(arr);
  System.out.println(arr);
}
```
2.3 Comparator比较器排序
Collections还有一个sort方法：
public static void sort(List list,Comparator com);带有比较器的排序方法
这个比较器源码：

```java
public interface Comparator<T>{
  int compare(T o1, T o2);    
}
```


我们注意到Comparator实际上是一个接口，那么我们在调用sort方法时，需要传人一个该接口的实现类对象（匿名内部类）

降序排序

```java
Collections.sort(arr, new Comparator<Integer>() {
  /*该方法就是比较方法，它会把集合中每两个元素传入
    @param o1 第一个元素
    @param o2 第二个元素
    @return 返回值代表谁大谁小，如果是正数代表o1大，负数则代表o2大，如果0代表一样大

     口诀：升序前减后，降序后减前
     */

  @Override
  public int compare(Integer o1, Integer o2) {
    return o2-o1;//降序
    //return o1-o2; //升序

  }
});
```
自定义排序

```java
public static void main(String[] args) {
  ArrayList<Dog> arr = new ArrayList<Dog>();

  arr.add(new Dog(1, "a", 4));
  arr.add(new Dog(2, "b", 2));
  arr.add(new Dog(3, "c", 3));
  arr.add(new Dog(4, "d", 2));

  Collections.sort(arr, new Comparator<Dog>() {
    @Override
    public int compare(Dog o1, Dog o2) {
      //按照年龄降序排序
      //                return o2.age - o1.age;
      //按照姓名升序排序
      //                return o1.name.length() - o2.name.length();
      //按照年龄和腿数总和升序
      return (o1.age+o1.legs_num)-(o2.age+o2.legs_num);

    }
  });

  for (Dog dog : arr) {
    System.out.println(dog);

  }
}
```
2.4 可变参数
a.什么是可变参数：是指方法参数的个数可以任意[JDK 1.5]
b.可变参数的格式：
数据类型 … 变量名

1
public static int getSum(int ... a){}
可变参数的本质其实就是一个数组；
注意事项：
a.一个方法中最多只能有一个可变参数
b.一个方法中如果既有正常参数，又有可变参数，那么可变参数必须写在最后面

```java
public static void main(String[] args) {
  System.out.println(getSum());
  System.out.println(getSum(1));
  System.out.println(getSum(1, 2));
  System.out.println(getSum(1, 2, 3));
  System.out.println(getSum(1, 2, 3, 4));
  System.out.println(getSum(1, 2, 3, 4, 5));
}

public static int getSum(int... a) {
  System.out.println("length: "+a.length);
  int sum = 0;
  for (int i : a) {
    sum +=i;
  }
  return sum;
}
```
2.5 可变参数的应用场景
Arrays工具类中有一个静态方法:
•public static List asList<T…a>:返回由指定数组支持的固定大小的列表
•返回的集合不能做 增 删 操作，可以做修改操作

List接口中有一个静态方法:
•public static List of(E…elements):返回包含任意数量元素的不可变列表
•返回的集合不能做 增 删 该 操作

Set接口中有一个静态方法:
•public static Set of(E…elements):返回一个包含任意数量元素的不可变集合
•在给元素时，不能给重复的元素

例：

```java

public static void main(String[] args) {
  ArrayList<String > arr= new ArrayList<String>();
  //Collections工具类又有一个方法，叫做addAll
  Collections.addAll(arr,"a","b","c","d","e");

  System.out.println(arr);
}
```

一次性向集合中添加多个元素

三.Set接口
3.1 Set接口的特点
a.Set接口也是继承Collection接口
b.Set接口的特点：
无序的（指存取顺序不保证一致）
无索引的(使用不能使用普通for循环遍历)
元素唯一的

但是实际上，严格来说，无序特点是不对的(实现类LinkedHashSet是有序的)
3.2 Set接口的常用方法以及常用实现类
a.Set接口中的方法(7个collection+1个迭代器)
b.Set方法的特有方法：无

c.Set接口的实现类:
HashSet
LinkedHashSet
TreeSet
3.3 HashSet的数据结构以及使用
a.HashSet也没有特有方法
b.HashSet底层采用的是哈希表结构(数组结构+链表结构+红黑树结构)
•对集合的迭代顺序不作任何保证，也就是说不保证存储和取出的元素 顺序一致
•没有带索引的方法，索引不能使用普通for循环遍历
•Set集合，所以是不包含重复元素的集合
c.HashSet的使用

```java

public static void main(String[] args) {
  HashSet<String> set = new HashSet<String>();
  Collections.addAll(set, "php","Java","C#");
  Collections.addAll(set, "Java","C#","Delphi","C","CPP","Python");

  System.out.println(set);
}
```

3.4 LinkedHashSet的数据结构以及使用
a.LinkedHashSet也没有特有方法
b.LinkedHashSet底层采用的是（链表结构+哈希表结构）
•由链表保证元素有序，也就是说元素的存储和取出顺序是一样的
•由哈希表保证元素唯一，也就是说没有重复的元素

c.LinkedHashSet的使用

```java
public static void main(String[] args) {
  LinkedHashSet LHS = new LinkedHashSet<String>();
  Collections.addAll(LHS, "php", "Java", "C#");
  Collections.addAll(LHS, "Java", "C#", "Delphi", "C", "CPP", "Python");

  System.out.println(LHS);
}
```

3.5 TreeSet的数据结构以及使用
a.TreeSet特点
无序的（无序是存取顺序不保证一致，但是它会以自然顺序输出）
TreeSet是无序的，但是它是无序中的一种特殊存在，有自然顺序！
TreeSet(Comparator comparator)：根据指定的比较器进行排序
无索引，所以不能用普通for循环
元素唯一，因为是Set集合
b.TreeSet特有方法:无
c.TreeSet底层采用的是红黑树结构
d.TreeSet的使用

```java
TreeSet<Integer> tree = new TreeSet<Integer>();
//添加元素，没有带索引的方法，证明无索引
//tree.add()
Collections.addAll(tree, 1, 3, 5, 2, 4, 6);
System.out.println(tree);
//[1, 2, 3, 4, 5, 6]证明自然顺序

tree.add(4);
System.out.println(tree);
//[1, 2, 3, 4, 5, 6] 证明元素唯一性
```

扩展：
如果TreeSet保存的是数值类型，那么按照数值的大小升序
如果TreeSet保存是Character类型，那么按照字母的码值排序
如果TreeSet保存的是String类型，那么按照字母首字母排序，若一样，次字母排序，依次类推

e.TreeSet也可以使用比较器自定义排列顺序
TreeSet有一个带有比较器的构造方法

```java
public static void main(String[] args) {
  TreeSet<Integer> tree = new TreeSet<Integer>(new Comparator<Integer>() {
    @Override
    public int compare(Integer o1, Integer o2) {
      return o2-o1;
    }
  });
  Collections.addAll(tree, 1, 3, 5, 2, 4, 6);
  System.out.println(tree);
}
```

3.6 哈希表结构的的介绍
•对象的哈希值(对象的”数字指纹”，是JDK根据对象的地址或者字符串或者数字算出来的int类型的数值)
a.对象的哈希值，相对于对象的“指纹”，只是这个指纹是一个数字
b.我们如何获取对象的哈希值：调用对象的hashCode()方法即可

1
2
3
4
5
public static void main(String[] args) {
    Student s1 = new Student(1, "a");
    int hashCode = s1.hashCode();//返回哈希值
    System.out.println(hashCode);
}
c.其实Java中所谓的地址值是假的，它是Hash值的16进制表示
源码

```java
public String toString() {
  return getClass().getName() + "@" + Integer.toHexString(hashCode());
}
```


d.Java中有真正的地址值，但是当打印时，会自动调用toString方法，将hash值输出
Dog d = new Dog();//d就是真正的地址值
System.out.println(d);//打印时，会自动调toString方法，hex16操作输出

e.不同的两个对象，可能有相同的hashCode（hashCode是int类型，最多42亿，因此会相同）

结论：哈希表结构如何保证元素的唯一性
哈希表结构，如何判断两个元素是否重复：
a.哈希表结构，会先比较两个对象的哈希值
b.当哈希值一样，再调用equals比较两个对象
只有哈希值相同，并且equals结构为true，才判定这两个元素是重复的

哈希表结构=数组结构+链表结构+红黑树结构（JDK8）
数组结构默认长度16
I.向哈希值中添加元素时，元素的索引：元素.hashCode()%数组长度 =0-15
II.当某个链表长度超过阀值(8)时，这个链表就会变成红黑树

3.7 哈希表结构保存自定义类型练习
为了保证哈希表中元素的唯一性，如果元素是自定义类型，那么必须重写hashCode和equals方法

```java
public class Dog {
  int age;
  String name;
  int legs_num;

  public Dog(){

  }

  public Dog(int age, String name, int legs_num) {
    this.age = age;
    this.name = name;
    this.legs_num = legs_num;
  }

  @Override
  public String toString() {
    return "Dog{" +
      "age=" + age +
      ", name='" + name + '\'' +
      ", legs_num=" + legs_num +
      '}';
  }
  //为了保证哈希表中元素的唯一性，要重写hasCode和equals方法

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    Dog dog = (Dog) o;
    return age == dog.age &&
      legs_num == dog.legs_num &&
      Objects.equals(name, dog.name);
  }

  @Override
  public int hashCode() {
    return Objects.hash(age, name, legs_num);
  }
}

public class TestHashSetDemo {
  public static void main(String[] args) {
    HashSet<Dog> dogHashSet = new HashSet<Dog>();
    dogHashSet.add(new Dog(1, "a", 4));
    dogHashSet.add(new Dog(2, "b", 4));
    dogHashSet.add(new Dog(3, "c", 4));
    dogHashSet.add(new Dog(1, "d", 4));

    //        for (Dog d : dogHashSet) {
    //            System.out.println(d);
    //        }
    //        System.out.println();
    //
    //        dogHashSet.add(new Dog(3, "c", 4));
    //        //哈希表判断两个元素重复or不重复的依据是哈希表和equals
    //        for (Dog d : dogHashSet) {
    //            System.out.println(d);
    //        }

    //为了保证元素的唯一性，要重写hashCode和equals，根据内容计算哈希值，equals也比较内容

    System.out.println();
    for (Dog d:dogHashSet
        ) {
      System.out.println(d);
    }
  }
```
3.8 HashSet的源码分析
a.构造方法

```java
public class HashSet<E> extends AbstractSet<E>
  implements Set<E>, Cloneable, java.io.Serializable {
  //内部一个HashMap——HashSet内部实际上是用HashMap实现的 private transient HashMap<E,Object> map;
  // 用于做map的值
  private static final Object PRESENT = new Object();

  /**
     * 构造一个新的HashSet，
     * 内部实际上是构造了一个HashMap
     */
  public HashSet() {
    map = new HashMap<>();
  }
}
```
b.HashMap的add方法

```java
public class HashSet { //......
  public boolean add(E e) {
    return map.put(e, PRESENT) == null;//内部实际上添加到map中，键:要添加的对象，值:Object
    对象
  }
  //......
}
```


c.HashMap的put方法
HashMap保存键时，是以键的哈希值为依据确定键的保存位置
添加成功之后，size++，将元素的个数增加1

```java
public class HashMap { //......
  public V put(K key, V value) {
    return putVal(hash(key), key, value, false, true);
  }

  //......
  static final int hash(Object key) {//根据参数，产生一个哈希值
    int h;
    return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
  }

  //......
  final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                 boolean evict) {

    Node<K, V>[] tab; //临时变量，存储"哈希表"——由此可见，哈希表是一个Node[]数组 
    Node<K,V> p;//临时变量，用于存储从"哈希表"中获取的Node
    int n, i;//n存储哈希表长度;i存储哈希表索引
    if ((tab = table) == null || (n = tab.length) == 0)//判断当前是否还没有生成哈希表
      n = (tab = resize()).length;//resize()方法用于生成一个哈希表，默认长度:16，赋给n
    if ((p = tab[i = (n - 1) & hash]) == null)//(n-1)&hash等效于hash % n，转换为数组索 
      tab[i] = newNode(hash, key, value, null);//此位置没有元素，直接存储
    else{//否则此位置已经有元素了 
      Node<K,V> e; K k;
      if (p.hash == hash &&
          ((k = p.key) == key || (key != null && key.equals(k))))//判断哈希值和
        e = p;//将哈希表中的元素存储为e
      else if (p instanceof TreeNode)//判断是否为"树"结构
        e = ((TreeNode<K, V>) p).putTreeVal(this, tab, hash, key, value);
      else {//排除以上两种情况，将其存为新的Node节点
        for (int binCount = 0; ; ++binCount) {//遍历链表 
          if ((e = p.next) == null) {//找到最后一个节点
            p.next = newNode(hash, key, value, null);//产生一个新节点，赋值到链
            if (binCount >= TREEIFY_THRESHOLD - 1) //判断链表长度是否大于了8 
              treeifyBin(tab, hash);//树形化
            break;
          }
          if (e.hash == hash &&
              ((k = e.key) == key || (key != null && key.equals(k))))//跟当前
            变量的元素比较，如果hashCode相同，equals也相同 break;//结束循环
          p = e;//将p设为当前遍历的Node节点 }
        }
        if (e != null) { // 如果存在此键
        }
      }
```
总结：

![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80-List%E3%80%81Collections%E3%80%81set/collection.svg)

Collection
{
Iterator it = cc.iterator();
public boolean add(E e);添加元素，返回值表示是否添加成功。
public boolean remove(E e);删除元素，返回值表示是否删除成功。
无修改方法。
无查询方法。
public boolean contains(Object obj);判断集合中是否包含某个元素。
public void clear();清空集合（把集合中的元素全部删除，不是把集合置为Null）
public boolean isEmpty();判断集合是否为空（指集合中没有元素，而非集合是否为Null）
public int size();返回集合中元素的个数
public Object[] toArray();将集合转成数组
}
List接口：
特点：有序，有索引，元素可重复
特有方法：
add(int index,E e);
remove(int index,E e);
set(int index,E e);
get(int index,E e);

ArrayList：
底层是数组结构
特有方法：无
特点：有序，有索引，元素可重复

LinkedList
底层是链表结构
特有方法：
public void addFirst(E e);//添加元素到集合首
public void addLast(E e);//添加元素到集合尾
public E getFirst(E e);//获取集合的首元素
public E getLast(E e);//获取集合的尾元素
public E removeFirst(E e);//删除集合的首元素
public E removeLast(E e);//删除集合的尾元素
public void pop(E e);//删除集合中的首元素，底层就是removeFirst
public void push(E e);//添加集合中的首元素，底层就是addFirst
特点：有序，有索引，元素可重复

Set接口：
特点：无序（LinkedHashSet除外），无索引，元素唯一
特有方法：无
特点：无索引，元素唯一

HashSet
底层是哈希表结构(数组结构+链表结构+红黑树结构)
特有方法：无
特点：无序，无索引，元素唯一

LinkedHashSet
底层是（链表结构+哈希表结构）
特有方法：无
特点：有序，无索引，元素唯一

TreeSet
底层是红黑树结构
特有方法：无
特点：无序的（无序是存取顺序不保证一致，但是它会以自然顺序输出），无索引，元素唯一

使用哈希表保存自定义类型时，为了保证元素的唯一性，要重写自定义类型中的hashCode方法和equals方法