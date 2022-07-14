---
title: Maven & Git
date: 2020-06-15 01:50:37
tags:
---

一.Maven
1.1 Maven基础回顾
目标

回顾Maven基础课程

学习路径

Maven好处
安装配置Maven
三种仓库
常见命令
坐标的书写规范
如何添加坐标
依赖范围
1.1.1 回顾
什么是Maven

Maven 是专门用于构建和管理Java相关项目的工具。

Maven好处

节省磁盘空间
可以一键构建
可以跨平台
应用在大型项目时可以提高开发效率（jar包管理，maven的工程分解，可分模块开发）
安装配置 maven

三种仓库

本地仓库，远程仓库（私服）, 公司内部中央仓库

常见的命令

Compile
Test
Package（jar，war）
Install（安装到本地仓库）
Deploy（部署到远程仓库（私服））
Clean（target下生成的文件）
坐标的书写规范

groupId 公司或组织域名的倒序
artifactId 项目名或模块名
version 版本号
如何添加坐标

在本地仓库中搜索
互联网上搜，推荐网址 http://www.mvnrepository.com/
依赖范围

<scope>属性：

依赖范围	对于编译classpath有效	对于测试classpath有效	对于运行classpath有效	例子
Compile(默认)	Y	Y	Y	Spring-core
Test	-	Y	-	Junit
Provided	Y	Y	-	servlet-api
Runtime	-	Y	Y	JDBC驱动
System	Y	Y	-	本地的，Maven仓库之外的类库
1.1.2 小结
Maven好处
安装配置Maven（熟练）
三种仓库（本地仓库(阿里镜像)，中央仓库（远程仓库），私服（代理仓库））
常见命令（clean compile test package install deploy）
坐标的书写规范（groupId artifactId version）
如何添加坐标（http://www.mvnrepository.com/）
依赖范围
私服的配置（settings.xml配置私服 工作中大概率要配置的）
1.2 Maven中jar包冲突问题
目标

使用maven依赖导入jar包，出现相同名称但版本不一致的jar包

学习路径

演示jar包冲突问题：遵循第一声明者优先原则
解决jar包冲突问题，路径近者优先
解决jar包冲突问题，直接排除法
首先创建一个Mavenjar包工程(New Project-Maven)

1.2.1 第一声明优先原则
哪个jar包在靠上的位置，这个jar包就是先声明的，先声明的jar包下的依赖包，可以优先引入项目中。

在pom.xml中引入如下坐标，分别是spring中不同的版本。

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
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.test</groupId>
  <artifactId>Maven_Advanced</artifactId>
  <version>1.0-SNAPSHOT</version>

  <packaging>jar</packaging>

  <!--导入相关依赖包-->
  <dependencies>
    <!--引入spring-context，它所以来的包都会导入进来-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>5.0.2.RELEASE</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-beans</artifactId>
      <version>4.2.4.RELEASE</version>
    </dependency>
  </dependencies>
</project>
在控制面板的maven面板，点击查看依赖关系按钮，看到了包和包之间的依赖关系存在冲突，都使用了spring-core包，关系图如下：



看看他们依赖包的导入，发现导入的包却没有问题，包使用的都是5.0.2的版本。



我们把上面2个包的顺序调换后就变成了低版本的依赖导入。



1.2.2 路径近者优先原则
直接依赖：项目中直接导入的jar包就是项目的直接依赖包。
传递依赖（间接依赖）：项目中没有直接导入的jar包，可以通过中直接依赖包传递到项目中去。
直接依赖比传递依赖路径近，最终进入项目的jar包会是路径近的直接依赖包。
修改jar包，直接引入依赖spring-core

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
<!--导入相关依赖包-->
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-beans</artifactId>
        <version>4.2.4.RELEASE</version>
    </dependency>

    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>5.0.2.RELEASE</version>
    </dependency>

    <!--引入直接依赖-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-core</artifactId>
        <version>4.2.8.RELEASE</version>
    </dependency>
</dependencies>
此时优先引入的是直接依赖的引用



1.2.3 直接排除法
问题：整合项目需要用到5的版本，引入4的版本，会不会出现异常（类没有找到，方法没有找到）
当我们需要排除某个jar包的依赖时，在配置exclusions标签的时候，内部可以不写版本号。pom.xml依赖如下：

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
<!--导入相关依赖包-->
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-beans</artifactId>
        <version>4.2.4.RELEASE</version>
        <!--直接排除-->
        <exclusions>
            <exclusion>
                <groupId>org.springframework</groupId>
                <artifactId>spring-core</artifactId>
            </exclusion>
        </exclusions>
    </dependency>

    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>5.0.2.RELEASE</version>
    </dependency>
</dependencies>
解决方案

pom.xml添加exclusions

1
2
3
4
5
6
<exclusions>
  <exclusion>
    <artifactId>spring-core</artifactId>
    <groupId>org.springframework</groupId>
  </exclusion>
</exclusions>
1.2.4 小结
出现1个项目存在多个同种jar包的时候，需要我们进行解决maven的jar包冲突问题（异常：Class not found、Method not found等）

路径近者
节点路径相同时，使用第一声明优先（xml上下顺序有关）
无法通过依赖管理原则排除的，使用直接排除法
1.3 工程分层
之前项目开发：



工程分层后的开发：所有的service和dao的代码都在一起，1：增强程序的通用性，2：降低了代码的耦合性



目标

实现项目工程分解，掌握聚合和继承的作用

学习路径

聚合和继承
准备数据库环境
ssm_parent（父工程） pom 引入依赖
ssm_model（子工程） 实体类
ssm_dao（子工程） 数据库操作
ssm_service（子工程） 完业务操作
ssm_web（子工程） 收集请求参数，调用业务，返回结果给前端
测试（工程发布tomcat）
1.3.1 聚合（多模块）和继承
继承和聚合结构图：



特点1（继承）

ssm_parent父工程：存放项目的所有jar包。

ssm_web和ssm_service和ssm_dao有选择的继承jar包，并在工程中使用。这样可以消除jar包重复，并锁定版本

特点2（聚合）

ssm_web依赖于ssm_service，ssm_service依赖于ssm_dao，启动ssm_web，便可访问程序。

执行安装的时候，执行ssm_parent，就可以将所有的子工程全部进行安装。

理解继承和聚合总结

通常继承和聚合同时使用。

何为继承

继承是为了消除重复，如果将 dao、 service、 web 分开创建独立的工程则每个工程的 pom.xml 文件中的内容存在重复，比如：设置编译版本、锁定 spring 的版本的等，可以将这些重复的 配置提取出来在父工程的 pom.xml 中定义。

何为聚合

项目开发通常是分组分模块开发， 每个模块开发完成要运行整个工程需要将每个模块聚合在 一起运行，比如： dao、 service、 web 三个工程最终会打一个独立的 war 运行。



1.3.2 准备数据库环境
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
SET FOREIGN_KEY_CHECKS=0;

CREATE DATABASE Maven;
use Maven;
DROP TABLE IF EXISTS `items`;
CREATE TABLE `items` (
                         `id` int(10) NOT NULL auto_increment,
                         `name` varchar(20) default NULL,
                         `price` float(10,0) default NULL,
                         `pic` varchar(40) default NULL,
                         `createTime` datetime default NULL,
                         `detail` varchar(200) default NULL,
                         PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

INSERT INTO `items` VALUES ('1', 'Test01', '1000', null, '2018-03-13 09:29:30', '带我走上人生巅峰');
INSERT INTO `items` VALUES ('2', 'Test02', null, null, '2018-03-28 10:05:52', '插入测试');
INSERT INTO `items` VALUES ('3', 'Test03', '199', null, '2018-03-07 10:08:04', '插入测试');
INSERT INTO `items` VALUES ('7', 'Test04', null, null, null, null);
INSERT INTO `items` VALUES ('8', 'Test05', null, null, null, null);
1.3.3 ssm_parent
创建ssm_parent的Maven Project
删除src文件夹
1.3.3.1 pom.xml
父工程：<packaging>pom</packaging>

详细信息
小结

<package>pom</pcakage>
管理所有的jar包（并锁定版本）
父工程不需要开发的代码，src的文件夹可以删除
1.3.4 ssm_model
选择ssm_parent=>New->Moudle->Maven->创建子项目ssm_model(即实体类)

1.3.4.1 pom.xml
查看子工程pom.xml

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
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>ssm_parent</artifactId>
        <groupId>com.test</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>ssm_model</artifactId>
    <packaging>jar</packaging>

</project>
回去查看ssm_parent的pom.xml，自动聚合类ssm_model

1
2
3
<modules>
  <module>ssm_model</module>
</modules>
1.3.4.2 创建Items.java
1
2
3
4
5
6
7
8
9
public class Items {
    private Integer id;
    private String name;
    private Float price;
    private String pic;
    private Date createTime;
    private String detail;
//此处省略getter/setter，toString
}
小结
<package>jar</pcakage>
管理项目中所有的实体类
1.3.5 ssm_dao
操作路径
配置pom.xml
创建spring-mybatis.xml（spring整合mybatis的配置）
创建ItemsDao.java
创建ItemsDao.xml
1.3.5.1 pom.xml
详细信息
查看父工程pom.xml

1
2
3
4
<modules>
  <module>ssm_model</module>
  <module>ssm_dao</module>
</modules>
1.3.5.2 创建spring-mybatis.xml
操作路径

设置数据库连接池
配置SqlSessionFactoryBean
添加Dao层接口扫描，让Dao被spring管理
spring-mybatis.xml

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
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    <!--1.数据库连接池-->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/Maven"/>
        <property name="username" value="root"/>
        <property name="password" value="root"/>
    </bean>

    <!--2.配置sqlSessionFactoryBean-->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <!--配置数据源-->
        <property name="dataSource" ref="dataSource"/>
        <!--别名配置-->
        <property name="typeAliases" value="com.test.domain"/>
    </bean>

    <!--3.dao接口扫描-->
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <property name="basePackage" value="com.test.dao"/>
    </bean>
</beans>
1.3.5.3 创建ItemsDao.java
1
2
3
4
5
public interface ItemsDao {
    List<Items> findAll();

    int save(Items items);
}
1.3.5.4 创建ItemsDao.xml
com/test/dao/ItemsDao.xml

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
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!--
    namespace="Dao接口的全限定名"
-->
<mapper namespace="com.test.dao.ItemsDao">

  <!--保存操作-->
  <insert id="save" parameterType="com.test.domain.Items">
    INSERT  INTO items(name,price,pic,creaTetime,detail) VALUES(#{name},#{price},#{pic},#{createTime},#{detail})
  </insert>

  <!--查询所有-->
  <select id="findAll" resultType="com.test.domain.Items">
    SELECT * FROM items
  </select>
</mapper>
1.3.5.5 dao测试
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
@Test
public  void testFindAll() {
  ClassPathXmlApplicationContext classPathXmlApplicationContext = new ClassPathXmlApplicationContext("classpath:spring-mybatis.xml");
  ItemsDao itemsDao = classPathXmlApplicationContext.getBean(ItemsDao.class);
  List<Items> all = itemsDao.findAll();

  for (Items items : all) {
    System.out.println(items);
  }
}
小结
<package>jar</pcakage>
引入依赖 ssm_model 、mybatis的依赖…
spring-mybatis.xml（spring的配置文件）（spring整合mybatis的框架）
数据源
工厂
包扫描(dao)
接口ItemsDao.java
创建映射文件ItemsDao.xml (映射文件路径与包名相同, resources目录下的)
1.3.6 ssm_service
操作路径
pom.xml
创建spring-service.xml（spring的声明式事务处理）
创建ItemsService接口
创建ItemsServiceImpl实现类
1.3.6.1 pom.xml
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
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>ssm_parent</artifactId>
        <groupId>com.test</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>ssm_service</artifactId>


    <!--jar包-->
    <packaging>jar</packaging>

    <!--依赖-->
    <dependencies>
        <!--依赖dao-->
        <dependency>
            <groupId>com.test</groupId>
            <artifactId>ssm_dao</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>

        <!-- spring -->
        <dependency>
            <groupId>org.aspectj</groupId>
            <artifactId>aspectjweaver</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-aop</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-tx</artifactId>
        </dependency>
    </dependencies>

</project>
1.3.6.2 创建spring-service.xml
操作路径
创建一个事务管理器
配置事务的通知，及传播特性，对切入点方法的细化
AOP声明式事务配置（配置切入点，通知关联切入点）
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
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/tx
       http://www.springframework.org/schema/tx/spring-tx.xsd
       http://www.springframework.org/schema/aop
       http://www.springframework.org/schema/aop/spring-aop.xsd
       http://www.springframework.org/schema/context
       http://www.springframework.org/schema/context/spring-context.xsd">
    <!--1.创建一个事务管理器-->
    <bean id="txtManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <!--指定数据源-->
        <property name="dataSource" ref="dataSource" />
    </bean>

    <!--2.方式一：声明式事务配置-->
    <tx:advice id="txAdvice" transaction-manager="txtManager">
        <!--配置传播特性属性-->
        <tx:attributes>
            <!--
                对应方法参与事务并且在事务下执行，事务隔离剂别使用默认隔离级别,发生异常需要事务回滚
            -->
          <tx:method name="add*" isolation="DEFAULT" propagation="REQUIRED" rollback-for="java.lang.Exception" />
          <tx:method name="insert*" isolation="DEFAULT" propagation="REQUIRED" rollback-for="java.lang.Exception" />
          <tx:method name="save*" isolation="DEFAULT" propagation="REQUIRED" rollback-for="java.lang.Exception" />
          <tx:method name="delete*" isolation="DEFAULT" propagation="REQUIRED" rollback-for="java.lang.Exception" />
          <tx:method name="update*" isolation="DEFAULT" propagation="REQUIRED" rollback-for="java.lang.Exception" />
          <tx:method name="edit*" isolation="DEFAULT" propagation="REQUIRED" rollback-for="java.lang.Exception" />
            <!--
                只读操作
            -->
            <tx:method name="*" read-only="true" />
        </tx:attributes>
    </tx:advice>
     <!--AOP声明式事务配置（配置切入点，通知关联切入点）-->
    <aop:config>
        <!--切点指点-->
        <aop:pointcut id="tranpointcut" expression="execution(* com.test.service.*.*(..))" />
        <!--配置通知-->
        <aop:advisor advice-ref="txAdvice" pointcut-ref="tranpointcut" />
    </aop:config>
    <!--方式二：注解方式事务配置-->
    <!--<tx:annotation-driven transaction-manager="txtManager"/>-->
    <!--3.扫描service-->
    <context:component-scan base-package="com.test.service"/>
    <!--4.引入spring-mybatis.xml-->
    <import resource="spring-mybatis.xml" />
</beans>
1.3.6.3 创建ItemsService接口
1
2
3
4
5
public interface ItemsService {
    List<Items> findAll();

    void save(Items items);
}
1.3.6.4 创建ItemsServiceImpl
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
@Service
public class ItemsServiceImpl implements ItemsService {
    @Autowired
    private ItemsDao itemsDao;

    @Override
    public List<Items> findAll() {
        return itemsDao.findAll();
    }

    @Override
    public void save(Items items) {
        itemsDao.save(items);
    }
}
1.3.6.5 service测试
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
public class ServiceTest {
  @Test
  public void testService(){
    ClassPathXmlApplicationContext classPathXmlApplicationContext = new ClassPathXmlApplicationContext("classpath:spring-service.xml");
    ItemsService bean = classPathXmlApplicationContext.getBean(ItemsService.class);
    List<Items> all = bean.findAll();

    for (Items items : all) {
      System.out.println(items);
    }
  }
}
小结
<package>jar</pcakage>
引入依赖 ssm_dao 、spring相关的依赖
spring-service.xml（声明式事务处理）
扫描业务层
事务管理器
通知->切的方法
aop:config
要切的包 表达式
把advice与pointcut整合起来
注解式事务
接口ItemsService.java
实现类ItemsServiceImpl.java
1.3.7 ssm_web
操作路径
pom.xml
创建web.xml
创建springmvc.xml
创建ItemsController.java
创建页面items.jsp
1.3.7.1 pom.xml
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
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <parent>
    <artifactId>ssm_parent</artifactId>
    <groupId>com.test</groupId>
    <version>1.0-SNAPSHOT</version>
  </parent>
  <modelVersion>4.0.0</modelVersion>

  <artifactId>ssm_web</artifactId>

  <!--war包-->
  <packaging>war</packaging>

  <!--依赖引入-->
  <dependencies>
    <!--依赖service-->
    <dependency>
      <groupId>com.test</groupId>
      <artifactId>ssm_service</artifactId>
      <version>1.0-SNAPSHOT</version>
    </dependency>

    <!--导入springmvc-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-web</artifactId>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
    </dependency>

    <!--servletAPI -->
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>servlet-api</artifactId>
      <scope>provided</scope>
    </dependency>

    <dependency>
      <groupId>javax.servlet.jsp</groupId>
      <artifactId>jsp-api</artifactId>
      <scope>provided</scope>
    </dependency>

    <!--jstl表达式 -->
    <dependency>
      <groupId>jstl</groupId>
      <artifactId>jstl</artifactId>
    </dependency>

  </dependencies>


  <build>
    <!--插件-->
    <plugins>
      <!--tomcat插件-->
      <plugin>
        <groupId>org.apache.tomcat.maven</groupId>
        <artifactId>tomcat7-maven-plugin</artifactId>
        <!--插件使用的相关配置-->
        <configuration>
          <!--端口号-->
          <port>18081</port>
          <!--写当前项目的名字(虚拟路径),如果写/，那么每次访问项目就不需要加项目名字了-->
          <path>/</path>
          <!--解决get请求乱码-->
          <uriEncoding>UTF-8</uriEncoding>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
1.3.7.2 创建web.xml
操作路径

配置编码过滤器

springmvc前端核心控制器

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
.
├── pom.xml
├── src
│   ├── main
│   │   ├── java
│   │   ├── resources
│   │   └── webapp
│   │       └── WEB-INF
│   │           └── web.xml
│   └── test
│       └── java
└── ssm_web.iml
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
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">
    <!--1.配置编码过滤器-->
    <filter>
        <filter-name>encodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <!--编码设置-->
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>encodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <!--2.springmvc核心控制器-->
    <servlet>
        <servlet-name>dispatcherServlet</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:spring-mvc.xml</param-value>
        </init-param>
        <!--启动优先级-->
        <load-on-startup>1</load-on-startup>
    </servlet>
    <!--3.指定映射拦截-->
    <servlet-mapping>
        <servlet-name>dispatcherServlet</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>
</web-app>
1.3.7.3 创建springmvc.xml
操作路径

包扫描
视图解析器
springmvc注解驱动，自动配置mvc的处理器适配器和处理映射器
静态资源不过滤
mport导入spring.xml
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
23
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc.xsd">
    <!--1：包扫描-->
    <context:component-scan base-package="com.test.controller"/>
    <!--2：视图解析器-->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/pages/"/>
        <property name="suffix" value=".jsp"/>
    </bean>
    <!--3：springmvc注解驱动，自动配置mvc的处理器适配器和处理映射器-->
    <mvc:annotation-driven/>
    <!--4：静态资源不过滤-->
    <mvc:default-servlet-handler/>
    <!--5：导入spring.xml-->
    <import resource="spring-service.xml"/>
</beans>
1.3.7.4 创建ItemsController
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

@Controller
@RequestMapping("/list")
public class ItemsController {

    @Autowired
    private ItemsService itemsService;

    @GetMapping("/findAll")
    public String findAll(Model model){
        List<Items> list = itemsService.findAll();
        for (Items items : list) {
            System.out.println(items);
        }
        model.addAttribute("list",list);
        return "list";
    }

    @PostMapping("/save")
    public String  save(Items items){
        itemsService.save(items);
        return "redirect:/list/findAll";
    }
}
1.3.7.5 创建页面items.jsp
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
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<table>
    <form action="${pageContext.request.contextPath}/list/save" method="post">
        <table>
            <tr>
                <td>名称</td>
                <td><input type="text" name="name"/></td>
            </tr>
            <tr>
                <td>价格</td>
                <td><input type="text" name="price"/></td>
            </tr>
            <tr>
                <td>创建日期</td>
                <td><input type="text" name="createTime"/></td>
            </tr>
            <tr>
                <td>详情</td>
                <td><input type="text" name="detail"/></td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" value="提交"/>
                </td>
            </tr>
        </table>
    </form>
</table>
<hr>


<table border="1">
    <tr>
        <td>ID</td>
        <td>name</td>
        <td>price</td>
        <td>createTime</td>
        <td>detail</td>
    </tr>
    <tr>
        <c:forEach items="${list}" var="item">
        <td>${item.id}</td>
        <td>${item.name}</td>
        <td>${item.price}</td>
        <td>${item.pic}</td>
        <td>${item.createTime}</td>
        <td>${item.detail}</td>
    </tr>
    </c:forEach>
</table>
</body>
</html>
1.3.7.6 小结
<package>war</pcakage>
引入依赖 ssm_service 、 springmvc 、 servlet_api等
springmvc.xml（springmvc的相关配置）
web.xml（springmvc的核心控制器、post乱码过滤器）
类ItemsController.java
测试页面items.jsp
1.3.8 测试
操作路径
测试打包package、安装install（演示maven聚合）
发布到外部tomcat
使用maven的tomcat插件发布
1.3.8.1 方式一：tomcat插件发布（配置父工程）
parent是有聚合的功能，不需要将ssm_parent，ssm_model，ssm_dao，ssm_service安装到本地仓库。

1.3.8.2 方式二：tomcat插件发布（配置web工程）
需要将ssm_parent，ssm_model，ssm_dao，ssm_service安装到本地仓库。

1.3.8.3 方式三：发布到外部tomcat
当使用外部tomcat进行开发的时候，不需要将ssm_parent，ssm_model，ssm_dao，ssm_service安装到本地仓库。

1.3.8.4 小结
1：拆分与聚合和继承

​ 拆分：解耦，代码最大程度的重复使用，维护方便

​ 聚合：靠父工程来聚合，单一工程是没法完成工作。

​ 继承：父工程引入依赖，子工程就不需要再引了

2: Maven的jar包冲突解决

路径近者优先
路径相同，第一声明优先
路径相同，使用强制排除exclusions
3：准备数据库环境

ssm_parent（父工程）聚合，引入依赖管理

ssm_model（子工程） 实体类

ssm_dao（子工程） mybatis, dataSource, sqlSessionFactorybean, MapperScannerConfigurer

注：映射文件的路径必须与包名路径一样

ssm_service（子工程）

扫service包，事务管理器，通知、切面。

ssm_web（子工程）

SpringMVC.xml 扫controller, 视图解析器，注解驱动，静态资源过滤
web.xml 编码过滤器，前端核心控制器(load-on-startup)
8：测试（工程发布tomcat）

推荐使用本地tomcat
1.4 补充
Maven项目，如果正在下载一个jar，但是突然断网，此时，就会产生一个m2e-lastUpdated.，别指望下次上网就会自动下载，必须手动删除该文件，然后再进行下载。

二.Git
学习目标：

能够概述git基本概念
能够概述git工作流程
能够使用git基本命令
能够使用idea操作git
2.1 Git版本控制系统目标
速度
简单的设计
对非线性开发模式的强力支持（允许上千个并行开发的分支）
完全分布式
有能力高效管理类似 Linux 内核一样的超大规模项目（速度和数据量）
2.2 Git与svn对比
SVN是集中式版本控制系统，版本库是集中放在中央服务器的

集中管理方式在一定程度上看到其他开发人员在干什么，而管理员也可以很轻松掌握每个人的开发权限。

但是相较于其优点而言，集中式版本控制工具缺点很明显：

服务器单点故障
容错性差
Git是分布式版本控制系统，那么它就没有中央服务器的

小结

git: 是一个代码(文档)版本的管理工具

svn：集中式版本控制工具（服务器完成对文件的版本控制）（一个仓库）

git：分布式版本控制工具（客户端、服务器都可以完成对文件的版本控制）（两个仓库，本地仓库、远程仓库）

2.3 git工作流程
一般工作流程如下：

从远程仓库中克隆 Git 资源作为本地仓库。

从本地仓库中checkout代码然后进行代码修改

在提交前先将代码提交到暂存区。

提交执行commit命令。提交到本地仓库。本地仓库中保存修改的各个历史版本。

在修改完成后，需要和团队成员共享代码时，可以将本地仓库的代码push到远程仓库。

小结

本地仓库——存入工程代码zip
工作区—— idea工作目录(代码明文)
暂存区
​ 命令：

远程仓库：(代码与他人共享的地方)

add（添加到暂存区）；

commit（提交到本地仓库）

clone（远程仓库的代码克隆到本地仓库 所有的版本）；

pull（将代码从远程仓库拉取到本地开发 只拉取某一版本的代码, 会尝试合并(远程与本地)）；

push（将代码从本地仓库推送到远程仓库）

clone与pull的区别

​ clone：第一次连接远程仓库 所有的版本 初始化

​ pull：第一次用clone命令，如果已经连接是哪个，其他都用pull命令拉取 只拉取某一版本的代码 会尝试合并(远程与本地)

2.4 使用git管理文件版本
目标

使用git在本地仓库完成版本控制，及相关命令的是使用

学习路径

创建版本库
添加/修改/删除文件/删除文件并保留副本
将java工程提交到版本库
忽略文件（提交版本库时，可忽略某些文件）
2.4.1 创建版本库
什么是版本库呢？版本库又名仓库，英文名repository，你可以简单理解成一个目录，这个目录里面的所有文件都可以被Git管理起来，每个文件的新增、修改、删除，Git都能跟踪，以便任何时刻都可以追踪历史，或者在将来某个时刻可以“还原”。由于git是分布式版本管理工具，所以git在不需要联网的情况下也具有完整的版本管理能力。

创建本地仓库执行命令

1
$ git init
查看

1
2
$ ls -a | grep git
 .git
创建服务器仓库

1
$ git --bare init
小结

git init 有工作空间，可以编码，一般用于客户端

git –bare init没有有工作空间，不可以编码，一般用于服务端

概念：

版本库

“.git”目录就是版本库，将来文件都需要保存到版本库中。

工作目录（工作区）

包含“.git”目录的目录，也就是.git目录的上一级目录就是工作目录。只有工作目录中的文件或者是文件夹才能保存到版本库中。

2.4.2 添加文件
2.4.2.1 添加文件过程
在git init的目录下创建一个文件

1
$ touch readme.txt
使用git add 命令即加入缓存区

1
$ git add readme.txt
使用git commit 添加注释并提交

1
$ git commit -m "Comment Message"
2.4.2.2 工作区和暂存区
Git和其他版本控制系统如SVN的一个不同之处就是有暂存区的概念。

什么是工作区（Working Directory）？

​ 工作区就是你在电脑里能看到的目录，比如我的reporstory/repo1文件夹就是一个工作区。

什么是版本库？

​ 在这个工作区目录中的“.git”隐藏文件夹是版本库。

​ Git的版本库里存了很多东西，其中最重要的就是称为stage（或者叫index）的暂存区，还有Git为我们自动创建的第一个分支master，以及指向master的一个指针叫HEAD。

可以简单理解为，需要提交的文件修改通通放到暂存区，然后，一次性提交暂存区的所有修改。

2.4.2.3 修改文件
2.4.2.3.1 提交修改
修改文件

显示修改文件

1
$ git status
显示修改内容

1
$ git diff readme.txt
使用git add 命令即加入缓存区

1
$ git add readme.txt
使用git commit 添加注释并提交

1
$ git commit -m "New Comment Message"
2.4.2.3.2 查看修改历史
查看修改历史

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
$ git log | less | grep -v "swzxsyh"       
commit 360abaca1a57aa9a9652c57fc3b06cf8a2c16742
Date:   Tue Jan 29 17:01:39 2019 +0800

Learning Part of C Language

commit 9b1e91b72926493818ccbafd1447c2ae3fe8af55
Date:   Tue Jan 29 16:57:04 2019 +0800

Cisco Packet Tracer ReadME
恢复版本

1
$ git checkout -- <file>
2.4.2.3.3 差异比较
1
$ git diff 新版本号 旧版本号 
2.4.2.3.4 还原修改
1
$ git reset HEAD <file>...
注意：此操作会撤销所有未提交的修改，所以当使用还原操作是需要慎重

2.4.2.4 删除文件
需要删除无用的文件时可以使用git提供的删除功能直接将文件从版本库中删除。

1
2
3
4
5
6
7
$ rm readme.txt

$ git rm readme.txt

$ git commit -m "rm readme.txt"

$ git push resp
2.4.2.5 删除文件并保留副本
1
2
3
4
#对于一个文件：
git rm --cached mylogfile.log
#对于一个目录：
git rm --cached -r mydirectory
2.4.2.6 案例：将java工程-提交到版本库
创建HelloProjet项目，将工程添加到暂存区。

1
$ git add HelloProjet/
忽略文件或文件夹

并不是所有文件都需要保存到版本库中的例如“out”目录及目录下的文件就可以忽略。

需要创建.gitignore文件，并添加ignore内容

1
$ echo "out.idea" >> .gitignore
提交代码

1
$ git commit -m "HelloProjet"
2.4.2.7 忽略文件（.gitignore）语法规范
空行或是以 # 开头的行即注释行将被忽略。

可以在前面添加正斜杠 / 来避免递归,下面的例子中可以很明白的看出来与下一条的区别。

可以在后面添加正斜杠 / 来忽略文件夹，例如 build/ 即忽略build文件夹。

可以使用 ! 来否定忽略，即比如在前面用了 *.apk ，然后使用 !a.apk ，则这个a.apk不会被忽略。

*用来匹配零个或多个字符，如 *.[oa] 忽略所有以”.o”或”.a”结尾， *~ 忽略所有以 ~ 结尾的文件（这种文件通常被许多编辑器标记为临时文件）； [] 用来匹配括号内的任一字符，如 [abc] ，也可以在括号内加连接符，如 [0-9] 匹配0至9的数； ? 用来匹配单个字符。

看了这么多，还是应该来个例子：

gitignore文件

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
# 忽略 .a 文件
*.a
# 不忽略 lib.a, 尽管已经在前面忽略了 .a 文件
!lib.a
# 仅在当前目录下忽略 TODO 文件， 但不包括子目录下的 subdir/TODO
/TODO
# 忽略 build/ 文件夹下的所有文件
build/
# 忽略 doc/notes.txt, 不包括 doc/server/arch.txt
doc/*.txt
# 忽略所有的 .pdf 文件，包括在 doc/ directory 下的
doc/**/*.pdf
2.4.2.8 小结
创建版本库

git init：初始化仓库(包含工作目录) –bare[创建的是纯仓库]

添加文件

git add：把文件添加进暂存区

git commit提交文件至本地仓库 添加提交日志

修改文件

删除文件

删除文件并保留副本

忽略文件（提交版本库时，可忽略某些文件。提交工程源码与jar和pom.xml，其它不提交）

将java工程提交到版本库【重点-不要提交忽略文件】

2.5 远程仓库
目标

使用git在远程仓库完成版本控制，及相关命令的使用，远程仓库可实现项目组人员之间的文件版本控制

学习路径

添加到远程仓库

（1）在github上创建仓库

（2）什么是ssh协议

（3）使用ssh协议同步到远程仓库

（4）使用https协议同步到远程仓库

从远程仓库上克隆

从远程仓库取代码

解决多人协作中版本冲突问题

搭建私有Git服务器（linux环境）

2.5.1 添加远程仓库
此时在本地已有一个Git仓库，想让其他人来协作开发，此时可以把本地仓库同步到远程仓库，同时还增加了本地仓库的一个备份。

2.5.1.1 在github上创建仓库
官网：https://github.com/

注册账号->登录->新建仓库->Start a project->->点击“create repository”按钮仓库即可

Github支持两种同步方式“https”和“ssh”。

使用https很简单基本不需要配置就可以使用，但是每次提交代码和下载代码时都需要输入用户名和密码

2.5.1.1.2 ssh协议版本
SSH 为 Secure Shell的缩写，利用 SSH 协议可以有效防止远程管理过程中的信息泄露问题。

使用ssh方式就需要客户端先生成一个密钥对，即一个公钥一个私钥。然后还需要把公钥放到githib的服务器上。

Client

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
[root@localhost ~]# ssh-keygen -t rsa       <== 建立密钥对，-t代表类型，有RSA和DSA两种
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): #密钥文件默认存放位置，按Enter即可
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase):  #输入密钥锁码
Enter same passphrase again:    
Your identification has been saved in /root/.ssh/id_rsa.    #生成的私钥
Your public key has been saved in /root/.ssh/id_rsa.pub.    #生成的公钥
The key fingerprint is:
SHA256:
ssh密钥配置

密钥生成后需要在github上配置密钥本地才可以顺利访问。

在key部分将id_rsa.pub文件内容添加进去，然后点击“Add SSH key”按钮完成配置。

使用ssh协议同步到远程仓库

1
2
$ git remote add origin git@github.com:itcast888/mytest.git
$ git push -u origin master
origin就是一个名字，它是在你clone一个托管在Github上代码库时，git为你默认创建的指向这个远程代码库的标签， origin指向的是repository，master只是这个repository中默认创建的第一个分支。

2.5.2 从远程仓库克隆
克隆远程仓库也就是从远程把仓库复制一份到本地，克隆后会创建一个新的本地仓库。选择一个任意部署仓库的目录，然后克隆远程仓库。

1
$ git clone [git@github.com:sublun/mytest.git](mailto:git@github.com:sublun/mytest.git)
2.5.3 从远程仓库取代码
1
2
3
1. git fetch：相当于是从远程获取最新版本到本地，不会自动merge（合并代码）

2. git pull：相当于是从远程获取最新版本并merge到本地，上述命令其实相当于git fetch 和 git merge
在实际使用中，git fetch更安全一些，但是不常用！

因为在merge前，我们可以查看更新情况，然后再决定是否合并。

git pull更常用，因为即得代码又可以自动合并

2.5.4 解决版本冲突
原因

同时获取同一份代码，用户A先提交，用户B再提交，即出现版本冲突

解决

先拉取（pull）远程仓库的代码到本地。

编辑冲突

合并成一个新的文件

再次推送

避免冲突

优先提交代码
提交后通知全组成员pull
2.6 分支管理
目标

在本地仓库中使用分支，可在一个项目中使用多条路径，完成版本控制。

学习路径

分支的概念

分支管理

（1）创建分支（2）合并分支（3）解决冲突（4）删除分支

2.6.1 分支的概念
在我们每次的提交，Git都把它们串成一条时间线，这条时间线就是一个分支。截止到目前，只有一条时间线，在Git里，这个分支叫主分支，即master分支。HEAD指针严格来说不是指向提交，而是指向master，master才是指向提交的，所以，HEAD指向的就是当前分支。

只要有本地仓库就有master分支。

1
2
3
4
5
6
$ git checkout 
A	"Algorithm/\347\256\227\346\263\225\345\233\276\350\247\243/.idea/$CACHE_FILE$"
M	C++ project/.vscode/launch.json
M	C++ project/.vscode/tasks.json
M	Java/MyFirstApp.class
Your branch is up to date with 'origin/master'.                             
Master是条线，Git用master指向最新的提交，再用HEAD指向master，就能确定当前分支

每次提交，master分支都会向前移动一步，这样，随着你不断提交，master分支的线也越来越长。

1
2
3
              Head
                ↓
A-->B-->C-->D-->E(Master)
创建新的分支，如dev，Git新建了一个指针叫dev，指向master相同的提交，再把HEAD指向dev，此时，对工作区的修改和提交就针对dev分支，提交后，dev指针往前移动一步，而master指针不变

1
2
$ git checkout -b dev
Switched to a new branch "dev"
1
2
3
4
5
6
7
              Master
                ↓
A-->B-->C-->D-->E
                 ↘
                  dev               
                   ↑
                  Head  
dev上的工作完成了，就可以把dev合并到master上，删除dev分支，变回一条线

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
#在切换分支之前，保持好一个干净的状态
$ git add xx/*
$ git commit -m "XXX"
#切换回 master 分支
$ git checkout master
Switched to branch 'master'
#假设提交，且无冲突，合并分支
$ git merge dev
#使用带 -d 选项的 git branch 命令来删除分支
$ git branch -d dev
2.7 IntelliJ IDEA中使用git
目标

在idea使用git完成版本控制

git操作本地仓库（自己进行版本控制）

git操作远程仓库（多人进行版本控制）

学习路径

配置Git
创建工程集成Git
推送代码到远程仓库
从远程仓库克隆
从远程仓库拉取
使用分支
2.7.1 在Idea中配置git
安装好IntelliJ IDEA后，如果Git安装在默认路径下，那么idea会自动找到git的位置，如果更改了Git的安装位置则需要手动配置下Git的路径。

选择File→Settings打开设置窗口，找到Version Control下的git选项
选择git的安装目录后可以点击“Test”按钮测试是否正确配置。
使用idea操作github远程服务器的时候，在idea中配置用户名和密码，这样使用https协议访问github的时候，不需要输入用户名和密码了。
2.7.2 创建工程集成GIT
2.7.2.1创建maven工程
创建Maven工程打包方式为jar包，创建User类

创建本地仓库

在菜单中选择“vcs”→Import into Version Control→Create Git Repository

此时样式改变，查看本地工程目录，有绿色箭头。说明创建了本地仓库。

2.7.2.2添加暂存区
项目右键——>Git—>Add

2.7.2.3 提交本地仓库
项目右键——>Git—>Commit Directory

2.7.3 远程仓库操作
2.7.3.1 推送到远程仓库
在github上创建一个远程仓库 HelloGithub 然后将本地仓库推送到远程。

注意：这里使用https的协议连接

在工程上点击右键，选择git→Repository→Remotes，添加URL

在工程上点击右键，选择git→Repository→Push

2.7.3.2 从远程仓库克隆
方式一

选择VCS—>Checkout from Version Control—>GitHub

方式二

在idea的欢迎页上有“Checkout from version control”下拉框，选择git(推荐使用https形式的url)

2.7.3.3 修改文件push到远程仓库
修改User

先commit到本地

Git–>Commit Directory

再push到远程

Git–>Repository–>Push

2.7.3.4 从远程仓库拉取
Git–>Repository–>Pull

2.7.4 在Idea中使用分支
选择VCS—>Git—>Branches

点击“New Branch”，新建一个分支

分支操作

Checkout：为切换分支
Merge：为合并分支
Delete：删除分支
小结
在idea中配置git
将工程添加至git（操作本地仓库，将工程推送到远程仓库）
从远程仓库克隆（远程仓库）
从服务端拉取代码（远程仓库）
在idea中使用分支