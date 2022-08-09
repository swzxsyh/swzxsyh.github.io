---
title: HTML 入门
date: 2020-04-04 01:01:44
tags:
---

一.HTML概述
超文本标记语言(Hyper Text Markup Language)
作用：搭建基础网页
超文本:具有普通文本的特性，同时还可以假如图片、视频、超链接等等
标记:即标签。预定义好的标签有不同的效果或者功能
语言:人与计算机沟通桥梁
二.HTML基础
创建:在IntelliJ IDEA-New Project-New Moudle-Static Web

Editor->Code Style->HTML->Other->Do not indent children of去除即可快捷键格式化


```html
<!DOCTYPE html><!--文档声明，声明当前html版本为5，固定格式 -->
<html lang="zh-CN"><!-- 表示当前网页语言 en英语，zh-CN简体中文 -->
  <head>
    <meta charset="UTF-8">
    <title>First Html</title>
  </head>
  <body>
    Hello,World
  </body>
</html>
```

2.2 书写规范
文档声明
要求:必须在第一行，固定格式

标签
要求：正确嵌套，正确闭合
双标签<开始></结束>
单标签<开始/>

属性
要求：必须在开始标签中编写，属性值单双引都可以
<开始 属性名=”属性值”></结束>

文本
要求：在标签题内编写

注释

1
<!-- 注释内容 -->
三.HTML常用标签
标签语义
标签语义：这个标签能干啥

3.1 标题标签

```html
<body>
  <!--
<hn></hn>
n表示取值范围:1~6
数值越小，字体越大
常用属性:
align:对齐方式
取值:left center right
-->

  <h1 align="center">我是H1标题</h1>
  <h2 align="left">我是H2标题</h2>
  <h3 align="right">我是H3标题</h3>
  <h4>我是H4标题</h4>
  <h5>我是H5标题</h5>
  <h6>我是H6标题</h6>

</body>
```

3.2 水平线标签

```html
<body>
  <!--
水平线:<hr/>
常用属性:
color:颜色
R(0-255)G(0-255)B(0-255) #ff ff ff
width: 宽度
1.像素 px 固定值
2.百分比 % 屏幕自适应
-->
  <hr>
  <hr color="red">
  <hr color="#183624" width="500px">
  <hr color="grey" width="50%">
</body>
```

3.3 段落和换行标签

```html
<body>
  <!--
换行:<br>
段落:<p></p>
上下留白
-->
  1<br>2<br>3<p>4</p><p>5</p><p>6</p>
</body>
```



3.4 超链接

```html
<body>
  <!--
超链接<a></a>
常用属性:
href:页面跳转地址
1.绝对地址 www.baidu.com
2.相对地址
./当前目录
../上级目录
3.target:打开方式
_self(default):当前窗口跳转
_blank:打开新窗口跳转      
-->
  <a href="http://www.baidu.com">百度</a>
  <br>
  <a href="./01%20Caption.html">相对地址标题 </a>
  <br>
  <a href="02%20Horizontal.html">水平线标题 </a>
  <br>
  <a href="../index.html">index.html </a>
  <a href="../../Day26_Web.iml">index.html </a>
  <br>
  <a href="http://www.bing.com" target="_blank">Bing</a>
</body>
```

3.5 图像标签

```html
<body>
  <!--
图像:<img/>
常用属性:
src: 图片资源地址
相对地址:网站内部地址
绝对地址:网站外部地址
alt:图片资源丢失后，问题提示
width:图片宽度
1.px像素固定值
2.% 百分比
height:高度
一般不使用，会失真
-->
  <img src="../img/Danboard.jpg" width="200px" alt="">
  <img src="../../img/Danboard.jpg" alt="错误">
  <img src="http://suo.im/5zeYyC" width="200px" height="200px" alt="错误">
</body>
```

3.6 列表

```html
<body>
  <!--
有序列表:<ol></ol>
无序列表:<ul></ul>
共同自标签:<li></li>
-->
  <ol>
    <li>A</li>
    <li>B</li>
  </ol>
  <ul>
    <li>C</li>
    <li>D</li>
    <li>E</li>
    <li>F</li>
  </ul>
</body>
```

3.7 div和span标签
没有语义的，就是一个容器，用来装内容，万物皆容器

```html
<body>
  <!--    <div>和<span>是没有语义的,就是一个容器,用来装内容
div(块级元素):大容器,特点:独自占用一行
span(行内元素):小容器,特点:内容有多大占用就多大
-->
  <div>AAAAAAAAAAAAABBBBBBBBBBBBB</div>
  <span>AAAAAAAAAAAAA</span>
  <span>BBBBBBBBBBBBB</span></body>
```

3.8 转义(实体)字符

```html

<body>
  <!--
在HTML中有两种特殊的转义符号
1.与HTML语法有冲突,例如a<b>c 小于号 &lt;
2.输入法不方便输入 ❤️
常用字体符(了解)
&nbsp; 英文半角空格
&emsp; 中文汉字空格
&lt;   小于号
&gt;   大于号
&amp;  &符号
-->
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AAA
  <br>
  &emsp;AAA &lt; &amp; &gt;
</body>
```

3.9 基本表格
有条理性地展示内容

```html

<body>
  <!--
table --表格
tr —— 列
td —— 行
th -- 列表单元格(居中，加粗)
table常用属性
border:边框
width:宽度
height:高度
align:表格对齐方式
取值：left,center,right
cellspacing：单元格外边距，通常取值 0
cellpadding：单元格内边距，通常取值 0
bgcolor:表格背景色
tr常用属性
bgcolor:表格背景色
align:内容对齐方式
取值：left,center,right
height:行高
td常用属性
bgcolor:表格背景色
align:内容对齐方式
-->
  <table border="1" width="300px" align="center" cellpadding="0" cellspacing="0" bgcolor="red" >
    <tr bgcolor="green" height="50">
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr align="center">
      <td>4</td>
      <td>5</td>
      <td>6</td>
    </tr>
    <tr>
      <td>7</td>
      <td bgcolor="pink" align="right">8</td>
      <td>9</td>
    </tr>
  </table>
</body>
```
3.10 合并表格



```html
<body>
  <!--
跨行合并：rowspan = "合并行数"
跨列合并：colspan = "合并列数"
1.确定跨行还是跨列
2.确定目标单元格
3.删除被合并的单元格
-->
  <table border="1" width="300px" align="center" cellpadding="0" cellspacing="0" bgcolor="red">
    <tr bgcolor="green" height="50">
      <td>1</td>
      <td colspan="2">2</td>
      <!--        <td>3</td>-->
    </tr>
    <tr>
      <td rowspan="2">4</td>
      <td>5</td>
      <td>6</td>
    </tr>
    <tr>
      <!--        <td>7</td>-->
      <td>8</td>
      <td>9</td>
    </tr>
  </table>
</body>
```

四.HTML的form表单
4.1 采集用户数据
4.2 发送数据到服务端(Java服务器)


```html
<body>
  <!--
表单:<form></form>(容器)
常用属性：
action:表单提交服务器的地址，今天暂时用#(当前页面)
method:表单提交方式，有两种:get(默认),post
get:
格式：提交地址:username=A&password=B&birthday=&gender=Male
特点：
参数在地址栏拼接，不太安全
浏览器地址大学有限制
post:
格式:username=A&password=B&birthday=&gender=Male
特点:
参数没有在地址栏拼接，相对安全(HTTP请求体)
浏览器不会对请求体做大小对限制
表单项标签:
1)文本框<input>
常用属性:
name:表单项的参数名(想要表单被提交，必须知道name的值)
value:表单项的值(用户输入,用户选择)
type:表单项类型，有很多中，不同的类型功能和展示效果也有所不同。
常用9种:
a.text 文本框(默认)
b.password 密码框 特点:掩码
c.date 日期选择框
d.radio 单选框  特点:同一组(name的值相等)只能选一个，checked="checked"设置默认选中
e.checkbox 复选框 特点:同一组(name的值相等)能选择多个，checked="checked"设置默认选中
f.file 文件上传 特点:必须post方式
reset 重置按钮(清空表单),特点:value属性就是按钮名称
submit 提交按钮,特点:value属性就是按钮名称

2)下拉框:<select></select>
列表项:<option></option>
常用属性: selected="selected"默认列表项被选中
3)文本域:<textarea></textarea>
常用属性:
rows:行高
cols:列宽
-->
  <form action="#" method="post">
    Name:<input type="text" name="username" placeholder="Please Input Name"><br>
    Passwd:<input type="password" name="password" placeholder="Please Input Passwd"><br>
    Birthday:<input type="date" name="birthday"><br>

    Gender:
    <input type="radio" name="gender" value="Male" checked="checked">Male
    <input type="radio" name="gender" value="Female">Female
    <br>

    Hobby:
    <input type="checkbox" name="hobby" value="smoke"> Smoke
    <input type="checkbox" name="hobby" value="drink"> Drink
    <input type="checkbox" name="hobby" value="perm" checked="checked"> perm
    <br>
    <input type="file" name="pic">
    <br>
    Level:
    <select name="Level">
      <option value="1">One</option>
      <option value="2" selected="selected">Two</option>
      <option value="3">Three</option>
    </select>
    <br>
    Intro:
    <textarea name="intro" rows="5" cols="20">
    </textarea>
    <br>
    <input type="reset" value="Reset Button">
    <input type="Submit" value="Submit Button">
  </form>
</body>
```
总结
第1章 概述
HTML

超文本标记语言

作用：搭建基础网页结构
第2章 基础
开发工具

idea

搭建 static web 模块
书写规范

文档声明

标签

双标签

单标签

<开始/>
属性

文本

注释

第3章 常用标签
标题

hn

h1~h6
水平线

hr

color

光三原色
段落换行

br

换行
p

段落

特点：上下留白
a

超链接

href

绝对地址

相对地址

./当前目录
../上一级目录
target

_self（默认）

_blank

打开新窗口
img

src

相对地址

./当前目录
../上一级目录
绝对地址

width

纵横比缩放
height

alt

列表

ul

无序
ol

有序
li

容器

div

块级元素，特点：独自占用一行
span

行内元素，特点：内容有多少，就占用多少
转义字符

&XXX;

 

英文半角
 

中文汉字
>

<

表格

table

border
bgcolor
cellspacing
cellpadding
width
height
align
tr

height
align
td

width

align

表格合并

colspan
rowspan
th

列标题单元格

特点：居中、加粗
第4章 表单
表单容器

form

action

method

get

post

推荐使用
表单标签

input

name

value

type

text
password
date
radio
checkbox
file
reset
submit
button
checked

用于设置单选和复选默认选中
label

for

表单项辅助标签

需要跟表单项id进行绑定
select

option

selected

默认选中
textarea