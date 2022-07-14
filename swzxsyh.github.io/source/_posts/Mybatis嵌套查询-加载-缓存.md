---
title: Mybatis嵌套查询 & 加载 & 缓存
date: 2020-05-12 01:37:47
tags:
---
一.Mybatis嵌套查询
1.1 什么事嵌套查询
嵌套查询就是将原来多表查询中的联合查询语句拆成多个单表的查询，再使用mybatis的语法嵌套在一起。

例

需求:查询一个订单，与此同时查询出该订单所属的用户

关联查询:

1
select * from orders o inner join user u on o.uid = u.id where o.id = 1;
缺点:
sql语句编写难度大

数据量过大，笛卡尔积数量倍增，可能造成内存溢出

嵌套查询

1
2
3
4
5
--根据订单id查询订单表
  select * from orders where id = 1;
--再根据订单表中uid(外键)查询用户表
	select * from user where id = 订单表uid;
--最后由mybatis框架进行嵌套组合
优点

sql语句编写简单

没有多表关联，不会产生笛卡尔积

1.2 一对一嵌套查询
需求

查询一个订单，与此同时查询出该订单所属的用户

sql语句

1
2
3
4
-- 1.根据订单id查询订单表
	select * from orders where id = 1;
-- 2.再根据订单表中uid(外键)查询用户表 
	select * from user where id = 41;
OrderMapper接口

1
2
3
4
public interface OrderMapper {

    //一对一嵌套查询
    public Order findByIdWithUser(Integer id);
OrderMapper映射

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
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.test.dao.OrderMapper">

    <resultMap id="orderMap" type="Order">
        <id column="id" property="id"></id>
        <result column="ordertime" property="ordertime"></result>
        <result column="money" property="money"></result>

        <!--通过mybatis嵌套查询user表-->
        <association property="user" javaType="User" column="uid" select="com.test.dao.OrderMapper.findById">

        </association>
    </resultMap>

<!--    一对一嵌套查询-->
    <!--    resultType:单表映射封装 -->
    <!--    resultMap:多表查询必须手动映射封装-->

    <select id="findByIdWithUser" parameterType="int" resultMap="orderMap">
        SELECT * FROM orders WHERE id=#{id}
    </select>
UserMapper接口

1
2
3
public interface UserMapper {
    // 根据用户id查询user对象
    public User findById(Integer id);
UserMapper映射

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

<mapper namespace="com.test.dao.UserMapper">

    <!--    根据用户id查询user对象-->
    <select id="findById" parameterType="int" resultType="User">
    SELECT * FROM user WHERE id=#{id}
		</select>
通过mybatis进行嵌套组合

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
<resultMap id="orderMap" type="Order">
    <id column="id" property="id"></id>
    <result column="ordertime" property="ordertime"></result>
    <result column="money" property="money"></result>
  
    <!--通过mybatis嵌套查询user表
    一对一association
    column="uid" 订单查询的用户外键字段，需要作为条件
    select="com.test.dao.OrderMapper.findById"查询用户表(用户接口+执行方法名)
    -->
    <association property="user" javaType="User" column="uid" select="com.test.dao.UserMapper.findById"/>
  
  
    </association>
</resultMap>
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
public class OrderMapperTest extends BaseMapperTest {

    // 一对一嵌套测试
    @Test
    public void testFindByIdWithUser() throws Exception {
        OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);

        // 根据id查询
        Order order = orderMapper.findByIdWithUser(1);
        System.out.println(order);
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
[2020-05-12 21:21:03,060] DEBUG o.OrderMapper.findByIdWithUser  - ==>  Preparing: 


//先查询订单
SELECT * FROM orders WHERE id=? 


[2020-05-12 21:21:03,111] DEBUG o.OrderMapper.findByIdWithUser  - ==> Parameters: 1(Integer)
[2020-05-12 21:21:03,159] DEBUG     com.test.dao.UserMapper  - Cache Hit Ratio [com.test.dao.UserMapper]: 0.0
[2020-05-12 21:21:03,159] DEBUG theima.dao.UserMapper.findById  - ====>  Preparing: 


//再查询用户
SELECT * FROM user WHERE id=? 

[2020-05-12 21:21:03,159] DEBUG theima.dao.UserMapper.findById  - ====> Parameters: 41(Integer)
[2020-05-12 21:21:03,162] DEBUG theima.dao.UserMapper.findById  - <====      Total: 1
[2020-05-12 21:21:03,165] DEBUG o.OrderMapper.findByIdWithUser  - <==      Total: 1



//用mybatis嵌套组合在一起
Order{id=1, ordertime=Mon May 20 15:58:02 CST 2019, money=999.5, user=User{id=41, username='老王', birthday=Tue May 28 06:47:08 CST 2019, sex='男', address='北京', orderList=null, roleList=null}}
嵌套关系

步骤	
//一对一嵌套查询
public Order findByIdWithUser(Integer id);
// 根据用户id查询user对象
public User findById(Integer id);
用mybatis嵌套组合在一起<br><association property=”user” javaType=”User” column=”uid” select=”com.test.dao.UserMapper.findById” fetchType=”eager”/>
1.3 一对多嵌套查询
需求

查询一个用户，与此同时查询出该用户具有的订单

sql语句

1
2
3
4
-- 1. 先根据用户id，查询用户表(一个) 
	SELECT * FROM USER WHERE id = 41;
-- 2. 再根据用户id，查询订单表(多个) 
	SELECT * FROM orders WHERE uid = 41;
UserMapper接口

1
2
// 一对多嵌套查询
public User findByIdWithOrders(Integer id);
UserMapper映射

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
<resultMap id="userWithOrdersMap" type="User">
    <id column="id" property="id"/>
    <result column="username" property="username"/>
    <result column="sex" property="sex"/>
    <result column="birthday" property="birthday"/>
    <result column="address" property="address"/>
    <!--一对多嵌套组合-->
    <collection property="orderList" ofType="Order" column="id" select="com.test.dao.OrderMapper.findByUid"/>
</resultMap>
  
  
<!--一对多嵌套查询-->
<select id="findByIdWithOrders" parameterType="int" resultMap="userWithOrdersMap">
    SELECT * FROM user WHERE id=#{id}
</select>
OrderMapper接口

1
2
// 根据用户id，查询订单列表
public List<Order> findByUid(Integer id);
OrderMapper映射

1
2
3
<select id="findByUid" parameterType="int" resultType="Order">
    SELECT * FROM orders WHERE uid=#{uid}
</select>
通过mybatis进行嵌套组合

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
<resultMap id="userWithOrdersMap" type="User">
    <id column="id" property="id"/>
    <result column="username" property="username"/>
    <result column="sex" property="sex"/>
    <result column="birthday" property="birthday"/>
    <result column="address" property="address"/>
    <!--一对多嵌套组合
    collection
    column="id" 根据用户查询的结果，id作为条件
    select="com.test.dao.OrderMapper.findByUid" 去查询订单表(映射接口+执行方法)
    -->
    <collection property="orderList" ofType="Order" column="id" select="com.test.dao.OrderMapper.findByUid"/>
</resultMap>
测试

1
2
3
4
5
6
7
8
public class UserMapperTest extends BaseMapperTest {

    @Test
    public void testFindByIdWithOrders() throws Exception {
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        User user = userMapper.findByIdWithOrders(41);
        System.out.println(user);
    }
1
2
3
4
5
//先查询用户
	SELECT * FROM USER WHERE id = 41;
//再查询订单
	SELECT * FROM orders WHERE uid = 41;
//用mybatis嵌套组合在一起
嵌套关系

步骤	
//先查询用户
public User findByIdWithOrders(Integer id);
// 再查询订单
public List<Order> findByUid(Integer id);
用mybatis嵌套组合在一起<br><collection property=”orderList” ofType=”Order” column=”id” select=”com.test.dao.OrderMapper.findByUid”/>
1.4 多对多嵌套查询
需求

查询用户同时查询出该用户的所有角色

mybatis的实现方案就是(一对多)，区别在于sql语句不同

sql语句

1
2
3
4
-- 1. 先根据用户id，查询用户表(一个)
SELECT * FROM USER WHERE id = 41;
-- 2. 再根据用户id，查询角色表(多个)
SELECT * FROM role r INNER JOIN user_role ur ON ur.`rid` = r.`id` WHERE ur.`uid` = 41;
UserMapper接口

1
2
// 多对多嵌套查询
public User findByIdWithRoles(Integer id);
UserMapper映射

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
<resultMap id="userWithRolesMap" type="User">
    <id column="id" property="id"/>
    <result column="username" property="username"/>
    <result column="sex" property="sex"/>
    <result column="birthday" property="birthday"/>
    <result column="address" property="address"/>
    <!-- 多对多嵌套-->
    <collection property="roleList" ofType="Role" column="id"
                select="com.test.dao.RoleMapper.findByUid"></collection>
</resultMap>
  
<select id="findByIdWithRoles" parameterType="int" resultMap="userWithRolesMap">
    SELECT * FROM user WHERE id=#{id}
</select>
RoleMapper接口

1
2
3
4
5
public interface RoleMapper {

    // 根据用户id，查询角色列表
    public List<Role> findByUid(Integer id);
}
RoleMapper映射

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
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.test.dao.RoleMapper">

    <resultMap id="roleResultMap" type="Role">
        <id column="id" property="id"/>
        <result column="role_name" property="roleName"/>
        <result column="role_desc" property="roleDesc"/>
    </resultMap>

    <!--    根据用户id，查询角色列表-->
    <select id="findByUid" parameterType="int" resultMap="roleResultMap">
        SELECT * FROM role r INNER JOIN user_role ur ON ur.`rid`=r.`id` WHERE ur.`uid`=#{uid}
    </select>
</mapper>
通过mybatis进行嵌套组合

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
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.test.dao.UserMapper">

    <cache></cache>

    <resultMap id="userWithOrdersMap" type="User">
        <id column="id" property="id"/>
        <result column="username" property="username"/>
        <result column="sex" property="sex"/>
        <result column="birthday" property="birthday"/>
        <result column="address" property="address"/>
        <!--一对多嵌套组合
        collection
        column="id" 根据用户查询的结果，id作为条件
        select="com.test.dao.OrderMapper.findByUid" 去查询订单表(映射接口+执行方法)
        -->
        <collection property="orderList" ofType="Order" column="id" select="com.test.dao.OrderMapper.findByUid"/>
    </resultMap>


    <resultMap id="userWithRolesMap" type="User">
        <id column="id" property="id"/>
        <result column="username" property="username"/>
        <result column="sex" property="sex"/>
        <result column="birthday" property="birthday"/>
        <result column="address" property="address"/>
        <!-- 多对多嵌套
        column="id" 用户id作为条件
        select="com.test.dao.RoleMapper.findByUid"查询角色表(角色映射接口+执行方法)
        -->
        <collection property="roleList" ofType="Role" column="id"
                    select="com.test.dao.RoleMapper.findByUid"></collection>
    </resultMap>


    <!--    根据用户id查询user对象-->
    <select id="findById" parameterType="int" resultType="User">
    SELECT * FROM user WHERE id=#{id}
</select>

    <!--一对多嵌套查询-->
    <select id="findByIdWithOrders" parameterType="int" resultMap="userWithOrdersMap">
        SELECT * FROM user WHERE id=#{id}
    </select>

    <select id="findByIdWithRoles" parameterType="int" resultMap="userWithRolesMap">
        SELECT * FROM user WHERE id=#{id}
    </select>
</mapper>
测试

1
2
3
4
5
6
7
8
// 多对多测试(根据用户查询角色)
@Test
public void testFindByIdWithRoles() throws Exception {
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
  
    User user = userMapper.findByIdWithRoles(41);
    System.out.println(user);
}
嵌套关系

步骤	
//先查询用户
public User findByIdWithRoles(Integer id);
// 再查询角色列表
public List<Order> findByUid(Integer id);
用mybatis嵌套组合在一起
<collection property=”roleList” ofType=”Role” column=”id” select=”com.test.dao.RoleMapper.findByUid”/>
1.5 知识小结
步骤:一对多举例

先查询(一方)单表=>再查询(多方)单表=>最后由mybatis嵌套组合

配置	
一对一配置	使用<resultMap>+<association>做配置，通过column条件，执行select查询
一对多配置	使用<resultMap>+<collection>做配置，通过column条件，执行select查询
多对多配置	使用<resultMap>+<collection>做配置，通过column条件，执行select查询
优点:	缺点
简化sql语句编写
不会产生笛卡尔积	麻烦
开发中到底使用哪一种

传统开发，数据量小

使用关联查询

互联网开发，数据量大

使用嵌套查询

二.Mybatis加载策略
2.1 什么是加载策略
当多个模型(表)之间存在关联关系时, 加载一个模型(表)的同时, 是否要立即加载其关联的模型, 我们把这种决策 称为加载策略

如果加载一个模型(表)的时候, 需要立即加载出其关联的所有模型(表), 这种策略称为立即加载

如果加载一个模型的时候, 不需要立即加载出其关联的所有模型, 等到真正需要的时候再加载, 这种策略称为延迟加载(懒加载)
Mybatis中的加载策略有两种:立即加载和延迟加载, 默认是立即加载

注意:延迟加载是在嵌套查询基础上实现的

什么样的场景使用立即加载

一对一

什么样的场景使用延迟加载(什么时候用，什么时候查询，提高数据库性能)

一对多、多对多

2.2 配置延迟加载
2.2.1 全局
SqlMapConfig.xml,设置开启全局延迟加载

1
2
3
4
5
<settings>
    <!--开启延迟(懒)加载 true 开始 false(默认值) 关闭-->
    <setting name="lazyLoadingEnabled" value="true"/>

</settings>
2.2.2 局部
mapper映射文件，指定某一个select标签配置

1
2
3
4
5
<association></association> 标签 
<collection></collection> 标签
fetchType=""属性 
	eager 立即加载 
	lazy 延迟加载
注意:局部优先级高于全局，就近原则

2.3 触发加载
有这样一个全局配置 lazyLoadTriggerMethods ,它定义的方法会触发立即加载

也就说当你调用它定义的方法时, 会执行数据加载, 它的默认值是 equals,clone,hashCode,toString

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
<settings>
    <!--开启延迟(懒)加载 true 开始 false(默认值) 关闭-->
    <setting name="lazyLoadingEnabled" value="true"/>
    <!--触发立即加载的配置
      默认值:equals,clone,hashCode,toString
      value="" 覆盖了默认值，表示在执行上述四个方法时，不会触发立即加载
      只有在执行get方法获取时，触发数据加载
    -->
    <setting name="lazyLoadTriggerMethods" value=""/>
</settings>
三.Mybatis缓存
什么是缓存

服务器内存(硬盘)中的一块区域

为什么使用缓存

提高查询效率

什么样的数据适合做缓存

经常访问但又不经常修改的数据

缓存是用来提高查询效率的，所有的持久层框架基本上都有缓存机制 Mybatis也提供了缓存策略，分为一级缓存，二 级缓存

3.1 一级缓存
3.1.1 介绍
MyBatis一级缓存是:SqlSession级别的缓存，默认开启，不需要手动配置



3.1.2 验证
需求

根据id查询用户

一级缓存测试

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
// 一级缓存测试
@Test
public void testFindByIdWithBufferLevel1() throws Exception {
    //需要用工具类开启/关闭session，否则会出现session错误
    SqlSession sqlSession = MyBatisUtils.openSession();
    UserMapper userMapper1 = sqlSession.getMapper(UserMapper.class);
    // 走数据库
    User user1 = userMapper1.findById(41);
    System.out.println(user1);
  
    // 清除缓存(自己测试增、删、改)
    sqlSession.clearCache();
  
    // 获取第二个代理对象
    UserMapper userMapper2 = sqlSession.getMapper(UserMapper.class);
    // 走缓存(如果上面清除缓存，还是走数据库)
    User user2 = userMapper2.findById(41);
    System.out.println(user2);
  
    // sqlSession关闭(清除缓存)
    MyBatisUtils.close(sqlSession);
}
3.1.3 分析
一级缓存是SqlSession范围的缓存，不同的SqlSession之间的缓存区域是互相不影响的，执行SqlSession的C(增

加)U(更新)D(删除)操作，或者调用clearCache()、commit()、close()方法，都会清空缓存

SqlSession对象		LocalCache(Map集合)
第一次查询	写入
➡	LocalCache
如果中间发生了DML(增删改)事务操作，清除缓存	清除
➡	LocalCache
第N次查询	读取
⬅	LocalCache
一级缓存源码

1
2
3
4
5
//org.apache.ibatis.cache.impl.PerpetualCache

public class PerpetualCache implements Cache {
    private final String id;
    private Map<Object, Object> cache = new HashMap();
3.2 二级缓存
3.2.1 介绍
MyBatis的二级缓存虽然是默认开启的，但需要在映射文件中配置 <cache/> 标签才能使用，而且要求实体类的必须 实现序列化接口



3.2.2 验证
mybatis全局配置，默认值就是开启了二级缓存

指定需要开启二级缓存的映射配置文件

1
2
3
4
5
6
7
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.test.dao.UserMapper">

    <!--    当前映射文件，使用二级缓存-->
    <cache></cache>
指定User实现序列化接口

1
public class User implements Serializable
二级缓存测试

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
// 二级缓存测试
@Test
public void testFindByIdWithBufferLevel2() throws Exception {
//需要用工具类开启/关闭session，否则会出现session错误
    // 模拟第一个用户
    SqlSession sqlSession1 = MyBatisUtils.openSession();
    UserMapper userMapper1 = sqlSession1.getMapper(UserMapper.class);
    User user1 = userMapper1.findById(41);
    System.out.println(user1);
  
    sqlSession1.close();
  
    // 模拟第二个用户
    SqlSession sqlSession2 = MyBatisUtils.openSession();
    UserMapper userMapper2 = sqlSession2.getMapper(UserMapper.class);
    User user2 = userMapper2.findById(41);
    System.out.println(user2);
    sqlSession2.close();
}
3.2.3 分析
二级缓存是mapper映射级别的缓存，多个SqlSession去操作同一个Mapper映射的sql语句，多个SqlSession可以共

用二级缓存，二级缓存是跨SqlSession的。

二级缓存相比一级缓存的范围更大(按namespace来划分)



3.3 知识小结


mybatis的缓存，不需要手动存储和获取数据。mybatis自动维护的。

使用mybatis，如果是中小型项目，使用自带缓存的机制是可以满足需求的。如果是大型(分布式)项目，mybatis的 缓存灵活性不足，需要使用第三方的缓存技术解决问题。

四.核心配置文件回顾
4.1 properties标签
加载外部的properties文件

1
<properties resource="jdbc.properties"></properties>
4.2 settings标签
全局参数配置

1
2
3
4
5
6
<settings>
<!--开启懒加载-->
<setting name="lazyLoadingEnabled" value="true"/>
<!-- 指定触发延迟加载的方法，只有get方法执行时才会触发立即加载 --> <setting name="lazyLoadTriggerMethods" value=""/> <!--开启二级缓存 true开启(默认) false关闭-->
<setting name="cacheEnabled" value="true"/>
</settings>
4.3 typeAliases标签
1
2
3
4
5
6
7
8
<!-- 单个定义别名 -->
<typeAliases>
<typeAlias type="cn.itcast.domain.User" alias="user"></typeAlias>
    </typeAliases>
<!-- 使用包的形式批量定义别名 -->
<typeAliases>
<package name="cn.itcast.domain"></package>
    </typeAliases>
4.4 mappers标签
加载映射配置

1
2
3
4
1. 加载指定的src目录下的映射文件，例如:
<mapper resource="com/test/mapper/UserMapper.xml"/>
1. 加载并扫描指定包下所有的映射文件(接口)，例如: 
<package name="com.test.mapper"/>
4.5 environments标签
数据源环境配置

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
        <transactionManager type="JDBC"/>
        <!--连接池,内置POOLED-->
        <dataSource type="POOLED">
            <property name="driver" value="${jdbc.driver}"/>
            <property name="url" value="${jdbc.url}"/>
            <property name="username" value="${jdbc.user}"/>
            <property name="password" value="${jdbc.password}"/>
        </dataSource>
    </environment>
</environments>
总结
## 一 MyBatis嵌套查询

### 将原来多表查询中的联合查询语句，拆成多个单表的查询

### 实现

- 一对一配置：使用<resultMap>+<association>做配置，通过column条件，执行select查询

- 一对多配置：使用<resultMap>+<collection>做配置，通过column条件，执行select查询

- 多对多配置：使用<resultMap>+<collection>做配置，通过column条件，执行select查询

## 二 MyBatis加载策略

### 全局延迟加载

- <settings>

​ <!–开启全局延迟加载功能–>

​ <setting name=”lazyLoadingEnabled” value=”true”/>

</settings>

### 局部延迟加载

- <association> 和 <collection> 标签

​ - fetchType=”lazy | eager”

- 局部的加载策略优先级高于全局的加载策略。

## 三 MyBatis缓存

### 一级缓存

- 是SqlSession级别的缓存

### 二级缓存

- 是mapper映射级别的缓存，需要手动配置且实体类实现serializable接口

## 四 核心配置文件回顾

### properties标签

- 加载外部的properties文件

### settings标签

- 全局参数配置

### typeAliases标签

- 为 Java 类型设置一个别名

### mappers标签

- 加载映射配置

### environments标签

- 数据源环境配置
