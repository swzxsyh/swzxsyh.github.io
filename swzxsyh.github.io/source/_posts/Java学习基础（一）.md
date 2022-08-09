---
title: Java学习基础（一）
date: 2020-02-25 23:59:30
tags: 
---


一：注释方法
//单行注释

/*
多行注释
*/

/**
文档注释
*/
二：关键字定义&&赋值
​ 关键字字母全部小写，一般会highlight

​ 变量：在程序运行过程中，其值可以发生改变的量。本质上讲，变量是内存的一小块区域。

​ 常量：在程序运行中，值不可更改的量
​ 常量分类：

字符串常量	用双引号括起来的内容	“Hello”,”一二三”
整数常量	不带小数点的数字	±1
小数常量	带小数点的数字	±3.14
字符常量	用单引号括起来的内容	‘A’,’0’,’我’
布尔常量	布尔值，true/false	true,false
空常量	特殊值，空值	null
/*
Java程序最基本组成单位：类
格式：
public class 类名称{
}
*/

```java
public class HelloWorld{
    //main方法是程序的入口方法，代码从main开始执行
	public static void main(String[] args){
		//字符串常量
		System.out.println("HelloWorld，一");
		//整数常量
		System.out.println(1);
		//小数串常量
		System.out.println(3.14);
		//字符常量
		System.out.println('A');
		System.out.println('0');
		System.out.println('一');
		//布尔常量
		System.out.println(true);
		System.out.println(false);

		/*空常量，不能直接输出
		System.out.println(null);
		
		error: reference to println is ambiguous
		System.out.println(null);
		          ^
		both method println(char[]) in PrintStream and method println(String) in PrintStream match
		*/
	}
}
```
三.数据类型
​ Java语言是强类型语言，对于每一种数据都给出了明确的数据类型，不同的数据类型也分配了不同的内存空间，所以它们表示的数据大小也是不一样的。

![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80%EF%BC%88%E4%B8%80%EF%BC%89/%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B.svg)


数据类型	关键字	内存占	取值范围
整数	byte	1	-128～127
short	2	-32768-32767
int （默认）	4	-2的31次方到2的31次方-1
long	8	-2的63次方到2的63次方-1
浮点数	float	4	负数：-3.402823E+38到-1.401298E-45
正数1.401298E-45到3.402823E+38
double （默认）	8	负数：-1.797693E+308到-4.9000000EE-324
正数：4.9000000EE-324到1.797693E+308
字符	char	2	0-65535
布尔	boolean	1	true，false
说明：E+38表示乘以10的38次方，E-45即乘以-10的45次方			
四：名称定义
​ 标识符：就是给类、方法，变量等起名字的符号。
​ 定义规则：
​ •由数字、字母、下划线（_）和美元符($)组成。
​ •不能以数字开头。
​ •不能是关键字。
​ •区分大小写。
​ 常见命名约定：
​ 小驼峰命名法：方法、变量
​ •约定1:标识符是一个单词的时候，首字母小写。
​ •范例1:name
​ •约定2:标识符由多个字母组成时，第一个单词字母小写，其他单词首字母大写。
​ •范例2:firstName
​ 大驼峰命名法：类
​ •约定1:标识符是一个单词的时候，首字母大写。
​ •范例1:Student
​ •约定2:标识符由多个字母组成时，每个单词首字母大写。
​ •范例2:GoodStudent

五：类型转换
​ 自动类型转换：把一个表示数据范围小的值或者变量赋予给另一个表示数据范围大的变量。
​ 范例：double d = 10；


![image](./Java%E5%AD%A6%E4%B9%A0%E5%9F%BA%E7%A1%80%EF%BC%88%E4%B8%80%EF%BC%89/%E7%B1%BB%E5%9E%8B%E8%BD%AC%E6%8D%A2.svg)


强制类型转换：把一个数据范围大的数值或者变量赋值给一个表示数据范围小的变量
•格式：目标数据类型 变量名=（目标数据类型）值或者变量
•范例int k = （int）88.88；