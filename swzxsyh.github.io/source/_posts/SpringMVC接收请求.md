---
title: SpringMVC接收请求
date: 2020-06-04 01:44:49
tags:
---

一.SpringMVC的请求
搭建环境

建立新Moudle，配置pom.xml

```xml
<!--依赖管理-->  
<packaging>war</packaging>
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

</dependencies>
```

Web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://java.sun.com/xml/ns/javaee"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
         version="2.5">

  <!-- 前端控制器 -->
  <servlet>
    <servlet-name>DispatcherServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:spring-mvc.xml</param-value>
    </init-param>
  </servlet>

  <servlet-mapping>
    <servlet-name>DispatcherServlet</servlet-name>
    <url-pattern>/</url-pattern>
  </servlet-mapping>

</web-app>
```


spring-mvc.xml

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/mvc
                           http://www.springframework.org/schema/mvc/spring-mvc.xsd
                           http://www.springframework.org/schema/context
                           http://www.springframework.org/schema/context/spring-context.xsd">

  <!--开启注解组件扫描-->
  <context:component-scan base-package="com.test.web"/>
  <!--开启mvc注解支持-->
  <mvc:annotation-driven/>
  <!-- 视图解析器 -->
  <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="prefix" value="/WEB-INF/pages/"/>
    <property name="suffix" value=".jsp"/>
  </bean>

</beans>
```


1.1 请求参数
客户端请求参数的格式是: name=value&name=value

服务器要获取请求的参数，有时还需要进行数据的封装，SpringMVC可以接收如下类型的参数:

简单类型(基本类型\基本类型的包装类型\字符串)

index.jsp

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

  <head>
    <title>index</title>
  </head>

  <body>

    <h2>SpringMVC知识学习</h2>

    <a href="${pageContext.request.contextPath}/user/simpleParam?username=jack&age=18">
      simpleParam
    </a>
  </body>
</html>
```


UserController

```java
@Controller
@RequestMapping("/user")
public class UserController {

  @RequestMapping("/simpleParam")
  public String simpleParam(String username,Integer age){
    System.out.println(username);
    System.out.println(age);
    return "success";
  }

}
```


注意:前端页面的name属性名必须与方法中的形参名称一致，类型自定义

对象类型

User

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
  private String username;
  private Integer age;
}
```


index.jsp

```jsp
<form action="${pageContext.request.contextPath}/user/pojoParam" method="post">
  User: <input type="text" name="username"><br>
  Age: <input type="text" name="age"><br>
  <input type="submit" value="Object_Type">
</form>
```

UserController

```java
@RequestMapping("/pojoParam")
public String pojoParam(User user){
  System.out.println(user);
  return "success";
}
```


注意:表单元素的name属性必须与user实体的属性名一致

数组类型

应用场景:批量删除

index.jsp

```jsp
<form action="${pageContext.request.contextPath}/user/arrayParam" method="post">
    <input type="checkbox" name="ids" value="1">User A<br>
    <input type="checkbox" name="ids" value="2">User B<br>
    <input type="checkbox" name="ids" value="3">User C<br>
    <input type="checkbox" name="ids" value="4">User D<br>
    <input type="submit" value="Array Param">
</form>
```

UserController

```java
@RequestMapping("/arrayParam")
public String arrayParam(Integer[] ids){
  System.out.println(Arrays.toString(ids));
  return "success";
}
```


注意:复选框的name属性名必须与数组的变量名一致

集合(复杂)类型

如果提交的是一个集合的数据，springMVC的方法形参是无法接收的，必须要通过实体类进行包装才行

QueryVo

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class QueryVo {

    //Simple Type
    private String keyword;
    //Object Type
    private User user;
    //List Type
    private List<Object> list;
    //Map Type
    private Map<String, Object> map;

}
```


index.jsp

```jsp
<form action="${pageContext.request.contextPath}/user/queryVoParam" method="post">
  Search: <input type="text" name="keyword"><br>
  User: <input type="text" name="user.username" placeholder="User Name"><input type="text" name="user.age" placeholder="Age"><br>


  List Array:
  <%--
  list[0] == 第一个元素
  list[1] == 第二个元素
  --%>
  <input type="text" name="list[0]" placeholder="First Element">
  <input type="text" name="list[1]" placeholder="Second Element">
  <input type="text" name="list[2]" placeholder="Third Element"><br>


  Map Array:
  <%--
  map.put("key1",value);
  map.put("key2",value);
  --%>
  <input type="text" name="map[key1]" placeholder="Key1 Value">
  <input type="text" name="map[key2]" placeholder="Key2 Value"><br>
  <input type="submit" value="Complex Type">

</form>
```



UserController

```java
@RequestMapping("/queryVoParam")
public String queryVoParam(QueryVo queryVo){
    System.out.println(queryVo);
    return "success";
}
```


1.2 中文乱码过滤器
如果是get请求，tomcat8以上版本的服务器统一了UTF-8编码，所以我们不会出现乱码

如果是post请求，由于servlet规范当中post默认解码方式为ISO-8859-1，所以出现了中文乱码问题

spring框架提供了post请求中文过滤器

web.xml

```xml
<!--中文乱码过滤器-->
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
```


1.3 自定义类型转换器
自定义类型转换器

此处应用场景:日期格式

yyyy-MM-dd 框架无法识别，报400错误，springMVC已支持自定义类型转换器的扩展

spring-mvc.xml

```xml
<!--开启mvc注解支持-->
<mvc:annotation-driven conversion-service="conversionService"/>

<!-- 扩展自定义类型转换器 -->
<bean id="conversionService" class="org.springframework.context.support.ConversionServiceFactoryBean">
    <property name="converters">
        <set>
            <bean class="com.test.web.convert.DateConverter"></bean>
        </set>
    </property>
</bean>
```


index.jsp

```jsp
<form action="${pageContext.request.contextPath}/user/dateParam" method="post">
    Birthday: <input type="text" name="birthday">(日期格式:yyyy-MM-dd)<br>
    <input type="submit" value="Date Submit">
</form>
```



UserController

```java
// 接收日期类型
@RequestMapping("/dateParam")
public String dateParam(Date birthday){
  SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
  System.out.println(simpleDateFormat.format(birthday));
  return "success";
}
```


注解方案

删除web.xml添加的配置

```xml
<!--开启注解组件扫描-->
<context:component-scan base-package="com.test.web"/>
<!--开启mvc注解支持-->
<mvc:annotation-driven />

<!-- 扩展自定义类型转换器 -->

<!--    <bean id="conversionService" class="org.springframework.context.support.ConversionServiceFactoryBean">-->
<!--        <property name="converters">-->
<!--            <set>-->
<!--                <bean class="com.test.web.convert.DateConverter"></bean>-->
<!--            </set>-->
<!--        </property>-->
<!--    </bean>-->
```


UserController

```java
// 接收日期类型
@RequestMapping("/dateParam")
public String dateParam(@DateTimeFormat(pattern = "yyyy-MM-dd") Date birthday){
  SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
  System.out.println(simpleDateFormat.format(birthday));
  return "success";
}
```


1.4 相关注解
@RequestParam

应用场景:分页查询

index.jsp

```jsp
<a href="${pageContext.request.contextPath}/user/findByPage?pageNum=1&size=10">
    Page Query
</a>
```

UserController

```java
//分页查询
/*
@RequestParam 注解 常用属性
name/value:帮我们解决请求参数名和方法的变量名不一致问题
required: 默认值为true，要求前端必须提交参数和值
defaultValue:指定参数的默认值
*/
@RequestMapping("/findByPage")
public String findByPage(@RequestParam(name = "pageNum",defaultValue = "1") Integer currentPage,@RequestParam(name = "size",defaultValue = "10")Integer pageSize){
    System.out.println(currentPage);
    System.out.println(pageSize);
    return "success";
}
```


@RequestHeader

获取请求头，相当于:request.getHeader();

index.jsp

```jsp
<a href="${pageContext.request.contextPath}/user/requestHeader">Request Header</a>
```


UserController

```java
@RequestMapping("/requestHeader")
public String requestHeader(@RequestHeader("User-Agent") String userAgent,@RequestHeader("Cookie") String cookie){
  System.out.println(userAgent);
  System.out.println(cookie);
  return "success";
}
```


@CookieValue

专门获取指定cookie名称的值

index.jsp

```jsp
<a href="${pageContext.request.contextPath}/user/cookieValue">Cookie Value</a>
```

UserController

```java
@RequestMapping("/cookieValue")
private String cookieValue(@CookieValue("JSESSIONID") String jsessionid){
  System.out.println("JSESSIONID: "+jsessionid);
  return "success";
}
```


1.5 获取Servlet相关API
index.jsp

```jsp
<a href="${pageContext.request.contextPath}/user/servletAPI"> servletAPI</a>
```

UserController

```java
// servletAPI
@RequestMapping("/servletAPI")
public void servletAPI(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, HttpSession httpSession) throws Exception{
  String username = httpServletRequest.getParameter("username");
  System.out.println(username);
  httpServletRequest.getRequestDispatcher("/WEB-INF/pages/success.jsp").forward(httpServletRequest,httpServletResponse);
}
```


二.文件上传
需求分析

需求分析
一.文件上传三要素
Avatar: <input type="file" name="picFile">
⬇
二.SpringMVC集成文件上传组件
MultipartResolver多组件上传解析器
⬇
底层依赖file-upload环境
⬇
UserController
public String upload(String username, MultipartFile picFile)
2.1 文件上传三要素
表单的提交方式 method=”POST”
表单的enctype属性是多部分表单形式 enctype=“multipart/form-data”
表单项(元素)type=”file”

```jsp
<form action="" method="post" enctype="multipart/form-data">
  Name: <input type="text" name="username"><br>
  Avatar: <input type="file" name="picFile">
</form>
```



2.2 文件上传原理

2.3 springMVC实现文件上传
index.jsp

```jsp
<form action="${pageContext.request.contextPath}/user/upload" method="post" enctype="multipart/form-data">
  Name: <input type="text" name="username"><br>
  Avatar: <input type="file" name="picFile"><br>
  <input type="submit" value="File Upload">
</form>
```



添加依赖

```xml
<!--文件上传-->  
<dependency> 
  <groupId>commons-fileupload</groupId>  
  <artifactId>commons-fileupload</artifactId>  
  <version>1.4</version> 
</dependency> 
```


修改spring-mvc.xml

```xml
<!--
文件上传组件扩展
id="multipartResolver" 此id必须是这个名称
-->
<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
  <!--
    限定文件的大小
    单位是字节(B)
    限制大约在5MB左右
    -->
  <property name="maxUploadSize" value="512000"/>
</bean>
```

UserController

```java
// 文件上传
@RequestMapping("/upload")
public String upload(String username, MultipartFile picFile){
  System.out.println("Basic"+username);
  System.out.println("File"+picFile);
  System.out.println("File Name"+picFile.getOriginalFilename());

  try {
    picFile.transferTo(new File("/Users/swzxsyh/Downloads/"+picFile.getOriginalFilename()));
  } catch (IOException e) {
    e.printStackTrace();
  }
  return "success";
}
```

三 静态资源访问的开启
问题

webapp路径下创建img文件夹，添加1.png图片，但是访问404

1
<a href="${pageContext.request.contextPath}/img/1.png">Static Resources</a>
解释

在SpringMVC的前端控制器DispatcherServlet的url-pattern配置的是 /(缺省),代表除了jsp请求不拦截, 其他的所有请求都会拦截，包括一些静态文件(html、css、js)等, 而拦截住之后,它又找不到对应的处理器方法来处理, 因此报错.





3.1 方式一
手动配置springMVC框架的静态资源映射

http://localhost:8080/项目名/img
⬇
配置<mvc:resources mapping=”/img/**” location=”/img/“/>
⬇
查找到src/main/webapp/img/1.png
spring-mvc.xml

```xml
<!--
    静态资源手动映射
    mapping="/img/**" 浏览器发送请求
    location="/img/" 静态资源的路径
    -->
<mvc:resources mapping="/img/**" location="/img/"/>
```

问题

不同静态资源目录，都需要映射一次，重复代码过多

3.2 方式二
spring-mvc.xml添加如下配置即可

```xml
<!--配置tomcat默认的静态资源处理-->
<mvc:default-servlet-handler/>
```



3.3 方式三
方式二可优化处

web.xml中url-pattern相当于覆盖tomcat本身规则，可以创建自身规则进行拦截

注释spring-mvc.xml内容

```xml
<!--    
  静态资源手动映射
    mapping="/img/**" 浏览器发送请求
    location="/img/" 静态资源的路径
    -->
<!--    <mvc:resources mapping="/img/**" location="/img/"/>-->

<!--配置tomcat默认的静态资源处理-->

<!--    <mvc:default-servlet-handler/>-->
```


配置web.xml

```xml
<!-- 前端控制器 -->
<servlet>
  <servlet-name>DispatcherServlet</servlet-name>
  <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
  <init-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>classpath:spring-mvc.xml</param-value>
  </init-param>
</servlet>

<!--
    自定义一个不会与默认的tomcat冲突的拦截规则
    配置：*.do  *.action 之后
    什么情况下才会被sprignMVC框架所拦截
    浏览器访问的资源需要加上：/user/quick.do
    所以静态  1.png  a.html 这些就不会被springMVC框架拦截，就不会出现404问题
-->
<servlet-mapping>
  <servlet-name>DispatcherServlet</servlet-name>
  <url-pattern>*.do</url-pattern>
</servlet-mapping>
```


