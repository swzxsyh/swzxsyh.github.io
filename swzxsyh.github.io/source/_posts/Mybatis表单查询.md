---
title: Mybatis表单查询
date: 2020-05-10 01:37:18
tags:
---

一.Mybatis表单查询
1.1 resultMap标签
如果数据库返回结果的列名和要封装的实体的属性名完全一致的话用 resultType 属性

如果数据库返回结果的列名和要封装的实体的属性名有不一致的情况用 resultMap 属性

使用resultMap手动建立对象关系映射

UserMapper接口

1
2
3
4
public interface UserMapper {
    public List<User> findAll();
    //ResultSet标签
    public List<User> findAllResultMap();
UserMapper.xml

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
<mapper namespace="com.test.dao.UserMapper">
    <!--查询所有-->
    <select id="findAll" resultType="User">
        SELECT * FROM user
    </select>


    <!--    resultMap手动建立映射
    id="userResultMap"
    type="com.test.domain.User"建立映射的java类型
    id 标签 主键
    id column="uid" 列名
    property="id"实体属性名
    result 标签 普通字段
    column="gender"  列名
    property="sex" 实体属性名
    -->
    
    <resultMap id="userResultMap" type="User">
        <id column="uid" property="id"/>
        <result column="name" property="username"/>
        <result column="bir" property="birthday"/>
        <result column="gender" property="sex"/>
        <result column="address" property="address"/>
    </resultMap>
    
    <!--    模拟表与实体的属性名不一致情况-->
    <select id="findAllResultMap" resultMap="userResultMap">
        SELECT id AS uid,username AS `name`,birthday AS bir,sex AS gender,address FROM `user`
    </select>
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
public class UserMapperTest {

    private SqlSession sqlSession = null;
    
    // 此方法在测试方法执行之前，执行
    @Before
    public void before() {
        // 获取sqlSession对象
        // 此方法必须线程内独享
        sqlSession = MyBatisUtils.openSession();
    }
    
    // 此方法在测试地方法执行之后，执行
    @After
    public void after() {
        // 关闭sqlSession
        MyBatisUtils.close(sqlSession);
    }
    
    @Test
    public void testFindAll() throws Exception {
        // 需要通过mybatis帮你根据接口规范创建实现类
        // 创建代理对象(实现类)
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        // 执行sql
        List<User> list = userMapper.findAll();
        System.out.println(list);
    }
    
    //resultMap标签
    @Test
    public void testFindAllResultMap() throws Exception {
        UserMapper sessionMapper = sqlSession.getMapper(UserMapper.class);
        List<User> list = sessionMapper.findAllResultMap();
        for (User user : list) {
            System.out.println(user);
        }
    }
1.2 多条件查询
需求

根据id和username查询user表

UserMapper接口

1
2
3
4
5
//多条件查询:方式一
public List<User> findByIdAndUsernameV1(@Param("id") Integer id, @Param("username") String username);

//多条件查询:方式二
public List<User> findByIdAndUsernameV2(User user);
UserMapper.xml

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
<!--    多条件查询方式
如果传递多个参数，属性省略不写-->
<select id="findByIdAndUsernameV1" resultType="User">
SELECT * FROM user WHERE id=#{id} AND username=#{username}
</select>
  

<select id="findByIdAndUsernameV2" parameterType="User" resultType="User">
SELECT * FROM user WHERE id=#{id} AND username=#{username}
</select>
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
13
14
15
16
17
18
19
//多条件查询
//V1
@Test
public void testfindByIdAndUsernameV1() throws Exception {
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    List<User> list = userMapper.findByIdAndUsernameV1(41, "老王");
    System.out.println(list);
}

//V2
@Test
public void testfindByIdAndUsernameV2() throws Exception {
    UserMapper sessionMapper = sqlSession.getMapper(UserMapper.class);
    User user = new User();
    user.setId(41);
    user.setUsername("W");
    List<User> list = sessionMapper.findByIdAndUsernameV2(user);
    System.out.println(list);
}
1.3 模糊查询
需求

根据username模糊查询user表

UserMapper接口

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
// 模糊查询，方式一
public List<User> findByUsername1(String username);

// 模糊查询，方式二
public List<User> findByUsername2(String username);

// 模糊查询，方式三
public List<User> findByUsername3(String username);

// 模糊查询，方式四
public List<User> findByUsername4(String username);
UserMapper.xml

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
    <!--    模糊查询，方式一
    java代码与sql语句有耦合-->
    <select id="findByUsername1" parameterType="string" resultType="User">
SELECT * FROM user WHERE username like #{username}
    </select>

    <!--    模糊查询，方式二
    mysql5.5版本之前，此拼接不支持多个单引号
    oracle数据库，除了别名的位置，其余位置都不能使用双引号-->
    <select id="findByUsername2" parameterType="string" resultType="User">
SELECT * FROM user WHERE username like "%" #{username} "%"
    </select>

    <!--    此方式，会出现sql注入
    ${} 字符串拼接，如果接收的简单数据类型，表达式名称必须是value
    -->
    <select id="findByUsername3" parameterType="string" resultType="User">
SELECT * FROM user WHERE username like '%${value}%'
    </select>

    <!--    模糊查询，方式四【掌握】-->
    <!--    使用concat()函数拼接-->
    <!--    注意:oracle数据库 concat()函数只能传递二个参数,可以使用函数嵌套来解决-->
    <select id="findByUsername4" parameterType="string" resultType="User">
SELECT * FROM user WHERE username like concat(concat('%',#{username}),'%')
    </select>
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
@Test
public void testfindByUsername1() throws Exception{
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    List<User> list = userMapper.findByUsername1("%王%");
    System.out.println(list);
}
@Test
public void testfindByUsername2() throws Exception{
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    List<User> list = userMapper.findByUsername2("王");
    System.out.println(list);
}
@Test
public void testfindByUsername3() throws Exception{
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    List<User> list = userMapper.findByUsername3("王");
    System.out.println(list);
}
@Test
public void testfindByUsername4() throws Exception{
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    List<User> list = userMapper.findByUsername4("王");
    System.out.println(list);
}
1.4 ${} 与 #{} 区别
${} :底层 Statement

sql与参数拼接在一起，会出现sql注入问题
每次执行sql语句都会编译一次
接收简单数据类型，命名:{value}
接收引用数据类型，命名: ${属性名}
字符串类型需要加 ‘${value}’
#{}底层 PreparedStatement

sql与参数分离，不会出现sql注入问题
sql只需要编译一次
接收简单数据类型，命名:#{随便写}
接收引用数据类型，命名:#{属性名}
二.Mybatis映射文件深入
2.1 返回主键
应用场景

向数据库保存一个user对象后, 然后在控制台记录下此新增user的主键值(id)

UserMapper接口

1
2
3
4
5
6
public interface UserMapper {
//    返回主键，方式一
    public void save1(User user);
//    返回主键，方式二
    public void save2(User user);
}
UserMapper.xml

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

<mapper namespace="com.test.dao.UserMapper">
    <!--
    返回主键，方式一
    useGeneratedKeys属性
    useGeneratedKeys="true" 开启新增主键返回功能
    keyColumn="id" user表中主键列
    keyProperty="id" user实体主键属性
    注意:仅支持主键自增类型的数据库 MySQL 和 SqlServer ， oracle不支持-->

    <insert id="save1" parameterType="User" useGeneratedKeys="true" keyColumn="id" keyProperty="id">
        INSERT INTO user (username,birthday,sex,address) VALUES (#{username},#{birthday},#{sex},#{address})
    </insert>
    
    <insert id="save2" parameterType="User">
        <selectKey keyColumn="id" keyProperty="id" resultType="int" order="AFTER">
            SELECT LAST_INSERT_ID()
        </selectKey>
        INSERT INTO user (username,birthday,sex,address) VALUES (#{username},#{birthday},#{sex},#{address})
    </insert>
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

    private SqlSession sqlSession=null;
    @Before
    public void before(){
        sqlSession= MyBatisUtils.openSession();
    }
    @After
    public void after(){
        MyBatisUtils.close(sqlSession);
    }
    
    @Test
    public void testSave1() throws Exception{
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    
        User user = new User();
        user.setUsername("Johe Eve");
        user.setBirthday(new Date());
        user.setAddress("SZ");
        user.setSex("Male");
    
        userMapper.save1(user);
        System.out.println("When Insert,Primary Key Returns: "+user.getId());
    }
    
    @Test
    public void testSave2() throws Exception{
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    
        User user = new User();
        user.setUsername("Johe Eve");
        user.setBirthday(new Date());
        user.setAddress("SZ");
        user.setSex("Male");
    
        userMapper.save2(user);
        System.out.println("When Insert,Primary Key Returns: "+user.getId());
    }
}
2.2 动态SQL
2.2.1 什么是动态SQL
需求

把id和username封装到user对象中，将user对象中不为空的属性作为查询条件

这个时候我们执行的sql就有多种可能

1
2
3
4
5
6
7
8
-- 如果id和用户名不为空
select * from user where id= #{id} and username = #{username}
-- 如果只有id
select * from user where id= #{id}
-- 如果只有用户名
select * from user where username = #{username}
-- 如果id和用户名都为空 
select * from user
像上面这样, 根据传入的参数不同, 需要执行的SQL的结构就会不同，这就是动态SQL

2.2.2 if 条件判断
需求

把id和username封装到user对象中，将user对象中不为空的属性作为查询条件

UserMapper接口

1
2
// if 条件判断
public List<User> findByIdAndUsernameIf(User user);
UserMapper.xml

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
<!--
if标签 条件判断
where标签 相当于 where 1=1 功能，如果没有条件情况下 where语句不在sql语句拼接
可以去掉第一个 and 或者 or
-->
<select id="findByIdAndUsernameIf" parameterType="User" resultType="User">
    SELECT * FROM user
    <where>
        <if test="id != null">
            AND id=#{id}
        </if>
        <if test="username != null">
            AND username = #{username}
        </if>
    </where>
</select>
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
13
14
15
16
// if判断
@Test
public void testfindByIdAndUsernameIf() throws Exception {
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    
    // 拼接条件
    User param = new User();
    param.setId(41);
    param.setUsername("老王");
    
    List<User> list = userMapper.findByIdAndUsernameIf(param);
    
    for (User user : list) {
        System.out.println(user);
    }
}
2.2.3 set 用于update语句
需求

动态更新user表数据，如果该属性有值就更新，没有值不做处理

UserMapper接口

1
2
// set 更新
public void updateIf(User user);
UserMapper.xml

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
<!--    set标签 更新 ，将条件中的最后一个逗号抹除-->
<update id="updateIf" parameterType="User">
    update user
    <set>
        <if test="username != null">
            username=#{username},
        </if>
        <if test="birthday != null">
            birthday=#{birthday},
        </if>
        <if test="sex != null">
            sex=#{sex},
        </if>
        <if test="address != null">
            address=#{address},
        </if>
    </set>
    where id = #{id}
</update>
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
//update
@Test
public void testUpdateIf() throws Exception{
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    
    // 设置更新内容
    User user = new User();
    user.setId(57);
    user.setUsername("Steve");
    
    userMapper.updateIf(user);
}
2.2.4 foreach 用于循环遍历
需求

根据多个id查询，user对象的集合

1
SELECT * FROM user WHERE id IN (41,43,46);
<foreach>标签用于遍历集合	属性
collection	代表要遍历的集合元素
open	代表语句的开始部分
close	代表结束部分
item	代表遍历集合的每个元素，生成的变量名
sperator	代表分隔符
练习三个版本

普通list集合	普通array数组	实体属性list集合
domain/QueryVo

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
/*
    根据页面查询条件封装到实体中 View Object
 */
public class QueryVo {

    private List<Integer> ids;
    
    public List<Integer> getIds() {
        return ids;
    }
    
    public void setIds(List<Integer> ids) {
        this.ids = ids;
    }
}
UserMapper接口

1
2
3
4
5
6
// foreach标签，普通list集合
public List<User> findByList(List<Integer> ids);
// foreach标签，普通array数组
public List<User> findByArray(Integer [] ids);
// foreach标签，实体属性list集合
public List<User> findByQueryVo(QueryVo queryVo);
UserMapper.xml

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
<!-- foreach标签，普通list集合
    传递 普通类型list集合 collection="list"
    属性取值:collection、list
-->
<select id="findByList" parameterType="list" resultType="User">
    SELECT * FROM user WHERE id in
    <foreach collection="list" open="(" close=")" item="id" separator=",">
        #{id}
    </foreach>
</select>

<!--    foreach标签，普通array数组
     传统 普通类型array数组 collection="array"
     属性取值 array-->
<select id="findByArray" parameterType="int" resultType="User">
    SELECT * FROM user WHERE id in
    <foreach collection="array" open="(" close=")" item="id" separator=",">
        #{id}
    </foreach>
</select>

<!--    foreach标签，实体属性list集合
     传递 实体中list属性集合的话，collection="ids"
     取值，实体的属性名-->
<select id="findByQueryVo" parameterType="QueryVo" resultType="User">
    SELECT * FROM user WHERE id in
    <foreach collection="ids" open="(" close=")" item="id" separator=",">
        #{id}
    </foreach>
</select>
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
// foreach标签，普通list集合
@Test
public void testFindByList() throws Exception {
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    
    List ids = new ArrayList();
    ids.add(41);
    ids.add(46);
    List list = userMapper.findByList(ids);
    System.out.println(list);
}
    
// foreach标签，普通array数组
@Test
public void testFindByArray() throws Exception {
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    
    Integer[] ids = {41, 46, 49};
    List<User> list = userMapper.findByArray(ids);
    System.out.println(list);

}
    
//    foreach标签，实体属性list集合
@Test
public void testFindByQueryVo() throws Exception {
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    
    List ids= new ArrayList();
    ids.add(41);
    ids.add(46);
    QueryVo queryVo = new QueryVo();
    queryVo.setIds(ids);
    List<User> list = userMapper.findByQueryVo(queryVo);
    System.out.println(list);
}
2.3 SQL片段
应用场景

映射文件中可将重复的 sql 提取出来，使用时用 include 引用即可，最终达到 sql 重用的目的

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
    <!-- foreach标签，普通list集合
        传递 普通类型list集合 collection="list"
        属性取值:collection、list
    -->
    <select id="findByList" parameterType="list" resultType="User">
        <include refid="selectUser"></include>
        WHERE id in
        <foreach collection="list" open="(" close=")" item="id" separator=",">
            #{id}
        </foreach>
    </select>

    <!--    foreach标签，普通array数组
         传统 普通类型array数组 collection="array"
         属性取值 array-->
    <select id="findByArray" parameterType="int" resultType="User">
        <include refid="selectUser"></include>
        WHERE id in
        <foreach collection="array" open="(" close=")" item="id" separator=",">
            #{id}
        </foreach>
    </select>
    
    <!--    foreach标签，实体属性list集合
         传递 实体中list属性集合的话，collection="ids"
         取值，实体的属性名-->
    <select id="findByQueryVo" parameterType="QueryVo" resultType="User">
        <include refid="selectUser"></include>
        WHERE id in
        <foreach collection="ids" open="(" close=")" item="id" separator=",">
            #{id}
        </foreach>
    </select>
    
    <!-- 将当前映射文件的共同的sql代码抽取一个片段，实现sql的复用性...
id="selectUser" 当前sql片段的唯一标识 -->
    <sql id="selectUser">
     select id,username,birthday,sex,address from user
    </sql>
2.4 知识小结
MyBatis映射文件配置

关键字	配置
<select>	查询
<insert>	插入
<update>	修改
<delete>	删除
<selectKey>	返回主键
<where>	where条件
<if>	if判断
<foreach>	for循环
<set>	set设置
<sql>	sql片段抽取
三.表关系回顾
在关系型数据库当中，表关系分为三种

关系	说明
特殊情况	一个订单只能从属于一个用户，mybatis框架就把这个多对一看做成一对一来实现
数据建立表关系	通过主外键关联
实体建立关系	通过属性关联


四.Mybatis多表查询
4.1 一对一(多对一)
一对一查询模型

用户表和订单表的关系为，一个用户有多个订单，一个订单只从属于一个用户

一对一查询的需求:查询一个订单，与此同时查询出该订单所属的用户

实体和表映射关系

1
SELECT * FROM orders o INNER JOIN `user` u ON o.`uid` = u.`id` WHERE o.`id` = 1
Order实体类

1
2
3
4
5
6
7
8
9
public class Order {
    private Integer id;
    private Date ordertime;
    private Double money;

    // 一个订单从属于一个用户
    private User user;

 //此处省略getter/setter，toString，User实体类
OrderMapper接口

1
2
3
4
public interface OrderMapper {
    // 一对一关联查询
    public Order findByIdWithUser(Integer id);
}
OrderMapper.xml

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
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.test.dao.OrderMapper">

    <resultMap id="orderMap" type="Order">
        <id column="id" property="id"/>
        <result column="ordertime" property="ordertime"/>
        <result column="money" property="money"/>
    
        <!--
        一对一多表关联 association标签
        property="user" 关联实体的属性名 javaType="cn.test.domain.User" 关联实体java类型
        -->
        <association property="user" javaType="User">
            <id column="uid" property="id"/>
            <result column="username" property="username"/>
            <result column="birthday" property="birthday"/>
            <result column="sex" property="sex"/>
            <result column="address" property="address"/>
        </association>
    </resultMap>
    
    <!--    一对一关联查询
        resultType:单表映射封装
        resultMap:多表查询必须手动映射封装-->
    <select id="findByIdWithUser" parameterType="int" resultMap="orderMap">
        SELECT * FROM orders o INNER JOIN `user` u ON o.`uid`=u.`id` WHERE o.`id`=#{id}
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
public class OrderMapperTest {
    private SqlSession sqlSession = null;

    @Before
    public void before() {
        sqlSession = MyBatisUtils.openSession();
    }
    
    @After
    public void after() {
        MyBatisUtils.close(sqlSession);
    }
    
    // 一对一关联测试
    @Test
    public void testFindByIdWithUser() throws Exception{
        OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
    
        Order order = orderMapper.findByIdWithUser(1);
        System.out.println(order);
    }
}
4.2 一对多
一对多查询模型

用户表和订单表的关系为，一个用户有多个订单，一个订单只从属于一个用户

一对多查询的需求：查询一个用户，与此同时查询出该用户具有的订单

实体和表关系

1
SELECT *,o.id AS oid FROM `user` u INNER JOIN orders o ON u.`id` = o.`uid` WHERE u.`id`=41
User实体类

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
public class User {
    private Integer id;
    private String username;
    private Date birthday;
    private String sex;
    private String address;

    // 一个用户具有多个订单
    private List<Order> orderList;

  //此处省略getter/setter,toString
UserMapper接口

1
2
3
4
public interface UserMapper {
    // 一对多关联
    public User findByIdWithOrders(Integer id);
}
UserMapper.xml

有多少记录，就创建多少order对象
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
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.test.dao.UserMapper">

    <resultMap id="userMap" type="User">
        <id column="id" property="id"></id>
        <result column="username" property="username"></result>
        <result column="birthday" property="birthday"></result>
        <result column="sex" property="sex"></result>
        <result column="address" property="address"></result>
    
        <!--
        一对多关联 collection标签
        property="orderList" 关联实体集合的属性名
        ofType="cn.itcast.domain.Order" 关联实体的java类型(集合泛型的类型)
        -->
        <collection property="orderList" ofType="Order">
            <id column="oid" property="id"></id>
            <result column="ordertime" property="ordertime"></result>
            <result column="money" property="money"></result>
        </collection>
    </resultMap>
    
    <!--       一对多关联-->
    <select id="findByIdWithOrders" parameterType="int" resultMap="userMap">
        SELECT *,o.id AS oid FROM `user` u INNER JOIN orders `o` ON u.`id`=o.`uid` WHERE u.`id`=#{id}
    </select>
</mapper>
测试

test/BaseMapperTest

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
public class BaseMapperTest {
    protected SqlSession sqlSession = null;

    @Before
    public void before() {
        sqlSession = MyBatisUtils.openSession();
    }
    
    @After
    public void after() {
        MyBatisUtils.close(sqlSession);
    }
}
UserMapperTest

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
public class UserMapperTest extends BaseMapperTest{

    // 一对多测试
    @Test
    public void testFindByIdWithOrders() throws Exception{
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        User user = userMapper.findByIdWithOrders(41);
        System.out.println(user);
    }

}
4.3 多对多(由二个一对多组成)
实体和表关系

1
2
3
4
SELECT * FROM `user` u
INNER JOIN user_role ur ON u.`id` = ur.`uid` -- 用户连接中间表 
INNER JOIN role r ON ur.`rid` = r.`id` -- 再根据中间表连接角色 
WHERE u.id = 41 -- 用户id 作为条件
User和Role实体

Role

1
2
3
4
5
public class Role {
    private Integer id;
    private String roleName;
    private String roleDesc;
}
User

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
public class User {
    private Integer id;
    private String username;
    private Date birthday;
    private String sex;
    private String address;

    // 一个用户具有多个订单
    private List<Order> orderList;
    
    // 一个用户具有多个角色
    private List<Role> roleList;
UserMapper接口

1
2
// 多对多关联
public User findByIdWithRoles(Integer id);
UserMapper.xml

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
<resultMap id="userWithRoleMap" type="User">
    <id column="id" property="id"></id>
    <result column="username" property="username"></result>
    <result column="birthday" property="birthday"></result>
    <result column="sex" property="sex"></result>
    <result column="address" property="address"></result>

    <!--多对多实现步骤和一对多是一样的(区别在于sql语句)-->
    <collection property="roleList" ofType="Role">
        <id column="rid" property="id"></id>
        <result column="role_name" property="roleName"></result>
        <result column="role_desc" property="roleDesc"></result>
    </collection>
</resultMap>


<select id="findByIdWithRoles" parameterType="int" resultMap="userWithRoleMap">
    SELECT * FROM `user` u INNER JOIN user_role ur
    ON u.`id`=ur.`uid` INNER JOIN role r ON ur.`rid`=r.`id`
    WHERE u.id=#{id}
</select>
测试

1
2
3
4
5
6
7
@Test
public void testFindByIdWithRoles() throws Exception{
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

    User user = userMapper.findByIdWithRoles(41);
    System.out.println(user);
}
4.4 知识小结
一对一配置:使用<resultMap>+<association>做配置			
association:		
property	关联的实体属性名
javaType	关联的实体类型(别名)
一对多配置:使用<resultMap>+<collection>做配置			
collection:		
property	关联的集合属性名
ofType	关联的集合泛型类型(别名)
多对多配置:使用<resultMap>+<collection>做配置			
collection:		
property	关联的集合属性名
ofType	关联的集合泛型类型(别名)
多对多的配置跟一对多很相似，难度在于SQL语句的编写。

4.5 优化测试
BaseMapperTest

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
public class BaseMapperTest {
    protected SqlSession sqlSession = null;

    @Before
    public void before() {
        sqlSession = MyBatisUtils.openSession();
    }
    
    @After
    public void after() {
        MyBatisUtils.close(sqlSession);
    }
}
OrderMapperTest

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
public class OrderMapperTest extends BaseMapperTest{
    // 一对一关联测试
    @Test
    public void testFindByIdWithUser() throws Exception{
        OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);

        Order order = orderMapper.findByIdWithUser(1);
        System.out.println(order);
    }
}