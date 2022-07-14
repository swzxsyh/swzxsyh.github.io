---
title: Spring 初识 & 相关配置
date: 2020-05-28 01:41:27
tags:
---

一.Spring概述
1.1 Spring是什么
Spring是分层的 Java SE/EE应用 full-stack(全栈) 轻量级开源框架。
Spring的核心是 IOC(Inverse Of Control:控制反转)和 AOP(Aspect Oriented Programming:面向切面编程)

Spring一个全栈应用框架, 提供了表现层 Spring MVC 和持久层 Spring JDBC 以及业务层事务管理等众 多应用技术

Spring还能整合开源世界众多著名的第三方框架和类库，逐渐成为使用最多的 Java EE 企业应用开源框 架

Spring官网:https://spring.io/

1.2 Spring发展历程
EJB

1997 年，IBM提出了EJB 的思想

1998 年，SUN制定开发标准规范 EJB1.0

1999 年，EJB1.1 发布

2001 年，EJB2.0 发布

2003 年，EJB2.1 发布

2006 年，EJB3.0 发布

Spring
Rod Johnson 2002年编著《Expert one on one J2EE design and development》指出了JavaEE和EJB组件框架中的存在的一些主要缺陷;提出普通java类依赖注入更为简单的解决方案。

2004年编著《Expert one-on-one J2EE Development without EJB》 阐述了JavaEE开发时不使用EJB的解决方式(Spring 雏形) 同年4月spring1.0诞生

2006年10月，发布 Spring2.0

2009年12月，发布 Spring3.0

2013年12月，发布 Spring4.0

2017年9月， 发布最新 Spring5.0 通用版(GA)

1.3 Spring优势
方便解耦，简化开发
通过Spring提供的 IOC 容器，可以将对象间的依赖关系交由 Spring 进行控制，避免硬编码所造成的过度耦合。

AOP编程的支持

通过Spring的AOP功能，方便进行面向切面编程，可以方便的实现对程序进行权限拦截、运行监控等功能。

声明式事务的支持

只需要通过配置就可以完成对事务的管理，而无需手动编程。

方便程序的测试

Spring对Junit4支持，可以通过注解方便的测试Spring程序。

方便集成各种优秀框架

Spring对各种优秀框架(Struts、Hibernate、Hessian、Quartz等)的支持。

降低JavaEE API的使用难度

Spring对JavaEEAPI(如JDBC、JavaMail、RPC等)进行了薄薄的封装层，使这些 API 的使用难度大为降低。

1.4 Spring体系结构
核心容器（Core Container）
数据访问/集成（Data Access/Integration）层
Web层
AOP（Aspect Oriented Programming）模块
植入（Instrumentation）模块
消息传输（Messaging）
测试（Test）模块


二.初识IOC
2.1 介绍
控制反转(Inverse Of Control) 是一种设计思想。它的目的是指导我们设计出更加松耦合的程序。

控制:在java中指的是对象的控制权限(创建、销毁)

反转:指的是对象控制权由原来 由开发者在类中手动控制 反转到 由Spring容器控制

2.2 环境搭建
IDEA new empty project ==>设置Project Name、JDK Version、Encodings==>添加maven module==>导入Jar包

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
<!--依赖管理--> 
<dependencies>
  <!--dom4j-->
  <dependency> 
    <groupId>dom4j</groupId> 
    <artifactId>dom4j</artifactId> 
    <version>1.6.1</version>
  </dependency>
  <!--xpath-->
  <dependency> 
    <groupId>jaxen</groupId> 
    <artifactId>jaxen</artifactId> 
    <version>1.1.6</version>
  </dependency>
  <!--junit-->
  <dependency> 
    <groupId>junit</groupId> 
    <artifactId>junit</artifactId> 
    <version>4.12</version>
  </dependency>
</dependencies>
2.3 版本一:原始版本
编写UserDao接口和实现类

1
2
3
public interface UserDao {
    void save();
}
1
2
3
4
5
6
public class UserDaoImpl implements UserDao {
    @Override
    public void save() {
        System.out.println("UserDao Saved!");
    }
}
编写UserService接口和实现类

1
2
3
public interface UserService {
    void save();
}
1
2
3
4
5
6
7
public class UserServiceImpl implements UserService {
    @Override
    public void save() {
        UserDaoImpl userDao = new UserDaoImpl();
        userDao.save();
    }
}
编写UserTest

1
2
3
4
5
6
7
8
public class UserTest{
  //调用Service实现保存
  @Test
  public void testUser01() throws Exception{
    UserServiceImpl userService = new UserServiceImpl();
    userService.save();
  }
}
问题

Service层和dao层代码产生耦合——松耦原则：编译期解耦，运行期可以耦合
每次调用save方法时，都会创建一个新的dao对象
2.4 版本二:工厂解耦
编写beans.xml

1
2
3
<beans>
  <bean id="userDao" class="com.test.dao.impl.UserDaoImpl"></bean>
</beans>
编写BeanFactory

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
public class BeanFactory {

    public static Object getBean(String id) {
        Object object = null;

        try {
            // 1.通过类加载器读取 beans.xml
            InputStream in = BeanFactory.class.getClassLoader().getResourceAsStream("beans.xml");

            // 2.创建dom4j核心解析器对象
            SAXReader saxReader = new SAXReader();
            Document document = saxReader.read(in);

            // 3.编写xpath表达式
            String xpath = "//bean[@id='" + id + "']";

            // 4.获取指定id的标签对象
            Element element = (Element) document.selectSingleNode(xpath);

            // 5.获取全限定名
            String className = element.attributeValue("class");

            // 6.通过反射创建对象实例
            object = Class.forName(className).newInstance();
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 7.返回对象实例
        return object;
    }
}
修改UserServiceImpl

1
2
3
4
5
6
7
8
public class UserServiceImpl implements UserService {
    @Override
    public void save() {
//        UserDaoImpl userDao = new UserDaoImpl();
        UserDao userDao = (UserDao) BeanFactory.getBean("userDao");
        userDao.save();
    }
}
问题

每次调用save方法，都会创建一个新的dao对象，工厂每次调用getBean方法都会创建一个新的对象实例，浪费内存

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
public class UserServiceImpl implements UserService {
    @Override
    public void save() {
//        UserDaoImpl userDao = new UserDaoImpl();
        UserDao userDao = (UserDao) BeanFactory.getBean("userDao");
        UserDao userDao1 = (UserDao) BeanFactory.getBean("userDao");
        userDao.save();
        userDao1.save();
    }
}

/*
com.test.dao.impl.UserDaoImpl@516be40f
com.test.dao.impl.UserDaoImpl@3c0a50da
UserDao Saved!
UserDao Saved!
*/
2.5 版本三:工厂优化
修改BeanFactory

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
public class BeanFactory {

    // 声明存储对象的容器(map集合)
    private static Map<String, Object> ioc = new HashMap<>();

    // 静态代码块，初始化ioc容器
    static {
        String id = null;
        String className = null;
        Object object = null;

        try {
            // 1.通过类加载器读取 beans.xml
            InputStream in = BeanFactory.class.getClassLoader().getResourceAsStream("beans.xml");

            // 2.创建dom4j核心解析器对象
            SAXReader saxReader = new SAXReader();
            Document document = saxReader.read(in);

            // 3.编写xpath表达式
            String xpath = "//bean";

            // 4.获取所有bean标签对象
            List<Element> list = document.selectNodes(xpath);

            // 5.遍历集合，创建对象实例，设置到ioc容器中
            for (Element element : list) {
                id = element.attributeValue("id");
                className = element.attributeValue("class");
                object = Class.forName(className).newInstance();

                // 设置到map集合
                ioc.put(id, object);
            }
        } catch (
                Exception e) {
            e.printStackTrace();
        }
    }

    // 7.从ioc容器获取指定id的对象实例
    public static Object getBean(String id) {
        return ioc.get(id);
    }
}


/*
com.test.dao.impl.UserDaoImpl@4ba2ca36
com.test.dao.impl.UserDaoImpl@4ba2ca36
UserDao Saved!
UserDao Saved!
*/
2.6 小结
对象的创建由原来的 使用 new关键字 在类中主动创建 变成了 从工厂中获取, 而对象的创建过程由工厂 内部来实现, 而这个工厂就是 Spring的IOC容器。

也就是以后我们的对象不再自己创建,而是直接向 Spring要, 这种思想就是IOC

目的：松耦合

三.Spring快速入门
3.1 需求
UserServiceImpl		UserDaoImpl
UserDao userDao = Spring客户端.getBean(id标识)		CURD方法
⬆⬇Spring框架		⬆⬇
读取xml配置文件
根据id标识获得Bean权限定名
通过反射创建Bean对象
返回对象	➡
⬅	xml配置文件
id标识=com.test.dao.UserDaoImpl
3.2 代码实现
创建maven的java模块

IDEA new moudle==>MVN==>导入依赖管理Spring、Junit坐标，JDK1.8插件

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
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>Spring_online_Day01_ioc_xml</artifactId>
    <version>1.0-SNAPSHOT</version>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                    <encoding>UTF-8</encoding>
                </configuration>
            </plugin>
        </plugins>
    </build>

    <!--依赖管理-->
    <dependencies>
        <!--spring的核心坐标-->
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
    </dependencies>
</project>
编写UserDao接口和实现类(同上)

1
2
3
public interface UserDao {
    void save();
}
1
2
3
4
5
6
public class UserDaoImpl implements UserDao {
    @Override
    public void save() {
        System.out.println("UserDao Saved!");
    }
}
创建spring的核心配置文件，导入约束

官方推荐名称:applicationContext.xml

1
2
3
4
5
6
7
8
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.2.xsd">

</beans>
写bean标签(id、class)

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
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.2.xsd">

    <!--    将userDao的对象创建权交给ioc容器-->
    <bean id="userDao" class="com.test.dao.impl.UserDaoImpl"></bean>
</beans>
测试(模拟service层)

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
public class UserTest {
    // spring的快速入门
    @Test
    public void testUser() throws Exception{
        // 1.通过spring的api读取配置文件
        ClassPathXmlApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
        // 2.获取指定id的对象实例
        UserDao userDao = (UserDao) app.getBean("userDao");
        userDao.save();
    }
}
四.Spring相关API
4.1 二个接口(创建的对象均为单例)
BeanFactory

介绍

IOC容器的顶级接口，定义了IOC的最基础的功能, 但功能比较简单,一般面向Spring自身使用

特点(懒汉设计)

在第一次使用到某个Bean时(调用getBean())，才对该Bean进行加载实例化[用的时候再创建]

ApplicationContext

介绍

这是在BeanFactory基础上衍生出的接口,它扩展了BeanFactory的功能,一般面向程序员使用

特点(恶汉设计)

在容器启动时，一次性创建并加载了所有的Bean [初始化的时候全创建好]

4.2 三个实现类
ClassPathXmlApplicationContext

功能：读取类路径(classpath)下的xml配置文件

FileSystemXmlApplicationContext

功能：读取本地磁盘下的xml配置文件

AnnotationConfigApplicationContext

功能：读取java配置类加载配置

4.3 一个方法
public Object getBean(String name) throws BeansException;

功能：通过指定id获取对象的实例，需要手动强转

public <T> T getBean(Class<T> requiredType);

功能：通过指定类型获取对象的实例，不需要强转

public <T> T getBean(String name, Class<T> requiredType);

功能：通过指定id和类型获取对象的实例

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
// getBean方法介绍
// 方式一: 通过指定id获取对象的实例，需要手动强转
@Test
public void testUserByID() throws Exception {
  // 1.通过spring的api读取配置文件
  ApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
  // 2.获取指定id的对象实例
  UserDao userDao = (UserDao) app.getBean("userDao");
  userDao.save();
}

// getBean方法介绍
// 方式二:通过指定(接口)类型获取对象的实例，不需要强转
//缺点:如果同一个接口类型下有多个对象实例，会报错
@Test
public void testUserByInstance() throws Exception {
  // 1.通过spring的api读取配置文件
  ApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");

  UserDao userDao = app.getBean(UserDao.class);
  userDao.save();
}

// getBean方法介绍
// 方式三:通过指定id和类型获取对象的实例
@Test
public void testUserBySpecifyIdOfType() throws Exception {
  // 1.通过spring的api读取配置文件
  ApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");

  UserDao userDao = app.getBean("userDao", UserDao.class);
  userDao.save();
}

4.4 知识小结
1
2
3
ApplicationContext app = new ClasspathXmlApplicationContext("xml文件"); 
app.getBean("id");
app.getBean(Class);
五.Spring配置文件
5.1 Bean标签基本配置
基本配置

1
<bean id="userDao" class="cn.itcast.dao.impl.UserDaoImpl"></bean>
基本属性	
id	在ioc容器的唯一标识
class	创建对象实例的全限定名
作用范围

scope属性:声明此对象的作用范围	何时创建	对象运行	何时销毁
singleton(单例对象)	ioc容器初始化时，创建对象	ioc容器在,对象在	ioc容器关闭时，销毁对象
prototype(多例对象)	在调用getBean()方法时，创建	一直使用就一直活着	当对象不再使用后，根据JVM GC机制垃圾回收
生命周期

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
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.2.xsd">

    <!--    将userDao的对象创建权交给ioc容器-->
  <bean id="userDao" class="com.test.dao.impl.UserDaoImpl" scope="singleton" init-method="MethodInit" destroy-method="MethodDestory"></bean>
</beans>
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
public class UserDaoImpl implements UserDao {
    @Override
    public void save() {
        System.out.println("UserDao Saved!");
    }

  //当创建时，init-method="MethodInit"
    private void MethodInit() {
        System.out.println("Method Init Now");
    }

  //当销毁时，destroy-method="MethodDestory"
    private void MethodDestory() {
        System.out.println("Method Die Now");
    }
}

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
@Test
public void testUserDestory() throws Exception {
  // 1.通过spring的api读取配置文件
  ApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
  // 2.获取指定id的对象实例
  UserDao userDao = (UserDao) app.getBean("userDao");
  UserDao userDao1 = (UserDao) app.getBean("userDao");

  System.out.println(userDao);
  System.out.println(userDao1);

  ((ClassPathXmlApplicationContext) app).close();
}

/*
Method Init Now
com.test.dao.impl.UserDaoImpl@78e67e0a
com.test.dao.impl.UserDaoImpl@78e67e0a
Method Die Now
*/
5.2 spring创建对象实例三种方式
无参构造方法实例化

在企业开发时，所有的类必须提供无参构造方法

1
2
public UserDaoImpl(String a)
  //若未提供无参构造，则xml中class="com.test.dao.impl.UserDaoImpl" 会报错
工厂静态方法实例化

依赖的jar包中有个A类，A类中有个静态方法m1，m1方法的返回值是一个B对象。如果我们频繁 使用B对象，此时我们可以将B对象的创建权交给spring的IOC容器，以后我们在使用B对象时，无 需调用A类中的m1方法，直接从IOC容器获得。

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
//工厂静态方法实例化对象
public class StaticFactoryBean {
    public static UserDao createUserDao(){
        return new UserDaoImpl();
    }

    // 传统方式，自己通过工厂获取对象
    public static void main(String[] args) {
        UserDao userDao = StaticFactoryBean.createUserDao();
    }
}
1
2
<!--工厂静态方法实例化对象-->
<bean id="userDao" class="com.test.factory.StaticFactoryBean" factory-method="createUserDao"></bean>
工厂普通方法实例化

依赖的jar包中有个A类，A类中有个普通方法m1，m1方法的返回值是一个B对象。如果我们频繁 使用B对象，此时我们可以将B对象的创建权交给spring的IOC容器，以后我们在使用B对象时，无 需调用A类中的m1方法，直接从IOC容器获得。

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
//工厂普通方法实例化对象
public class DynamicFactoryBean {

  public UserDao createUserDao() {
    return new UserDaoImpl();
  }


  // 传统方式，自己通过工厂获取对象
  public static void main(String[] args) {
    // 1.创建工厂对象
    DynamicFactoryBean dynamicFactoryBean = new DynamicFactoryBean();
    // 2.创建UserDao对象
    UserDao userDao = dynamicFactoryBean.createUserDao();
  }
}
1
2
3
<!--工厂普通方法实例化对象-->
<bean id="dynamicFactoryBean" class="com.test.factory.DynamicFactoryBean"></bean>
<bean id="userDao" factory-bean="dynamicFactoryBean"></bean>
5.3 Bean依赖注入
5.3.1 概述
依赖注入(Dependency Injection, DI) 它是 Spring 框架核心 IOC 的具体实现

其实就是给对象中的属性赋值的过程，通过spring完成依赖注入

UserServiceImpl	➡依赖	UserDaoImpl
private UserDao userDao
userDao.save()		
⬆service层需要调用dao层对象的实例，就要从Spring的ioc容器注入此实例，
⬆这个过程称为依赖注入		
Spring的配置文件		
<bean id=”userDao” class=”xxx”>
<bean id=”userService” class=”xxx”>		
5.3.2 环境搭建
IDEA new moudle==>MVN==>导入依赖管理Spring、Junit坐标，JDK1.8插件==>复制UserDao,UserService==>编写spring的核心配置文件

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
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <configuration>
                <source>1.8</source>
                <target>1.8</target>
                <encoding>UTF-8</encoding>
            </configuration>
        </plugin>
    </plugins>
</build>

<!--依赖管理-->
<dependencies>
    <!--spring的核心坐标-->
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
    <dependency>
        <groupId>dom4j</groupId>
        <artifactId>dom4j</artifactId>
        <version>1.6</version>
        <scope>compile</scope>
    </dependency>
</dependencies>
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
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.2.xsd">

    <!--    将userDao的对象创建权交给ioc容器-->
    <bean id="userDao" class="com.test.dao.impl.UserDaoImpl"></bean>


    <!--    将userService交给ioc容器-->
    <bean id="userService" class="com.test.service.impl.UserServiceImpl"></bean>

</beans>
5.4 Bean依赖注入方式
构造方法

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
public class UserServiceImpl implements UserService {

    private UserDao userDao;

    public UserServiceImpl(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public void save() {
        userDao.save();
    }
}
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
<!--
构造方法注入: <constructor-arg> 子标签
版本一:
	name:构造方法参数名称 
	value:简单数据类型(String、int、double...)
	ref:引用数据类型(从ioc容器中获取的对象) 
版本二:
	index:构造方法参数索引 
	type:该索引对应的java类型(全限定名) 
	value:简单数据类型(String、int、double...) 
	ref:引用数据类型(从ioc容器中获取的对象)
-->

<!--    将userService交给ioc容器-->
<bean id="userService" class="com.test.service.impl.UserServiceImpl">
  <constructor-arg name="userDao" ref="userDao"></constructor-arg>
</bean>
set方法(推荐使用 )

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
public class UserServiceImpl implements UserService {

    private UserDao userDao;

//    public UserServiceImpl(UserDao userDao) {
//        this.userDao = userDao;
//    }

    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public void save() {
        userDao.save();
    }
}
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
<!--    将userDao的对象创建权交给ioc容器-->
<bean id="userDao" class="com.test.dao.impl.UserDaoImpl"></bean>

<!--

    set方法注入:<property> 子标签
        name:set方法的属性名 setUserDao() -> UserDao -> userDao
        value:简单数据类型(String、int、double...)
        ref:引用数据类型(从ioc容器中获取的对象)
        -->
<bean id="userService" class="com.test.service.impl.UserServiceImpl">
  <property name="userDao" ref="userDao"></property>
</bean>
P命名空间注入

P命名空间注入底层(本质)使用的也是set方法注入，只是在上着的基础上进行简化

导入P命名空间约束

1
2
3
4
5
6
7
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:p="http://www.springframework.org/schema/p"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.2.xsd">
使用P命名空间注完成注入(单一属性来简洁，但是若变量多，则不如第二种规范)

1
<bean id="userService" class="com.test.service.impl.UserServiceImpl" p:userDao-ref="userDao"></bean>
5.5 Bean依赖注入的数据类型
简单数据类型

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
public class User {

    private Integer id;

    private String username;

    public void setId(Integer id) {
        this.id = id;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
1
2
3
4
5
<!-- 注入简单数据类型 -->
<bean id="user" class="com.test.domain.User">
  <property name="id" value="1"></property>
  <property name="username" value="jack"></property>
</bean>
引用数据类型

参考5.4 Bean依赖注入方式

集合数据类型

单列集合(list、set、array)

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
public class UserDaoImpl implements UserDao {

    private List<Object> list;
    private Set<Object> set;
    private Object[] array;

    public void setList(List<Object> list) {
        this.list = list;
    }

    public void setSet(Set<Object> set) {
        this.set = set;
    }

    public void setArray(Object[] array) {
        this.array = array;
    }

    @Override
    public void save() {
        System.out.println("UserDao Saved!");
    }

}
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
<!--
    di 注入单列集合类型
        需要在 <property>标签中
    list集合 使用子标签 <list>
            <value> 简单数据类型
            <ref> 引用数据类型(对象在ioc容器中)
    set集合 使用子标签 <set>
        <value> 简单数据类型
        <ref> 引用数据类型(对象在ioc容器中)
    array数组 使用子标签<array>
        <value> 简单数据类型
        <ref> 引用数据类型(对象在ioc容器中)
-->


<bean id="userDao" class="com.test.dao.impl.UserDaoImpl">
  <property name="list">
    <list>
      <value>A</value>
      <value>B</value>
      <ref bean="user"></ref>
    </list>
  </property>

  <property name="set">
    <set>
      <value>C</value>
      <value>D</value>
      <ref bean="user"></ref>
    </set>
  </property>

  <property name="array">
    <array>
      <value>E</value>
      <value>F</value>
      <ref bean="user"></ref>
    </array>
  </property>
</bean>
双列集合(map、properties)

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
package com.test.dao.impl;


import com.test.dao.UserDao;

import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

public class UserDaoImpl implements UserDao {

//    private List<Object> list;
//    private Set<Object> set;
//    private Object[] array;
//
//    public void setList(List<Object> list) {
//        this.list = list;
//    }
//
//    public void setSet(Set<Object> set) {
//        this.set = set;
//    }
//
//    public void setArray(Object[] array) {
//        this.array = array;
//    }

    private Map<String ,Object> map;
    private Properties properties;

    public void setMap(Map<String, Object> map) {
        this.map = map;
    }

    public void setProperties(Properties properties) {
        this.properties = properties;
    }

    @Override
    public void save() {
        System.out.println("UserDao Saved!");
    }

}
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
    
<!--
di 注入双列集合类型
    需要在 <property>标签中
map集合 使用子标签<map>
    <entry key="" value="简单数据类型" | value-ref="引用数据类型(对象ioc中)" ></entry>
properties集合 使用子标签 <props>
     <prop key="" >value</prop>
-->
    
    
<bean id="userDao" class="com.test.dao.impl.UserDaoImpl">
    <property name="map">
        <map>
            <entry key="k1" value="v1"></entry>
            <entry key="k2" value="v2"></entry>
            <entry key="u1" value-ref="user"></entry>
        </map>
    </property>
    <property name="properties">
        <props>
            <prop key="k1">v1</prop>
            <prop key="k3">v2</prop>
            <prop key="k3">v3</prop>
        </props>
    </property>
</bean>
5.6 配置文件模块化
实际开发中，Spring的配置内容非常多，这就导致Spring配置很繁杂且体积很大，所以，可以将部分配置拆解到其他配置文件中，也就是所谓的配置文件模块化。

并列加载

1
2
3
4
5
6
//并列加载
@Test
public void testParallels() throws Exception{
    ApplicationContext app = new ClassPathXmlApplicationContext("applicationContext_dao.xml","applicationContext_service.xml");
  
}
主从配置

1
2
3
4
5
tree   
.
├── applicationContext-dao.xml
├── applicationContext-service.xml
└── applicationContext.xml
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
<!-- applicationContext.xml-->

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.2.xsd">

    <import resource="classpath:applicationContext-dao.xml"></import>
    <import resource="classpath:applicationContext-service.xml"></import>
注意：不论是否同一个xml，都不得出现相同id，否则触发报错或覆盖问题

5.7 知识小结
<bean>标签:创建对象并放到spring的IOC容器

id属性:在容器中Bean实例的唯一标识，不允许重复

class属性:要实例化的Bean的全限定名

scope属性:Bean的作用范围，常用是Singleton(默认)和prototype

<constructor-arg>标签:属性注入

name属性:属性名称

value属性:注入的简单属性值

ref属性:注入的对象引用值

<property>标签:属性注入

name属性:属性名称

value属性:注入的简单属性值

ref属性:注入的对象引用值

<list>
<set>
<array>
<map>
<props>

<import>标签:导入其他的Spring的分文件

总结
# spring01

## 一 Spring概述

### spring是一款 full-stack 轻量级开源框架

- IOC

​ - 控制反转

- AOP

​ - 面向切面编程

## 二 初识IOC

### 控制反转（Inverse Of Control）是一种设计思想。它的目的是指导我们设计出更加松耦合的程序。

### 自定义IOC容器

- BeanFactory

## 三 Spring快速入门

### 1. 创建java项目，导入spring开发基本坐标

### 2. 编写Dao接口和实现类

### 3. 创建spring核心配置文件

### 4. 在spring配置文件中配置 UserDaoImpl

### 5. 使用spring相关API获得Bean实例

## 四 Spring相关API

### BeanFactory

- 是 IOC 容器的核心接口，它定义了IOC的基本功能。

### ApplicationContext

- 代表应用上下文对象，可以获得spring中IOC容器的Bean对象。

- 常用实现类

​ - 1. ClassPathXmlApplicationContext

​ - 2. FileSystemXmlApplicationContext

​ - 3. AnnotationConfigApplicationContext

- 常用方法

​ - 1. Object getBean(String name);

​ - 2. <T> T getBean(Class<T> requiredType);

​ - 3. <T> T getBean(String name,Class<T> requiredType);

## 五 Spring配置文件

### 5.1 Bean标签基本配置

- id：Bean实例在Spring容器中的唯一标识

- class：Bean的全限定名

### 5.2 Bean标签范围配置

- scope

​ - singleton

​ - prototype

### 5.3 Bean生命周期配置

- init-method

- destroy-method

### 5.4 Bean实例化三种方式

无参构造方法

工厂静态方法

工厂实例方法

### 5.5 Bean依赖注入概述

通过框架把持久层对象传入业务层，而不用我们自己去获取。
### 5.6 Bean依赖注入方式

构造方法
<constructor-arg name=”userDao” ref=”userDao”/>
set方法
<property name=”userDao” ref=”userDao”/>
p命名空间
<bean id=”userService” class=”com.test.service.impl.UserServiceImpl” p:userDao-ref=”userDao”/>
### 5.7 Bean依赖注入的数据类型

- 简单数据类型

- 引用数据类型

- 集合数据类型

​ - list

​ - set

​ - array

​ - map

​ - properties

### 5.8 配置文件模块化

- 主从配置

<import resource=”applicationContext-xxx.xml”/>