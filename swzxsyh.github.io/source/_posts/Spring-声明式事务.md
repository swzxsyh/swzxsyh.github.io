---
title: Spring 声明式事务
date: 2020-06-03 01:44:21
tags:
---

一.Spring的事务
Spring的事务控制可以分为编程式事务控制和声明式事务控制。

编程式事务

就是将业务代码和事务代码放在一起书写,它的耦合性太高,开发中不使用

声明式事务

其实就是将事务代码和业务代码隔离开发, 然后通过一段配置让他们组装运行, 最后达到事务控制的目的.

声明式事务就是通过AOP原理实现的.

1.1 Spring声明式事务
在 Spring 配置文件中声明式的处理事务来代替代码式的处理事务。底层采用AOP思想来实现的

1.1.1 思想
目标对象:AccountServiceImpl
通知对象:DataSourceTransactionManager
配置切面:xml、注解
1.1.2 环境搭建
创建java模块

导入jar包

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
<!--依赖管理-->
<dependencies>
    <!--mysql驱动-->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>5.1.47</version>
    </dependency>
    <!--druid连接池-->
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>druid</artifactId>
        <version>1.1.15</version>
    </dependency>
    <!--spring-jdbc-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-jdbc</artifactId>
        <version>5.1.5.RELEASE</version>
    </dependency>
    <!--spring核心-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>5.1.5.RELEASE</version>
    </dependency>
    <!--junit-->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
    </dependency>
    <!--spring整合junit-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-test</artifactId>
        <version>5.1.5.RELEASE</version>
    </dependency>
    <!--spring的orm-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-orm</artifactId>
        <version>5.1.5.RELEASE</version>
    </dependency>
    <!--aspectj-->
    <dependency>
        <groupId>org.aspectj</groupId>
        <artifactId>aspectjweaver</artifactId>
        <version>1.9.5</version>
    </dependency>
</dependencies>
编写AccountDao

1
2
3
4
5
public interface AccountDao {
    void outUser(String outUser, Double money);

    void inUser(String inUser, Double money);
}
编写AccountDaoImpl

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
public class AccountDaoImpl implements AccountDao {

    private JdbcTemplate jdbcTemplate;

    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void outUser(String outUser, Double money) {
        String sql = "UPDATE account SET money = money - ? WHERE name  = ?";
        jdbcTemplate.update(sql, money, outUser);

    }

    @Override
    public void inUser(String inUser, Double money) {
        String sql = "UPDATE account SET money = money + ? WHERE name  = ?";
        jdbcTemplate.update(sql, money, inUser);
    }
}
编写AccountService

1
2
3
public interface AccountService {
    void transfer(String outUser,String inUser,Double money);
}
编写AccountServiceImpl

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
public class AccountServiceImpl implements AccountService {

    private AccountDao accountDao;

    public void setAccountDao(AccountDao accountDao) {
        this.accountDao = accountDao;
    }

    @Override
    public void transfer(String outUser, String inUser, Double money) {
        accountDao.outUser(outUser,money);
        accountDao.inUser(inUser,money);
    }
}
编写spring的配置文件

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
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation=" http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd">

    <!--加载第三方配置文件-->
    <context:property-placeholder location="classpath:jdbc.properties"/>

    <!--druid交给ioc-->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="${jdbc.driver}"/>
        <property name="url" value="${jdbc.url}"/>
        <property name="username" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>
    </bean>

    <!--jdbcTemplate交给ioc-->
    <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
        <constructor-arg name="dataSource" ref="dataSource"/>
    </bean>

    <!--dao交给ioc-->
    <bean id="accountDao" class="com.test.dao.impl.AccountDaoImpl">
        <property name="jdbcTemplate" ref="jdbcTemplate"/>
    </bean>

    <!--将service交给ioc-->
    <bean id="accountService" class="com.test.service.impl.AccountServiceImpl">
        <property name="accountDao" ref="accountDao"/>
    </bean>

    <!--事务管理器交给ioc-->
    <bean id="transactionManager"  class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>
</beans>
测试

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
@RunWith(SpringRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class AccountServiceTest {

    @Autowired
    private AccountService accountService;

    @Test
    public void test() throws Exception{
        accountService.transfer("tom","jerry",100d);
    }
}
1.1.3 XML配置
配置xml事务aop

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
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation=" http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd
        http://www.springframework.org/schema/tx
        http://www.springframework.org/schema/tx/spring-tx.xsd">

    <!--加载第三方配置文件-->
    <context:property-placeholder location="classpath:jdbc.properties"/>

    <!--druid交给ioc-->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="${jdbc.driver}"/>
        <property name="url" value="${jdbc.url}"/>
        <property name="username" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>
    </bean>

    <!--jdbcTemplate交给ioc-->
    <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
        <constructor-arg name="dataSource" ref="dataSource"/>
    </bean>

    <!--dao交给ioc-->
    <bean id="accountDao" class="com.test.dao.impl.AccountDaoImpl">
        <property name="jdbcTemplate" ref="jdbcTemplate"/>
    </bean>

    <!--将service交给ioc-->
    <bean id="accountService" class="com.test.service.impl.AccountServiceImpl">
        <property name="accountDao" ref="accountDao"/>
    </bean>

    <!--事务管理器交给ioc-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>

    <!--将事务管理器升级为事务通知类-->
  <tx:advice id="txAdvice" transaction-manager="transactionManager">
    <tx:attributes>
      <tx:method name="*" />
    </tx:attributes>
  </tx:advice>
  
  <!--aop配置-->
  <aop:config>
    <!-- 仅spring的事务切面配置使用此标签
            通知+切点=切面
        -->
    <aop:advisor advice-ref="txAdvice" pointcut="execution(* com.test.service..*.*(..))"/>
  </aop:config>
</beans>
测试

事务通知类细节补充

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
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation=" http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd
        http://www.springframework.org/schema/tx
        http://www.springframework.org/schema/tx/spring-tx.xsd">

    <!--加载第三方配置文件-->
    <context:property-placeholder location="classpath:jdbc.properties"/>

    <!--druid交给ioc-->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="${jdbc.driver}"/>
        <property name="url" value="${jdbc.url}"/>
        <property name="username" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>
    </bean>

    <!--jdbcTemplate交给ioc-->
    <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
        <constructor-arg name="dataSource" ref="dataSource"/>
    </bean>

    <!--dao交给ioc-->
    <bean id="accountDao" class="com.test.dao.impl.AccountDaoImpl">
        <property name="jdbcTemplate" ref="jdbcTemplate"/>
    </bean>

    <!--将service交给ioc-->
    <bean id="accountService" class="com.test.service.impl.AccountServiceImpl">
        <property name="accountDao" ref="accountDao"/>
    </bean>

    <!--事务管理器交给ioc-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>

    <!--将事务管理器升级为事务通知类-->
  <tx:advice id="txAdvice" transaction-manager="transactionManager">
    <tx:attributes>
      <tx:method name="save*" isolation="DEFAULT" propagation="REQUIRED" read-only="false" timeout="-1"/>
      <tx:method name="update*" isolation="DEFAULT" propagation="REQUIRED" read-only="false" timeout="-1"/>
      <tx:method name="delete*" isolation="DEFAULT" propagation="REQUIRED" read-only="false" timeout="-1"/>
      <tx:method name="find*" propagation="SUPPORTS" read-only="false"/>
      <tx:method name="*" isolation="DEFAULT" propagation="REQUIRED" read-only="false" timeout="-1"/>
    </tx:attributes>
  </tx:advice>

    <!--
    定义事务管理器信息 DefaultTransactionDefinition
    可以控制指定的方法，设置事务隔离级别、传播行为、是否只读、是否超时
    name="transfer" 需要控制事务的方法名
    isolation="DEFAULT" 设置当前方法的事务隔离界别，mysql默认级别:repeatable_read
    propagation="REQUIRED" 设置当前方法的事务传播行为 ，REQUIRED:当前方法 必须有一个事务(单独使用开启，别人调用加入对方事务)
    read-only="false" 当前方式为非只读(增删改用的)
    timeout="-1" 事务超时时间，-1:永不超时
    -->

  <!--aop配置-->
  <aop:config>
    <!-- 仅spring的事务切面配置使用此标签
            通知+切点=切面
        -->
    <aop:advisor advice-ref="txAdvice" pointcut="execution(* com.test.service..*.*(..))"/>
  </aop:config>
</beans>
1.1.4 ANNO配置
复制java模块

删除事务的xml配置&&开启tx的注解支持

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
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation=" http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd
        http://www.springframework.org/schema/tx
        http://www.springframework.org/schema/tx/spring-tx.xsd">

    <!--加载第三方配置文件-->
    <context:property-placeholder location="classpath:jdbc.properties"/>

    <!--druid交给ioc-->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="${jdbc.driver}"/>
        <property name="url" value="${jdbc.url}"/>
        <property name="username" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>
    </bean>

    <!--jdbcTemplate交给ioc-->
    <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
        <constructor-arg name="dataSource" ref="dataSource"/>
    </bean>

    <!--dao交给ioc-->
    <bean id="accountDao" class="com.test.dao.impl.AccountDaoImpl">
        <property name="jdbcTemplate" ref="jdbcTemplate"/>
    </bean>

    <!--将service交给ioc-->
    <bean id="accountService" class="com.test.service.impl.AccountServiceImpl">
        <property name="accountDao" ref="accountDao"/>
    </bean>

    <!--事务管理器交给ioc-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>

    <!-- 开启tx事务注解支持 -->
    <tx:annotation-driven/>
</beans>
在目标对象的上，使用事务注解

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
public class AccountServiceImpl implements AccountService {

    private AccountDao accountDao;

    public void setAccountDao(AccountDao accountDao) {
        this.accountDao = accountDao;
    }

    @Override
    @Transactional    //此方法被事务控制
    public void transfer(String outUser, String inUser, Double money) {
        accountDao.outUser(outUser,money);
//        int i = 1/0;
        accountDao.inUser(inUser,money);
    }
}
测试

注解事务细节补充(使用就近原则)

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
@Transactional //当前类所有方法被事务控制
public class AccountServiceImpl implements AccountService {

    private AccountDao accountDao;

    public void setAccountDao(AccountDao accountDao) {
        this.accountDao = accountDao;
    }

    @Override
    //此方法被事务控制，配置单独参数,方法控制就近原则
    @Transactional(isolation = Isolation.DEFAULT,propagation = Propagation.REQUIRED,readOnly = false,timeout = -1)
    public void transfer(String outUser, String inUser, Double money) {
        accountDao.outUser(outUser,money);
//        int i = 1/0;
        accountDao.inUser(inUser,money);
    }
}
二.Spring集成Web环境
2.1 Web环境搭建
创建Maven模块，JBLJavatoweb变更为web模块，添加Tomcat支持，配置pom.xml

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
<!--依赖管理-->
<dependencies>
  <!--spring-jdbc-->
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>5.1.5.RELEASE</version>
  </dependency>
  <!--spring核心-->
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.1.5.RELEASE</version>
  </dependency>
  <dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>3.1.0</version>
    <scope>provided</scope>
  </dependency>
  <dependency>
    <groupId>javax.servlet.jsp</groupId>
    <artifactId>jsp-api</artifactId>
    <version>2.2</version>
    <scope>provided</scope>
  </dependency>
</dependencies>
UserDao

1
2
3
4
public interface UserDao {

    public void save();
}
UserDaoImpl

1
2
3
4
5
6
7
8
@Repository
public class UserDaoImpl implements UserDao {

    @Override
    public void save() {
        System.out.println("Saved!");
    }
}
UserServic

1
2
3
4
public interface UserService {

    public void save();
}
UserServiceImpl

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
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public void save() {
        userDao.save();
    }
}
UserServlet

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
@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 获取spring容器的上下文对象
        ClassPathXmlApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
        // 调用service，实现保存功能
        UserService userService = app.getBean(UserService.class);
        userService.save();
    }
}
applicationContext

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
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:p="http://www.springframework.org/schema/p"
       xsi:schemaLocation="
       	http://www.springframework.org/schema/beans
		http://www.springframework.org/schema/beans/spring-beans.xsd
       	http://www.springframework.org/schema/context
		http://www.springframework.org/schema/context/spring-context.xsd">


    <!--开启注解组件扫描-->
    <context:component-scan base-package="com.test"/>

</beans>
测试

http://localhost:8080/项目名/UserServlet

问题

在servlet中的方法，直接创建spring容器，每一次都要创建，浪费内容空间和性能

2.2 自定义监听器和工具类
在web阶段学的servletContextListener监听器，在项目启动时执行，就可以创建 ClassPathXmlApplicationContext ，可以将这个spring的app对象，设置到ServletContext域，所有servlet都可以从这个域中，获取此对象

自定义监听器

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
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="http://java.sun.com/xml/ns/javaee"
	xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
	version="2.5">

	<context-param>
		<param-name>contextConfigLocation</param-name>
		<param-value>applicationContext.xml</param-value>
	</context-param>

	<listener>
		<listener-class>com.test.web.listener.MyContextLoaderListener</listener-class>
	</listener>

</web-app>
MyContextLoaderListener

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
public class MyContextLoaderListener implements ServletContextListener {

    ClassPathXmlApplicationContext app = null;

    // 在web项目启动时，创建spring环境
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // 获取servletContext域对象
        ServletContext servletContext = sce.getServletContext();
        // 读取全局配置参数
        String contextConfigLocation = servletContext.getInitParameter("contextConfigLocation");
        // 创建spring环境
        app = new ClassPathXmlApplicationContext(contextConfigLocation);
        // 设置到域中
        servletContext.setAttribute("app", app);
        System.out.println("Spring Environment Init");
    }

    // 在web项目卸载时，关闭spring环境
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        app.close();
        System.out.println("Spring Environment Destroyed");
    }
}
获取spring容器工具类

1
2
3
4
5
6
7
// 专门从web最大的域中获取spring环境
public class MyWebApplicationContextUtils {

  public static ApplicationContext getWebApplicationContext(ServletContext servletContext){
    return (ApplicationContext) servletContext.getAttribute("app");
  }
}
修改UserServlet

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
@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 获取spring容器的上下文对象
//        ClassPathXmlApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
        // 调用service，实现保存功能

        ApplicationContext app = MyWebApplicationContextUtils.getWebApplicationContext(req.getServletContext());

        UserService userService = app.getBean(UserService.class);
        userService.save();
    }
}
2.3 Spring提供工具类
导入spring-web坐标

1
2
3
4
5
6
<!--spring整合web容器-->
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-web</artifactId>
  <version>5.1.5.RELEASE</version>
</dependency>
设置spring提供的监听器

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
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="http://java.sun.com/xml/ns/javaee"
	xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
	version="2.5">

	<!--全局配置参数-->
	<context-param>
		<param-name>contextConfigLocation</param-name>
		<param-value>classpath:applicationContext.xml</param-value>
	</context-param>

	<listener>
		<listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
	</listener>
</web-app>
修改UserServlet

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
@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ApplicationContext app = WebApplicationContextUtils.getWebApplicationContext(req.getServletContext());

        UserService userService = app.getBean(UserService.class);
        userService.save();
    }
}
三.Spring的MVC简介
3.1 回顾MVC模式
MVC

Model

模型 JavaBean(1.处理业务逻辑 2.封装数据)

View

视图 Jsp/html(展示数据)

Controller

控制器 Servlet(1.接收请求 2.调用模型 3.转发视图)

三层架构

web层

用户与java交互

service层

处理业务逻辑

dao层

Java与数据库交互

用户		Web层		Service层(JavaBean)		Dao层(JavaBean)
用户	➡请求	SpringMVC:简化servlet	↔	处理业务逻辑
Spring:IOC,AOP	↔	封装数据
Mybatis,DbUtils,JdbcTemplate
用户		⬇				
用户	⬅响应	视图(jsp)				
3.2 SpringMVC介绍
SpringMVC 是一种基于 Java 的实现 MVC 设计模式的轻量级 Web 框架，它可以通过一套注解，让一个 简单的Java类成为控制器，而无须实现任何接口。

SpringMVC框架本质上就是一个servlet，封装了共有的行为(请求、响应)，简化代码

User	➡请求
⬅响应	Tomcat				
⬇			↗	特有行为JavaBean
Web.xml
配置Servlet
指定Servlet的类信息
指定Servlet的url地址	➡	SpringMVC框架
Servlet
共有行为		
↘	特有行为JavaBean
四.SpringMVC快速入门
需求

访问一个URL, 可以在控制台打印一句话, 然后跳转到一个新的页面

需求分析

User	➡请求
⬅响应	Tomcat
一.导入SpringMVC坐标		三.编写Controller和jsp页面
四.将Controller交给IOC容器建立URL和方法映射		
⬇			↗	特有行为JavaBean
Web.xml
二.配置前端控制器DispatcherServlet
配置Servlet
指定Servlet的类信息
指定Servlet的url地址	➡	SpringMVC框架
Servlet
共有行为		
五.编写Spring-mvc.xml
1.开启注解组件扫描
2.开启MVC注解支持	↘	特有行为JavaBean
代码实现

创建web模块，并导入坐标

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
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>org.example</groupId>
    <artifactId>Spring_online_Day05_04_WEB_MVC</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>
    <!--依赖管理-->
    <dependencies>
        <!--springMVC-->
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
    </dependencies>
</project>
配置前端控制器(servlet)

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

    <!--前端控制器-->
    <servlet>
        <servlet-name>DispatcherServlet</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>

        <!--加载指定配置文件-->
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:spring-mvc.xml</param-value>
        </init-param>
        <!--指定servlet在tomcat启动时创建-->
        <load-on-startup>4</load-on-startup>
    </servlet>

    <!--拦截url规则:/(默认)-->
    <servlet-mapping>
        <servlet-name>DispatcherServlet</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>

</web-app>
编写controller和jsp

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
//一个模块对应一个控制器(类)
public class UserController {

    //// 一个请求对应一个方法
    public String quickStart(){
        System.out.println("Quick Start");
        // 转发给一个视图（在该路径创建该JSP即可）
        return "/WEB-INF/pages/success.jsp";
    }
}
配置controller

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
//一个模块对应一个控制器(类)
@Controller
public class UserController {

    //// 一个请求对应一个方法
    @RequestMapping(path = "/quickStart")
    public String quickStart(){
        System.out.println("Quick Start");
        // 转发给一个视图
        return "/WEB-INF/pages/success.jsp";
    }
}
编写spring-mvc.xml

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
</beans>
部署并测试

http://localhost:8080/项目名/quickStart

简易流程



五.SpringMVC组件概述
5.1 执行流程


5.2 三大组件
处理器映射器:HandlerMapping
将请求url 和 处理器的方法 建立映射关系

处理器适配器

HandlerAdapter 从多个处理器当中，适配其中一个，调用目标执行

视图解析器

ViewResolver 将逻辑视图解析为物理视图

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
# Default implementation classes for DispatcherServlet's strategy interfaces.
# Used as fallback when no matching beans are found in the DispatcherServlet context.
# Not meant to be customized by application developers.

org.springframework.web.servlet.LocaleResolver=org.springframework.web.servlet.i18n.AcceptHeaderLocaleResolver

org.springframework.web.servlet.ThemeResolver=org.springframework.web.servlet.theme.FixedThemeResolver

#处理器映射器
org.springframework.web.servlet.HandlerMapping=org.springframework.web.servlet.handler.BeanNameUrlHandlerMapping,\
	org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping

#处理器适配器
org.springframework.web.servlet.HandlerAdapter=org.springframework.web.servlet.mvc.HttpRequestHandlerAdapter,\
	org.springframework.web.servlet.mvc.SimpleControllerHandlerAdapter,\
	org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter

org.springframework.web.servlet.HandlerExceptionResolver=org.springframework.web.servlet.mvc.method.annotation.ExceptionHandlerExceptionResolver,\
	org.springframework.web.servlet.mvc.annotation.ResponseStatusExceptionResolver,\
	org.springframework.web.servlet.mvc.support.DefaultHandlerExceptionResolver

org.springframework.web.servlet.RequestToViewNameTranslator=org.springframework.web.servlet.view.DefaultRequestToViewNameTranslator

#视图解析器
org.springframework.web.servlet.ViewResolver=org.springframework.web.servlet.view.InternalResourceViewResolver

org.springframework.web.servlet.FlashMapManager=org.springframework.web.servlet.support.SessionFlashMapManager
5.3 常用注解
@Controller

SpringMVC基于Spring容器，所以在进行SpringMVC操作时，需要将Controller存储到Spring容器中， 故使用此注解

@RequestMapping

用于建立请求 URL 和处理请求方法之间的对应关系

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
//一个模块对应一个控制器(类)
@Controller
@RequestMapping("/user")
public class UserController {

    /*
         @RequestMapping
            功能:将请求的url 和 方法 建立映射关系
        位置:
            类上:建立一级url访问路径
            方法上:建立二级的url访问路径，与一级路径组成一个完整url路径
        例:
                    /user/quickStart
        常用属性:
            value/path:声明url访问路径
            method:限定请求方式，默认支持所有，共有7种(get、post、put、delete)
            params:限定请求参数
*/

    @RequestMapping(value = "/quickStart", method = {RequestMethod.POST, RequestMethod.GET}, params = {"username", "password"})
    public String quickStart() {
        System.out.println("Quick Start");
        // 转发给一个视图
        return "success";
    }
}
总结
# spring05

## 一 Spring的事务

### 声明式事务控制

- xml配置

​ - 平台事务管理器配置

​ -

​

​ - 事务通知的配置

​ - <tx:advice id=”myAdvice” transaction-manager=”transactionManager”>

​
​ tx:attributes

​ <tx:method name=”*”/>

​

​ - 事务aop织入的配置

​ - aop:config

​ <aop:advisor advice-ref=”myAdvice”

​ pointcut=”execution(* com.test.service.impl..(..))”>

​

- 常用注解配置

​ - 平台事务管理器配置

​ -

​

​ - 开启注解支持

​ - tx:annotation-driven/

​ - 在目标对象上使用事务注解

​ - @Transactional

## 二 Spring集成web环境

### 导入Spring集成web的坐标

​ org.springframework

​ spring-web

​ 5.1.5.RELEASE

### 配置ContextLoaderListener监听器

​ contextConfigLocation

​ classpath:applicationContext.xml

​

​ org.springframework.web.context.ContextLoaderListener

### 通过工具获得应用上下文对象

ApplicationContext app =

​ WebApplicationContextUtils.getWebApplicationContext(servletContext);

​ Object obj = app.getBean(“id”);

## 三 SpringMVC简介

### MVC模式

- M（model）模型：处理业务逻辑，封装实体

- V（view） 视图：展示内容

- C（controller）控制器：负责调度分发（1.接收请求、2.调用模型、3.转发到视图）

### springMVC

- springMVC是基于java实现MVC设计模式的轻量级web框架。封装了servlet共有的特性，使开发者关注业务本身。

- 本质上就是一个servlet

​ - 我们只需要写控制器（controller）

## 四 SpringMVC快速入门

### 1. 创建web项目，导入SpringMVC相关坐标

### 2. 配置SpringMVC前端控制器 DispathcerServlet

### 3. 编写Controller类和视图页面

### 4. 使用注解配置Controller类中业务方法的映射地址

### 5. 配置SpringMVC核心文件 spring-mvc.xml

### 6.部署并测试

## 五 SpringMVC组件概述

### SpringMVC的执行流程

### 三大组件

- HandlerMapping

- HandlerAdapter

- ViewResolver

​ - 重写视图解析器，指定前后缀

### 注解解析

- @Controller

​ - 将对象交给ioc容器

- @requestMapping

​ - 将url与方法建立映射关系