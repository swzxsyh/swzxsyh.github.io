---
title: Java学习基础-Map
date: 2020-03-12 00:41:41
tags:
---

一.Map集合
1.1 Map的概述以及特点
什么是Map集合：
Collection集合称为单列集合，Map集合称为双列集合，key-value，键-值，名称：Entry
Map集合的特点：
a.Collection每个元素单独存在(单列)，Map每个元素成对存在(双列)
b.Map集合中，键必须是唯一的，值是可以重复的
c.Collection中，泛型只有一个。Map<K,V>中，泛型有两个(其中K代表键Key的类，V代表值Value类)

1.2 Map的3个常用实现类以及其特点
Map接口有三个常见的实现类：
HashMap<K,V>:
底层采用哈希表结构
无序

LinkedHashMap<K,V>:
底层采用链表+哈希表结构
有序

TreeMap<K,V>:
底层采用红黑树结构
无序，键有自然顺序的，即按照键的自然顺序输出

重点：Map中为了保证键的唯一性，如果键是自定义类型，必须重写键的hashCode和equals方法

1.3 Map接口中定义的通用方法
增:public V put(K key, V value) ;添加一个键值对Entry，返回null
删:public V remove(Object key);根据键Key去删键值对Entry，返回被删除的键值对的值
查:public V get(Object key);根据键Key获取对应的值Value
改:public V put(K key, V value) ;添加一个重复的键时，该方法变为修改，返回修改前的值
其他:
public boolean containKey(Object K);判断Map中是否包含该键
public boolean containKey(Object V);判断Map中是否包含该值




```java
public static void main(String[] args) {
  HashMap<String ,Integer> map = new HashMap<String,Integer>();
  //增加
  map.put("a",1);
  map.put("b",2);
  map.put("c",3);
  map.put("d",4);
  map.put("e",5);
  map.put("f",6);
  System.out.println(map);
  //删除
  Integer v1 = map.remove("a");
  System.out.println(v1);
  System.out.println(map);
  //删除不存在的v
  Integer v2 = map.remove("g");
  System.out.println(v2);
  System.out.println(map);
  //获取
  Integer v3 = map.get("a");
  System.out.println(v3);
  System.out.println(map);
  //修改也是调用put
  Integer v4 = map.put("c", 12);
  System.out.println(v4);
  System.out.println(map);
  //判断
  boolean k = map.containsKey("a");
  System.out.println(k);
  boolean v = map.containsValue(5);
  System.out.println(v);
}
```

1.4 Map的遍历
•遍历方式一：以键找值
public Set keySet() : 获取Map集合中所有的键，存储到Set集合中。

```java
public static void main(String[] args) {
  HashMap<String, Integer> map = new HashMap<String, Integer>();
  //增加
  map.put("a", 1);
  map.put("b", 2);
  map.put("c", 3);
  map.put("d", 4);
  map.put("e", 5);
  map.put("f", 6);
  Set<String> keys = map.keySet();
  for (String key : keys) {
    Integer value = map.get(key);
    System.out.println(key);
    System.out.println(value);
  }
}
```
•遍历方式二:键值对方式
public Set<Map.Entry<K,V>> entrySet() : 获取到Map集合中所有的键值对对象的集合(Set集合)。

```java
public static void main(String[] args) {
  HashMap<String, Integer> map = new HashMap<String, Integer>();
  //增加
  map.put("a", 1);
  map.put("b", 2);
  map.put("c", 3);
  map.put("d", 4);
  map.put("e", 5);
  map.put("f", 6);
  //Map集合遍历的第二种方式：键值对方式
  //获取所有键值对
  Set<Map.Entry<String, Integer>> entries = map.entrySet();
  //遍历entrys集合
  for (Map.Entry<String, Integer> entry : entries) {
    //从entry种取出键值
    String key = entry.getKey();
    Integer value = entry.getValue();
    System.out.println(key+"..."+value);
  }
}
```


1.5 HashMap存储自定义类型的键
需求：创建一个Map，学生为键，家庭地址作值。

学生键：




```java
public class Student {
  String Name;
  int age;
  public Student(){

  }

  @Override
  public String toString() {
    return "Student{" +
      "Name='" + Name + '\'' +
      ", age=" + age +
      '}';
  }

  public Student(String name, int age) {
    Name = name;
    this.age = age;
  }
  //为了保证学生键的唯一性，要重写hashCode和equals
  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    Student student = (Student) o;
    return age == student.age &&
      Objects.equals(Name, student.Name);
  }

  @Override
  public int hashCode() {
    return Objects.hash(Name, age);
  }
}
```

测试Demo：



```java

public static void main(String[] args) {
  HashMap<Student,String >  std= new HashMap<Student,String>();
  std.put(new Student("a",1), "PK");
  std.put(new Student("b",2), "GZ");
  std.put(new Student("c",3), "SH");
  std.put(new Student("d",4), "SZ");
  System.out.println(std);
  std.put(new Student("b",2), "SC");
  System.out.println(std);
}
```


结论：如果键是自定义类型，那么为了保证键的唯一性，必须重写hashCode和equals方法

1.6 LinkedHashMap介绍
HashMap底层采用哈希表结构，所以无序
LinkedHashMap底层采用的是链表结构+哈希表，所以是有序的




```java
public static void main(String[] args) {
  LinkedHashMap<String ,Integer> LHS = new LinkedHashMap<String ,Integer>();
  LHS.put("a", 1);
  LHS.put("c", 1);
  LHS.put("d", 1);
  LHS.put("b", 1);

  System.out.println(LHS);
}
```
1.7 TreeMap集合
TreeMap底层采用的是红黑树结构，无序的，但是会以键的自然顺序输出

```java
public static void main(String[] args) {
  TreeMap<String ,Integer> TM = new TreeMap<String,Integer>();
  TM.put("a", 1);
  TM.put("c", 2);
  TM.put("e", 3);
  TM.put("d", 4);
  TM.put("b", 5);

  System.out.println(TM);
}
```


扩展：
如果键是数值类型，那么按照数值的大小升序
如果键是Character类型，那么按照字母的码值排序
如果键是String类型，那么按照字母首字母排序，若一样，次字母排序，依次类推
这四种结论是一样的：Arrays.sort() Collections.sort() TreeSet TreeMap

我们也可以使用比较器排序


```java

public static void main(String[] args) {
  TreeMap<String, Integer> TM = new TreeMap<String, Integer>();
  TM.put("a", 1);
  TM.put("c", 2);
  TM.put("e", 3);
  TM.put("d", 4);
  TM.put("b", 5);

  System.out.println(TM);

  TreeMap<Integer, String> new_TM = new TreeMap<Integer, String>(new Comparator<Integer>() {
    @Override
    public int compare(Integer o1, Integer o2) {
      return o2 - o1;
    }
  });
  new_TM.put(1, "a");
  new_TM.put(3, "a");
  new_TM.put(2, "a");
  new_TM.put(5, "a");
  new_TM.put(4, "a");

  System.out.println(new_TM);
  TreeMap<Student, String> std = new TreeMap<Student, String>(new Comparator<Student>() {
    @Override
    public int compare(Student o1, Student o2) {
      return o2.Name.length() - o1.Name.length();
    }
  });

  std.put(new Student("aa", 1), "PK");
  std.put(new Student("bbb", 2), "GZ");
  std.put(new Student("cc", 3), "SH");
  std.put(new Student("ddddd", 4), "SZ");

  System.out.println(std);
}
```

1.8 Map集合练习
输入一个字符串，统计字符串中每个字符出现的次数


```java
public static void main(String[] args) {
  //定义一个Map
  LinkedHashMap<Character, Integer> LHM = new LinkedHashMap<Character, Integer>();
  //输入一个字符串
  System.out.println("input char");
  String str = new Scanner(System.in).nextLine();
  //遍历字符串
  for (int i = 0; i < str.length(); i++) {
    //           取出字符串中的某个字符
    char ch = str.charAt(i);
    //这个字符ch以前出现过
    if (LHM.containsKey(ch)) {
      Integer oldCount = LHM.get(ch);
      LHM.put(ch, oldCount + 1);
    } else {
      LHM.put(ch, 1);
    }
  }
  System.out.println(LHM);
}
```

二.集合的嵌套
什么是集合嵌套
集合中的元素还是一个集合

2.1 List嵌套list

```java
public static void main(String[] args) {
  ArrayList<String> class1 = new ArrayList<String>();
  Collections.addAll(class1, "a", "b", "c");

  ArrayList<String> class2 = new ArrayList<String>();
  Collections.addAll(class2, "e", "f", "g");

  //        将class1和class2保存到一个大集合中
  ArrayList<ArrayList<String>> classAll = new ArrayList<ArrayList<String>>();

  Collections.addAll(classAll, class1, class2);

  for (ArrayList<String> className : classAll) {
    for (String name:className
        ) {
      System.out.println(name);
    }
    System.out.println(className);
  }
}
```

2.2 List嵌套Map
a.保存两个班学生的姓名以及对应的年龄




```java

public static void main(String[] args) {
  HashMap<String, Integer> class1 = new HashMap<String, Integer>();
  class1.put("a", 12);
  class1.put("b", 11);
  class1.put("c", 13);
  class1.put("d", 14);
  class1.put("e", 18);
  HashMap<String, Integer> class2 = new HashMap<String, Integer>();
  class2.put("f", 19);
  class2.put("g", 17);
  class2.put("h", 16);
  class2.put("i", 15);
  class2.put("k", 14);

  ArrayList<HashMap<String, Integer>> classAll = new ArrayList<HashMap<String, Integer>>();
  classAll.add(class1);
  classAll.add(class2);

  System.out.println(classAll);

  for (HashMap<String, Integer> className : classAll
      ) {
    Set<String> keys = className.keySet();
    for (String key : keys) {
      System.out.println(key);
    }
    System.out.println(className);
  }
}
```

2.3 Map嵌套Map
a.保存两个班的名字，和班里的同学的姓名，以及对应的年龄



```java

public static void main(String[] args) {
  HashMap<String, Integer> class1 = new HashMap<String, Integer>();
  class1.put("a", 12);
  class1.put("b", 11);
  class1.put("c", 13);
  class1.put("d", 14);
  class1.put("e", 18);
  HashMap<String, Integer> class2 = new HashMap<String, Integer>();
  class2.put("f", 19);
  class2.put("g", 17);
  class2.put("h", 16);
  class2.put("i", 15);
  class2.put("k", 14);

  //将两个班级的Map集合保存到另一个集合中，要求有该班级的名字
  HashMap<String, HashMap<String, Integer>> classAll = new HashMap<String, HashMap<String, Integer>>();

  classAll.put("class one", class1);
  classAll.put("class two", class2);

  System.out.println(classAll);

  //获取所有的键
  Set<String> names = classAll.keySet();

  System.out.println(names);
  //遍历所有的键
  for (String name : names) {
    //以值找值
    HashMap<String, Integer> map = classAll.get(name);
    //获取map所有的键
    System.out.println(map);
    Set<String> ns = map.keySet();
    for (String n : ns
        ) {
      Integer value = map.get(n);
      System.out.println(n + "..." + value);
    }
  }
}
```
.模拟斗地主洗牌发牌
3.1 案例介绍
3.2 案例分析
斗地主要想办法自定义排序规则
核心思想：给斗地主中每一张牌，准备一个编号
a.不能出现相同的编号
b.牌越大，编号越大

I.准备编号和牌组成的Map集合
II.准备54个编号（一副牌）
III.洗牌（打乱集合）
V.发牌（遍历集合）
IV.对编号排序（sort）
IIV.转牌（以键找值map.get）
IIIV.打印给用户（println）



```java

public static void main(String[] args) {
  //        I.准备编号和牌组成的Map集合
  LinkedHashMap<Integer, String> Map = new LinkedHashMap<Integer, String>();

  //a.花色4种
  String[] colors = {"黑桃♠️", "红桃♥️", "梅花♣️", "方片♦️"};
  //b.数值13种
  String[] numbers = {"3", "4", "5", "6", "7", "8", "9", "10", "J", "K", "Q", "A", "2"};
  //c.组合拍
  int id = 1;
  for (String num : numbers) {
    for (String color : colors) {
      String card = color + num;
      //                for ( i < num.length(); i++) {
      Map.put(id, card);
      id++;
    }
  }
  Map.put(53, "小王");
  Map.put(54, "大王");

  //        II.准备54个编号（一副牌）
  ArrayList<Integer> Cards = new ArrayList<Integer>();
  for (int i = 1; i < 55; i++) {
    Cards.add(i);
  }
  //        III.洗牌（打乱集合）
  Collections.shuffle(Cards);

  //        V.发牌（遍历集合）
  ArrayList<Integer> player1 = new ArrayList<Integer>();
  ArrayList<Integer> player2 = new ArrayList<Integer>();
  ArrayList<Integer> player3 = new ArrayList<Integer>();
  ArrayList<Integer> Holo_Card = new ArrayList<Integer>();

  //        IV.对编号排序（sort）
  //此处不能使用增强for
  for (int i = 0; i < Cards.size()-3; i++) {
    Integer Card = Cards.get(i);
    if (i % 3 == 0) {
      player1.add(Card);
    } else if (i % 3 == 1) {
      player2.add(Card);
    } else {
      player3.add(Card);
    }
  }
  //最后3张给底牌
  Holo_Card.add(Cards.get(53));
  Holo_Card.add(Cards.get(52));
  Holo_Card.add(Cards.get(51));

  Collections.sort(player1);
  Collections.sort(player2);
  Collections.sort(player3);
  Collections.sort(Holo_Card);

  //        IIV.转牌（以键找值map.get）
  //        IIIV.打印给用户（println）
  lookCards(player1, Map);
  lookCards(player2, Map);
  lookCards(player3, Map);
  lookCards(Holo_Card, Map);
}

public static void lookCards(ArrayList<Integer> idCards, LinkedHashMap<Integer, String> Map) {
  for (Integer idCard : idCards) {
    String card = Map.get(idCard);
    System.out.println(card + "");
  }
  System.out.println();
}
```
3.3 代码实现

三.冒泡排序
排序:将一组数据按照固定的规则进行排列

3.1 冒泡排序的介绍
所谓的冒泡排序的思想：
依次比较数组/集合中相连的两个元素，然后将较大的元素放在后面，最后按照从小到大的顺序排列出来
规律：
•如果有n个数进行排序比较，那么比较次数为n-1轮
•每轮比较完毕，下一轮比较就会少一个数据参与

4.2 冒泡排序过程图解

3.3 代码实现

```java
public static void main(String[] args) {
  int[] arr = {4, 6, 1, 3, 82, 9, 7, 5};
  //外层循环，控制循环次数
  for (int i = 0; i < arr.length - 1; i++) {
    //内层循环，控制比较次数
    for (int j = 0; j < arr.length - 1 - i; j++) {
      if (arr[j] > arr[j + 1]) {
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
      }
    }
  }
  System.out.println(Arrays.toString(arr));
}
```


总结：
1.Map接口中定义对通用方法*
put(K,V);
remove(K);
get(K)
put(repeat K,V)
containsKey(K)
containsValue(V)

2.Map各种实现类对遍历方式(以键找值，键值对)*
a.以键找值
set keys = map.kepSet();
for(K key:keys){//遍历所有的键
//以键找值
V value = map.get(key);
sout(key,value);
}

b.键值对
set<Map.Entry<K,V>> entrys = map.entrySet();//获取所有的键值对集合
for(Map.Entry<K,V> entry:entrys)//遍历键值对集合
{
K key = entry.getKey();//获取键值中对键和值
V value = entry.getValue();//获取键值中对键和值
sout(key,value);
}
3.集合嵌套
a.List套list
ArrayList<ArrayList> arr;

b.List套Map
ArrayList<HashMap<String,Integet>> arr;

c.Map套map
HashMap<String,HashMap<String,Integer>> map;

4.斗地主案例*

5.冒泡排序
a.冒泡过程
b.算法背下来

```java
for(int i=0;i<arr.lenth-1;i++){
  for(int j=0;j<arr.lenth-1-i;j++){
    if(arr[j]>arr[j+i]){
      int temp=arr[j];
      arr[j]=arr[j+1]
        arr[j+1]=temp;
    }}
}
```

