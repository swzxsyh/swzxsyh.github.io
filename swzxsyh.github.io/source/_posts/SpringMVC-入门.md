---
title: SpringMVC 入门
date: 2020-06-12 01:45:52
tags:
---


一.SpringMVC介绍
知识点-SpringMVC概述
1.1 目标
介绍SpringMVC框架

1.2 路径
三层架构(SpringMVC在三层架构的位置)

什么是SpringMVC

SpringMVC 的优点

<!-- more -->

1.3 讲解
1.3.1 三层架构
Spring：IOC控制反转 和 AOP切面编程

浏览器		Web层	业务层	持久层
Servlet,Filter,JSP	Spring	JDBC,DbUtils
SpringMVC	Spring	Hibername
MyBatis
获得请求参数
调用业务
分发转向	对事务管理
处理业务
调用Dao	操作数据库
服务器端程序，一般都基于两种形式，一种C/S架构程序，一种B/S架构程序. 使用Java语言基本上都是开发B/S架构的程序，B/S架构又分成了三层架构.

三层架构

 表现层：WEB层，用来和客户端进行数据交互的。表现层一般会采用MVC的设计模型

 业务层：处理公司具体的业务逻辑的

 持久层：用来操作数据库的

MVC全名是Model View Controller 模型视图控制器，每个部分各司其职。

 Model：数据模型，JavaBean的类，用来进行数据封装。

 View：指JSP、HTML用来展示数据给用户

 Controller：用来接收用户的请求，整个流程的控制器。用来进行数据校验等(Hibernate Validator)

1.3.2 什么是SpringMVC
简单来说

SpringMVC 是一种基于Java实现的MVC设计模型的请求驱动类型的轻量级WEB层框架。

作用

参数绑定(获得请求参数)

调用业务

响应

1.3.3 SpringMVC 的优点
清晰的角色划分：
前端控制器（DispatcherServlet）  
  请求到处理器映射（HandlerMapping）
  处理器适配器（HandlerAdapter）
  视图解析器（ViewResolver）
  处理器或页面控制器（Controller）
  验证器（ Validator）
  命令对象（Command 请求参数绑定到的对象就叫命令对象）
  表单对象（Form Object 提供给表单展示和提交到的对象就叫表单对象）。
分工明确，而且扩展点相当灵活，可以很容易扩展，虽然几乎不需要。
由于命令对象就是一个 POJO，无需继承框架特定 API，可以使用命令对象直接作为业务对象。
和 Spring 其他框架无缝集成，是其它 Web 框架所不具备的。
可适配，通过 HandlerAdapter 可以支持任意的类作为处理器。
可定制性， HandlerMapping、 ViewResolver 等能够非常简单的定制。
功能强大的数据验证、格式化、绑定机制。
利用 Spring 提供的 Mock 对象能够非常简单的进行 Web 层单元测试。
本地化、主题的解析的支持，使我们更容易进行国际化和主题的切换。
强大的 JSP 标签库，使 JSP 编写更容易。
还有比如RESTful风格的支持、简单的文件上传、约定大于配置的契约式编程支持、基于注解的零配置支持等等。
1.4.小结
SpringMVC 位于web层

SpringMVC: Spring家族web层的一个框架,作用

参数绑定(获得请求参数)
调用业务
响应
二.SpringMVC入门
2.1 需求
浏览器请求服务器(SpringMVC), 响应成功页面

2.2 分析
创建maven工程，引入spring-webmvc
创建Controller, 处理的请求
创建一个index.jsp页面
配置springmvc.xml
配置web.xml 启动时加springmvc.xml
2.3 实现
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
SpringMVC_Day01_01_quickstart
├── SpringMVC_Day01_01_quickstart.iml
├── pom.xml
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── test
│   │   │           └── web
│   │   │               └── controller.java
│   │   ├── resources
│   │   │   └── springmvc.xml
│   │   └── webapp
│   │       ├── WEB-INF
│   │       │   ├── pages
│   │       │   │   └── success.jsp
│   │       │   └── web.xml
│   │       └── index.jsp
│   └── test
│       └── java
└── target
    ├── SpringMVC_Day01_01_quickstart-1.0-SNAPSHOT
    │   ├── META-INF
    │   │   └── MANIFEST.MF
    │   ├── WEB-INF
    │   │   ├── classes
    │   │   │   ├── com
    │   │   │   │   └── test
    │   │   │   │       └── web
    │   │   │   │           └── controller.class
    │   │   │   └── springmvc.xml
    │   │   ├── lib
    │   │   ├── pages
    │   │   │   └── success.jsp
    │   │   └── web.xml
    │   └── index.jsp
    ├── classes
    │   ├── com
    │   │   └── test
    │   │       └── web
    │   │           └── controller.class
    │   └── springmvc.xml
    └── generated-sources
        └── annotations

2.3.1 创建web项目,引入坐标
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
  <dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.10</version>
  </dependency>
  <!--文件上传-->
  <dependency>
    <groupId>commons-fileupload</groupId>
    <artifactId>commons-fileupload</artifactId>
    <version>1.4</version>
  </dependency>
</dependencies>
2.3.2 编写Controller
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
public class controller {

    @RequestMapping("/sayHello")
    public String sayHelo(){
        System.out.println("quickStart_sayHello");
        return "success";
    }
}
2.3.3 编写SpringMVC的配置文件
springmvc.xml

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
    <!-- 配置spring创建容器时要扫描的包 -->
    <context:component-scan base-package="com.test"></context:component-scan>

    <!-- 配置视图解析器 -->
    <bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <!--   配置前缀后缀     -->
        <property name="prefix" value="/WEB-INF/pages/"></property>
        <property name="suffix" value=".jsp"></property>
    </bean>
</beans>
2.3.4 在里面配置核心控制器
web.xml

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
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://java.sun.com/xml/ns/javaee"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
         version="2.5">

    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>
    
    <servlet>
        <servlet-name>SpringMVC</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <!-- 配置初始化参数，用于读取 SpringMVC 的配置文件 -->
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:springmvc.xml</param-value>
        </init-param>
        <!-- 配置 servlet 的对象的创建时间点：应用加载时创建。取值只能是非 0 正整数，表示启动顺序 -->
        <load-on-startup>4</load-on-startup>
    </servlet>
    
    <servlet-mapping>
        <servlet-name>SpringMVC</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>
</web-app>
2.3.5 测试
1
<a href="${pageContext.request.contextPath}/sayHello">SpringMVC Quick Start</a>
2.4 小结
创建Maven工程(war), 导入坐标(webmvc, servlet-api, jsp-api)
创建Controller类, 创建一个方法, 添加注解(类上@Controller, 方法@RquestMapping)
创建springmvc.xml(开启包扫描, 注册视图解析器, 注解驱动)
配置web.xml(前端控制器, 默认访问主页)
知识点-入门案例的执行过程及原理分析
2.5 目标
RequestMapping的使用

2.6 路径
介绍RequestMapping作用
RequestMapping的使用的位置
RequestMapping的属性
2.7 讲解
2.7.1 RequestMapping作用
RequestMapping注解的作用是建立请求URL和处理方法之间的对应关系

作用

把url与controller中的方法进行绑定，当请求过来时，通过url去找对应的controller对应的方法进行调用RequestMapping注解可以作用在方法和类上

2.7.2 RequestMapping的使用的位置
使用在类上:

 请求 URL 的第一级访问目录。此处不写的话，就相当于应用的根目录。 写的话需要以/开头 .它出现的目的是为了使我们的 URL 可以按照模块化管理

使用在方法上:

 请求 URL 的第二级访问目录

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
@Controller
@RequestMapping("/account")
public class AccountController {

    @RequestMapping("/add")
    public String add(String username, double money) {
        System.out.format("%s %f", username, money);
        return "success";
    }
  }
1
<a href="${pageContext.request.contextPath}/user/add">Add User</a><br>
2.7.3 RequestMapping的属性
value/path: 指定请求路径的url

1
2
3
4
5
@RequestMapping("/update")
private String update(Account account) {
  System.out.println(account);
  return "success";
}
method : 指定该方法的请求方式

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
//只能接受post方式请求    
@PostMapping("/delete")
public String delete() {
  System.out.println("Post Method Delete");
  return "success";
}

//只能接受gett方式请求
@GetMapping("/required")
public String required() {
  System.out.println("Get Method Required");
  return "success";
}
1
2
3
4
5
6
<form action="${pageContext.request.contextPath}/user/delete" method="post">
    <input type="submit" value="Post Method Successful">
</form>
<form action="${pageContext.request.contextPath}/user/required" method="get">
    <input type="submit" value="GET Method Successful">
</form>
2.7.4 了解的属性
params: 指定限制请求参数的条件

1
2
3
4
5
6
//请求参数必须是=18,如果不是,则会报错(HTTP Status 400 – Bad Request)    
@RequestMapping(value = "/modify", params = {"age=18"})
public String modify() {
  System.out.println("Modity User");
  return "success";
}
```jsp
<a href="${pageContext.request.contextPath}/user/modify?age=18">Params Successful</a><br>
<a href="${pageContext.request.contextPath}/user/modify">Failed By No Paramters</a>
<hr>
```
headers: 发送的请求中必须包含的请求头

1
2
3
4
5
6
7
//请求头必须有Accept=application/json,否则就会报错
@RequestMapping(value = "/headers", headers = "Accept=application/json")
public String headers() {
  System.out.println("Headers");
  return "success";
}

```jsp
<a href="${pageContext.request.contextPath}/user/headers">Headers Successful</a>
```
2.8 小结
RequestMapping: URL和方法进行绑定

RequestMapping定义位置

类上面

方法上面

如果类上面使用了, 方法上面也使用了. 访问: 类上面的RequestMapping/方法上面的RequestMapping

属性

value/path: 访问的路径(可以配置多个)

method: 配置访问的请求方式(可以配置多个, 默认就是任何请求方式都可以)

get,post,put,delete restful风格

@GetMapping->RequestMethod.GEt

@PostMapping

@PutMapping

@DeleteMapping

三.SpringMVC进阶
知识点-请求参数的绑定
3.1 目标
SpringMVC的参数绑定

3.2 分析
绑定机制

 表单提交的数据都是key=value格式的(username=zs&password=123),SpringMVC的参数绑定过程是把表单提交的请求参数，作为控制器中方法的参数进行绑定的(要求：提交表单的name和参数的名称是相同的)

支持的数据类型

 基本数据类型和字符串类型

 实体类型（JavaBean）

 集合数据类型（List、map集合等）

使用要求

如果是基本类型或者 String 类型： 要求我们的参数名称必须和控制器中方法的形参名称保持一致。 (严格区分大小写) .
如果是 POJO 类型，或者它的关联对象： 要求表单中参数名称和 POJO 类的属性名称保持一致。并且控制器方法的参数类型是 POJO 类型 .
如果是集合类型,有两种方式： 第一种：要求集合类型的请求参数必须在 POJO 中。在表单中请求参数名称要和 POJO 中集合属性名称相同。给 List 集合中的元素赋值， 使用下标。给 Map 集合中的元素赋值， 使用键值对。第二种：接收的请求参数是 json 格式数据。需要借助一个注解实现
3.3 讲解
3.3.1 基本类型和 String 类型作为参数
AccountController

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
@Controller
@RequestMapping("/account")
public class AccountController {

  @RequestMapping("/add")
  public String add(String username, double money) {
    System.out.format("%s %f", username, money);
    return "success";
  }
}
```jsp
<a href="${pageContext.request.contextPath}/account/add?name=A&money=1">Basic Type With name & money</a>
```
3.3.2 实体类型作为参数
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
public class Account implements Serializable {

    private Integer id;
    private String name;
    private Double money;
    
    private Address address;
}
public class Address implements Serializable {
    private String provinceName;
    private String Cityname;
}

//此处省略getter/setter，toString
jsp

```jsp
<form action="${pageContext.request.contextPath}/account/update">
    Name:<input type="text" name="name"><br>
    Money:<input type="text" name="money"><br>
    Provience:<input type="text" name="address.provinceName"><br>
    City:<input type="text" name="address.cityName"><br>
    <input type="submit" value="Reference Type Domain Account">
</form>
```
AccountController

1
2
3
4
5
@RequestMapping("/update")
private String update(Account account) {
  System.out.println(account);
  return "success";
}
3.3.3 提交到数组
AccountController

1
2
3
4
5
6
7
@RequestMapping("/findByIds")
public String findByIds(Integer[] ids){
  for (Integer id : ids) {
    System.out.println(id);
  }
  return "success";
}
```jsp
<form action="${pageContext.request.contextPath}/user/findByIds">
    <input type="checkbox" value="1" name="ids">A<br>
    <input type="checkbox" value="2" name="ids">B<br>
    <input type="checkbox" value="3" name="ids">C<br>
    <input type="checkbox" value="4" name="ids">D<br>
    <input type="submit" value="Reference Type Update Array">
</form>
```
注意:只能用数组来接前端多个参数，不能用List集合。确实需要List集合接收时，使用包装user.list

3.4 POJO 类中包含集合类型参数
3.4.1 POJO 类中包含List
User.java

1
2
3
4
5
6
7
public class User implements Serializable {
    private String username;
    private String password;
    private Integer age;
    private List<Account> accountList;
  //此处省略getter/setter，toString
}
```jsp
10
<form action="${pageContext.request.contextPath}/account/saveList" method="post">
    Name:<input type="text" name="username"><br>
    Password:<input type="password" name="password"><br>
    Age:<input type="text" name="age"><br>
    First Account Name:<input type="text" name="accountList[0].name"><br>
    First Account Money:<input type="text" name="accountList[0].money"><br>
    Second Account Name:<input type="text" name="accountList[1].name"><br>
    Second Account Money:<input type="text" name="accountList[1].money"><br>
    <input type="submit" name="List Save">
</form>
```
AccountController.java

1
2
3
4
5
@RequestMapping("/saveList")
private String saveList(User user) {
  System.out.println(user);
  return "success";
}
3.4.2 POJO 类中包含Map
Player.java

1
2
3
4
5
6
7
public class Player implements Serializable {
    private String username;
    private String password;
    private Integer age;
    private Map<String ,Account> accountMap;
  //此处省略getter/setter，toString
}
```jsp
<form action="${pageContext.request.contextPath}/account/saveMap" method="post">
    Name:<input type="text" name="username"><br>
    Password:<input type="password" name="password"><br>
    Age:<input type="text" name="age"><br>
    First Account Name:<input type="text" name="accountMap[0].name"><br>
    First Account Money:<input type="text" name="accountMap[0].money"><br>
    Second Account Name:<input type="text" name="accountMap[1].name"><br>
    Second Account Money:<input type="text" name="accountMap[1].money"><br>
    <input type="submit" name="Map Save">
</form>
```
AccountController.java

1
2
3
4
5
@RequestMapping("/saveMap")
private String saveMap(Player player) {
  System.out.println(player);
  return "success";
}
3.5 小结
请求参数类型是简单(基本,String)类型

方法的形参和请求参数的name一致就可以
请求参数类型是pojo对象类型

形参就写pojo对象
pojo的属性必须和请求参数的name一致就可以
请求参数类型是pojo对象类型, 包含集合

形参就写pojo对象
pojo的属性必须和请求参数的name一致就可以
如果包含List, list的属性名[下标].pojo属性名
如果包含map, map的属性名[key].pojo属性名
提交数组，只能用数组接收，多个参数的参数名一致，参数要与controller中的参数名一致

注意：

严格区分大小写

不能直接提交List与map集合, 需要通过其它方式转换(fastjson)

3.6 请求参数细节和特殊情况
3.6.1 目标
乱码处理和自定义类型转换器

3.6.2 路径
请求参数乱码处理
自定义类型转换器
使用 ServletAPI 对象作为方法参数
3.6.3 讲解
3.6.3.1 请求参数乱码处理
在web.xml里面配置编码过滤器

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
<!-- 配置spring提供的字符集过滤器 -->
	<filter>
        <filter-name>CharacterEncodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
		<!-- 配置初始化参数，指定字符集 -->
        <init-param>[]
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
        <!-- 强制使用 -->
        <init-param>
            <param-name>forceEncoding</param-name>
            <param-value>true</param-value>
        </init-param>
	</filter>
	<filter-mapping>
		<filter-name>CharacterEncodingFilter</filter-name>
		<url-pattern>/*</url-pattern>
	</filter-mapping>
3.6.3.2 自定义类型转换器
默认情况下,SpringMVC已经实现一些数据类型自动转换。 内置转换器全都在： org.springframework.core.convert.support包下 ,如遇特殊类型转换要求，需要我们自己编写自定义类型转换器。

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
java.lang.Boolean -> java.lang.String : ObjectToStringConverter
java.lang.Character -> java.lang.Number : CharacterToNumberFactory
java.lang.Character -> java.lang.String : ObjectToStringConverter
java.lang.Enum -> java.lang.String : EnumToStringConverter
java.lang.Number -> java.lang.Character : NumberToCharacterConverter
java.lang.Number -> java.lang.Number : NumberToNumberConverterFactory
java.lang.Number -> java.lang.String : ObjectToStringConverter
java.lang.String -> java.lang.Boolean : StringToBooleanConverter
java.lang.String -> java.lang.Character : StringToCharacterConverter
java.lang.String -> java.lang.Enum : StringToEnumConverterFactory
java.lang.String -> java.lang.Number : StringToNumberConverterFactory
java.lang.String -> java.util.Locale : StringToLocaleConverter
java.lang.String -> java.util.Properties : StringToPropertiesConverter
java.lang.String -> java.util.UUID : StringToUUIDConverter
java.util.Locale -> java.lang.String : ObjectToStringConverter
java.util.Properties -> java.lang.String : PropertiesToStringConverter
java.util.UUID -> java.lang.String : ObjectToStringConverter
 ....
3.6.3.3 场景
jsp

1
<a href="${pageContext.request.contextPath}/account/BirthDate?date=1900-01-01">Convert Date</a><br>
AccountController.java(错误页面400)

1
2
3
4
5
@RequestMapping("/BirthDate")
public String BirthDate(Date date) {
  System.out.println(date);
  return "success";
}
需自定义类型转换器

步骤

创建一个类实现Converter 接口

配置类型转换器

实现

定义一个类，实现 Converter 接口

该接口有两个泛型,,S:表示接受的类型， T：表示目标类型(需要转的类型)

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
public class StringToDateConverter implements Converter<String,Date> {
  @Nullable
  @Override
  public Date convert(String s) {
    try {
      if(StringUtils.isEmpty(s)){
        throw  new RuntimeException("字符串不能为null");
      }
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
      return dateFormat.parse(s);
    } catch (ParseException e) {
      e.printStackTrace();
      return  null;
    }
  }
在springmvc.xml里面配置转换器

spring 配置类型转换器的机制是，将自定义的转换器注册到类型转换服务中去

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
<!-- 配置类型转换器 -->
<bean id="conversionService" class="org.springframework.context.support.ConversionServiceFactoryBean">
  <!-- 给工厂注入一个新的类型转换器 -->
  <property name="converters">
    <set>
      <!-- 配置自定义类型转换器 -->
      <bean class="com.test.converter.StringToDateConverter"/>
    </set>
  </property>
</bean>
在 annotation-driven 标签中引用配置的类型转换服务

1
2
<!--配置Spring开启mvc注解-->
<mvc:annotation-driven conversion-service="conversionService"/>
3.6.3.4 使用 ServletAPI 对象作为方法参数
SpringMVC 还支持使用原始 ServletAPI 对象作为控制器方法的参数。我们可以把它们直接写在控制的方法参数中使用。

支持原始 ServletAPI 对象
HttpServletRequest
HttpServletResponse
HttpSession
java.security.Principal
Locale
InputStream
OutputStream
Reader
Writer


```jsp
<a href="${pageContext.request.contextPath}/account/testServletAPI?name=AAA">testServletAPI</a>
```
AccountController.java

1
2
3
4
5
6
7
@RequestMapping("/testServletAPI")
public String testServletAPI(HttpServletRequest req,HttpServletResponse resp,HttpSession session) {
    System.out.println(req);
    System.out.println(resp);
    System.out.println(session);
    return "success";
}
3.6.3.5 小结
处理post乱码 直接在web.xml 配置编码过滤器 characterEncodingFilter /*

类型转换器

创建一个类实现Converter <Src, target>
在springmvc.xml进行配置 conversionService
ServletApi方式

直接方法的形参里面绑定requet, response. session…
使用属性注入
3.7 知识点-常用注解
3.7.1 目标
常用注解

3.7.2 路径
@RequestParam

@RequestBody

@PathVariable

@RequestHeader

@CookieValue

3.7.3 讲解
3.7.3.1 RequestParam
3.7.3.1.1 使用说明
作用：

把请求中指定名称的参数给控制器中的形参赋值。

属性

value： 请求参数中的名称。
required：请求参数中是否必须提供此参数。 默认值： true。表示必须提供，如果不提供将报错。

defaultValue:默认值

使用场景：form提交，url参数使用的是 ? 方式来提交请求
3.7.3.1.2 使用实例
页面
```jsp
<form action="${pageContext.request.contextPath}/user/testRequestParam">
    Name:<input type="text" name="username">
    <input type="submit" value="testRequestParam">
</form>
```
UserController.java

1
2
3
4
5
@RequestMapping("/testRequestParam")
public String testRequestParam(@RequestParam(value = "username", required = true, defaultValue = "一") String username) {
  System.out.println(username);
  return "success";
}
3.7.3.2 RequestBody
请求体: post方式的请求参数,get方式没有请求体

Get和Post区别

get方式 请求参数拼接在请求路径后面, post 方式 请求参数在请求体里面
get方式 请求参数浏览器地址栏可见, post 方式 请求参数浏览器地址栏不可见
get方式 请求参数大小有限制的, post 方式请求参数大小没有限制的
3.7.3.2.1使用说明
作用

1.用于获取请求体内容。 直接使用得到是 key=value&key=value…结构的字符串。

2.把获得json类型的数据转成pojo对象(后面再讲)【推荐】

注意: get 请求方式不适用。

属性

required：是否必须有请求体。默认值是:true。当取值为 true 时,get 请求方式会报错。如果取值为 false， get 请求得到是 null。

@RequestBody 不能使用get请求, 在Controller的方法参数里，有且只有一个
3.7.3.2.2使用实例

```jsp
<form action="${pageContext.request.contextPath}/user/testRequestBody" method="post">
  Name:<input type="text" name="username"><br>
  Password:<input type="password" name="password"><br>
  <input type="submit" value="testRequestBody">
</form>
```
UserController.java

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
@RequestMapping(value = "/testRequestBody", produces = "application/xml; charset=utf-8")
public String testRequestBody(@RequestBody String queryStr) {
  try {
    //返回json格式，中途会转化成欧码，需要转换
    String a = URLDecoder.decode(queryStr, "UTF-8");
    System.out.println(a);

  } catch (UnsupportedEncodingException e) {
    e.printStackTrace();
  }
  return "success";
}
3.7.3.2.3 PathVariable
3.7.3.2.3.1 REST 风格 URL
REST（英文： Representational State Transfer，简称 REST）描述了一个架构样式的网络系统，比如 web 应用程序。它首次出现在 2000 年 Roy Fielding 的博士论文中，他是 HTTP 规范的主要编写者之一。在目前主流的三种 Web 服务交互方案中， REST 相比于 SOAP（Simple Object Access protocol，简单对象访问协议）以及 XML-RPC 更加简单明了，无论是对 URL 的处理还是对 Payload 的编码， REST 都倾向于用更加简单轻量的方法设计和实现。值得注意的是 REST 并没有一个明确的标准，而更像是一种设计的风格。它本身并没有什么实用性，其核心价值在于如何设计出符合 REST 风格的网络接口。

restful 的优点

它结构清晰、符合标准、易于理解、 扩展方便，所以正得到越来越多网站的采用。

restful 的特性：

 资源（Resources） ： 网络上的一个实体，或者说是网络上的一个具体信息。它可以是一段文本、一张图片、一首歌曲、一种服务，总之就是一个具体的存在。可以用一个 URI（统一资源定位符）指向它，每种资源对应一个特定的 URI 。要获取这个资源，访问它的 URI 就可以，因此 URI 即为每一个资源的独一无二的识别符。表现层（Representation） ： 把资源具体呈现出来的形式，叫做它的表现层 （Representation）。比如，文本可以用 txt 格式表现，也可以用 HTML 格式、 XML 格式、 JSON 格式表现，甚至可以采用二进制格式。状态转化（State Transfer） ： 每 发出一个请求，就代表了客户端和服务器的一次交互过程。HTTP 协议，是一个无状态协议，即所有的状态都保存在服务器端。因此，如果客户端想要操作服务器，必须通过某种手段， 让服务器端发生“ 状态转化” （State Transfer）。而这种转化是建立在表现层之上的，所以就是 “ 表现层状态转化” 。具体说，就是 HTTP 协议里面，四个表示操作方式的动词： GET 、 POST 、 PUT、DELETE。它们分别对应四种基本操作： GET 用来获取资源， POST 用来新建资源， PUT 用来更新资源， DELETE 用来删除资源 .

实例

保存(POST方式)
传统	http://localhost:8080/user/save
REST	http://localhost:8080/user
执行保存 添加资源
不安全且不幂等(执行多次)
更新(PUT方式,requestBody更新的内容)
传统	http://localhost:8080/user/update?id=1
REST	http://localhost:8080/user/1
执行更新 1代表id
不安全，幂(多少次方)等
删除(DELETE方式)
传统	http://localhost:8080/user/delete?id=1
REST	http://localhost:8080/user/1
执行删除 1代表id
不安全，幂(多少次方)等
查询(GET方式)
传统	http://localhost:8080/user/findAll
REST	http://localhost:8080/user
GET方式 查所有
安全，幂(多少次方)等
传统	http://localhost:8080/user/findById?id=1
REST	http://localhost:8080/user/1
GET方式 根据id查1个
安全，幂(多少次方)等
3.7.3.2.3.2 使用说明
作用：

用于绑定 url 中的占位符。 例如：请求 url 中 /delete/{id}， 这个{id}就是 url 占位符。
url 支持占位符是 spring3.0 之后加入的。是 springmvc 支持 rest 风格 URL 的一个重要标志。

属性：

value： 用于指定 url 中占位符名称。
required：是否必须提供占位符。

场景：获取路径中的参数
3.7.3.2.3.3 使用实例
jsp

1
<a href="${pageContext.request.contextPath}/user/testPathVaribale/1">testPathVaribale</a>
UserController.java

1
2
3
4
5
@RequestMapping("testPathVaribale/{id}")
public String testPathVaribale(@PathVariable(value = "id") Integer id) {
  System.out.println(id);
  return "success";
}
3.7.3.2.3.4 RequestHeader
3.7.3.2.3.4.1 使用说明
作用：
用于获取请求消息头。
属性：
value：提供消息头名称
required：是否必须有此消息头
从请求头中获取参数，鉴权(token 畅购open auth 2.0 jwt token) Authorization
3.7.3.2.3.4.2 使用实例

```jsp
<a href="${pageContext.request.contextPath}/user/testRequestHeader">testRequestHeader</a>
UserController.java
```
1
2
3
4
5
6
@RequestMapping("/testRequestHeader")
public String testRequestHeader(@RequestHeader(value = "User-Agent") String requestHeader) {

  System.out.println(requestHeader);
  return "success";
}
3.7.3.2.3.5 CookieValue
3.7.3.2.3.5.1 使用说明
作用：

用于把指定 cookie 名称的值传入控制器方法参数。

属性：

value：指定 cookie 的名称。
required：是否必须有此 cookie。

3.7.3.2.3.5.2 使用实例
jsp

```jsp
<a href="${pageContext.request.contextPath}/user/testCookieValue">testCookieValue</a>
```
UserController.java

1
2
3
4
5
@RequestMapping("/testCookieValue")
public String testCookieValue(@CookieValue(value = "JSESSIONID") String sessionId){
  System.out.println(sessionId);
  return "success";
}
3.7.3.2.3.6 ModelAttribute
3.7.3.2.3.6.1 使用说明
作用：

 该注解是 SpringMVC4.3 版本以后新加入的。它可以用于修饰方法和参数。

 出现在方法上，表示当前方法会在控制器的方法执行之前，先执行。它可以修饰没有返回值的方法，也可以修饰有具体返回值的方法。

 出现在参数上，获取指定的数据给参数赋值。

属性：
value：用于获取数据的 key。 key 可以是 POJO 的属性名称，也可以是 map 结构的 key。

应用场景：
当表单提交数据不是完整的实体类数据时，保证没有提交数据的字段使用数据库对象原来的数据。
例如：
​ 我们在编辑一个用户时，用户有一个创建信息字段，该字段的值是不允许被修改的。在提交表单数
​据是肯定没有此字段的内容，一旦更新会把该字段内容置为 null，此时就可以使用此注解解决问题。

3.7.3.2.3.6.2 使用实例
jsp

```jsp
<form action="${pageContext.request.contextPath}/user/testModelAttributeMethod" method="post">
    Name:<input type="text" name="username"/><br/>
    Password:<input type="text" name="password"/><br/>
    <input type="submit" value="testModelAttribute"/>
</form>

<form action="${pageContext.request.contextPath}/user/testModelAttributeArgs" method="post">
    Name:<input type="text" name="username"/><br/>
    Password:<input type="text" name="password"/><br/>
    <input type="submit" value="testModelAttribute"/>
</form>
```
实体类

1
2
3
4
5
6
public class User {
  private String username;
  private String password;
  private String gender;
  //此处省略getter/setter，toString
}
UserController.java(用在方法上面)

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
@RequestMapping("/testModelAttribute")
public String  testModelAttribute(User user){
    System.out.println("testModelAttribute ...收到了请求..."+user);
    return  "success";
}

@ModelAttribute
public User  getModel(String username,String password){
    System.out.println("getModel ...收到了请求...");
    //模拟查询数据库, 把性别也查询出来
    User user = new User();
    user.setUsername(username);
    user.setUsername(password);
    // 在前端的form表单中不要有这个字段，不要提交这个参数，<input disabled>
    // 如果提交了这个参数，则以提交的为主
    user.setGender("男");
    return  user;
}
UserController.java(用在参数上面)

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
   @RequestMapping("/testModelAttribute")
   public String  testModelAttribute(@ModelAttribute("u") User user){
       System.out.println("testModelAttribute ...收到了请求..."+user);
       return  "success";
   }

   @ModelAttribute
//没有返回值
   public void  getModel(String username, String password, Map<String,User> map){
       System.out.println("getModel ...收到了请求...");
       //模拟查询数据库, 把性别也查询出来
       User user = new User();
       user.setUsername(username);
       user.setUsername(password);
       user.setGender("男");
       map.put("u",user);
   }
3.7.3.2.3.7 SessionAttributes
3.7.3.2.3.7.1 使用说明

作用：

用于多次执行(多次请求)控制器方法间的参数共享。(该注解定义在类上)

属性：
value：用于指定存入的属性名称
type：用于指定存入的数据类型。

3.7.3.2.3.7.2 使用实例
```jsp
<form action="${pageContext.request.contextPath}/sessionController/setAttribute" method="post">
  <input type="text" name="name"><br>
  <input type="text" name="age"><br>
  <input type="submit" value="setAttribute">
</form>
<a href="${pageContext.request.contextPath}/sessionController/getAttribute">Get SessionAttribute</a><br/>
<a href="${pageContext.request.contextPath}/sessionController/removeAttribute">Empty SessionAttribute</a><br/>
```
SessionController.java

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
@Controller
@RequestMapping("/sessionController")
@SessionAttributes(value = {"name", "age"})
public class SessionController {
  @RequestMapping("/setAttribute")
  public String setAttribute(String name, int age, Model model) {
    model.addAttribute("name", name);
    model.addAttribute("age", age);
    return "success";

  }

  @RequestMapping("/getAttribute")
  public String getAttribute(ModelMap modelMap) {
    System.out.println(modelMap.get("name"));
    System.out.println(modelMap.get("age"));
    return "success";

  }

  @RequestMapping("/removeAttribute")
  public String removeAttribute(SessionStatus sessionStatus) {
    sessionStatus.setComplete();
    return "success";
  }
}
四.响应数据和结果视图
知识点-返回值分类
4.1 目标
Controller的返回值使用

4.2 路径
字符串
void
ModelAndView
4.3 讲解
4.3.1 字符串
controller 方法返回字符串可以指定逻辑视图名，通过视图解析器解析为物理视图地址。

jsp

1
<a href="${pageContext.request.contextPath}/response/testReturnString">String Return Value</a>
Controller

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
@RequestMapping("/response")
public class ResponseController {

  //指定逻辑视图名，经过视图解析器解析为 jsp 物理路径： /WEB-INF/pages/success.jsp
  @RequestMapping("/testReturnString")
  public String testReturnString(){
    System.out.println("testReturnString");
    return "success";
  }
}
4.3.2 void
控制器方法返回值是void时:

 如果控制器方法的参数中没有response对象

 它的视图是以方法是RequestMapping的取值作为视图名称

 如果类上也有RequestMapping，则类上的RequestMapping是其中的1级路径

 如果控制器方法的参数中有response对象

 则默认前往的jsp页面上无法显示内容

```jsp
<a href="${pageContext.request.contextPath}/response/testReturnVoid">void Return Value</a>

<a href="${pageContext.request.contextPath}/response/testReturnVoidWithReturnValue">void Return Value</a>
```
Controller

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
@RequestMapping("/testReturnVoid")
public void testReturnVoid(){
    System.out.println("testReturnVoid");
}

@RequestMapping("/testReturnVoidWithReturnValue")
public void testReturnVoidWithReturnValue(HttpServletRequest req, HttpServletResponse resp){
    System.out.println("testReturnVoidWithReturnValue");
    try {
        resp.sendRedirect("http://www.baidu.com");
    } catch (IOException e) {
        e.printStackTrace();
    }
}
4.3.3 ModelAndView
ModelAndView 是 SpringMVC 为我们提供的一个对象，该对象也可以用作控制器方法的返回值。

jsp

1
<a href="${pageContext.request.contextPath}/response/testReturnModelAndView">testReturnModelAndView</a>
Controller

1
2
3
4
5
6
7
8
@RequestMapping("/testReturnModelAndView")
public ModelAndView testReturnModelAndView(){
    ModelAndView modelAndView = new ModelAndView();
    modelAndView.addObject("name","a");
    modelAndView.addObject("age",18);
    modelAndView.setViewName("success");
    return modelAndView;
}
4.3.4 小结
返回String. 返回值是逻辑视图, 通过视图解析器拼接成物理视图

返回void

返回ModelAndView

设置数据 向request存
设置视图 逻辑视图
方法参数中使用Model 携带数据到jsp中，替换ModelAndView

4.4 知识点-转发和重定向
4.4.1 目标
Controller中的转发和重定向使用

4.4.2 路径
forward 转发
Redirect 重定向
4.4.3 讲解
4.4.3.1 forward 转发
​ controller 方法在提供了 String 类型的返回值之后，默认就是请求转发。我们也可以加上 forward: 可以转发到页面,也可以转发到其它的controller方法

转发到页面

 需要注意的是，如果用了 formward： 则路径必须写成实际视图 url，不能写逻辑视图。它相当于“request.getRequestDispatcher(“url”).forward(request,response)”

```jsp
<a href="${pageContext.request.contextPath}/forwardToPage">forwardToPage</a><br>
<a 
```

@Controller
public class RedirectController {

  //转发到页面
  @RequestMapping("/forwardToPage")
  public String forwardToPage() {
    System.out.println("forwardToPage");
    return "forward:/WEB-INF/pages/success.jsp";
  }

}
转发到其它的controller方法

语法: forward:/类上的RequestMapping/方法上的RequestMapping

1
href="${pageContext.request.contextPath}/forwardToOtherController">forwardToOtherController</a>
1
2
3
4
5
6
//转发到其它controller
@RequestMapping("/forwardToOtherController")
public String forwardToOtherController() {
  System.out.println("forwardToOtherController");
  return "forward:/response/testReturnModelAndView";
}
4.4.3.2 Redirect 重定向
​ contrller 方法提供了一个 String 类型返回值之后， 它需要在返回值里使用: redirect: 同样可以重定向到页面,也可以重定向到其它controller

重定向到页面

 它相当于“response.sendRedirect(url)” 。需要注意的是，如果是重定向到 jsp 页面，则 jsp 页面不能写在 WEB-INF 目录中，否则无法找到。

```jsp
<a href="${pageContext.request.contextPath}/redirectToPage">redirectToPage</a><br>
```
1
2
3
4
5
6
//重定向到页面
@RequestMapping("/redirectToPage")
public String redirectToPage(){
  System.out.println("redirectToPage");
  return "redirect:/redirect.jsp";
}
重定向到其它的controller方法

语法: redirect:/类上的RequestMapping/方法上的RequestMapping

```jsp
<a href="${pageContext.request.contextPath}/redirectToOtherController">redirectToOtherController</a>
```
1
2
3
4
5
6
//重定向到其它Controller
@RequestMapping("/redirectToOtherController")
public String redirectToOtherController(){
  System.out.println("redirectToOtherController");
  return "redirect:/response/testReturnModelAndView";
}
4.4.4 小结
4.4.1 转发和重定向区别
转发是一次请求, 重定向是两次请求
转发路径不会变化, 重定向的路径会改变
转发只能转发到内部的资源,重定向可以重定向到内部的(当前项目里面的)也可以是外部的(项目以外的)
转发可以转发到WEB-INF里面的资源, 重定向不可以重定向到WEB-INF里面的资源
4.4.2 转发和重定向(返回String)
转发到页面

1
forward:/页面的路径
转发到Controller

1
forward:/类上面的RequestMapping/方法上面的RequestMapping
重定向到页面

1
redirect:/页面的路径
重定向到Controller

1
redirect:/类上面的RequestMapping/方法上面的RequestMapping
4.4.3 知识点-ResponseBody响应 json数据
4.4.3.1 目标
SpringMVC与json交互

4.4.3.2 路径
使用说明
使用示例
4.4.3.3 讲解
4.4.3.3.1 使用说明
​ 该注解用于将 Controller 的方法返回的对象，通过 HttpMessageConverter 接口转换为指定格式的数据如： json,xml 等，通过 Response 响应给客户端

4.4.3.3.2 使用示例
需求:

发送Ajax请求, 使用@ResponseBody 注解实现将 controller 方法返回对象转换为 json 响应给客户端

步骤:

导入jackson坐标

把什么对象转json, 方法返回值就定义什么类型

添加@ResponseBody注解

实现

在springmvc.xml里面设置过滤资源

DispatcherServlet会拦截到所有的资源(除了JSP)，导致一个问题就是静态资源（img、css、js）也会被拦截到，从而不能被使用。解决问题就是需要配置静态资源不进行拦截.

语法: <mvc:resources location="/css/" mapping="/css/**"/>, location:webapp目录下的包,mapping:匹配请求路径的格式

在springmvc.xml配置文件添加如下配置

1
2
3
4
<!-- 设置静态资源不过滤 -->
<mvc:resources location="/css/" mapping="/css/**"/>  <!-- 样式 -->
<mvc:resources location="/images/" mapping="/images/**"/>  <!-- 图片 -->
<mvc:resources location="/js/" mapping="/js/**"/>  <!-- javascript -->
页面

```jsp
<input type="button" id="BtnId" value="Ajax Request"><br>
<script>
    $(function () {
        $("#BtnId").click(function () {
            $.post("${pageContext.request.contextPath}/response/testJson",{username:"ABC",password:123},function (result) {
                alert("result="+result);
            },"json");
        });
    });
</script>
```
Springmvc 默认用 MappingJacksonHttpMessageConverter 对 json 数据进行转换，需要添加jackson依赖。

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
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.9.0</version>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-core</artifactId>
    <version>2.9.0</version>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-annotations</artifactId>
    <version>2.9.0</version>
</dependency>
java

1
2
3
4
5
6
@RequestMapping("/testJson")
public @ResponseBody User ResponseController(User user){
  System.out.println(user);
  user.setUsername("ABC");
  return user;
}
4.4.3.3.3 小结
4.4.3.3.3.1 实现步骤
添加jackson坐标
把什么对象转成json, controller中的方法的返回值就是什么类型
在方法上面或者方法的返回值前面添加@ResponseBody
4.4.3.3.3.2 注意事项
Dispacher的路径是/ , 除了jsp以外所有的资源都匹配, 要使用JQ 忽略静态资源
idea有时不会自动帮我们把新加内容打包到target目录下，这时需要手工删除target目录