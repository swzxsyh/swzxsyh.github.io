---
title: Cookie
date: 2020-04-18 01:21:57
tags:
---

一.会话概述
1.1 什么是会话
http协议是一个无状态协议，同一会话的多次请求相互独立，会话负责存储浏览器和服务器多次请求之间的数据

1.2 会话技术
客户端会话技术:Cookie
服务端会话技术:Session

二.Cookie
2.1 概述
作用:在一次会话的多个请求之间共享数据,将数据保存到客户端

2.2 快速入门
2.2.1 设置数据到Cookie中
创建cookie对象，设置数据
Cookie cookie = new Cookie(String name,String value);
通过response,响应(返回)cookie
response.addCookie(cookie);
2.2.2 从cookie中获取数据
通过request对象，接收cookie数组
Cookie[] cookies = request.getCookies()
遍历数组
for(Cookie cookie:cookies){
}

浏览器具有自动存储cookie的能力，也有请求携带cookie的能力



```java
@WebServlet("/SetServlet")
public class SetServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    Cookie cookie = new Cookie("name","jack");
    resp.addCookie(cookie);
  }
}

@WebServlet("/GetServlet")
public class GetServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //通过request对象，接收cookie数组
    Cookie[] cookies = req.getCookies();
    if (cookies != null) {
      //遍历数组
      for (Cookie cookie : cookies) {
        String name = cookie.getName();
        String value = cookie.getValue();
        System.out.println(name+"="+value);
      }
    }
  }
}
```

2.3 工作原理
基于HTTP协议:请求头cookie和响应头set-cookie

2.4 Cookie细节
2.4.1 服务器如何发送多个Cookie
创建多个cookie对象
Cookie cookie1 = new Cookie(“name”,”rose”);
Cookie cookie2 = new Cookie(“age”,”18”);

通过response响应多个cookie
response.addCookie(cookie1);
response.addCookie(cookie2);

```java
@WebServlet("/MultipleCookie")
public class MultipleCookie extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    Cookie cookie = new Cookie("name", "rose");
    Cookie age = new Cookie("age", "18");
    resp.addCookie(cookie);
    resp.addCookie(age);
  }
```
}
2.4.2 Cookie在浏览器的保存时间
默认情况下，浏览器关闭(会话结束),cookie销毁(浏览器内存中存储)
设置Cookie的存活时间
cookie.setMaxAge(int second);
正数:指定存活时间，持久化浏览器的磁盘中，到期后自动销毁
负数:默认浏览器关闭，cookie销毁
零:立即销毁

```java
@WebServlet("/MaxAgeCookie")
public class MaxAgeCookie extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //创建Cookie对象
    Cookie cookie = new Cookie("product", "MI");
    //设置Cookie的存活时间,默认值-1，关闭自动销毁
    //        cookie.setMaxAge(-1);
    //设定30s，自动销毁
    //        cookie.setMaxAge(30);
    //立即销毁
    cookie.setMaxAge(0);
    //resp响应Cookie
    resp.addCookie(cookie);
  }
}
```

2.4.3 Cookie是否支持中文存储
Tomcat 8版本开始支持中文

但是不支持部分特殊字符，如:分号，空格，逗号等，会触发Rfc6265 CookieProcessor规范错误

建议使用通用方法存储字符
URLEncoder 编码
URLDecoder 解码

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

```java
@WebServlet("/EncodeCookie")
public class EncodeCookie extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String product = ("华为 30X,");
    product= URLEncoder.encode("UTF-8");
    Cookie cookie = new Cookie("Brand", "苹果");
    Cookie cookie1 = new Cookie("product", product);
    resp.addCookie(cookie);
  }}

@WebServlet("/GetServlet")
public class GetServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //通过request对象，接收cookie数组
    Cookie[] cookies = req.getCookies();
    if (cookies != null) {
      //遍历数组
      for (Cookie cookie : cookies) {
        String name = cookie.getName();
        String value = cookie.getValue();
        //解码
        value = URLDecoder.decode("UTF-8");
        System.out.println(name + "=" + value);
      }
    }
  }}
```

2.4.4 Cookie共享数据的范围
2.4.4.1 同一个Tomcat服务器中，部署多个web项目，能否共享Cookie
默认情况下不可以
默认Cookie的携带路径，是当前设置cookie的servlet父路径

设置Cookie:http://localhost:8080/Day36_war_exploded/EncodeCookie
默认携带路径:http://localhost:8080/Day36_war_exploded/

指定Cookie携带路径
cookie.setPath(String Path);
例:cookie.setPath(“/“);

/ 相当于http://localhost:8080/

此cookie携带路径

http://localhost:8080/

访问:

http://localhost:8080/Day36_war_exploded/
http://localhost:8080/Day35_war_exploded/

携带路径不同，可以存储同名的cookie

在当前项目下共享cookie方法
cookie.setPath(“/项目名”);

2.4.4.2 不同Tomcat服务器之间的Cookie能否共享
默认情况下不可以
多个服务器之间的数据共享cookie，需要在同一个一级域名下
cookie.setDomain(“.xx.com”)
2.5 Cookie特点
Cookie存储的数据都在客户端
Cookie存储的数据只能是字符串
Cookie单个大学不能超过4kb
同一个域名下Cookie的数量不能超过50个
Cookie路径不同，可以重名出现
Cookie存储数据不太安全
三.综合案例
3.1 用户上次访问记录
需求:访问一个Servlet，如果是第一次访问，则提示:”您好”，如果不是，则提示”上次访问时间”



```java

public class CookieUtils {
  //根据指定名称，查找cookie对象
  public static Cookie findByName(String name, Cookie[] cookies) {
    //非空判断
    if (cookies != null && cookies.length > 0) {
      //遍历
      for (Cookie cookie : cookies) {
        //判断是否有指定名称的cookie
        if (name.equals(cookie.getName())) {
          return cookie;
        }
      }
    }
    return null;
  }
}
@WebServlet("/LastTimeServlet")
public class LastTimeServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.setContentType("text/html;charset=UTF-8");
    //接收cookie数组，取出指定名称cookie对象
    Cookie cookie = CookieUtils.findByName("last_time", req.getCookies());
    //判断
    if (cookie == null) {
      //不存在
      resp.getWriter().write("Welcome");
    } else {
      //存在
      String value = cookie.getValue();
      resp.getWriter().write("Welcome Back,Last Visit Time:" + value);
    }
    //创建cookie对象,记录本次访问时间
    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd-HH:mm:ss");
    String currentTime = simpleDateFormat.format(new Date());
    cookie = new Cookie("last_time", currentTime);
    //设置cookie存活1年
    cookie.setMaxAge(60*60*24*365);
    //resp响应cookie
    resp.addCookie(cookie);
  }
}
```

3.2 JSP初体验
Java服务端页面
简单来说:一个特殊的页面，即可定义html标签，又可定义Java代码
作用:简化书写，展示动态页面
本质:Servlet
脚本:JSP通过脚本方式来定义Java代码
<% Java代码 %> 就相当于Servlet中service方法

内置对象:在JSP页面中不需要获取和创建，可以直接使用对象
request
response
out
在JSP中响应内容，使用out
tomcat优先解析response缓冲区内容，再解析out缓冲区内容

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <title>Demo</title>
</head>

<body>

<h3>I am Title</h3>
<table border="1" width="300" align="center">
    <tr>
        <td>I am static resource</td>


    </tr>

</table>
<%
//    response.getWriter().write("I am JSP");
    System.out.println("I am jsp");
    out.write("Out");
%>
</body>
</html>
```

3.3 商品浏览记录

```jsp
<body>

  <h3>List</h3>

  <a href="/Day36_war_exploded/GoodsInfoServlet?name=MI">MI</a><br>
  <a href="/Day36_war_exploded/GoodsInfoServlet?name=HW">HW</a><br>
  <a href="/Day36_war_exploded/GoodsInfoServlet?name=Apple">Apple</a><br>
  <a href="/Day36_war_exploded/GoodsInfoServlet?name=TCL">TCL</a><br>
</body>

<body>
  <%
  //Java Code
  //获取指定名称的Cookie对象
  Cookie cookie = CookieUtils.findByName("goods_name", request.getCookies());
  //判断是否存在浏览记录
  if (cookie == null) {
    out.write("No History");
  } else {
    //格式:MI-Apple..
    String value = cookie.getValue();
    for (String product : value.split("-")) {
      out.write(product + "<br/>");
    }
  }
  %>
</body>
```



```java
@WebServlet("/GoodsInfoServlet")
public class GoodsInfoServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //设置请求的解码方式
    req.setCharacterEncoding("utf-8");
    resp.setContentType("text/html;charset=utf-8");
    //获取请求参数name
    String product = req.getParameter("name");
    //展示当前商品详情
    resp.getWriter().write("It's " + product);
    //获取指定名称的Cookie对象
    Cookie cookie = CookieUtils.findByName("goods_name", req.getCookies());

    if (cookie == null) {
      //如果不存在，将当前商品设置到cookie中
      cookie = new Cookie("goods_name", product);
    } else {
      //如果存在，将浏览记录取出
      String value = cookie.getValue();
      //判断当前商品是否在此Cookie中
      List<String> list = Arrays.asList(value.split("-"));
      //如果不包含，追加，如果包含，不操作
      if (!list.contains(product)) {
        value=value+"-"+product;
      }
      //将value重置到Cookie中
      cookie = new Cookie("goods_name", value);
    }
    //通过response响应到浏览器
    cookie.setMaxAge(10);
    resp.addCookie(cookie);

    //制作a标签，实现继续浏览商品功能
    resp.getWriter().write("<br/><a href='/Day36_war_exploded/goods.html'>Continue View</a><br/>");
    //制作a标签，实现查看浏览记录功能
    resp.getWriter().write("<a href='/Day36_war_exploded/history.jsp'>History</a><br/>");
  }
}
```

