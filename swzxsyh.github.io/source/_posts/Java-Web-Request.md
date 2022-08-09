---
title: Java Web - Request
date: 2020-04-15 01:19:16
tags:
---

一.Request概述
用户通过浏览器访问服务器时,Tomcat将HTTP请求中所有信息封装在Request对象中
作用:开发人员可以通过Request对象方法，来获取浏览器发送的所有信息

Request体系结构

ServletRequest
⬆
HttpServletRequest
⬆
org.apache.catalina.connector.RequestFacade(由tomcat厂商提供实现类)
二.Request获取Http请求信息
2.1 获取请求行信息
例如:
GET /Day34_Request_war_exploded/RequestDemo01 HTTP/1.1
相关API:
说明
API
获取请求方式	String getMethod()
获取项目虚拟路径名	String getContextPath()
获取URI
(统一资源标识符)	String getRequestURI()
获取URL
(统一资源定位符)	StringBuffer getRequestURL()
获取协议和版本号	String getProtocol()
获取客户端IP	String getRemoteAddr()

```java
@WebServlet("/RequestDemo01")
public class RequestDemo01 extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //        System.out.println(req);
    //1.获取请求方式
    System.out.println("Request Method "+req.getMethod());
    //2.获取项目路径
    System.out.println("Project Path "+req.getContextPath());
    //3.获取URI
    System.out.println("URI "+req.getRequestURI());
    //4.获取URL
    System.out.println("URI "+req.getRequestURL());
    //5.协议和版本
    System.out.println("Protocol & Version "+ req.getProtocol());
    //6.客户端IP
    System.out.println("IP "+ req.getRemoteAddr());}

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
  }
}
```


//输出
Request Method: GET
Project Path: /Day34_Request_war_exploded
URI: /Day34_Request_war_exploded/RequestDemo01
URL: http://127.0.0.1:8080/Day34_Request_war_exploded/RequestDemo01
Protocol & Version: HTTP/1.1
IP: 127.0.0.1
2.2 获取请求头信息
例如:

Host:locaohost:8080

相关API

说明
API
获取请求头名称对应的值	String getHeader(String name)
获取所有请求头的名称	Enumeration getHeaderNames()

```java
@WebServlet("/RequestDemo02")
public class RequestDemo02 extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //获取所有请求头名称
    Enumeration<String> headerNames = req.getHeaderNames();
    //遍历
    while (headerNames.hasMoreElements()){
      //取出元素名(请求头名称)
      String name = headerNames.nextElement();
      //根据名称获取值
      String value = req.getHeader(name);
      System.out.println(value);
    }
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
  }
}
```


案例:模拟视频防盗链

```java
@WebServlet("/RefereRequest")
public class RefereRequest extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //0.设置编码，让中文不乱码
    resp.setContentType("text/html;charset=UTF-8");
    //1.获取请求来源(如果是浏览器地址栏直接访问，referer是Null)
    String referer = req.getHeader("referer");
    //2.判断是否自己网站发起的请求
    if(referer != null && referer.startsWith("http://127.0.0.1:8080")){
      resp.getWriter().write("Play Video");
    }else {
      resp.getWriter().write("Permission Denied");
    }
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
  }
}
```


案例:浏览器兼容性

```java
@WebServlet("/UserAgentRequest")
public class UserAgentRequest extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //0.设置语言编码
    resp.setContentType("text/html;charset=UTF-8");
    //1.获取浏览器版本信息
    String useragent = req.getHeader("user-agent");
    //2.判断浏览器版本
    System.out.println(useragent);
    if (useragent.contains("Chrome")){
      System.out.println("Chrome");
    }else if (useragent.contains("Firefox")){
      System.out.println("Firefox");
    }else {
      System.out.println("Others");
    }
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
  }
}
```


2.3 获取请求参数(请求体)
不论是get还是post请求方式,都可以使用下列方式来获取请求参数
参数:
username=jack&password=123
说明
API
获取指定参数名的值	String getParameter(String name);
获取指定参数名的值数组	String[] getParameterValues(String name);
获取所有参数名和对应值数组	Map<String,String[]> getParameterMap()
中文乱码
get:在Tomcat 8 及以上版本，内部URL编码(UTF-8)
post:编码解码不一致，造成乱码现象
客户端(浏览器)编码UTF-8
服务器默认解码:ISO-8859-1
指定解码:void setCharacterEncoding(String env)
注意:指定解码必须在行首



```java

@WebServlet("/RequestDemo03")
public class RequestDemo03 extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //Get manually
    //        String username = req.getParameter("username");
    //        System.out.println(username);
    //        String password = req.getParameter("password");
    //        System.out.println(password);
    //        String[] hobbies = req.getParameterValues("hobby");
    //        System.out.println(Arrays.toString(hobbies));
    //Automatic acquisition
    Map<String, String[]> parameterMap = req.getParameterMap();
    parameterMap.forEach((k, v) -> {
      System.out.println(k + "" + Arrays.toString(v));
    });
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    req.setCharacterEncoding("UTF-8");
    //使用方法一样，可以直接调用get方法
    this.doGet(req, resp);
  }
}
```

2.4 BeanUtils
Apache提供的工具类，简化参数封装，即将前端数据直接封装到想要的JavaBean中

导入Jar包

使用工具类封装数据(要求:map集合的key,必须为JavaBean属性名)

```java
public class User {
  private String username;
  private String password;
  private String[] hobby;

  // 此处省略getter setter toString

  @WebServlet("/RequestDemo04")
  public class RequestDemo04 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      //Get manually
      String username = req.getParameter("username");
      System.out.println(username);
      String password = req.getParameter("password");
      System.out.println(password);
      String[] hobbies = req.getParameterValues("hobby");
      //Automatic acquisition
      Map<String, String[]> parameterMap = req.getParameterMap();
      parameterMap.forEach((k, v) -> {
        System.out.println(k + "" + Arrays.toString(v));
      });
      //将前端表单数据赋值到user对象中,保存到数据库
      User user = new User();
      user.setUsername(username);
      user.setPassword(password);
      user.setHobby(hobbies);
      System.out.println(user);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      req.setCharacterEncoding("UTF-8");
      //使用方法一样，可以直接调用get方法
      this.doGet(req, resp);

      //使用BeanUtils快速封装数据到User对象中
      //map集合的key,必须为JavaBean属性名
      Map<String, String[]> parameterMap = req.getParameterMap();
      //
      User user = new User();
      try {
        BeanUtils.populate(user, parameterMap);
      } catch (IllegalAccessException e) {
        e.printStackTrace();
      } catch (InvocationTargetException e) {
        e.printStackTrace();
      }
      System.out.println(user);
    }
  }
```

```html
<h3>Bean Utils:</h3>
<form action="/Day34_Request_war_exploded/RequestDemo04" method="post">
  Name:
  <input type="text" name="username"><br>
  Password:
  <input type="password" name="password"><br>
  Hobby:
  <input type="checkbox" name="hobby" value="smoke">smoke
  <input type="checkbox" name="hobby" value="drink">drink
  <input type="checkbox" name="hobby" value="perm">perm<br>
  <input type="submit" value="Post Submit Method">
</form>
```

2.4.1 变量名是否等于属性

```java
//成员变量名username
private String username;


//属性Username，是方法的命名
public String getUsername() {
  return username;
}

//属性是getter/setter方法截取之后的产物
//通常情况下,使用IDEA自动生成getter&setter时，变量名 equals 属性
getUsername-Username-username

  //不一样的情况
  //成员变量名
  private String user;
//属性名
public String getUsername() {
  return user;
}
```

三.Request其他功能
3.1 请求转发
一种在服务器内部的资源跳转方式
说明
API
通过request对象，获得转发器对象	RequestDispatcher getRequestDispatcher(String path);
通过转发器对象，实现转发功能	void forward(ServletRequest request,ServletResponse response);
请求转发的特点:
浏览器:只发了一次请求
地址栏:没有改变
只能转发到服务器内部资源

链式编程
request.getRequestDispatcher(“/bServlet”).forward(reqeust,response)
3.2 域对象(共享数据)
域对象:一个有作用访问的对象，可以在范围内共享数据

request域:代表一次请求范围,一般用于一次请求中转发的多个资源中共享数据

说明
API
设置数据	void setAttribute(String name,Object o);
获取数据	Object getAttribute(String name)
删除数据	void removeAttribute(String name)
生命周期

创建时间	用户发送请求时，发送request
销毁时间	服务器返回响应时，销毁request
作用范围	一次请求，包含多次转发

```java

@WebServlet("/AServlet")
public class AServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req,resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //转发到BServlet
    //1.获取转发器对象 path=@WebServlet("/BServlet")
    //        RequestDispatcher requestDispatcher = req.getRequestDispatcher("/BServlet");
    //2.实现转发功能
    //        requestDispatcher.forward(req,resp);
    //AServlet存一个数据
    req.setAttribute("name","This is A Object");

    //链式编程
    req.getRequestDispatcher("/BServlet").forward(req,resp);
  }
}

@WebServlet("/BServlet")
public class BServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req,resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.getWriter().write("B");
    String name = (String) req.getAttribute("name");
    resp.getWriter().write(name);
  }
}
```
3.3 获取ServletContext对象
应用上下文对象，表示一个web项目
通过request，可以获取ServletContext对象
public ServletContext getServletContext();

```java
@WebServlet("/RequestDemo05")
public class RequestDemo05 extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //获取当前web项目对象
    ServletContext servletContext = req.getServletContext();
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
  }
}
```


四.用户登陆案例
实现用户的登录功能
登录成功跳转到SuccessServlet展示:登录成功!xxx,欢迎您
登录失败跳转到FailServlet展示:登录失败，用户名或密码错误

创建web项目，导入BeanUtils(工具类)
编写index.html
User实体类
创建LoginServlet,SuccessServlet，FailedServlet

```html
<form action="/Day34_Request_war_exploded/loginServlet" method="post">Login
  Name:<input type="text" name="username"><br>
  Password:<input type="password" name="password"><br>
  <input type="submit" value="Login Submit">
</form>
```

```java
public class User {
  private String username;
  private String password;
  //此处getter & setter ，toString省略
}


@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //1.设置request解码方式
    req.setCharacterEncoding("UTF-8");
    //2.获取浏览器参数，map集合
    Map<String, String[]> parameterMap = req.getParameterMap();
    //3.使用BeanUtils工具类，封装到User中
    User user = new User();
    try {
      BeanUtils.populate(user, parameterMap);
    } catch (IllegalAccessException e) {
      e.printStackTrace();
    } catch (InvocationTargetException e) {
      e.printStackTrace();
    }

    //4.判断(写一个file文件，存储真实到用户名密码，判断)
    if ("jack".equals(user.getUsername()) && "123".equals(user.getPassword())){
      req.setAttribute("user",user);
      req.getRequestDispatcher("/successServlet").forward(req, resp);
    }else{
      req.getRequestDispatcher("/failedServlet").forward(req, resp);
    }
  }
}


@WebServlet("/successServlet")
public class SuccessServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //1.从request域获取user对象
    User user = (User) req.getAttribute("user");
    //2.提示
    resp.setContentType("text/html;charset=utf-8");
    resp.getWriter().write(user.getUsername()+"Successful");
  }
}
@WebServlet("/failedServlet")
public class FailedServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.setContentType("text/html;charset=utf-8");
    resp.getWriter().write("Login Failed,Wrong Username or Password");
  }
}
```

附录:Servlet模版设置
IDEA-Settings-Editor-File and Code Templates-Other-Web>Jaava code templates>Servlet Annotated Class.java
更改为如下代码

```java
#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME};#end #parse("File Header.java") @javax.servlet.annotation.WebServlet("/${Class_Name}")
public class ${Class_Name} extends javax.servlet.http.HttpServlet {
protected void doGet(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, java.io.IOException {
this.doPost(request,response); }
protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, java.io.IOException {

} }
```


总结
一 Request概述
开发人员可以通过request对象方法，来获取浏览器发送的所有信息.
二 Request获取Http请求信息
行
getMethod()

请求方式

get
post
getContextPath()

项目名（虚拟路径）
getRemoteAddr()

客户端的ip地址
头
getHeader(String key)

Referer

防盗链
User-Agent

浏览器兼容器
getHeaderNames()

参数（体）
api

getParameter()
getParameterValues()
getParameterMap()
BeanUtils工具类

中文乱码

get：tomcat8及以上版本，解决了get方式乱码问题
post：request.setCharacterEncoding(“utf-8”);
三 Request其他功能
请求转发
一种在服务器内部的资源跳转方式

request.getRequestDispatcher(“/内部资源”).forward(request,response);

特点

转发是一次请求
浏览器地址栏不发生变化
只能跳转到服务器内部资源
域对象（共享数据）
api

void setAttribute(String name, Object o)
Object getAttribute(String name)
void removeAttribute(String name)
生命周期

何时创建

用户发送请求时
何时销毁

服务器做出响应后
作用范围

一次请求转发中
获取ServletContext
api

ServletContext getServletContext()