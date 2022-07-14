---
title: Java Web - Session
date: 2020-04-18 01:22:35
tags:
---
一.Session
1.1 概述
1.2 快速入门
HttpSession也是一个对象

说明	API
存储数据	void setAttribute(String name,Object value)
获取数据	Object getAttribute(String name)
删除数据	void removeAttribute(String name)
步骤分析

将数据存储到session中

说明	API
通过request对象，获取session对象	HttpSession session = req.getSession();
操作session的API，存储数据	session.setAttribute(“username”,”AAABBBCCCC”);
从session中获取数据
说明	API
通过request对象，获取session对象	HttpSession session = req.getSession();
操作session的API，获取数据	session.getAttribute(“username”);

```java
@WebServlet("/SetSession")
public class SetSession extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //通过request对象，获取session对象
    HttpSession session = req.getSession();
    //操作session的API，存储数据
    session.setAttribute("username","AAABBBCCCC");
  }
}


@WebServlet("/GetSession")
public class GetSession extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //通过request对象，获取session对象
    HttpSession session = req.getSession();
    //操作session的API，获取数据
    String  username = (String) session.getAttribute("username");
    System.out.println("GetSession:"+username);
  }
}
```

1.3 工作原理
Session基于Cookie技术实现
HttpSession session = req.getSession();
如果用户是第一次访问:表示创建Session对象，生成编号
如果用户是第N次访问，根据浏览器携带编号找session对象

1.4 Session细节
1.4.1 客户端关闭，服务器不关闭，两次获取的Session数据是否相同
默认情况下，浏览器关闭再打开，两次获取的Session不同(基于cookie实现，浏览器关闭，cookie销毁)
设置cookie的存活时间(JESSIONID)，代替服务器，覆盖JESSIONID，指定持久化时间



```java
@WebServlet("/SessionDemo01")
public class SessionDemo01 extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  //指定JESSIONID时间
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //获取session对象
    HttpSession session = req.getSession();
    //向session中存数据
    session.setAttribute("username","zZZ");
    //获取SESSION 的唯一编号
    String id = session.getId();
    //设置cookie时长
    Cookie cookie = new Cookie("JESSIONID", id);
    //设置存活时间
    cookie.setMaxAge(60*2);
    //当前项目下共享
    cookie.setPath(req.getContextPath());
    //response响应cookie
    resp.addCookie(cookie);
  }
}
```

1.4.2 客户端不关闭，服务器关闭，两次获取的Session数据是否相同
当服务器正常关闭，重启后，两次获取的session数据一样
Tomcat实现了以下功能
钝化(序列化):当服务器正常关闭时,session中当数据，会序列化到磁盘
活化(反序列化):当服务器开启后，从磁盘中读取文件，反序列化到内存中
1.4.3 生命周期
何时创建

用户第一次调用req.getAttribute()时，创建
何时销毁

服务器非正常关闭
非活跃状态30分钟后销毁(tomcat/conf/web.xml官方已配置)
session.invalidate();立即销毁
作用范围

一次会话中，多次请求之间
注意:每一个浏览器和服务器之间都是独立的会话
1.4.4 URL重写
Session基于Cookie技术实现；浏览器Cookie可以禁用，一旦禁用，Session会出现问题
开发中，一般不考虑禁用Cookie用户

如果真要处理，可以使用URL重写



```java
@WebServlet("/SessionDemo02")
public class SessionDemo02 extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //获取session对象
    HttpSession session = req.getSession();
    //向session中存数据
    session.setAttribute("username", "SIODJOISDJSO");

    //定义URL
    String url = "/Day37_war_exploded/GetSession";
    //重写URL，拼接JESSIONID
    url = resp.encodeURL(url);

    resp.setContentType("text/html;charset=utf-8");
    resp.getWriter().write("<a href'" + url + "'>Direct to get Session</a>");
  }
}
```

1.5 Session特点
session存储数据在服务器
session存储类型任意(Object)
session存储大小和数据没有限制(相对于内存)
session存储数据相对安全
cookie和session的选择

cookie将数据保存在浏览器端，数据相对不安全，建议敏感数据不要放在cookie中，且数据大小有限制
成本低，对服务器要求不高
浏览器为了解决该不足，前端使用了localStroage

session将数据保存在服务器端，数据相对安全，数据大小比cookie中灵活
成本较高，对服务器压力大

二. 三大域对象总结
request,session,ServletContext

2.1 API
设置数据	void setAttribute(String name,Object o)
获取数据	Object getAttribute(String name)
删除数据	void removeAttribute(String name)
2.2 生命周期
2.2.1 ServleetContext域对象
何时创建	服务器正常启动，项目加载时创建
何时销毁	服务器关闭或项目卸载时，卸载
作用范围	整个web项目(共享数据)
2.2.2 HttpSession域对象
何时创建	用户第一次调用req.getSession() 方法时创建
用户访问携带的JESSIONID与服务器不匹配时创建
何时销毁	服务器非正常关闭时
未活跃时间30 min
session.invalidate();立即销毁
作用范围	一次会话中，多次请求间(共享数据)
2.2.3 HttpServletRequest域对象
何时创建	用户发送请求时创建
何时销毁	服务器做出响应后销毁
作用范围	一次请求中，多次转发间(共享数据)
2.3 小结
能用小的不用大的:request<session<servletContext

常用场景

request	一次查询的结果 (servlet转发jsp)
session	存放当前会话的私有数据
(验证码、购物车、等)
servletContext:若需要所有的Servlet都能访问到，才使用这个域对象

三.综合案例
3.1 商品购物车
3.1.1 需求分析
addCatrSetvlet

1.获取请求参数name(product)
2.返回:product 商品已加入购物车
3.从session中获取购物车
4.如果购物车为空，创建cart = new HashMap()
5.判断，此商品是否存在于购物车
6.不存在，添加商品数量1
7.存在，在原商品基础上+1
8.将购物车重写到session中

cart.jsp

1.从session中获取购物车对象
2.判断是否为空
3.如果空，显示购物车空
4.如果不为空，遍历展示商品和数量

3.1.2 代码实现
goods.jsp
addCartServlet
cart.jsp

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

  <head>
    <title>Goods</title>
  </head>

  <body>

    <h3>商品列表</h3>

    <a href="/Day37_war_exploded/AddCartServlet?name=TV">TV,add to cart</a><br>
    <a href="/Day37_war_exploded/AddCartServlet?name=PC">PC,add to cart</a><br>
    <a href="/Day37_war_exploded/AddCartServlet?name=Phone">Phone,add to cart</a><br>
  </body>
</html>
```





```java
@WebServlet("/AddCartServlet")
public class AddCartServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //设置编码
    req.setCharacterEncoding("UTF-8");
    resp.setContentType("text/html;charset=utf-8");

    //获取请求参数
    String product = req.getParameter("name");
    resp.getWriter().write(product + ", has add to Cart");

    //从session中获取购物车
    Map<String, Integer> cart = (Map<String, Integer>) req.getSession().getAttribute("cart");

    //判断购物车是否为空
    if (cart == null) {
      cart = new HashMap<>();
    }

    //判断购物车中是否包含本次商品
    if (cart.containsKey(product)) {
      //存在,product++
      Integer oldCount = cart.get(product);//之前的数量
      cart.put(product, ++oldCount);//数量加一
    } else {
      //不存在 ,加入购物车
      cart.put(product, 1);
    }

    //重新将购物车写入到session中
    req.getSession().setAttribute("cart", cart);

    //继续浏览
    resp.getWriter().write("<br><a href='/Day37_war_exploded/goods.jsp'>Continue View</a><br>");
    //查看购物车
    resp.getWriter().write("<br><a href='/Day37_war_exploded/cart.jsp'>Check Shopping Cart</a>");

  }
}
```

```html
<table border="1" width="200px" align="center">
  <tr>
    <th>Product</th>
    <th>Quantity</th>
  </tr>
  <%
     //从session中获取购物车
     Map<String, Integer> cart = (Map<String, Integer>) request.getSession().getAttribute("cart");
  //判断是否为空
  if (cart == null) {
  out.write("No Product here<br>");
  } else {
  for (String product : cart.keySet()) {
  out.write("<tr><td>" + product + "</td>  <td>" + cart.get(product) + "</td><tr/>");
  }
  }
  %>
  <a href='/Day37_war_exploded/goods.jsp'>Continue View</a>
  </table>
```


3.2 用户登陆(验证码)
3.2.1 需求分析
3.2.2 代码实现

```java
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    doPost(req, resp);
  }
  //课下作业实现非空判断
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    req.setCharacterEncoding("UTF-8");
    resp.setContentType("text/html;charset=utf-8");
    //获取用户输入验证码
    String checkcode = req.getParameter("checkcode");
    //获取session验证码
    String codeSession = (String) req.getSession().getAttribute("code_session");
    //校验匹配
    if (!checkcode.equalsIgnoreCase(codeSession)) {
      //验证码不匹配提示
      req.setAttribute("Error", "Check Code Wrong");
      //转发到login.jsp
      req.getRequestDispatcher("/login.jsp").forward(req, resp);
      //代码不再向下执行
      return;
    }
    //获取用户输入到用户名和密码
    String username = req.getParameter("username");
    String password = req.getParameter("password");

    //判断用户名密码
    if (!("jack".equals(username) && "123".equals(password))) {
      //用户名密码不匹配提示
      req.setAttribute("Error", "Username or Password Wrong");
      //转发到login.jsp
      req.getRequestDispatcher("/login.jsp").forward(req, resp);
      //代码不再向下执行
      return;
    }

    //将用户名存入session
    req.getSession().setAttribute("username", username);
    //重定向到Succes.jsp
    resp.sendRedirect(req.getContextPath() + "/success.jsp");
  }
}
```

```js
<form action="/war_exploded/LoginServlet" method="post">
  Name: <input type="text" name="username"><br>
    Password: <input type="password" name="password"><br>
      Checkcode: <input type="text" name="checkcode"><img src="/Day37_war_exploded/CheckCodeServlet" id="image1"
alt=""><br>
  <input type="submit" value="Login">
    <span style="color: red">
      <%
      String error = (String) request.getAttribute("Error");
if (error != null) {
  out.write(error);
}
%>

  </span>
</form>
<script>
  document.getElementById("image1").onclick = function () {
  this.src = '/Day37_war_exploded/CheckCodeServlet?' + new Date().getTime();
}
</script>
</body>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <html>
  <head>
  <title>Success</title>
</head>
<body>
  <%
  //获取用户信息
  String username = (String) request.getSession().getAttribute("username");
if (username != null){
  out.write("Welcome ,"+username);
}
%>
  </body>
</html>
```
总结
概述
在一次会话的多次请求之间共享数据，将数据保存到服务器端
实现原理
基于Cookie技术
jsessionid=xxxx
常用方法
获取session
request.getSession()
使用session
setAttribute()
getAttribute()
remomveAttribute()
生命周期
何时创建
用户第一次执行getSession()方法时，创建
用户携带的jssionid与服务器不匹配时，创建
何时销毁
服务器非正常关闭时
session.invalidate()
session默认销毁时间30分钟

tomcat目录/conf/web.xm
作用范围
一次会话中，多次请求之间
特点
1. session在服务器端存储数据
2. session存储数据格式可以是任意类型
3. session存储数据没有大小限制（相对于内存）
4. session存储数据相对安全
三个域对象
ServletContext
创建
销毁
作用域
HttpSession
创建
销毁
作用域
HttpServletRequest
创建
销毁
作用域
综合案例
商品购物车
用户登录（验证码）