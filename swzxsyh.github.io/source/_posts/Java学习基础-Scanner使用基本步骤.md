---
title: Java学习基础-Scanner使用基本步骤
date: 2020-02-26 00:15:58
tags:
---

一.数据输入
1.1 Scanner使用基本步骤
①导包
import java.util.Scanner;
导包的动作必须出现在定义上面。
②创建对象
Scanner sc = new Scanner(System.in);
上面这个格式里，只有变量名sc可以变，其他都不允许变。
③接收数据
int i = sc.nextInt();
上面这个格式里，只有变量名i可以变，其他都不允许变。