---
title: JAVA-List实现类对比
date: 2022-07-05 22:48:38
tags:
---

# List

## LinkedList vs ArrayList

### Internal implementation

这两个集合都允许重复的元素并维持元素的插入顺序。 

`LinkedList`使用**doubly-linked list** `LinkedList`实现它。 `ArrayList`使用**dynamically resizing array**实现它。 这将导致性能上的进一步差异。

### Performance

#### Add operation

如果不需要调整Array的大小，则在ArrayList中添加元素是`O(1)`操作。 如果调整数组大小，则它变为`O(log(n))` 。 

在LinkedList中添加元素是`O(1)`操作，因为它不需要任何导航。 

<!-- more -->

#### Remove operation

当我们从ArrayList中移除一个元素（在后备数组中）时，它将所有元素向右移动。 在最坏的情况下（删除第一个元素），它接近`O(n)` ；在最好的情况下（删除最后一个元素），它接近`O(n)` ）。 

LinkedList删除操作提供`O(1)`性能，因为它只需要重置上一个和下一个节点的指针。 无需复制或移动。 

#### Iteration

迭代是LinkedList和ArrayList的`O(n)`操作，其中n是元素的数量。 

#### Get operation

ArrayList提供`get(int index)`方法，该方法可以直接在给定索引位置找到元素。 它的阶数为**O(1)** 。 

LinkedList还提供`get(int index)`方法，但它首先遍历所有节点以到达正确的节点。 它使性能可变。 最好的情况是`O(1)` ，最坏的情况是`O(n)` 。

### Conclusion

在不处理大量数据之前，这两个类都将为您提供相同的性能水平。 两者都提供有序集合，并且两者也不同步。 

`LinkedList`实现`Deque`接口，因此它通过诸如`peek()`和`poll()`方法提供**queue**如**FIFO**功能。 

从性能比较中可以看出， `ArrayList`更适合存储和访问数据。 `LinkedList`更适合处理数据。



## ArrayList vs Vector

### Thread safety

**`Vector`是一个同步集合，而`ArrayList`不是** 。 

这仅表示在并发应用程序上工作时，我们可以使用Vector，而无需开发人员使用`synchronized`关键字实现任何其他同步控件。 矢量内部的公共方法被定义为`synchronized` ，这使得矢量中的所有操作对于并发需求都是安全的。 

要在并发应用程序中使用arraylist，我们必须显式控制对实例的线程访问，以使应用程序按预期工作。 如果要获取arraylist的同步版本，则可以使用`Collections.synchronizedList()`方法。 

返回的列表是`List`接口的内部实现，与arraylist不同。 但是它具有与arraylist类相同的功能。

### Capacity increment

默认情况下，当vector需要增加容量以添加元素时（填充现有容量时），其容量会增加**100%.** 这意味着矢量大小增长到以前的容量的两倍。 我们可以使用构造函数`public Vector(int initialCapacity, int capacityIncrement)` CapacityIncrement）覆盖默认容量。 这里的第二个参数是向量溢出时容量增加的数量。 

在ArrayList中，默认情况下，容量将增加现有容量的`50%` 。 在arraylist中，我们可以定义初始容量，但不能定义容量增加因子

### Performance

这两个集合都有一个后备数组，它们在其上存储和搜索元素。 因此，本质上， **add**和**get**操作的性能差异不大。 

当我们考虑同步时，就会出现真正的性能差异。 `ArrayList`是不同步的，因此线程安全性没有时间流逝。 `Vector`是`synchronized` ，因此它在线程管理/锁定等方面有一些开销。

### ConcurrentModificationException

这些合集如何处理迭代而集合仍由程序修改时有一个区别。 

`ArrayList`提供迭代器，它们是**fail-fast** 。 一旦我们修改了arraylist结构（添加或删除元素），迭代器就会抛出**ConcurrentModificationException**错误。 

`Vector`提供**iterator**以及**enumeration** 。 迭代器是快速失败的，而枚举不是。 如果我们在枚举迭代期间修改向量，则它不会失败。











###### 来源:

https://rumenz.com/java-topic/java/collections/arraylist/linkedlist-vs-arraylist/index.html

https://rumenz.com/java-topic/java/collections/arraylist/arraylist-vs-vector/index.html
