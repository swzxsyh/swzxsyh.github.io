---
title: JSP & MVC
date: 2020-04-21 01:26:17
tags:
---

一.JSP
1.1 概述
简单来说:在html标签中嵌套java代码
作用:简化书写，展示动态页面
1.2 快速入门
在jsp页面显示当前时间
```jsp
<body>
<%
    Date date = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
    String currentTime = sdf.format(date);
%>
<h3><%out.write(currentTime);%></h3>

</body>
```
1.3 工作原理
JSP本质就是一个Servlet
index.jsp
转换⬇
index_jsp.java
servlet接口
编译⬇
index_jsp.class
执行 service方法
1.4 脚本和注释
1.4.1 脚本
JSP通过脚本方式来定义Java代码
格式	说明
<% 代码%>	脚本片段，生成在service方法中，每次请求的时候都会执行
<%! 代码%>	声明片段，在java代码中声明成员，放在jsp生成jsva文件中的成员位置
<%=代码%>	输出脚本片段，相当于out.print(“Code”);方法，输出到jsp页面
格式	说明
out.print();	方法支持一切类型输出
out.write();	仅支持字符类型输出，如果传递的是整型，将根据ASCII码表转换输出
1.4.2 注释
格式	说明
<!– 注释静态资源 –>	html注释
<%– 注释所有 –%>	JSP注释
// 单行注释
/* 多行注释 /
/*文档注释 */	Java注释(JSP脚本内使用)
1.5 指令
作用
用于配置JSP页面，导入资源文件

格式
<%@ 指令名称 属性名1=”属性值1” 属性名2=”属性值2” %>

三大指令

指令	作用
page	配置JSP页面
include	页面包含(静态)
taglib	导入资源文件
1.5.1 page指令
指令	作用
contentType	相当于response.setContentType();设置响应体的MIME类型和编码方式
language	指定语言，目前仅支持Java
import	导入jar包
errorpage	当页面报错后，自动跳转到指定错误提示页面
isErrorpage	默认false关闭，设置true
```jsp
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"  errorPage="500.jsp"%>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    new Date();
    new SimpleDateFormat();
    Integer age=1/0;
%>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h3>Server Busy</h3>
<%
    //打印错误提示
    out.print(exception.getMessage());
%>
</body>
```
1.5.2 include指令(静态包含)
```jsp
<!-- top.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Top</title>
</head>
<body>
<div style="border: skyblue dashed 5px;height: 150px">Top</div>
</body>
</html>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Demo03</title>
</head>
<body>
<%@include file="top.jsp"%>
<div style="border: 5px solid red;height:200px ">
Demo03
</div>
</body>
</html>
```
1.5.3 taglib指令
导入jar包
通过taglib指令引入
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Demo04</title>
</head>
<body>
<h3>Taglib 指令</h3>
<c:if test=""></c:if>
</body>
</html>
```
1.6 内置对象
作用
JSP 页面中不需要get获取也不需要手动创建，就可以直接使用的对象
变量名	真实类型	作用
pageContexxt	PageContext	当前页面中共享数据(域对象)
request	HttpServletRequest	一切请求中共享数据
session	HttpSession	一次会话中共享数据(域对象)
application	ServletContext	整个web应用共享数据(域对象)
————-	——————-	——————-
response	HttpServletResponse	响应对象
page(this)	Object	当前页面Servlet对象
out	JSPWriter	输出对象
config	ServletConfig	Servlet配置对象
exception	Throwable	异常对象(默认关闭)
常用:
pageContext	1)当前页面的域对象
2)获取其他八个内置对象
request	1)接收用户请求(参数)
2)一次请求中域对象
response	1)设置响应:
  字节流
  字符流
out	1)专门在jsp中处理字符流
  print()//可以输出一切类型
  wirte(); //只能输出字符类型
1.7 JSP动作标签
作用
简化JSP页面编码
常用
指令	底层	作用
<Jsp:include>	request.getRequestDispatcher().include(req,resp)	页面包含(动态)
<Jsp:forward>	request.getRequestDispatcher().forward(req,resp)	请求转发(页面跳转)
<Jsp:param>	include forward的子标签
使用request.getParameter()获取参数	参数传递
1.7.1 动态包含
静态包含

demo03.jsp	合并转换为一个java文件➡	demo3.java	编译➡	demo3.class	执行➡	response封装响应输出
top.jsp
动态包含

demo06.jsp	转换➡	demo06.java	编译➡	demo06.class	合并执行➡	response封装响应输出
top.jsp	转换➡	top.java	编译➡	top.class

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <title>Demo06</title>
</head>

<body>
<jsp:include page="top.jsp"></jsp:include>

<div style="border: gray 1px solid;height: 400px">JSP的动态包含:主体</div>

</body>
</html>
```


在企业开发时，推荐使用静态包含提示访问性能；注意:不能出现重名的变量

1.7.2 请求转发
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>A</title>
</head>
<body>
<%
    System.out.println("A Run");
    request.setAttribute("username","request Set");
%>
<jsp:forward page="b.jsp">
    <jsp:param name="name" value="jack"></jsp:param>
    <jsp:param name="age" value="18"></jsp:param>
</jsp:forward>
</body>
</html>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>B</title>
</head>
<body>
<%
    System.out.println("B Run");
    //request域传递
    System.out.println(request.getAttribute("username"));
    //param标签传递
    System.out.println(request.getParameter("name"));
    System.out.println(request.getParameter("age"));
%>
</body>
</html>
```
二.MVC模式
2.1 JSP发展介绍
早期只有servlet，只能使用response输出html标签，非常麻烦。
后来有了JSP，简化了servlet开发;如果过度使用JSP，在JSP页面中写了大量的java代码和html标签，造成难于 维护，难于分工协作的场景。
再后来为了弥补过度使用jsp的问题，我们使用servlet+jsp这套组合拳，利于分工协作。
简单来说:就是一套总结出来的设计经验，适合在各种软件开发领域

目的:高内聚，低耦合
2.2 MVC介绍
MVC设计模式: Model-View-Controller简写。
MVC是软件工程中的一种软件架构模式，它是一种分离业务逻辑与显示界面的设计方法。
指令	
M	model(模型)
⬇
JavaBean(1.处理业务逻辑，2.封装实体)
V	view(视图
⬇
JSP(展示数据)
C	controller(控制器)
⬇
Servlet(1.接收请求，2.调用模型，3.转发视图)
优点	降低耦合性，方便维护和拓展，利于分工协作
缺点	使得项目架构变得复杂，对开发人员要求高
客户端
静态资源
动态资源
请求➡	服务器
Controller
Servlet
1.接收请求
2.调用模型
3.转发视图	➡
⬅	Model
JavaBean
处理业务逻辑
封装实体	➡
⬅	SQL
⬇
⬅返回	View
jsp、html
展示动静内容
