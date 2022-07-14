---
title: SpringMVC的统一异常处理 & 拦截器 & SSM
date: 2020-06-13 01:49:59
tags:
---
一.SpringMVC 实现文件上传
1.1 目标
掌握文件上传的要求

1.2 学习路径
文件上传概述
文件上传要求
常见的文件上传jar包和框架
1.3 讲解
1.3.1 文件上传概述
就是把客户端(浏览器)的文件保存一份到服务器(参考各类云盘)

<!-- more -->

1.3.2 文件上传要求
1.3.2.1 浏览器端要求(通用浏览器的要求)
表单提交方式 post
提供文件上传框(组件) input type=”file”
表单的enctype属性必须为 multipart/form-data
1.3.2.2 服务器端要求
要使用request.getInputStream()来获取数据

注意:若表单使用了 multipart/form-data ,使用原生request.getParameter()去获取参数的时候都为null

通常借助第三方组件(jar, 框架 SpringMVC)实现文件上传.

1.3.2.3 常见的文件上传jar包和框架
serlvet3.0
commons-fileupload : apache出品的一款专门处理文件上传的工具包
struts2(底层封装了:commons-fileupload)
SpringMVC(底层封装了:commons-fileupload)
1.3.2.4 小结
文件上传可以上传文件，或sql文件直接导入数据等等
前端三要素 form post, encpt=multipart/form-data, input type=file
原生的api处理复杂，使用commons-fileupload可以帮我们简化了开发
案例：SpringMVC 传统方式文件上传
1.4 需求
使用springmvc 完成传统方式文件上传

1.4.1 步骤
创建Maven工厂，添加SpringMVC依赖
导入commons-fileupload坐标
在控制器的方法的形参里面定义和文件相关的变量 MultipartFile
存储到服务器
配置文件解析器 (commons-file)
在springmvc.xml配置文件解析器
1.4.2 实现
创建Maven工程,添加依赖

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
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
<dependencies>
  <!--springMVC核心-->
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.1.5.RELEASE</version>
  </dependency>
  <!--servlet-->
  <dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>servlet-api</artifactId>
    <version>2.5</version>
    <scope>provided</scope>
  </dependency>
  <!--jsp-->
  <dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>jsp-api</artifactId>
    <version>2.0</version>
    <scope>provided</scope>
  </dependency>

  <!--文件上传-->
  <dependency>
    <groupId>commons-fileupload</groupId>
    <artifactId>commons-fileupload</artifactId>
    <version>1.4</version>
  </dependency>


  <dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.9.0</version>
  </dependency>
</dependencies>
配置web.xml

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
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
<filter>
  <filter-name>characterEncodingFilter</filter-name>
  <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
  <init-param>
    <param-name>encoding</param-name>
    <param-value>utf-8</param-value>
  </init-param>
  <init-param>
    <param-name>forceEncoding</param-name>
    <param-value>true</param-value>
  </init-param>
</filter>
<filter-mapping>
  <filter-name>characterEncodingFilter</filter-name>
  <url-pattern>/*</url-pattern>
</filter-mapping>

<!--前端核心控制器-->
<servlet>
  <servlet-name>dispatcherServlet</servlet-name>
  <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
  <init-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>classpath:springmvc.xml</param-value>
  </init-param>
  <!--    启动时加载    -->
  <load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
  <servlet-name>dispatcherServlet</servlet-name>
  <!--  除jsp外的所有      -->
  <url-pattern>/</url-pattern>
</servlet-mapping>
配置springmvc.xml

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
<!-- 配置spring创建容器时要扫描的包 -->
<context:component-scan base-package="com.test"></context:component-scan>

<!-- 配置视图解析器 -->
<bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
  <!--   配置前缀后缀     -->
  <property name="prefix" value="/WEB-INF/pages/"></property>
  <property name="suffix" value=".jsp"></property>
</bean>    

<!-- 处理请求返回json字符串的中文乱码问题 -->
<mvc:annotation-driven/>

<!-- 设置静态资源不过滤 -->
<mvc:default-servlet-handler/>
导入Utils

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
17
18
19
public class UploadUtils {

  public static String getUUIDName(String fileName){
    //获取后缀名
    int index = fileName.lastIndexOf(".");
    if(index==-1){
      return UUID.randomUUID().toString().replace("-", "").toUpperCase();
    }else{
      return UUID.randomUUID().toString().replace("-", "").toUpperCase()+fileName.substring(index);
    }
  }

  public static String getDir(){
    String s="0123456789ABCDEF";
    Random r = new Random();
    return "/"+s.charAt(r.nextInt(16))+"/"+s.charAt(r.nextInt(16));
  }

}
创建前端index.jsp页面

1
2
3
4
5
6
7
<!-- 要素：enctype ，method -->
<form action="${pageContext.request.contextPath}/upload" enctype="multipart/form-data" method="post">
  <!-- 要素：type="file"  -->
  <input type="file" name="upLoadFile">
  <input name="desc">
  <input type="submit" value="Submit">
</form>
创建FileUploadController控制器

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
17
18
19
20
21
22
23
24
25
@Controller
public class FileInputController{

  @RequestMapping("/upload")
  public String upload(HttpServletRequest req,MultipartFile upLoadFile,String desc){
    //获取原名
    String originalFilename = upLoadFile.getOriginalFilename();
    //通过UUID变为唯一
    String uuidName = UploadUtils.getUUIDName(originalFilename);
    //获取文件真实存放路径
    String realPath = req.getSession().getServletContext().getRealPath("/upload");

    //生成新存放目录结构
    String dir = UploadUtils.getDir();
    //创建保存目录
    File savePath = new File(realPath, dir);
    if (!savePath.exists()) {
      savePath.mkdirs();
    }
    //保存文件
    upLoadFile.transferTo(new File(savePath, uuidName));
    
    return "success";
  }
}
在springmvc.xml配置文件解析器

注意：

文件上传的解析器 ==id 是固定的，不能起别的名称==，否则无法实现请求参数的绑定。（不光是文件，其他字段也将无法绑定）

1
2
3
4
5
<!--配置文件上传解析器-->
<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
  <!-- 设置上传文件的最大尺寸为 5MB --> 
  <property name="maxUploadSize" value="5242880"></property>
</bean>
1.4.3 小结
前端三要素 form post, encpt=multipart/form-data, input type=file
Controller使用MultipartFile接收文件，形参名称必须与 前端中的name 一样，严格大小写
配置使用commons-fileupload
分目录存储
案例：SpringMVC 跨服务器上传
1.5 需求
了解使用springmvc 跨服务器方式的文件上传

1.5.1 分析
1.5.2 分服务器的目的
服务器分工问题，以及数据安全问题，需要将数据存储到其他服务器，此处使用另一台Tomcat服务器作为数据接收服务器

应用服务器：负责部署我们的应用 (Tomcat,JBOSS等)
数据库服务器：运行我们的数据库(Oracle小型机等)
缓存和消息服务器：负责处理大并发访问的缓存和消息(MQ等)
文件服务器：负责存储用户上传文件的服务器。 (Ceph等)

1.5.3 文件服务器步骤
复制一份Tomcat，并更改conf/web.xml为非只读

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
17
<servlet>
  <servlet-name>default</servlet-name>
  <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>
  <init-param>
    <param-name>debug</param-name>
    <param-value>0</param-value>
  </init-param>
  <init-param>
    <param-name>readonly</param-name>
    <param-value>false</param-value>
  </init-param>
  <init-param>
    <param-name>listings</param-name>
    <param-value>false</param-value>
  </init-param>
  <load-on-startup>1</load-on-startup>
</servlet>
创建web工程文件服务器的应用(需2台Tomcat，因此需要更改端口)，布署到这个tomcat上来, 创建 upload目录

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
fileUploadServer
├── pom.xml
└── src
    ├── main
    │   ├── java
    │   ├── resources
    │   └── webapp
    │       ├── WEB-INF
    │       │   └── web.xml
    │       └── upload
    └── test
        └── java
1.5.4 实现(使用传统方式文件上传案例)
添加添jersey依赖

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
<dependency>
  <groupId>com.sun.jersey</groupId>
  <artifactId>jersey-core</artifactId>
  <version>1.18.1</version>
</dependency>
<dependency>
  <groupId>com.sun.jersey</groupId>
  <artifactId>jersey-client</artifactId>
  <version>1.18.1</version>
</dependency>
前端页面

1
2
3
4
5
6
7
<!-- 要素：enctype ，method -->
<form action="${pageContext.request.contextPath}/uploadToRemote" enctype="multipart/form-data" method="post">
  <!-- 要素：type="file"  -->
  <input type="file" name="upLoadFile">
  <input name="desc">
  <input type="submit" value="Submit">
</form>
FileUploadController控制器

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
17
18
@RequestMapping("/uploadToRemote")
public String uploadToRemote(HttpServletRequest req, MultipartFile upLoadFile, String desc) throws IOException {
    System.out.println(desc);
    //获取原名
    String originalFilename = upLoadFile.getOriginalFilename();
    //通过UUID变为唯一
    String uuidName = UploadUtils.getUUIDName(originalFilename);
    // 文件服务器的连接
    String url = "http://localhost:8081/fileUploadServer/upload/";
    // jersey客户端，需要选择jersey的Client
    Client client = Client.create();
    // 定位存储的目录, 服务器的地址
    WebResource resource = client.resource(url + uuidName);
    // 上传
    resource.put(upLoadFile.getBytes());
    
    return "success";
}
1.6 小结
为什么要分服务器存储

安全
维护方便
服务器性能充分的利用
准备文件服务器

准备文件服务器， 复制一份tomcat, 修改conf/web.xml 更改只读 为 false
创建web工程文件服务器的应用，布署(更改端口), 创建 upload目录
修改文件上传代码

使用jersey，上传文件

二.SpringMVC 中的异常处理
2.1 目标
掌握SpringMVC的统一异常处理

2.2 分析
系统中异常包括两类

预期异常：通过捕获异常从而获取异常信息运行时异常
RuntimeException：主要通过规范代码开发、测试通过手段减少运行时异常的发生。
目前Server中的MVC层均throws Exception，通过SpringMVC前端控制器交由异常处理器进行异常处理

SpringMVC在处理请求过程中出现异常信息交由异常处理器进行处理，自定义异常处理器可以实现一个系统的异常处理逻辑。

步骤

自定义异常类 已知错误。作用：作为已知不符合业务逻辑的继续执行
创建异常处理类实现HandlerExceptionResolver接口
配置让springMVC使用这个接口
测试
2.3 代码实现
2.3.1 自定义异常类
目的: 统一的管理异常, 方便统一管理错误提示语

1
2
3
4
5
6
//自定义异常类
public class SysException extends RuntimeException {
  public SysException(String msg){
    super(msg);
  }
}
2.3.2 自定义异常处理器
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
17
18
19
20
21
22
23
24
25
//全局异常处理
public class SysExceptionResolver implements HandlerExceptionResolver {
    //处理controller往上抛的异常
    @Override
    public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        ModelAndView modelAndView = new ModelAndView();

        // 对已知道的异常，只要提示信息
        String message=null;
    
        if(ex instanceof SysException){
            SysException sysException = (SysException) ex;
            // 自己报错的信息
             message = ex.getMessage();
        }else {
            // 对未知的异常，包装下再返回给页面
            message="Error,Please Contact Administrator";
        }
        // 返回给前端的提示信息
        modelAndView.addObject("message",message);
        modelAndView.setViewName("error");
//        ex.printStackTrace();
        return modelAndView;
    }
}
2.3.3 配置异常处理器
springmvc.xml

1
2
<!--  注册全局异常处理器 由springmvc自动装载 annotation-driven  -->
<bean id="sysExceptionResolver" class="com.test.exception.SysExceptionResolver"/>
2.3.4 小结
自定义异常：终止已经不符合业务逻辑的继续执行，反馈自定义提示页面
自定义异常继承RuntimeException
全局异常处理器 实现HandlerExceptionResolver接口，对异常封装处理
2.4 扩展异常处理
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
17
18
19
20
21
22
23
@Controller
public class MyExceptionHandler {


    /**
     * ExceptionHandler 获取的是哪种异常，使用这个方法来处理  catch
     * 参数：捕获的异常, 如果运行时抛出的异常与它不匹配，则不会调用这个方法，根据异常的类型来捕获，遵循从小到大
     * model: 数据模型，作用：传递数据给jsp页面
     * @return
     */
    
    @ExceptionHandler(Exception.class)
    public String handleException(Exception exception, Model model){
        model.addAttribute("message","Unknown Error");
        return "error";
    }
    //数字异常
    @ExceptionHandler(ArithmeticException.class)
    public String handleArithmeticException(ArithmeticException arithmeticException,Model model){
        model.addAttribute("message","Math Error");
        return "error";
    }
}
三.SpringMVC 中的拦截器
3.1 目标
掌握SpringMVC基本使用

3.1.1 学习路径
拦截器概述
自定义拦截器入门
3.1.2 讲解
3.1.3 拦截器概述
Spring MVC 的处理器拦截器类似于 Servlet 开发中的过滤器 Filter，用于对处理器(自己编写的Controller)进行预处理和后处理。用户可以自己定义一些拦截器来实现特定的功能。

谈到拦截器，还要向大家提一个词——拦截器链（Interceptor Chain）。拦截器链就是将拦截器按一定的顺序联结成一条链。在访问被拦截的方法或字段时，拦截器链中的拦截器就会按其之前定义的顺序被调用。

它和过滤器是有几分相似，但也有区别

类别	使用范围	拦截范围
拦截器	SpringMVC项目	只会拦截访问的控制器方法, 可以使用spring容器
过滤器	任何web项目	任何资源(servlet,控制器,jsp,html等)， 无法使用Spring容器
3.1.4 自定义拦截器入门
编写个一测试用的ControllerDemo

1
2
3
4
5
6
7
8
9
@Controller
public class ControllerDemo {

    @RequestMapping("/demo01")
    public String demo01(){
        System.out.println("Demo01 By ControllerDemo");
        return "success";
    }
}
编写一个普通类HandlerInterceptorDemo1实现 HandlerInterceptor 接口

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
public class HandlerInterceptorDemo1 implements HandlerInterceptor{
  /**
     * 前置拦截, 在调用controller的方法前执行
     * @return true: 放行， false：阻止
     */
  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    // response 可以重定向， 用户登陆认证(session中不存)
    System.out.println("HandlerInterceptorDemo1.preHandle 执行了");
    return true;
  }
}
在springmvc.xml配置拦截器

1
2
3
4
5
6
7
8
9
<!--配置拦截器-->
<mvc:interceptors>
  <!--        interceptor 一个拦截器-->
  <mvc:interceptor>
    <!--用于指定拦截的路径-->
    <mvc:mapping path="/**"/>
    <bean id="intercepter01" class="com.test.interceptor.HandlerInterceptorDemo1"></bean>
  </mvc:interceptor>
</mvc:interceptors>
3.1.5 小结
拦截器，在进入 controller之前拦截。
实现HandlerInterceptor接口, preHandler方法， 返回true则可以调用controller方法，false则不会调用controller
配置springmvc.xml
3.2 目标(进阶版本)
掌握自定义拦截器的高级使用

3.2.1 学习路径
拦截器的放行
拦截后跳转
拦截器的路径
拦截器的其它方法
多个拦截器执行顺序
3.2.2 讲解
3.2.3 拦截器的放行
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
public class HandlerInterceptorDemo1 implements HandlerInterceptor {
  @Override
  //在达到目标方法之前进行拦截——preHandle
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

    System.out.println("HandlerInterceptorDemo1");
    //true放行，false拦截，源码默认放行
    return true;
  }
}
3.2.4 拦截后跳转
拦截器的处理结果

放行： 如果后面还有拦截器就执行下一个拦截器，如果后面没有了拦截器，就执行Controller方法
拦截： 但是注意，拦截后也需要返回到一个具体的结果(页面,Controller)
在preHandle方法返回false,通过request进行转发,或者通过response对象进行重定向,输出

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
public class Intercepter01 implements HandlerInterceptor {
    @Override
    //在达到目标方法之前执行(拦截的方法)
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("preHandle 执行了...");
        //转发到拦截后的页面
        //request.getRequestDispatcher("/intercepter01.jsp").forward(request,response);
        //转发到controller
        request.getRequestDispatcher("/demo01/fun02").forward(request,response);
        return false;//返回true放行, 返回false拦截
    }
3.2.5 拦截器的路径
1
2
3
4
5
6
7
8
9
<mvc:interceptors>
  <mvc:interceptor>
    <!-- 指定拦截器  拦截  路径 -->
    <mvc:mapping path="/**"/>
    <!-- 指定拦截器  放行  路径 -->
    <mvc:exclude-mapping path="/demo/fun01"/>
      <bean id="interceptorDemo1" class="com.test.interceptor.HandlerInterceptorDemo1"/>
   </mvc:interceptor>
</mvc:interceptors>
3.2.6 拦截器的其它方法
afterCompletion 在目标方法完成视图层渲染后执行。

postHandle 在被拦截的目标方法执行完毕获得了返回值后执行。

preHandle 被拦截的目标方法执行之前执行。

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
17
18
19
public class Intercepter01 implements HandlerInterceptor {
  @Override
  //在达到目标方法之前执行(拦截的方法)
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    System.out.println("preHandle 执行了...");
    return true;//返回true放行, 返回false拦截
  }
  @Override
  //在目标方法执行完成之后,完成页面渲染之前执行
  public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable ModelAndView modelAndView) throws Exception {
    System.out.println("postHandle 执行了...");
  }

  @Override
  //完成页面渲染之后执行
  public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable Exception ex) throws Exception {
    System.out.println("afterCompletion 执行了...");
  }
}
3.2.7 多个拦截器执行顺序
配置顺序

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
17
<!--配置拦截器-->
<mvc:interceptors>
  <mvc:interceptor>
    <!--用于指定拦截的路径-->
    <mvc:mapping path="/**"/>
    <!--用于指定忽略(不拦截的路径)-->
    <mvc:exclude-mapping path="/demo01/fun02"/>
    <bean id="intercepter01" class="com.test.web.interceptor.Intercepter01"></bean>
  </mvc:interceptor>
  <mvc:interceptor>
    <!--用于指定拦截的路径-->
    <mvc:mapping path="/**"/>
    <!--用于指定忽略(不拦截的路径)-->
    <mvc:exclude-mapping path="/demo01/fun02"/>
    <bean id="intercepter02" class="com.test.web.interceptor.Intercepter02"></bean>
  </mvc:interceptor>
</mvc:interceptors>
3.2.8 小结
拦截器是一个链式模式
只有preHandler方法才有返回true 放行，false拦截
拦截器的跳转 return false, request转发，response重定向
preHandle->postHandle->afterCompletion
多个执行的顺序与配置文件的顺序有关
四.SSM整合环境的准备
4.1 目标
能够独立准备SSM环境

4.2 步骤
创建数据库和表
创建Maven工程(war)
导入坐标
创建实体类
拷贝log4J日志到工程
4.3 讲解
4.3.1 创建数据库和表结构
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
create database ssm;
use ssm;
create table account(
  id int primary key auto_increment,
  name varchar(40),
  money double
)character set utf8 collate utf8_general_ci;

insert into account(name,money) values('zs',1000);
insert into account(name,money) values('ls',1000);
insert into account(name,money) values('ww',1000);
4.3.2 创建Maven工程
创建web项目

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
17
18
├── SpringMVC_Day02_04_ssm.iml
├── pom.xml
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── test
│   │   │           └── dao
│   │   │               └── AccountDao.java
│   │   ├── resources
│   │   │   └── log4j.properties
│   │   └── webapp
│   │       ├── WEB-INF
│   │       │   └── web.xml
│   │       └── index.jsp
│   └── test
│       └── java
└── target
导入坐标

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
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
91
92
93
94
95
96
97
98
99
100
101
102
103
104
105
106
107
108
109
110
111
<properties>
        <spring.version>5.0.2.RELEASE</spring.version>
        <slf4j.version>1.6.6</slf4j.version>
        <log4j.version>1.2.12</log4j.version>
  			<!-- mysql8 驱动版本坐标 -->
        <mysql.version>5.1.46</mysql.version>
        <mybatis.version>3.4.5</mybatis.version>
    </properties>
    <dependencies>
        <!-- spring -->
        <dependency>
            <groupId>org.aspectj</groupId>
            <artifactId>aspectjweaver</artifactId>
            <version>1.6.8</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-aop</artifactId>
            <version>${spring.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>${spring.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-web</artifactId>
            <version>${spring.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>${spring.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-test</artifactId>
            <version>${spring.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-tx</artifactId>
            <version>${spring.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>${spring.version}</version>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>${mysql.version}</version>
        </dependency>
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>servlet-api</artifactId>
            <version>2.5</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>jsp-api</artifactId>
            <version>2.0</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>jstl</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>
        <!-- log start -->
        <dependency>
            <groupId>log4j</groupId>
            <artifactId>log4j</artifactId>
            <version>${log4j.version}</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>${slf4j.version}</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-log4j12</artifactId>
            <version>${slf4j.version}</version>
        </dependency>
        <!-- log end -->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>${mybatis.version}</version>
        </dependency>
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis-spring</artifactId>
            <version>1.3.0</version>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
            <version>1.0.16</version>
        </dependency>
    </dependencies>
编写实体类

1
2
3
4
5
6
7
public class Account implements Serializable {

  private Integer id;
  private String name;
  private double money;
  //省略getter/setter，toString
}
拷贝log4J配置文件到工程

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
##\u8bbe\u7f6e\u65e5\u5fd7\u8bb0\u5f55\u5230\u63a7\u5236\u53f0\u7684\u65b9\u5f0f
log4j.appender.std=org.apache.log4j.ConsoleAppender
log4j.appender.std.Target=System.out
log4j.appender.std.layout=org.apache.log4j.PatternLayout
log4j.appender.std.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %5p %c{1}:%L - %m%n
##\u8bbe\u7f6e\u65e5\u5fd7\u8bb0\u5f55\u5230\u6587\u4ef6\u7684\u65b9\u5f0f
log4j.appender.file=org.apache.log4j.FileAppender
log4j.appender.file.File=d:/mylog.log
log4j.appender.file.layout=org.apache.log4j.PatternLayout
log4j.appender.file.layout.ConversionPattern=%d{ABSOLUTE} %5p %c{1}:%L - %m%n
##\u65e5\u5fd7\u8f93\u51fa\u7684\u7ea7\u522b\uff0c\u4ee5\u53ca\u914d\u7f6e\u8bb0\u5f55\u65b9\u6848
log4j.rootLogger=debug,std
五.Spring整合SpringMVC
5.1 目标(初始版本——SpringMVC独立运行)
5.2 步骤
创建AccountController, 定义方法 添加注解
创建springmvc.xml(开启包扫描, 注册视图解析器,忽略静态资源, 注解驱动)
配置web.xml(前端控制器, 编码过滤器)
测试
5.3 实现
创建AccountController.java

1
2
3
4
5
6
7
8
9
@Controller
@RequestMapping("/account")
public class AccountController{
  @RequestMapping("/findAll")
  public String findAll(){
    System.out.println("Find All");
    return "list";
  }
}
创建springmvc.xml配置文件

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
17
18
19
20
21
22
23
24
25
26
27
28
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/mvc
        http://www.springframework.org/schema/mvc/spring-mvc.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd">

    <!--开启包扫描-->
    <context:component-scan base-package="com.test"></context:component-scan>
    
    <!--配置视图解析器-->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <!--   配置前缀后缀     -->
        <property name="prefix" value="/WEB-INF/pages/"></property>
        <property name="suffix" value=".jsp"></property>
    </bean>
    <!--配置注解驱动支持-->
    <mvc:annotation-driven></mvc:annotation-driven>
      
    <!--  静态资源过滤  -->
    <mvc:default-servlet-handler/>
</beans>
在web.xml里面配置前端控制器

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
17
18
19
20
21
22
23
24
25
26
27
<servlet>
  <servlet-name>springmvc</servlet-name>
  <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
  <init-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>classpath:springmvc.xml</param-value>
  </init-param>
  <load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
  <servlet-name>springmvc</servlet-name>
  <url-pattern>/</url-pattern>
</servlet-mapping>

<!--编码过滤器-->
<filter>
  <filter-name>CharacterEncodingFilter</filter-name>
  <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
  <init-param>
    <param-name>encoding</param-name>
    <param-value>UTF-8</param-value>
  </init-param>
</filter>
<filter-mapping>
  <filter-name>CharacterEncodingFilter</filter-name>
  <url-pattern>/*</url-pattern>
</filter-mapping>
5.4 小结
创建Controller, 创建方法 添加注解
创建springmvc.xml(开启包扫描, 注册视图解析器,忽略静态资源,开启注解驱动)
配置web.xml(前端控制器, 编码过滤器)
5.5 目标(进阶版本——注入业务层)
5.6 步骤
注册Service
在Controller里面注入Service
5.7 实现
编写AccountService.java

1
2
3
public interface AccountService{
  List<Account> findAll();
}
编写AccountServiceImpl.java

1
2
3
4
5
6
7
8
@service
public class AccountServiceImpl implements AccountService{
  @Override
  public List<Account> findAll(){
    System.out.println("Find All By AccountServiceImpl");
    return null;
  }
}
在AccountController调用AccountService

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
@Controller
@Requestmapping("/account")
public class AccountController{
  @Autowired AccountService accountService;

  @Requestmapping("/findAll"){
    System.out.println("Find All By AccountServiceImpl");
		List<Account> list = accountService.findAll();
    return "list";
  }
}
5.8 小结
创建业务接口与实现类
在实现类上加@Service 把交给spring容器管理
AccountController 注入进来 @Autowired, 调用业务方法
六.Spring整合MyBatis
6.1 目标(初始版本——MyBatis独立运行)
6.1.1 步骤
创建Dao接口, 定义方法, 添加注解
创建SqlMapConfig.xml
编写Java代码测试
6.1.2 实现
创建AccountDao.java, 添加注解

1
2
3
4
public interface AccountDao{
  @Select("SELECT * FROM account")
 List<Account> findAll(); 
}
编写MyBatis核心配置文件:SqlMapConfig.xml

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
17
18
19
20
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
  <environments default="development">
    <environment id="development">
      <transactionManager type="JDBC"/>
      <dataSource type="POOLED">
        <property name="driver" value="com.mysql.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/ssm"/>
        <property name="username" value="root"/>
        <property name="password" value="123456"/>
      </dataSource>
    </environment>
  </environments>
  <mappers>
    <package name="com.test.dao"></package>
  </mappers>
</configuration>
测试运行结果

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
17
18
19
20
21
public class DaoTest {

  @Test
  public void DaoTest() throws Exception{
    // 创建工厂对象
    SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(Resources.getResourceAsStream("SqlMapConfig.xml"));

    SqlSession sqlSession = sqlSessionFactory.openSession();
    
    AccountDao accountDao = sqlSession.getMapper(AccountDao.class);
    
    List<Account> list = accountDao.findAll();
    
    for (Account account : list) {
      System.out.println(account);
    }
    
    sqlSession.close();

  }
}
6.1.3 小结
创建Dao接口, 定义方法, 添加注解
创建SqlMapConfig.xml
编写Java测试代码
6.2 目标(进阶版本——注解版本)
6.2.1 分析
问题	优化方式
连接池还是用的MyBatis自带的	用第三方的连接池,通过Spring管理
SqlSessionFactory还是我们自己构建的	通过Spring管理SqlSessionFactory
扫描Dao还是由MyBatis加载的	通过Spring扫描Dao
事务还是由MyBatis管理	通过Spring管理事务
6.2.2 步骤
创建applicationContext.xml
注册DataSource(配置四个基本项)
注册SqlSessionFactory
扫描Dao接口
配置事务
加载applicationContext.xml
6.2.3 实现
把SqlSessionFactory交给Spring管理,也就意味着把 mybatis 配置文件（SqlMapConfig.xml）中内容配置到 spring 配置文件中同时，把 mybatis 配置文件的内容清掉。
使用Spring管理事务
6.2.3.1 Spring 接管MyBatis的Session工厂
创建applicationContext.xml

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
<!--  数据源  -->
<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
  <property name="driverClassName" value="com.mysql.jdbc.Driver"></property>
  <property name="url" value="jdbc:mysql://localhost:3306/ssm"></property>
  <property name="username" value="root"></property>
  <property name="password" value="root"></property>
</bean>
<!--  sqlsessionFactory交给spring来创建  -->
<bean class="org.mybatis.spring.SqlSessionFactoryBean">
  <property name="dataSource" ref="dataSource"></property>
</bean>
<!--  扫描dao接口 dao已经进入spring 容器了  -->
<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
  <property name="basePackage" value="com.test.dao"/>
</bean>
注意:

由于我们使用的是代理 Dao 的模式， Dao 具体实现类由 MyBatis 使用代理方式创建，所以此时 mybatis配置文件不能删。

6.2.3.2 配置 spring 的事务
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
17
18
19
20
21
22
<!--  事务管理器  -->
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
  <property name="dataSource" ref="dataSource"/>
</bean>
<!--  注解声明式事务  -->
<tx:annotation-driven transaction-manager="transactionManager"/>

<tx:advice id="advice" transaction-manager="transactionManager">
  <tx:attributes>
    <tx:method name="add*" propagation="REQUIRED" rollback-for="java.lang.Exception" isolation="DEFAULT"/>
    <tx:method name="save*" propagation="REQUIRED" rollback-for="java.lang.Exception" isolation="DEFAULT"/>
    <tx:method name="update*" propagation="REQUIRED" rollback-for="java.lang.Exception" isolation="DEFAULT"/>
    <tx:method name="delete*" propagation="REQUIRED" rollback-for="java.lang.Exception" isolation="DEFAULT"/>
    <!--    read-only: true 不需要事务        -->
    <tx:method name="*" read-only="true"/>
  </tx:attributes>
</tx:advice>
<!--  切面  -->
<aop:config>
  <aop:pointcut id="mypoint" expression="execution(* com.test.service..*.*(..))"/>
  <aop:advisor advice-ref="advice" pointcut-ref="mypoint"/>
</aop:config>
6.2.3.3 加载applicationContext.xml
方式一:直接把applicationContext.xml里面的配置定义在springmvc.xml

方式二:更改名称，用通配符导入

1
2
3
4
5
<!--初始化参数:加载配置文件-->
<init-param>
  <param-name>contextConfigLocation</param-name>
  <param-value>classpath:applicationContext*.xml</param-value>
</init-param>
方式三: 在springmvc.xml 引入applicationContext.xml

applicationContext.xml已经写完了, 但是发现并没有被加载,也就意味着Spring整合MyBatis的部分并没有生效. 其实我们在Spring整合SpringMVC时候, 当服务器启动的时候已经加载过springmvc.xml, spring容器也就会被初始化. 我们可以通过import标签把applicationContext.xml导入到springmvc.xml中一起加载.

1
<import resource="classpath:applicationContext.xml"></import>
6.2.3.4 测试SSM整合结果
6.2.3.4.1 查询所有展示页面
AccountController.java

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
@Controller
@Requestmapping("/account")
public class AccountController{

  @Autowired
  private AccountService accountService;

  @Requestmapping("/findAll")
  public String findAll(Model model){
		List<Account> list = accountService.findAll();
    model.addAttribute("list",list)
    return "list";
  }
}
AccountServiceImpl.java

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
@service
public class AccountServiceImpl implements AccountService{
  @Autowired
  private AccountDao accountDao;

  @Override
  public List<Account> findAll(){
    return accountDao.findAll();
  }
}
AccountDao.java

1
2
3
4
5
public interface AccountDao{

  @Select("SELECT * FROM account")
  List<Account> findAll();
}
前端list.jsp页面

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
17
18
19
20
21
22
23
24
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Title</title>
  </head>
  <body>
    <table>
      <tr>
        <td>ID</td>
        <td>Name</td>
        <td>Money</td>
      </tr>
      <c:forEach items="${list}" var="account">
        <tr>
          <td>${account.id}</td>
          <td>${account.name}</td>
          <td>${account.money}</td>
        </tr>
      </c:forEach>
    </table>
  </body>
</html>

6.2.3.4.2 添加账户
index.jsp页面

1
2
3
4
5
<form action="${pageContext.request.contextPath}/account/add">
    Name:<input name="name">
    Money<input name="money">
    <input type="submit" value="Submit">
</form>
AccountController.java

1
2
3
4
5
@Requestmapping("/add")
public String add(Account account){
  accountService.add(account);
  return "redirect:/account/findAll"
}
AccountService

1
2
3
4
5
public interface AccountService{
  List<Account> findAll();

  void add(Account account);
}
AccountServiceImpl.java

1
2
3
4
@Override
public void add(Account account){
  accountDao.add(account);
}
AccountDao.java

1
2
@Insert("INSERT INTO account(name,money) VALUES(#{name},#{money})")
void add(Account account);
6.2.4 总结
SpringMVC

创建Controller, @RequestMapping, @Controller
springmvc.xml
扫controller
视图解析器
资源过滤
注解驱动
web.xml
编码过滤器 filter CharacterEncodingFilter
前端核心控制器 DispatcherServlet
整合spring业务注入

创建service接口与实现类
实现类上加@Service
Controller通过@Autowired注入业务，controller中的方法，调用业务层
初级版本(MyBatis独立运行)

创建dao接口 注解方法
创建SqlMapConfig.xml 配置数据源，扫包
测试
spring整合mybatis

创建applicationContext.xml
注册DataSource(配置四个基本项)
注册SqlSessionFactory
扫描Dao接口
配置事务 advice aop, tx:annotation-driven
注意：

applicationContext.xml导入到springmvc.xml