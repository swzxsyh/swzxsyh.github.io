---
title: Mybatis入门
date: 2020-05-09 01:36:34
tags:
---

一.框架简介
之前的MVC三层架构

表现层:Java与浏览器交互

业务层:根据某个功能除了业务逻辑

持久层:Java与数据库交互

优点	缺点
高内聚，低耦合	所有基础代码都需要手动编写，繁琐导致效率低
框架

半成品软件

框架阶段三层代码

框架阶段实现了绝大部分基础代码，只需要开发一些特有代码即可，提高开发效率

Broswer		Server		Server		Server		数据库
web层		service层		dao层		
Servlet控制器		将多个dao排序组合实现某个功能		提高jdbc操作数据库，实现最基本CURD	➡
⬅	SQL
user/passwd	➡	⬇	↘
↖	功能A
find()
save()	➡
⬅	find()
save()
update()
delete()		
Login.jsp	⬅	jsp视图	↘		↙			
实体类domain,pojo				
常用框架:SpringMVC，Struts2		常用框架：Spring		常用框架：Mybatis,hibernate，jpa		
目前国内主流框架

SSM(springMVC+Spring+mybatis)

二.Mybatis简介
2.1 ORM概述
ORM(object Relational Mapping)对象关系映射

常用ORM框架有:hibernate(全自动ORM映射)、mybatis(半自动ORM映射)、jpa

例

Object:User类

Relational:user表

Mapping:将User类中成员变量与user表中的字段产生映射关系

需求:操作user对象的CURD，就能实现对user表的字段修改，一个实体类对应一张表，一个对象对应一条记录

总结：以面向对象方式，实现对数据库的操作

2.2 Mybatis介绍
简介

MyBatis官网地址:http://www.mybatis.org/mybatis-3/

mybatis是一款优秀的持久层框架，他不需要项JDBC繁琐编写代码，只需要开发人员关注(接口+sql)
它采用了简单的xml配置+接口方式实现增删改查，开发时我们只需要关注SQL本身
三.Mybatis快速入门*
3.1 步骤分析
创建mybatis_db数据库和user表
创建java项目，导入jar包 (mysql驱动、mybatis、log4j日志)
创建User实体类
编写映射文件UserMapper.xml
编写核心文件SqlMapConfig.xml
编写测试代码
3.2 代码实现
创建mybatis_db数据库和user表
详细信息
创建Java项目，导入jar包

log4j-1.2.17.jar
mybatis-3.5.1.jar
mysql-connector-java-5.1.37-bin.jar

log4j.properties

创建User实体类

1
2
3
4
5
6
7
public class User {
    private Integer id;
    private String username;
    private Date birthday;
    private String sex;
    private String address;
//此处省略getter/setter,toString
编写映射文件UserMapper.xml

1
2
3
4
5
6
7
8
9
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="UserMapper">
    <!--查询所有-->
    <select id="findAll" resultType="com.test.domain.User">
        SELECT * FROM user
    </select>
</mapper>
编写核心文件SqlMapConfig.xml

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
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN" "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!--数据库环境配置-->
    <environments default="mysql">
        <!--使用MySQL环境-->
        <environment id="mysql">
            <!--事务管理器,底层JDBC-->
            <transactionManager type="JDBC"></transactionManager>
            <!--连接池,内置POOLED-->
            <dataSource type="POOLED">
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/mybatis_db"/>
                <property name="username" value="root"/>
                <property name="password" value="root"/>
            </dataSource>
        </environment>
    </environments>
    <mappers>
        <mapper resource="com/test/dao/UserMapper.xml"></mapper>
    </mappers>
</configuration>
编写测试代码

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
public class UserMapperTest {
    //查询所有值快速入门
    @Test
    public void testFindAll() throws Exception {
        //加载核心配置文件SqlMapConfig.xml
        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
        //构建SqlSessionFactory工厂对象
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(in);
        //通过工厂构建SqlSession会话对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //执行SQL语句
        /*
        参数一：命名空间+具体ID
        参数二：返回的Java类接收
        */
        List<User> list = sqlSession.selectList("UserMapper.findAll");
        for (User user : list) {
            System.out.println(user);
        }

        //释放资源
        sqlSession.close();
    }
四.Mybatis映射文件概述
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
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="UserMapper">
    <select id="findAll" resultType="com.test.domain.User">
        SELECT * FROM user
    </select>
</mapper>

<!--
映射文件DTD约束头
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
-->
语句	作用
<!DOCTYPE mapper PUBLIC … s-3-mapper.dtd”>	映射文件DTD约束头
mapper	根标签
namespace	命名空间，与下面语句的id一起组成查询的标识
select	查询操作，可选的还有insert,update,delete
id	语句的id标识，与上面的命名空间一起组成查询的标识
resultType	查询结果对应的实体类型
SELECT * FROM user	要执行的SQL语
五.Mybatis增删改查*
编写映射文件UserMapper.xml

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
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="UserMapper">
    <!--查询所有-->
    <select id="findAll" resultType="com.test.domain.User">
        SELECT * FROM user
    </select>
    <!--新增-->
    <insert id="sava" parameterType="com.test.domain.User">
        INSERT INTO
        user(username,birthday,sex,address)
        VALUES (#{username},#{birthday},#{sex},#{address})
    </insert>
    <!--修改-->
    <update id="update" parameterType="com.test.domain.User">
        UPDATE user set username=${},birthday=#{birthday},sex=#{sex},addrress=#{address} WHERE id =#{id}
    </update>
    <!--删除-->
    <delete id="delete" parameterType="java.lang.Integer">
        DELETE FROM user WHERE id = #{id}
    </delete>
</mapper>
编写测试代码

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
public class UserMapperTest {
    //查询所有值快速入门
    @Test
    public void testFindAll() throws Exception {
        //加载核心配置文件SqlMapConfig.xml
        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
        //构建SqlSessionFactory工厂对象
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(in);
        //通过工厂构建SqlSession会话对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //执行SQL语句
        /*
        参数一：命名空间+具体ID
        参数二：返回的Java类接收
        */
        List<User> list = sqlSession.selectList("UserMapper.findAll");
        for (User user : list) {
            System.out.println(user);
        }

        //释放资源
        sqlSession.close();
    }

    @Test
    public void testSave() throws Exception {
        //加载核心配置文件SqlMapConfig.xml
        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
        //构建SqlSessionFactory工厂对象
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(in);
        //通过工厂构建SqlSession会话对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //执行SQL语句
        User user = new User();
        user.setUsername("Jack");
        user.setBirthday(new Date());
        user.setSex("Male");
        user.setAddress("GZ");
        int i = sqlSession.insert("UserMapper.save", user);
        if (i > 0) {
            System.out.println("Ass Successful");
        }
        //注意:Mybatis默认不提交，需要手动提交事务(DML)
        sqlSession.commit();
        //释放资源
        sqlSession.close();
    }

    @Test
    public void tetUpdate() throws Exception {
        //加载核心配置文件SqlMapConfig.xml
        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
        //构建SqlSessionFactory工厂对象
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(in);
        //通过工厂构建SqlSession会话对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //执行SQL语句
        User user = new User();
        user.setId(50);
        user.setUsername("lucy");
        user.setBirthday(new Date());
        user.setSex("Female");
        user.setAddress("PK");
        sqlSession.update("UserMapper.update",user);
        //注意:Mybatis默认不提交，需要手动提交事务(DML)
        sqlSession.commit();
        //释放资源
        sqlSession.close();
    }

    //删除
    @Test
    public void testDelete() throws Exception {
        //加载核心配置文件SqlMapConfig.xml
        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
        //构建SqlSessionFactory工厂对象
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(in);
        //通过工厂构建SqlSession会话对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //执行SQL语句
        sqlSession.delete("UserMapper.delete", 50);
        //注意:Mybatis默认不提交，需要手动提交事务(DML)
        sqlSession.commit();
        //释放资源
        sqlSession.close();
    }
}
5.4 知识小结
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
- 插入语句insert标签
- 在映射文件中使用parameterType属性指定插入数据类型
- sql语句#{实体属性名} 表示?占位符
- 我们插入操作API是 sqlSession.insert("命名空间.id", 实体对象); 
- DML类型语句mybatis需要手动提交事务 sqlSession.commit();


- 修改操作使用update标签
- 修改操作的API使用的 sqlSession.update("命名空间.id", 实体对象);

- 删除语句使用delete标签
- 如果parameterType是引用数据类型 #{实体属性名}
- 如果parameterType是简单数据类型 #{键名知意}
- 删除操作API sqlSession.delete("命名空间.id", Object);
六.抽取工具类
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
public class MyBatisUtils {

    private static SqlSessionFactory sqlSessionFactory = null;

    //在静态代码块中(加载核心配置文件，构建工程对象)
    static {
        //加载核心配置文件
        try {
            InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(in);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //提供获取sqlSession的静态方法
    public static SqlSession openSession() {
        return sqlSessionFactory.openSession();
    }

    //提供提交事务和释放资源方法
    public static void close(SqlSession sqlSession){
        //提交事务
        sqlSession.commit();
        //释放资源
        sqlSession.close();
    }
}
需求

根据指定id，查询User对象

编写映射文件UserMapper.xml

1
2
3
4
<!--查询一个-->
<select id="findById" parameterType="java.lang.Integer" resultType="com.test.domain.User">
    SELECT * FROM user WHERE id=#{id}
</select>
编写测试代码

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
//查询一个
@Test
public void testFindById() throws Exception {
    // 1.获取sqlSession(根据工具类)
    SqlSession sqlSession = MyBatisUtils.openSession();
    // 2.执行sql
    User user = sqlSession.selectOne("UserMapper.findById", 50);
    System.out.println(user);
    // 3.关闭sqlSession
    MyBatisUtils.close(sqlSession);
}
七.Mybatis核心文件概述
7.1 核心配置文件层级关系
MyBatis 的配置文件包含了会深深影响 MyBatis 行为的设置和属性信息。 配置文档的顶层结构如下：

configuration（配置）
properties（属性）
settings（设置）
typeAliases（类型别名）
typeHandlers（类型处理器）
objectFactory（对象工厂）
plugins（插件）
environments（环境配置）
environment（环境变量）
transactionManager（事务管理器）
dataSource（数据源）
databaseIdProvider（数据库厂商标识）
mappers（映射器）
7.2 常用配置标签解析
environments标签

数据库环境的配置，支持多环境配置

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
<!--数据库环境配置-->
<environments default="mysql">
    <!--使用MySQL环境-->
    <environment id="mysql">
        <!--事务管理器,底层JDBC-->
        <transactionManager type="JDBC"></transactionManager>
        <!--连接池,内置POOLED-->
        <dataSource type="POOLED">
            <property name="driver" value="com.mysql.jdbc.Driver"/>
            <property name="url" value="jdbc:mysql://localhost:3306/mybatis_db"/>
            <property name="username" value="root"/>
            <property name="password" value="root"/>
        </dataSource>
    </environment>
</environments>
语句	作用
<environments default=”mysql”>	使用默认数据库环境
<environment>	连接某个数据库的具体环境配置
id=”mysql”	当前环境名称
transactionManager type=”JDBC”	事务管理类型JDBC
dataSource type=”POOLED”	使用数据库连接池:mybatis内置
property	数据库连接基本配置
其中，事务管理器(transactionManager)类型有两种:

transactionManager	作用
JDBC	这个配置就是直接使用了JDBC 的提交和回滚设置，它依赖于从数据源得到的连接来管理事务作用域。
MANAGED	这个配置几乎没做什么。它从来不提交或回滚一个连接，而是让容器来管理事务的整个生命周期。
其中，数据源(dataSource)常用类型有二种

dataSource	作用
UNPOOLED	这个数据源的实现只是每次被请求时打开和关闭连接。
POOLED	这种数据源的实现利用“池”的概念将 JDBC 连接对象组织起来。
properties标签

加载外置的properties配置文件

1
2
3
4
5
6
#jdbc.properties

jdbc.driver=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/Day48
jdbc.user=root
jdbc.password=root
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
    <!--加载外部properties文件-->
    <properties resource="jdbc.properties"></properties>


<!--                <property name="driver" value="com.mysql.jdbc.Driver"/>-->
<!--                <property name="url" value="jdbc:mysql://localhost:3306/mybatis_db"/>-->
<!--                <property name="username" value="root"/>-->
<!--                <property name="password" value="root"/>-->


<!--改为EL表达式 -->
                <property name="driver" value="${jdbc.driver}"></property>
                <property name="url" value="${jdbc.url}"></property>
                <property name="username" value="${jdbc.user}"></property>
                <property name="password" value="${jdbc.password}"></property>

typeAliases标签

为 Java 类型设置一个短的名字(类型别名)

mybatis框架内置了一些java类型的别名

别名Alias	映射的类型Mapped Type
_byte	byte
_long	long
_short	short
_int	int
_integer	int
_double	double
_float	float
_boolean	boolean
string	String
byte	Byte
long	Long
short	Short
int	Integer
integer	Integer
double	Double
float	Float
boolean	Boolean
date	Date
decimal	BigDecimal
bigdecimal	BigDecimal
object	Object
map	Map
hashmap	HashMap
list	List
arraylist	ArrayList
collection	Collection
iterator	Iterator
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
  <!--mybatis核心配置文件-->
  
<!--设置java类型别名-->
  <typeAliases>
      <!--设置一个java类型的别名
      <typeAlias type="com.test.domain.User" alias="User"></typeAlias>
      -->
      <!--将整个包下所有的类名设置了别名，别名（小名）：类名-->
      <package name="com.test.domain"></package>
  </typeAliases>
1
2
3
4
<!--查询一个-->
<select id="findById" parameterType="int" resultType="User">
    SELECT * FROM user WHERE id = #{id}
</select>
mappers标签

用于加载映射文件，加载方式有如下几种

作用	语句
加载指定的src目录下的映射文件	<mapper resource=”com/test/dao/UserMapper.xml”/>
加载指定接口的全限定名(注解开发时使用)	<mapper class=”com.test.mapper.UserMapper”/>
加载并扫描指定包下所有的接口(基于接口扫描方式加载)	<package name=”com.test.mapper”/>
mybatis文件的关系介绍

User实体类	⬅	UserMapper.xml	➡	User表
建立orm关系		
7.3 核心配置文件标签顺序
1
<!ELEMENT configuration (properties?, settings?, typeAliases?, typeHandlers?, objectFactory?, objectWrapperFactory?, reflectorFactory?, plugins?, environments?, databaseIdProvider?, mappers?)>
7.4 知识小结
properties标签:该标签可以加载外部的properties文件

1
<properties resource="jdbc.properties"></properties>
typeAliases标签:设置类型别名

1
<typeAlias type="com.test.domain.User" alias="user"></typeAlias>
environments标签:数据源环境配置

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
<!--数据库环境配置-->    
<environments default="mysql">
        <!--使用MySQL环境-->
        <environment id="mysql">
            <!--事务管理器,底层JDBC-->
            <transactionManager type="JDBC"></transactionManager>
            <!--连接池,内置POOLED-->
            <dataSource type="POOLED">
                <property name="driver" value="${jdbc.driver}"></property>
                <property name="url" value="${jdbc.url}"></property>
                <property name="username" value="${jdbc.user}"></property>
                <property name="password" value="${jdbc.password}"></property>

            </dataSource>
        </environment>
    </environments>
mappers标签:加载映射配置

1
<mapper resource="com/test/dao/UserMapper.xml"></mapper>
八.Mybatis的API概述
8.1 API介绍
Resources

加载mybatis的核心配置文件

1
2
// 加载mybatis的核心配置文件，获取io流
InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
SqlSessionFactoryBuilder

根据mybatis的核心配置文件构建出SqlSessionFactory工厂对象

1
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(in);
SqlSessionFactory

用于创建SqlSession会话对象(相当于Connection对象)

这是一个工厂对象，对于这种创建和销毁都非常耗费资源，一个项目中只需要存在一个即可

1
2
3
4
// DML类型语句，需要手动提交事务 
SqlSession openSession();
// 设置是否开启自动提交事务的会话对象，如果设置true，自动提交 
SqlSession openSession(boolean autoCommit);
SqlSession

这是Mybatis的一个核心对象。我们基于这个对象可以实现对数据的CRUD操作
对于这个对象应做到每个线程独有，每次用时打开，用完关闭
执行语句的方法主要有

1
2
3
4
5
<T> T selectOne(String statement, Object parameter);
<E> List<E> selectList(String statement, Object parameter);
int insert(String statement, Object parameter);
int update(String statement, Object parameter);
int delete(String statement, Object parameter);
操作事务的方法主要有

1
2
void commit();
void roolback();
8.2 工作原理


九.Mybatis实现Dao层
9.1 传统开发方式
编写UserMapper接口

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
public interface UserMapper {
    //查询所有
    public List<User> findAll();

    public Integer save();

    public Integer update();

    public int delete();

    public User findByID();
}
编写UserMapper实现类

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
112
113
114
115
public class UserMapperImpl implements UserMapper {
    @Override
    public List<User> findAll() {
        try {
            // 1.加载核心配置文件
            InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
            // 2.构建工厂
            SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(in); // 3.创建会话
            SqlSession sqlSession = sqlSessionFactory.openSession();
            // 4.执行sql
            List<User> list = sqlSession.selectList("UserMapper.findAll");

            // 5.释放资源
            sqlSession.close();
            return list;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Integer save( ) {
        try {
            // 1.加载核心配置文件
            InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
            // 2.构建工厂
            SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(in); // 3.创建会话
            SqlSession sqlSession = sqlSessionFactory.openSession();
            // 4.执行sql
            User user = new User();
            user.setUsername("SAVE");
            user.setSex("Male");
            user.setBirthday(new Date());
            user.setAddress("HK");
            int insert = sqlSession.insert("UserMapper.save", user);

            sqlSession.commit();
            // 5.释放资源
            sqlSession.close();
            return insert;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Integer update( ) {
        try {
            // 1.加载核心配置文件
            InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
            // 2.构建工厂
            SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(in); // 3.创建会话
            SqlSession sqlSession = sqlSessionFactory.openSession();
            // 4.执行sql
            User user = new User();
            user.setId(53);
            user.setUsername("UPDATE");
            user.setSex("Female");
            user.setBirthday(new Date());
            user.setAddress("HK");
            int update = sqlSession.update("UserMapper.update", user);
            sqlSession.commit();

            // 5.释放资源
            sqlSession.close();
            return update;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }


    @Override
    public int delete( ) {
        try {
            // 1.加载核心配置文件
            InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
            // 2.构建工厂
            SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(in); // 3.创建会话
            SqlSession sqlSession = sqlSessionFactory.openSession();
            // 4.执行sql
            int delete = sqlSession.delete("UserMapper.delete", 50);
            sqlSession.commit();
            // 5.释放资源
            sqlSession.close();
            return delete;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public User findByID( ) {

        try {
            // 1.加载核心配置文件
            InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
            // 2.构建工厂
            SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(in); // 3.创建会话
            SqlSession sqlSession = sqlSessionFactory.openSession();
            // 4.执行sql
            User user = sqlSession.selectOne("UserMapper.findById", 53);
            // 5.释放资源
            sqlSession.close();
            return user;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
编写UserMapper.xml映射文件

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
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="UserMapper">
    <!--查询所有-->
    <select id="findAll" resultType="User">
        SELECT * FROM user
    </select>
    <!--新增-->
    <insert id="save" parameterType="User">
        INSERT INTO
        user(username,birthday,sex,address)
        VALUES (#{username},#{birthday},#{sex},#{address})
    </insert>
    <!--修改-->
    <update id="update" parameterType="User">
        UPDATE user set username=#{username},birthday=#{birthday},sex=#{sex},address=#{address} WHERE id =#{id}
    </update>
    <!--删除-->
    <delete id="delete" parameterType="int">
        DELETE FROM user WHERE id = #{id}
    </delete>

    <!--查询一个-->
    <select id="findById" parameterType="int" resultType="User">
        SELECT * FROM user WHERE id = #{id}
    </select>
</mapper>
模拟service测试

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

public class UserMapperTest {

    @Test
    public void findall() throws Exception{
        UserMapperImpl userMapper = new UserMapperImpl();
        List<User> list = userMapper.findAll();
        System.out.println(list);
    }

    @Test
    public void save() throws Exception{
        UserMapperImpl userMapper = new UserMapperImpl();
        Integer save = userMapper.save();
        System.out.println(save);
    }


    @Test
    public void update() throws Exception{
        UserMapperImpl userMapper = new UserMapperImpl();
        Integer update = userMapper.update();
        System.out.println(update);
    }

    @Test
    public void delete() throws Exception{
        UserMapperImpl userMapper = new UserMapperImpl();
        int delete = userMapper.delete();
        System.out.println(delete);
    }


    @Test
    public void findOne() throws Exception{
        UserMapperImpl userMapper = new UserMapperImpl();
        User byID = userMapper.findByID();
        System.out.println(byID);
    }
}
知识小结

编写UserMapper接口
编写UserMapperImpl实现类
编写UserMapper.xml映射
9.2 接口代理开发方式
基于接口代理方式的开发只需要:编写接口和映射文件，Mybatis 框架会为我们动态生成实现类的对象。

接口开发规范

Mapper映射文件的namespace与Mapper接口全限定名一致

Mapper接口的方法名与id的属性名一致

方法的参数类型与parameterType属性类型一致

方法的返回值类型与resultType属性类型一致

映射文件需要与接口在同一个包下，文件名和接口名相同:扫描包，加载所有的映射文件

<package name=”cn.itcast.dao”>

编写UserMapper接口

1
2
3
4
public interface UserMapper {
// 查询所有
    public List<User> findAll();
}
编写UserMapper.xml映射文件

1
2
3
4
5
6
7
8
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="cn.itcast.dao.UserMapper">
<!--查询所有-->
<select id="findAll" resultType="User">
        select * from user
    </select>
</mapper>
模拟service测试

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
public class UserMapperTest {
    @Test
    public void testFindAll() throws Exception {
        // 需要通过mybatis帮你根据接口规范创建实现类
        SqlSession sqlSession = MyBatisUtils.openSession();
        // 创建代理对象(实现类)
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        // 执行sql
        List<User> list = userMapper.findAll();
        System.out.println(list);
        // 关闭会话
        MyBatisUtils.close(sqlSession);
    }
基于接口代理方式的内部执行原理

使用了JDK动态代理技术，帮我们创建了接口的实现类，底层还是执行SqlSession.insert() | update()

十.接口代理的增删改查
10.1 UserMapper接口
1
2
3
4
5
6
7
8
public interface UserMapper {
    public List<User> findAll();

    public void save(User user);
    public void update(User user);
    public void delete(Integer id);
    public User findById(Integer id);
}
10.2 UserMapper.xml 映射文件
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
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.test.dao.UserMapper">
    <!--查询所有-->
    <select id="findAll" resultType="User">
        SELECT * FROM user
    </select>
    <!--新增-->
    <insert id="save" parameterType="User">
        INSERT INTO
        user(username,birthday,sex,address)
        VALUES (#{username},#{birthday},#{sex},#{address})
    </insert>
    <!--修改-->
    <update id="update" parameterType="User">
        UPDATE user set username=#{username},birthday=#{birthday},sex=#{sex},address=#{address} WHERE id =#{id}
    </update>
    <!--删除-->
    <delete id="delete" parameterType="int">
        DELETE FROM user WHERE id = #{id}
    </delete>

    <!--查询一个-->
    <select id="findById" parameterType="int" resultType="User">
        SELECT * FROM user WHERE id = #{id}
    </select>
</mapper>
10.3 测试代码
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
public class UserMapperTest {
    @Test
    public void testFindAll() throws Exception {
        // 需要通过mybatis帮你根据接口规范创建实现类
        SqlSession sqlSession = MyBatisUtils.openSession();
        // 创建代理对象(实现类)
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        // 执行sql
        List<User> list = userMapper.findAll();
        System.out.println(list);
        // 关闭会话
        MyBatisUtils.close(sqlSession);
    }

    @Test
    public void testSave() throws Exception{
        SqlSession sqlSession = MyBatisUtils.openSession();
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        User user = new User();
        user.setUsername("testSAVE_Interface");
        user.setSex("Male");
        user.setAddress("HK");
        user.setBirthday(new Date());
        userMapper.save(user);

        MyBatisUtils.close(sqlSession);
    }

    @Test
    public void testUpdate() throws Exception{
        SqlSession sqlSession = MyBatisUtils.openSession();
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        User user = new User();
        user.setId(54);
        user.setUsername("testUpdate_Interface");
        user.setSex("Female");
        user.setAddress("HK");
        user.setBirthday(new Date());
        userMapper.update(user);

        MyBatisUtils.close(sqlSession);
    }

    @Test
    public void testDelete() throws Exception{
        SqlSession sqlSession = MyBatisUtils.openSession();
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        userMapper.delete(53);
        MyBatisUtils.close(sqlSession);
    }

    @Test
    public void testFindById() throws Exception{
        SqlSession sqlSession = MyBatisUtils.openSession();
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

        User user = userMapper.findById(52);
        System.out.println(user);

        MyBatisUtils.close(sqlSession);
    }
}
总结
## 一 框架简介

### MVC模式

- model模型

- view视图

- controller控制器

### 三层架构

- web层

- service层

- dao层

### 什么是框架？

- 半成品软件

### 常见框架

- 持久层

​ - mybatis

​ - hibernate

​ - spring jdbc

- 表现层

​ - struts2

​ - spring mvc

- 全栈（业务层）

​ - spring

## 二 Mybatis简介

### mybatis是一款优秀的持久层框架，封装了jdbc实现细节，让开发者只关注 sql本身。

### mybatis是ORM映射框架

## 三 Mybatis快速入门

### 1. 创建mybatis_db数据库和user表

### 2. 创建java项目，引入MyBatis相关jar包

### 3. 创建User实体类

### 4. 编写映射文件UserMapper.xml

### 5. 编写核心文件SqlMapConfig.xml

### 6. 编写测试类

## 四 Mybatis映射文件概述

## 五 Mybatis增删改查

### 了解

## 六 抽取工具类

## 七 Mybatis核心文件概述

### environments标签

- 数据库环境配置

### properties标签

- 引入第三方配置

### typeAliases标签

- 实体别名配置

### mappers标签

- 加载映射配置

## 八 Mybatis的API概述

### Resources

- 加载核心配置文件

### SqlSessionFactoryBuilder

- 构建工厂

### SqlSessionFactory

- 生产会话对象

### SqlSession

- 实现与数据库CRUD操作

## 九 Mybatis实现Dao层的二种方式

### 传统方式

### 接口代理方式

- 1。映射文件的命名空间必须是接口的全限定类名

- 2。接口方法的名称必须与statement标签id一致

- 3。接口方法参数类型必须与statement标签的parameterType类型一致

- 4。接口方法返回值类型必须与statement标签的ResultType类型一致

- 5。接口和映射文件同名，同包

## 十 接口代理的增删改查