---
title: EL & JSTL & MVC
date: 2020-04-21 01:23:40
tags:
---

一.EL
1.1 概述
表达式语言(Expression Language)
作用:
主要用于代替jsp中脚本的功能，简化对java代码对操作
语法:
${表达式}
1.2 使用
1.2.1 获取值
EL表达式只能从域对象(4个域)中获取数据
标准写法	
${pageScope.键名}	从page域中获取指定键名对应的值
${requestScope.键名}	从request域中获取指定键名对应的值
${sessionScope.键名}	从session域中获取指定键名对应的值
${applicationScope.键名}	从servletContext域中获取指定键名对应的值
简化写法	
${键名}	特点:默认从最小域开始找，找到后直接显示，不在继续寻找
注意:要求四个域键名唯一
```js
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Demo01</title>
</head>
<body>
<h3>EL 表达式基本语法</h3>
<%
    /*模拟Servlet向域中存值*/
    pageContext.setAttribute("Username", "Jack");
    request.setAttribute("Age", "50");
    session.setAttribute("Gender", "Male");
    application.setAttribute("Address", "NY");
%>
<h5>标准语法</h5>
${pageScope.Username}<br><%--不会提示空指针异常--%>
${requestScope.Age}<br>
${sessionScope.Gender}<br>
${applicationScope.Address}<br>
<h5>简化语法</h5>
${Username}<br>
${Age}<br>
${Gender}<br>
${Address}<br>
</body>
</html>
```
练习
获取字符串	${键名}
获取对象(User)	${键名.属性名}
获取List(Array)集合	${键名[索引]}
获取Map集合	${键名.key}
${键名[“key”]}
——–	
注意	El不会出现null和数组角标越界问题
```js
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <html>
  <head>
  <title>Demo02</title>
</head>
<body>
  <h3>获取User对象</h3>
<%
  User user = new User("Jack", 13, "Male");
request.setAttribute("user",user);
%>
  ${user}<br><%--执行该对象对toString方法--%>
    ${user.username} ｜${user.age} ｜${user.gender}<br>

      <h3>获取List集合</h3>
<%
      List<Object> list = new ArrayList<>();
list.add("A");
list.add("B");
list.add("C");
list.add(user);
request.setAttribute("list",list);

%>>
  ${list}<br><%--执行该对象对toString方法--%>
    ${list[0]} ｜ ${list[1]} ｜ ${list[2]} ｜ ${list[3].username} ｜${list[3].age}<br>
      ${list[3].gender}<%--EL表达式不会出现集合(数组)角标越界异常--%>

        <h3>获取map集合</h3>
<%
        Map<String, Object> map = new HashMap<>();
map.put("key1","A");
map.put("key2","B");
map.put("key3","C");
map.put("key.4",user);
request.setAttribute("map",map);
%>
  ${map}<br><%--执行该对象对toString方法--%>
    ${map.get("key1")} | ${map.key2} | ${map.key3}<br>
      ${map['key.4']}<br>
        ${map['key.4'].username} | ${map['key.4'].age} | ${map['key.4'].gender}
</body>
</html>
```
1.2.2 执行运算
运算符	语法
算数运算符	+ - * /(div) %(mod)
比较运算符	> < >= <= ==(eq) !=(ne)
逻辑运算符	&&(and)
三元运算符	${条件表达式?为真:为假}
——–	————————–
空运算符	${not empty 对象}
功能:
可以判断字符串和对象是否为空
可以判断一个集合的长度是否为0
```js
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <html>
  <head>
  <title>Demo03</title>
</head>
<body>
  <%
  int a = 4;
int b = 3;
request.setAttribute("a", a);
request.setAttribute("b", b);
%>
  <h5>算数运算符</h5>
${a / b} | ${a div b} <br>
  ${a % b} | ${a mod b} <br>

    <h5>比较运算符</h5>
${a == b} | ${a eq b}<br>
  ${a != b} | ${a ne b}<br>

    <h5>三元运算符</h5>
${a==b?"Y":"N"}<br>

  <h5>非空判断</h5>
<%
  User user = new User();
request.setAttribute("user", user);

List list = new ArrayList();
list.add("aa");
request.setAttribute("list", list);
%>
  ${not empty user}<%--if(user != null){}--%>
    ${not empty list}<%--if(list != null && list.size()>0)--%><br>

      <h5>空值判断</h5>
${empty user}<%--if(user == null){}--%>
  ${empty list}<%--if(list == null && list.size()==0)--%><br>
    </body>
</html>
```
1.2.3 隐式对象
EL表达式中有11个隐藏对象
掌握
pageContext
cookie
对象	作用
pageContext	就是jsp九大内置对象之一，可以通过它获得其他八个内置对象
cookie	可以获取浏览器指定cookie名称的值

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

  <head>
    <title>Demo04</title>
  </head>

  <body>

    <h3>EL隐式对象</h3>

    ${pageContext.request.contextPath}<%--动态获取:项目名称(虚拟路径)--%><br>
    ${cookie.JSESSIONID.value}<%--获取指定cookie名称的值--%>
  </body>
</html>
1.2.4 补充
jsp默认支持el表达式
servlet2.3规范中，默认不支持el表达式
忽略el表达式	方法
忽略当前jsp页面中所有的el表达式	isELIgnored=”true” 属性
忽略单个el表达式	${表达式}

<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
  <head>
    <title>Demo04</title>
  </head>
  <body>
    <h3>EL隐式对象</h3>
    ${pageContext.request.contextPath}<%--动态获取:项目名称(虚拟路径)--%><br>
    ${cookie.JSESSIONID.value}<br><%--获取指定cookie名称的值--%>
    \${cookie.JSESSIONID.value}<%--获取指定cookie名称的值--%>
  </body>
</html>
```

1.3 JavaBean
实际上是一个普通Java类
使用规范
所有字段(成员变量)为private
提供无参构造方法
提供getter,setter和is方法
实现Serializable接口
例如:如下User类有4个字段(成员变量),有全参和无参构造方法，有一个属性(username)

```java
public class User implements Serializable {
  private String Username;
  private Integer Age;
  private String  Gender;

  private boolean success;//是否操作成功

  public boolean isSuccess() {
    return success;
  }

  public void setSuccess(boolean success) {
    this.success = success;
  }

  public User() {
  }

  public String getUsername() {
    return Username;
  }

  public void setUsername(String username) {
    Username = username;
  }

  public Integer getAge() {
    return Age;
  }

  public void setAge(Integer age) {
    Age = age;
  }

  public String getGender() {
    return Gender;
  }

  public void setGender(String gender) {
    Gender = gender;
  }
}
```
二.JSTL
2.1 概述
Jsp 标准标签库(Jsp Standard Tag Library)，是由Apache组织提供的开源的jsp标签库
作用:替换和简化jsp页面中java代码的编写
JSTL标准标签库有5个子库，但随着发展，目前常使用的是它的核心库(Core)
标签库	标签库的URI	前缀
Core	http://java.sun.com/jsp/jstl/core	c
国际化(几乎不用)	http://java.sun.com/jsp/jstl/fmt	fmt
SQL(过时)	http://java.sun.com/jsp/jstl/sql	sql
XML(过时)	http://java.sun.com/jsp/jstl/xml	x
Functions(几乎不用)	http://java.sun.com/jsp/jstl/functions	fn
2.2 Core标签使用
2.2.1 使用步骤
当前Web项目引入第三方jar包
当前JSP页面使用taglib指令引入core核心标签
```js
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <html>
    <head>
    <title>Demo01</title>
</head>
<body>
    </body>
</html>
```
2.2.2 常用标签
标签		语法
c:if	相当于Java中的if(){}	<c:if test=”boolean值>
true:显示标签体内容
false:隐藏标签体内容
注意:此标签没有else功能，需要使用就取反
c:forEach	1)普通for循环for(int i=1;i<=5;i++){i}
<c:forEach>
begin=”1”起始值(包含)
end=”5”结束值(包含)
step=”1”步长1
var=”i” 当前输出临时变量

2) 增强for循环 for(User user:list){user}	<c:forEach items=”${list}” var=”user” varStatus=”vs”>
${user}
</c:forEach>
items=”list” 集合
var=”user” 当前输出的临时变量
varStatus=”vs” 变量状态
index 当前索引 从0开始
count 计数器 从1开始
c:choose	相当于java中的switch语句	<c:choose>等价于switch
<c:when>等价于case+break
<c:otherwise>等价于default
```js
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <html>
    <head>
    <title>Demo01</title>
</head>
<body>
    <%
    User user = new User();
user.setUsername("Jack");
request.setAttribute("user",user);
%>

  <c:if test="${empty user}">
    Welcome ,Please Login
      </c:if>
<c:if test="${not empty user}">
  Welcome, ${user.username}
</c:if>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <html>
    <head>
    <title>Demo02</title>
</head>
<body>
    <h3>普通for循环</h3>
<c:forEach begin="1" end="5" step="1" var="i">    <%--for循环将临时变量存储到pageContext域空间--%>
    ${i}<br>
      </c:forEach>

<h3>增强for循环</h3>
<%
      List list = new ArrayList();
list.add(new User("A",1,"F"));
list.add(new User("B",1,"F"));
list.add(new User("C",1,"M"));
list.add(new User("D",1,"M"));
request.setAttribute("list",list);
%>>
  ${requestScope.list}

<c:forEach items="${list}" var="user" varStatus="vs">
  索引:${vs.index}<br>
    计数器:${vs.count}<br>
      ${user}<br>
        ${user.username}<br>
          </c:forEach>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <html>
    <head>
    <title>Demo03</title>
</head>
<body>
    <h3>Choose标签</h3>
<%
    Integer money=30000;
request.setAttribute("money",money);
%>
  <c:choose>
    <c:when test="${money==7000}">AAA</c:when>
<c:when test="${money==8000}">BBB</c:when>
<c:when test="${money==9000}">CCC</c:when>
<c:when test="${money==30000}">DDD</c:when>
<c:otherwise>
  ZZZZZZ
</c:otherwise>
</c:choose>
</body>
</html>
```
三.三层架构
3.1 概述
通常意义上的三层架构就是将整个业务应用划分为:表示层、业务逻辑层、数据访问层
区分层次的目的为了高聚合低耦合思想
表示层:称为web层，与浏览器进行数据交互(控制器合视图)
业务逻辑层:又称为service层，处理业务数据(if判断，for循环)
数据访问(持久)层:称为Dao层，与数据库进行交互(每一条记录与JavaBean实体产生对应关系)

包目录结构	
com.xxx	基本包(公司域名倒写)
com.xxx.dao	持久层
com.xxx.service	业务层
com.xxx.web	表示层
com.xxx.domain	实体(JavaBean)
com.xxx.util	工具
3.2 案例:用户信息列表显示
需求:MVC模式开发代码，完成用户显示列表功能。
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

```java
public class UserDao {
  private static List<User> list = new ArrayList<>();

  static {
    list.add(new User("1","A","Male",18,"NY","123","sd@qq.com"));
    list.add(new User("2","B","Female",18,"NY","234","ad@qq.com"));
    list.add(new User("3","C","Male",18,"NY","345","sv@qq.com"));

  }

  public List<User> findAll() {
    return list;
  }}public class User {
  private String SID;
  private String Name;
  private String Gender;
  private Integer Age;
  private String Address;
  private String QQ;
  private String EMAIL;

  //此处省略无参、全参、toString，set/get
  public class UserService {
    public List<User> findAll() {
      //调用DAO，查询
      UserDao userDao = new UserDao();
      List<User> list = userDao.findAll();
      return list;
    }
  }
  @WebServlet("/FindAllServlet")
  public class FindAllServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      this.doPost(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      //调用Service查询
      UserService userService = new UserService();
      List<User> list=userService.findAll();
      //将list存储到request域
      req.setAttribute("list",list);
      //转发list.jsp
      req.getRequestDispatcher("/list.jsp").forward(req,resp);
    }
  }
```
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
  <head>
    <title>List</title>
  </head>
  <body>
    <table border="1" cellpadding="0" cellspacing="0" width="500px" align="center">
      <tr>
        <th>编号</th>
        <th>姓名</th>
        <th>性别</th>
        <th>年龄</th>
        <th>地址</th>
        <th>QQ</th>
        <th>邮箱</th>
      </tr>
      <c:forEach items="${list}" var="user">
        <tr align="center">
          <td>${user.SID}</td>
          <td>${user.name}</td>
          <td>${user.gender}</td>
          <td>${user.age}</td>
          <td>${user.address}</td>
          <td>${user.QQ}</td>
          <td>${user.EMAIL}</td>
        </tr>
      </c:forEach>
    </table>
  </body>
</html>
```
