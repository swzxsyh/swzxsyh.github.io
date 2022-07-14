---
title: Java Web- Filter
date: 2020-04-23 01:28:53
tags:
---

一.概述
Web中的过滤器:当用户访问服务器资源时，过滤器将请求拦截，完成一些通用操作

应用场景:登陆验证，统一编码处理，敏感字符过滤

二.快速入门
2.1 XML配置
编写Java类




```java
public class QuickFilter implements Filter {
  @Override
  public void init(FilterConfig filterConfig) throws ServletException {}

  @Override
  public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    //此方法拦截用户的请求
    //servletRequest请求对象
    //servletResponse响应对象
    //FilterChain过滤器链
    System.out.println("QuickFilter Filter");
    //放行
    filterChain.doFilter(servletRequest, servletResponse);

  }

  @Override
  public void destroy() {

  }}
```

配置XML

```xml
<!--    快速入门-->
<filter>
  <filter-name>QuickFilter</filter-name>
  <filter-class>com.test.Demo01.QuickFilter</filter-class>
</filter>
<filter-mapping>
  <filter-name>QuickFilter</filter-name>
  <url-pattern>/Demo01.jsp</url-pattern>
</filter-mapping>
```

2.2 注解配置
注意:使用注解，需要把web.xml标签注释

编写java类，实现Filter接口

```java
//@WebFilter(filterName = "QuickFilter",urlPatterns = "/quick.jsp")
//@WebFilter(urlPatterns = "/quick.jsp")
//@WebFilter(value = "/quick.jsp")
@WebFilter("/quick.jsp")
public class QuickFilter implements Filter {
  @Override
  public void init(FilterConfig filterConfig) throws ServletException {}

  @Override
  public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    //此方法拦截用户的请求
    //servletRequest请求对象
    //servletResponse响应对象
    //FilterChain过滤器链
    System.out.println("QuickFilter Filter");
    //放行
    filterChain.doFilter(servletRequest, servletResponse);

  }

  @Override
  public void destroy() {

  }}
```

三.工作原理
发送请求
doFilter{
对请求拦截
是否放行
对响应增强
}
quick.jsp调用Service方法
doFilter{
对响应增强
}
返回响应
四.使用细节
4.1 生命周期
方法	代码
初始化方法	public void init(FilterConfig filterConfig)
拦截方法	public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
销毁方法	public void destroy()
时机	说明
创建	服务器启动项目加载，创建filter对象，执行init方法
运行(过滤拦截)	用户访问被拦截目标资源时，执行doFilter方法
销毁	服务器关闭或项目卸载时，销毁filter对象，执行destroy方法(只执行一次)
注意	过滤器一定是优先于servlet创建的

```java
// 设置初始化参数一般不会在注解中使用
//@WebFilter(value = "/show.jsp", initParams = {@WebInitParam(name = "encode", value = "utf-8")})
//@WebFilter("/show.jsp")
public class LifeCycleFilter implements Filter {
  private String encode;

  //filterConfig它是filter对配置对象
  //作用:获取filter对初始化参数
  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
    System.out.println("LifeCycleFilter Run");
    filterConfig.getInitParameter("encode");
  }

  @Override
  public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    System.out.println("LifeCycleFilter Filter Request,Run Method");
    System.out.println("Unicode"+encode);
    filterChain.doFilter(servletRequest, servletResponse);
  }

  @Override
  public void destroy() {
    System.out.println("LifeCycleFilter Destroy");
  }
}
```

```xml
<filter>
  <filter-name>LifeCycleFilter</filter-name>
  <filter-class>com.test.Demo02.LifeCycleFilter</filter-class>
  <init-param>
    <param-name>encode</param-name>
    <param-value>UTF-8</param-value>
  </init-param>
</filter>
<filter-mapping>
  <filter-name>LifeCycleFilter</filter-name>
  <url-pattern>/show.jsp</url-pattern>
</filter-mapping>
```


4.2 拦截路径
在开发时，可以指定过滤器对拦截路径来定义拦截目标资源的范围
匹配方式	说明
精准匹配	用户访问指定目标资源(/show.jsp)时，过滤器进行拦截
目录匹配	用户访问指定目录下(/user/*)所有资源时，过滤器进行拦截
后缀匹配	用户访问指定后缀名(*.jsp)的资源时，过滤器进行拦截
匹配所有	用户访问该网站所有资源(/*)时，过滤器进行拦截



```java
//@WebFilter("/show.jsp") //精准匹配
//@WebFilter("/User/*")     //目录匹配
//@WebFilter("*.html")  //后缀匹配
@WebFilter("/*")
public class UrlPatternFilter implements Filter {
  @Override
  public void init(FilterConfig filterConfig) throws ServletException {

  }

  @Override
  public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    System.out.println("UrlPatternFilter拦截了请求..."); // 放行
    filterChain.doFilter(servletRequest, servletResponse);
  }

  @Override
  public void destroy() {

  }
}
```

4.3 拦截方式
开发时，可以指定过滤器拦截方式来处理不同的应用场景(如浏览器发送的，或内部转发的)
拦截方式	说明
request(默认拦截方式)	浏览器直接发送请求时，过滤器拦截
forward	资源A转发到资源B时，过滤器拦截
资源A:ForwardServlet
资源B:show.jsp
可以同时配置两者	
XML版本



```java
public class ModeFilter implements Filter {
  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
  }
  @Override
  public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    System.out.println("Filter");
    filterChain.doFilter(servletRequest, servletResponse);
  }

  @Override
  public void destroy() {

  }
}
```
```xml
<filter>
  <filter-name>ModeFilter</filter-name>
  <filter-class>com.test.Demo04.ModeFilter</filter-class>
</filter>
<filter-mapping>
  <filter-name>ModeFilter</filter-name>
  <url-pattern>/show.jsp</url-pattern>
  <dispatcher>FORWARD</dispatcher>
  <dispatcher>REQUEST</dispatcher>
</filter-mapping>
```

注解版本


```java
@WebFilter(value = "/show.jsp",dispatcherTypes = {DispatcherType.REQUEST,DispatcherType.FORWARD})
public class ModeFilter implements Filter {
  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
  }
  @Override
  public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    System.out.println("Filter");
    filterChain.doFilter(servletRequest, servletResponse);
  }

  @Override
  public void destroy() {

  }
}
```

4.4 过滤器链
在一次请求中，若请求匹配到多个filter，通过请求将相当于把这些filter串起来，形成过滤器链

需求
用户访问目标资源 show.jsp时，经过 FilterA FilterB

过滤器链执行顺序 (先进后出)

1.用户发送请求
2.FilterA拦截，放行
3.FilterB拦截，放行
4.执行目标资源 show.jsp
5.FilterB增强响应
6.FilterA增强响应
7.封装响应消息格式，返回到浏览器

过滤器链中执行的先后问题

方式	顺序
配置文件	谁先声明，谁先执行
<filter-mapping>
注解【不推荐】	根据过滤器类名进行排序，值小的先执行
FilterA FilterB 进行比较， FilterA先执行
4.5 注解和XML使用
如果是自己定义filter，无执行先后顺序，可以使用注解开发
如果是第三方jar提供的filter，要在web.xml进行配置
五.综合案例
5.1 用户评论留言
需求
用户访问某论坛网站，可以对文章比赛等内容进行留言

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>BBS</title>
  </head>

  <body>

    <h3>LPL View Board</h3>
    <hr>
    <form action="${pageContext.request.contextPath}/WordServlet" method="post">
      <textarea name="content" id="" cols="30" rows="10"></textarea>
      <input type="submit" value="text">


    </form>
  </body>
</html>
```

```java
@WebServlet("/WordServlet")
public class WordServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //接收请求参数Content
    String content = req.getParameter("content");
    //结果响应到浏览器
    resp.getWriter().write(content);
  }
}
```
5.2 统一网站编码
需求
tomcat8.5版本中已经将get请求的中文乱码解决了,但是post请求还存在中文乱码 浏览器发出的任何请求，通过过滤器统一处理中文乱码

```xml
<!-- 统一网站编码   -->
<filter>
  <filter-name>EncodeFilter</filter-name>
  <filter-class>com.test.Case01.EncodeFilter</filter-class>
  <init-param>
    <param-name>encode</param-name>
    <param-value>UTF-8</param-value>
  </init-param>
</filter>
<filter-mapping>
  <filter-name>EncodeFilter</filter-name>
  <url-pattern>/*</url-pattern>
</filter-mapping>
```

```java
public class EncodeFilter implements Filter {
  private String encode;

  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
    encode = filterConfig.getInitParameter("encode");
  }

  @Override
  public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    //类型向下转换
    HttpServletRequest request = (HttpServletRequest) servletRequest;
    HttpServletResponse response = (HttpServletResponse) servletResponse;
    //判断用户是否为post请求，才设置编码
    if (request.getMethod().equalsIgnoreCase("post")) {
      request.setCharacterEncoding(encode);
    }
    response.setContentType("text/html;charset=" + encode);

    //放行
    filterChain.doFilter(servletRequest, servletResponse);
  }

  @Override
  public void destroy() {

  }
}
```
5.3 非法字符拦截

```java
@WebFilter("/WordServlet")
public class WordsFilter implements Filter {
  private List<String> wordList;

  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
    //加载配置文件,ResourceBundle专门读取src下的properties文件，不需要后缀名
    ResourceBundle words = ResourceBundle.getBundle("words");
    //读取keyword关键字内容
    String keyword = words.getString("keyword");
    //split切割，转为list集合
    wordList = Arrays.asList(keyword.split(","));
    System.out.println(wordList);
  }

  @Override
  public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    //向下转型
    HttpServletRequest request = (HttpServletRequest) servletRequest;
    HttpServletResponse response = (HttpServletResponse) servletResponse;
    //获取用户输入的值
    String content = request.getParameter("content");
    //拦截非法内容，提示
    for (String word : wordList) {
      if(content.contains(word)){
        response.getWriter().write("Input Words has Problem");
        return;
      }
    }
    //放行
    filterChain.doFilter(request, response);
  }

  @Override
  public void destroy() {

  }
}
```
5.4 非法字符过滤

```java
public class MyRequest extends HttpServletRequestWrapper {
  //非法词库
  private List<String> wordList;

  public MyRequest(HttpServletRequest request, List<String> wordList) {
    super(request);
    this.wordList = wordList;
  }

  //对谁增强就重写谁
  @Override
  public String getParameter(String name) {
    //调用原有的功能，获取用户输入的值
    String parameter = super.getParameter(name);
    //对非法词库过滤
    for (String word : wordList) {
      if (parameter.contains(word)) {
        //注意:替换完后进行覆盖
        parameter = parameter.replaceAll(word, "**");
      }
    }
    return parameter;
  }
}
```



```java
@WebFilter("/WordServlet")
public class WordsProFilter implements Filter {
  private List<String> wordList;

  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
    //加载配置文件,ResourceBundle专门读取src下的properties文件，不需要后缀名
    ResourceBundle words = ResourceBundle.getBundle("words");
    //读取keyword关键字内容
    String keyword = words.getString("keyword");
    //split切割，转为list集合
    wordList = Arrays.asList(keyword.split(","));
    System.out.println(wordList);
  }

  @Override
  public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    //向下转型
    HttpServletRequest request = (HttpServletRequest) servletRequest;
    HttpServletResponse response = (HttpServletResponse) servletResponse;

    //对request对象进行包装(过滤)
    MyRequest requestPro = new MyRequest(request, wordList);

    //放行
    filterChain.doFilter(requestPro, response);
    System.out.println(wordList);
  }

  @Override
  public void destroy() {

  }
}
```

附录 Filter模版设置
```java
#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME};#end #parse("File Header.java") @javax.servlet.annotation.WebFilter("/${Entity_Name}")
  public class ${Class_Name} implements javax.servlet.Filter {
    public void init(javax.servlet.FilterConfig config) throws javax.servlet.ServletException {
    }
    public void doFilter(javax.servlet.ServletRequest servletRequest, javax.servlet.ServletResponse servletResponse, javax.servlet.FilterChain chain) throws javax.servlet.ServletException, java.io.IOException {
      // 放行
      chain.doFilter(servletRequest, servletResponse); }
    public void destroy() {
    } }
```


总结
概述
作用
拦截用户请求
应用场景
如：登录验证、统一编码处理、敏感字符过滤…
快速入门

1. 定义一个类实现Filter接口
javax.servlet 包
2. 重写filter方法
doFilter
3. 配置
web.xml
注解
工作原理
用户发送请求
执行Filter拦截请求

放行（执行放行后的资源）

执行Filter拦截响应

响应给浏览器结果
细节
生命周期
何时创建

在服务器启动时，创建fitler对象，执行init方法，只执行一次
何时销毁

服务器正常关闭时，销毁filter对象，执行destroy方法，只执行一次
创建优先级

ServletContext

Filter

Servlet
拦截路径
精准匹配

/show.jsp
目录匹配

/user/*
后缀匹配

*.html
拦截所有

/*
拦截方式
REQUEST

客户端直接访问资源时，执行Filter
FORWARD

服务器内部资源跳转时，执行Filter
过滤器链
拦截顺序

先进后出
执行先后

web.xml

谁先声明，谁先执行
注解

按照自定义过滤器类名的字符串比较规则，值小的先执行