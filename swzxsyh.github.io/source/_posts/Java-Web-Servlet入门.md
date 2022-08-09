---
title: Java Web - Servlet入门
date: 2020-04-13 01:18:43
tags:
---

一.Servlet概述
Servlet 运行在服务端的Java小程序，是sun公司提供一套规范，用来处理客户端请求、响应给浏览器的动态资源。
但servlet的实质就是java代码，通过java的API动态的向客户端输出内容

servlet= server+applet 运行在服务器端的java程序。
Servlet是一个接口，一个类要想通过浏览器被访问到,那么这个类就必须直接或间接的实现Servlet接口
二.Servlet快速入门
2.1 代码编写
创建web项目

编写普通java类,实现Servlet接口
写抽象方法(service方法)



```java

public class QuickServlet implements Servlet {
  @Override
  public void init(ServletConfig servletConfig) throws ServletException {}

  @Override
  public ServletConfig getServletConfig() {
    return null;
  }

  //对外提供服务
  /*
request:代表请求
response:代表响应
 */
  @Override
  public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
    //向浏览器写一句话
    servletResponse.getWriter().write("QuickServlet");
  }

  //表示当前Servlet对象的描述信息
  @Override
  public String getServletInfo() {
    return "快速入门";
  }

  @Override
  public void destroy() {

  }}
```

配置web.xml
配置servlet网络访问路径

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">
  <!--
把QuickServlet交给tomcat管理
servlet-name:当前servlet的别名(使用类名即可)
servlet-class:全限定类名
-->
  <servlet>
    <servlet-name>QuickServlet</servlet-name>
    <servlet-class>Project.QuickServlet</servlet-class>
  </servlet>
  <!--
给servlet社长一个网络访问地址(路径)
servlet-name:给指定别名的servlet配置映射
url-pattern:网络访问地址(注意:必须以"/"开头)
-->
  <servlet-mapping>
    <servlet-name>QuickServlet</servlet-name>
    <url-pattern>/QuickServlet</url-pattern>
  </servlet-mapping>
</web-app>
```

部署web项目
启动测试
2.2 执行原理
步骤:
Step 1: Browser通过 Domain 在网络中Request到该 Server(Tomcat)
Step 2: 找到该Server后，通过Project Name查找项目(Day32_Servlet_XML)
Step 3: 通过Source Name(QuickServlet)查找web.xml中同名的url-pattern标签
Step 4: 找到url-pattern同名标签后，查找其映射的servlet-name
Step 5: 通过servlet-name寻找servlet-class
Step 6: 通过反射机制创建QuickServlet
Step 7: 创建后，自动调用service方法,Response to Browser

三.Servlet相关API
3.1 生命周期相关
3.1.1 思想介绍
生命周期:指的是一个对象从创建到销毁到过程

```java
//servlet对象创建时,调用此方法
@Override
public void init(ServletConfig servletConfig) throws ServletException {
  System.out.println("LifeServlet Created");
}

//用户访问servlet时,调用此方法
@Override
public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
  System.out.println("LifeServlet carried out");
}

//servlet对象销毁时,调用此方法
@Override
public void destroy() {
  System.out.println("LifeServlet destroy");
}
```


创建

1)默认
用户第一次访问时,创建servlet,执行init方法
2）修改servlet创建时机
<load-on-startup></load-on-startup>

值	说明
正数	服务器启动时创建
(Tomcat默认1-3，建议4开始)
负数(默认值):-1	用户第一次访问时创建
运行

第二次开始，都调用执行service方法

销毁

服务器正常关闭时,销毁servlet，执行destroy方法

3.1.2 代码演示
LifeServlet




```java
public class LifeServlet implements Servlet {
  @Override
  public void init(ServletConfig servletConfig) throws ServletException {
    System.out.println("LifeServlet Created");
  }

  @Override
  public ServletConfig getServletConfig() {
    return null;
  }

  @Override
  public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
    System.out.println("LifeServlet carried out");
  }

  @Override
  public String getServletInfo() {
    return null;
  }

  @Override
  public void destroy() {
    System.out.println("LifeServlet destroy");
  }
}
```

web.xml

```xml
<!--
servlet生命周期
-->
<servlet>
  <servlet-name>LifeServlet</servlet-name>
  <servlet-class>Project.Demo02.LifeServlet</servlet-class>
  <load-on-startup>4</load-on-startup>
</servlet>
<servlet-mapping>
  <servlet-name>LifeServlet</servlet-name>
  <url-pattern>/LifeServlet</url-pattern>
</servlet-mapping>
```


3.2 拓展:ServletConfig接口
Tomcat在Servlet对象创建时,执行init()方法，并创建一个ServletConfig配置对象

主要作用:读取web.xml配置文件Servlet中信息,实现参数和代码的解耦



```java
public class EncodingServlet implements Servlet {
  //定义全局变量
  private ServletConfig servletConfig;
  @Override
  public void init(ServletConfig servletConfig) throws ServletException {
    this.servletConfig = servletConfig;
  }

  @Override
  public ServletConfig getServletConfig() {
    return servletConfig;
  }

  //用户访问,执行service方法
  @Override
  public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
    //        String encode = "UTF-8";
    //        servletResponse.getWriter().write(encode);
    String encode = getServletConfig().getInitParameter("encode");
    servletResponse.getWriter().write(encode);
  }
  @Override
  public String getServletInfo() {
    return null;
  }

  @Override
  public void destroy() {

  }
}
```
```xml
<!--servlet配置对象-->
<servlet>
  <servlet-name>EncodingServlet</servlet-name>
  <servlet-class>Project.Demo02.EncodingServlet</servlet-class>
  <init-param>
    <param-name>encode</param-name>
    <param-value>UTF-8</param-value>
  </init-param>
</servlet>
<servlet-mapping>
  <servlet-name>EncodingServlet</servlet-name>
  <url-pattern>/EncodingServlet</url-pattern>
</servlet-mapping>
```

四.Servlet体系结构
Servlet
顶级接口,提供了5个抽象方法
⬆	
GenericServlet	抽象类,重写绝大多数的抽象方法，只需要开发者重写service方法
⬆	
HttpServlet	抽象类，处理Http协议的交互信息(请求，响应),根据不同的请求方式作出不同的处理
4.1 GenericServlet
编写普通Java类继承GenericServlet抽象类

```java
public class ServletDemo01 extends GenericServlet {
  @Override
  public void init() throws ServletException {
    System.out.println("ServletDemo01 Created");
  }

  @Override
  public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
    super.getServletConfig();//调用父类的配置对象
    servletResponse.getWriter().write("ServletDemo01 extends GenericServlet");
  }

  @Override
  public void destroy() {
    System.out.println("ServletDemo01 Destroyed");
  }
}
```

配置web.xml

```xml
<!--servlet继承GenericServlet-->
<servlet>
  <servlet-name>ServletDemo01</servlet-name>
  <servlet-class>Project.Demo03_inherit.ServletDemo01</servlet-class>
  <init-param>
    <param-name>encode</param-name>
    <param-value>UTF-8</param-value>
  </init-param>
</servlet>
<servlet-mapping>
  <servlet-name>ServletDemo01</servlet-name>
  <url-pattern>/ServletDemo01</url-pattern>
</servlet-mapping>
```


4.2 HttpServlet
编写前端HTML页面提交表单

```html
<html>
  <head>
    <meta charset="UTF-8">
    <title>Login</title>
  </head>


  <body>
    <h3>Login</h3>
    <form action="http://localhost:8080/Day33_Servlet_war_exploded/ServletDemo02" method="get">
      <input type="submit" value="Update Form">
    </form>

  </body>
</html>
```


编写普通java类，继承HttpServlet抽象类





```java
public class ServletDemo02 extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.getWriter().write("Get");
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.getWriter().write("Post");
  }
}
```

配置web.xml

```xml
<!--servlet继承HttpServlet-->
<servlet>
  <servlet-name>ServletDemo02</servlet-name>
  <servlet-class>Project.Demo03_inherit.ServletDemo02</servlet-class>
</servlet>
<servlet-mapping>
  <servlet-name>ServletDemo02</servlet-name>
  <url-pattern>/ServletDemo02</url-pattern>
</servlet-mapping>
```


4.3 Http错误
响应状态码405
方法没有重写，父类抛出405
例:
ServletDemo02 extends HttpServlet 没有重写get方法，而form使用get方法，则抛出父类405错误

```java
//父类方法
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
  String protocol = req.getProtocol();
  String msg = lStrings.getString("http.method_get_not_supported");
  if (protocol.endsWith("1.1")) {
    resp.sendError(405, msg);
  } else {
    resp.sendError(400, msg);
  }
}
```


响应状态码500
Java代码写错了

五.Servlet路径
5.1 url-patterns
作用:讲一个请求的网络地址和servlet建立一个映射关系

5.1.1 Servlet映射多个路径

```java

public class ServletDemo03 extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.getWriter().write("ServletDemo3 Get Method Run");
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.getWriter().write("ServletDemo3 Post Method Run");
  }
}
```
```xml
<!--    一个Servlet类可以映射多个网络访问地址        -->
<servlet>
  <servlet-name>ServletDemo03</servlet-name>
  <servlet-class>Project.Demo04_URL_Partten.ServletDemo03</servlet-class>
</servlet>
<!--    映射地址一   -->
<servlet-mapping>
  <servlet-name>ServletDemo03</servlet-name>
  <url-pattern>/ServletDemo03</url-pattern>
</servlet-mapping>
<!--    映射地址二    -->
<servlet-mapping>
  <servlet-name>ServletDemo03</servlet-name>
  <url-pattern>/Demo03</url-pattern>
</servlet-mapping>
```

5.1.2 url映射模式
配置<url-pattern>url地址取值可以是:

精确匹配

```java

public class ServletDemo04 extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.getWriter().write("ServletDemo4 Get Method Run");
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.getWriter().write("ServletDemo4 Post Method Run");
  }
}
```
```xml
<!--目录的匹配规则
只要浏览器符合规则:/aa/xxx
都访问ServletDemo04
-->
<servlet>
    <servlet-name>ServletDemo04</servlet-name>
    <servlet-class>com.test.Demo04_URL_Partten.ServletDemo04</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>ServletDemo04</servlet-name>
    <url-pattern>/aa/*</url-pattern>
</servlet-mapping>
```


后缀匹配
*.xxx

例如:*.do

```java
public class ServletDemo05 extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.getWriter().write("ServletDemo5 Get Method Run");
  }@Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.getWriter().write("ServletDemo5 Post Method Run");
  }
}
```
```xml
<!-- 只要浏览器符合后缀匹配规则，都可以访问到这个servlet-->
<servlet>
  <servlet-name>ServletDemo05</servlet-name>
  <servlet-class>com.test.Demo04_URL_Partten.ServletDemo05</servlet-class>
</servlet>
<servlet-mapping>
  <servlet-name>ServletDemo05</servlet-name>
  <url-pattern>*.do</url-pattern>
</servlet-mapping>
```


5.2 相对/绝对路径
浏览器的地址栏
a标签的href属性
form表单的action属性
js的location.href属性
ajax请求地址

//访问地址：http://localhost:8080/projectname/static/Path.html

```html
<html>
  <head>
    <meta charset="UTF-8">
    <title>Path</title>
  </head>
  <body>

    <h3>Text Interview Path</h3>

    <h4>绝对路径</h4>

    <!--
在开发时，强烈建议使用绝对路径
完整:protocol://domain:port/project/SourceName
推荐:/项目名/资源名
-->
    <a href="http://localhost:8080/Day33_Servlet_war_exploded/QuickServlet">
      带HTTP协议的绝对路径:QuickServlet
    </a><br/>

    <a href="/Day33_Servlet_war_exploded/QuickServlet">不带HTTP协议的绝对路径:QuickServlet</a>
    <br/>

    <h4>相对路径</h4>

    <!--
相对路径语法：
./当前目录
../上级目录
-->
    <a href="../QuickServlet">相对路径:QuickServlet</a>

  </body>
</html>
```


六.Servlet3.0
通过注解配置Servlet,简化web.xml配置Servlet复杂性，提高开发效率，集合所有框架都使用注解

创建web项目
编写普通Java类继承HttpServlet抽象类
配置@WebServlet



```java
@WebServlet("/QuickServlet")
public class QuickServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.getWriter().write("Quick Servlet 3.0 Get Method");
  }@Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.getWriter().write("Quick Servlet 3.0 Post Method");
  }}
```

总结
一 Servlet概述
运行在服务器端的java程序
一个类要想通过浏览器被访问到,那么这个类就必须直接或间接的实现Servlet接口
二 Servlet快速入门
① 创建web项目
② 创建普通的java类，实现servlet接口，重写抽象方法
③ 配置web.xml
④ 部署web项目
⑤ 启动测试
三 Servlet相关API
生命周期相关
创建

1)默认情况下，用户第一次访问时创建，执行init方法，只创建一次
2）修改创建时机，在tomcat启动时，创建servlet，执行init方法，只创建一次
运行（提供服务）

用户访问servlet资源时，执行service方法
销毁

服务器正常关闭，销毁servlet，执行destroy方法
ServletConfig接口
加载web.xml配置文件信息，实现参数和代码的解耦
四 Servlet体系结构
Servlet
GenericServlet

HttpServlet
五 Servlet路径
url-pattern
Servlet映射多个url

url映射模式

精确匹配
目录匹配
后缀匹配
相对/绝对路径
绝对路径…
六 Servlet3.0
@WebServlet(“/网络访问地址”)