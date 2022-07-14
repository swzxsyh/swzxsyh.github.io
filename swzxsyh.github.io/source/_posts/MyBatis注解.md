---
title: MyBatis注解
date: 2020-05-13 01:38:24
tags:
---


一.MyBatis注解
1.1 MyBatis常用注解
注解	作用
@Insert	实现新增，代替了<insert></insert>
@Update	实现更新，代替了<update></update>
@Delete	实现删除，代替了<delete></delete>
@Select	实现查询，代替了<select></select>
@Result	实现结果集封装，代替了<result></result>
@Results	可以与@Result 一起使用，封装多个结果集，代替了<resultMap></resultMap>
@One	实现一对一结果集封装，代替了<association></association>
@Many	实现一对多结果集封装，代替了<collection></collection>
1.2 MyBatis 单表操作
需求

基于user模块通过注解实现，增删改查

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
public interface UserMapper {

    //查询所有
    @Select("SELECT id AS uid,username AS uname,birthday AS bir,sex AS gender,address AS addr FROM user")
    @Results(value = {
            //resultMap标签手动映射封装
            @Result(column = "uid", property = "id", id = true),
            @Result(column = "uname", property = "username"),
            @Result(column = "bir", property = "birthday"),
            @Result(column = "gender", property = "sex"),
            @Result(column = "addr", property = "address")
    })
    public List<User> findAll();


    //id查询
    @Select("SELECT * FROM user WHERE id = #{id}")
    public User findById(Integer id);


    //新增
    @Insert("INSERT INTO user (username,birthday,sex,address) VALUES(#{username},#{birthday},#{sex},#{address})")
    public void save(User user);


    //修改(动态sql推荐使用xml)
    @Update("UPDATE user SET username=#{username},birthday=#{birthday},sex=#{sex},address=#{address} WHERE id = #{id}")
    public void update(User user);

    //删除
    @Delete("DELETE FROM user WHERE id = #{id}")
    public void delete(Integer id);
    
}
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
41
42
43
44
45
46
47
48
49
public class UserMapperTest extends BaseMapperTest {
    //单表测试
    @Test
    public void testFindAll() throws Exception {
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        List<User> list = userMapper.findAll();
        System.out.println(list);
    }

    //单表测试,查询一个
    @Test
    public void testFindById() throws Exception {
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        User user = userMapper.findById(41);
        System.out.println(user);
    }

    //新增
    @Test
    public void testInsert() throws Exception {
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

        User user = new User();
        user.setUsername("A");
        user.setBirthday(new Date());
        user.setAddress("GZ");
        user.setSex("Male");
        userMapper.save(user);
    }

    //修改
    @Test
    public void testUpdate() throws Exception {
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

        User user = new User();
        user.setId(58);
        user.setUsername("B");
        userMapper.save(user);
    }

    //删除
    @Test
    public void testDelete() throws Exception {
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

        userMapper.delete(58);
    }
}
1.3 MyBatis多表操作
注解多表操作是基于嵌套查询来实现

注解	说明
@Results	结果映射的列表，包含了一个特别结果列如何被映射到属性或字段的详情。属性有：value, id。value 属性是 Result 注解的数组。这个 id 的属性是结果映射的名称。
@Result	在列和属性或字段之间的单独结果映射。属性有：id, column, javaType, jdbcType, typeHandler, one, many。id 属性是一个布尔值，来标识应该被用于比较（和在 XML 映射中的相似）的属性。one 属性是单独的联系，和 相似，而 many 属性是对集合而言的，和相似。它们这样命名是为了避免名称冲突。
@One	复杂类型的单独属性值映射。属性有：select，已映射语句（也就是映射器方法）的全限定名，它可以加载合适类型的实例。fetchType会覆盖全局的配置参数 lazyLoadingEnabled。注意 联合映射在注解 API中是不支持的。这是因为 Java 注解的限制,不允许循环引用。
@Many	映射到复杂类型的集合属性。属性有：select，已映射语句（也就是映射器方法）的全限定名，它可以加载合适类型的实例的集合，fetchType 会覆盖全局的配置参数 lazyLoadingEnabled。注意 联合映射在注解 API中是不支持的。这是因为 Java 注解的限制，不允许循环引用
1.3.1 一对一查询
需求

查询一个订单，与此同时查询出该订单所属的用户

一对一查询语句

1
2
SELECT * FROM orders where id = #{id};
SELECT * FROM `user` WHERE id = #{订单的uid};
OrderMapper接口

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
public interface OrderMapper {

    //一对一嵌套注解
    @Select("SELECT * FROM orders WHERE id = #{id}")
    @Results(value = {
            //resultMap标签手动映射封装
            @Result(column = "uid", property = "id", id = true),
            @Result(column = "uname", property = "username"),
            @Result(column = "bir", property = "birthday"),
            @Result(column = "gender", property = "sex"),
            @Result(column = "addr", property = "address"),
            @Result(property = "user", javaType = User.class, column = "uid", one = @One(select = "com.test.dao.UserMapper.findById",fetchType = FetchType.EAGER))

    })
    public Order findByIdWithUsers(Integer id);
}
UserMapper接口

1
2
3
//id查询
@Select("SELECT * FROM user WHERE id = #{id}")
public User findById(Integer id);
注解嵌套

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
public interface OrderMapper {

    //一对一嵌套注解
    @Select("SELECT * FROM orders WHERE id = #{id}")
    @Results(value = {
            //resultMap标签手动映射封装
            @Result(column = "uid", property = "id", id = true),
            @Result(column = "uname", property = "username"),
            @Result(column = "bir", property = "birthday"),
            @Result(column = "gender", property = "sex"),
            @Result(column = "addr", property = "address"),
      
      //注解嵌套
      @Result(property = "user", javaType = User.class, column = "uid", one = @One(select = "com.test.dao.UserMapper.findById",fetchType = FetchType.EAGER))
      

    })
    public Order findByIdWithUsers(Integer id);
}
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
public class OrderMapperTest extends BaseMapperTest {

    //一对一嵌套注解测试
    @Test
    public void testFindByIdWithUsers() throws Exception {
        OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
        Order order = orderMapper.findByIdWithUsers(1);
        System.out.println(order);
    }
}
1.3.2 一对多查询
需求

查询一个用户，与此同时查询出该用户具有的订单

一对多查询语句

1
2
SELECT * FROM `user` where id = #{id};
SELECT * FROM orders where uid = #{用户id};
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
12
//一对多注解嵌套查询
@Select("SELECT * FROM user WHERE id = #{id}")
@Results({ // resultMap标签手动映射
        @Result(column = "id",property = "id",id=true), // result标签映射封装
        @Result(column = "username",property = "username"),
        @Result(column = "birthday",property = "birthday"),
        @Result(column = "sex",property = "sex"),
        @Result(column = "address",property = "address"),
        @Result(property = "orderList",javaType = List.class,column = "id",many = @Many(select = "com.test.dao.OrderMapper.findByUid"))
})
public User findByIdWithOrders(Integer id);
  
OrderMapper接口

1
2
@Select("SELECT * FROM orders WHERE uid = #{id}")
public List<Order> findByUid(Integer id);
注解嵌套

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
    //一对多注解嵌套查询
    @Select("SELECT * FROM user WHERE id = #{id}")
    @Results({ // resultMap标签手动映射
            @Result(column = "id",property = "id",id=true), // result标签映射封装
            @Result(column = "username",property = "username"),
            @Result(column = "birthday",property = "birthday"),
            @Result(column = "sex",property = "sex"),
            @Result(column = "address",property = "address"),
            
@Result(property = "orderList",javaType = List.class,column = "id",many = @Many(select = "com.test.dao.OrderMapper.findByUid"))
    })
    public User findByIdWithOrders(Integer id);

测试

1
2
3
4
5
6
7
8
//一对多注解测试
@Test
public void testFindByIdWithOrders() throws Exception{
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    User user = userMapper.findByIdWithOrders(41);
    System.out.println(user);
    System.out.println(user.getOrderList());
}
1.3.3 多对多查询
需求

查询用户同时查询出该用户的所有角色

多对多查询语句

1
2
3
SELECT * FROM `user` where id = #{id};
SELECT * FROM role r INNER JOIN user_role ur ON r.`id` = ur.`rid` 
	WHERE ur.`uid` = #{用户id};
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
12
//多对多注解嵌套查询
@Select("SELECT * FROM user WHERE id = #{id}")
@Results({ // resultMap标签手动映射
        @Result(column = "id",property = "id",id=true), // result标签映射封装
        @Result(column = "username",property = "username"),
        @Result(column = "birthday",property = "birthday"),
        @Result(column = "sex",property = "sex"),
        @Result(column = "address",property = "address"),
        @Result(property = "roleList",javaType = List.class,column = "id",many = @Many(select = "com.test.dao.OrderMapper.findByUid"))
})
public User findByIdWithRoles(Integer id);
  
RoleMapper接口

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
public interface RoleMapper {
    @Select("SELECT * FROM role r INNER JOIN user_role ur ON ur.`rid = r.`id` WHERE ur.`uid`=#{uid}")
    @Results(value = {
            @Result(column = "id",property = "id",id = true),
            @Result(column = "role_name",property = "roleName"),
            @Result(column = "role_desc",property = "roleDesc")
    })
    public List<Role> findByUid(Integer id);

}
注解嵌套

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
    //多对多注解嵌套查询
    @Select("SELECT * FROM user WHERE id = #{id}")
    @Results({ // resultMap标签手动映射
            @Result(column = "id",property = "id",id=true), // result标签映射封装
            @Result(column = "username",property = "username"),
            @Result(column = "birthday",property = "birthday"),
            @Result(column = "sex",property = "sex"),
            @Result(column = "address",property = "address"),
            
      
@Result(property = "roleList",javaType = List.class,column = "id",many = @Many(select = "com.test.dao.OrderMapper.findByUid"))
    })
    public User findByIdWithRoles(Integer id);

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
// 多对多注解测试
@Test
public void testFindByIdWithRoles() throws Exception{
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
  
    User user = userMapper.findByIdWithRoles(41);
    System.out.println(user);
    System.out.println(user.getOrderList());
}
1.4 延迟加载
不管是一对多还是多对多 ，在注解配置中都有fetchType的属性

fetchType = FetchType.LAZY 表示懒加载

fetchType = FetchType.EAGER 表示立即加载

fetchType = FetchType.DEFAULT 表示使用全局配置

1.5 二级缓存
配置SqlMapConfig.xml文件开启二级缓存的支持

1
2
3
4
5
6
7
<settings>
    <!--
		因为cacheEnabled的取值默认就为true，所以这一步可以省略不配置。
		为true代表开启二级缓存；为false代表不开启二级缓存。
    -->
    <setting name="cacheEnabled" value="true"/>
</settings>
在Mapper接口中使用注解配置二级缓存

1
2
@CacheNamespace
public interface UserMapper {...}
1.6 知识小结
注解开发和xml配置相比，从开发效率来说，注解编写更简单，效率更高。

从可维护性来说，注解如果要修改，必须修改源码，会导致维护成本增加。xml维护性更强。

经验：单表简单CRUD可以使用注解、多表及动态sql就用xml

二.MyBatis案例练习
2.1 编程风格
浏览器：Chrome、Firefox

包目录：cn(com).公司名.项目名（都是小写）

类：大驼峰式命名

方法名：小驼峰式命名

2.2 环境搭建
编写中文过滤器

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
@WebFilter("/*")
public class EncodeFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        servletRequest.setCharacterEncoding("UTF-8");
        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {

    }
}
2.3 查询所有
2.3.1 需求和效果实现
通过三层架构+接口+mybatis，查询员工信息，在页面展示

2.3.2需求分析
index.jsp–>EmpServlet–>EmpService接口EmpServiceImp实现类–>EmpDao接口+EmpDao映射，最终返给list.jsp

2.3.3 代码实现
index.jsp

1
<a href="${pageContext.request.contextPath}/emp?action=findAll">员工列表</a>
Emp实体类

1
2
3
4
5
6
7
8
public class Emp {
    private Integer id;
    private String name;
    private String sex;
    private String joindate;
    private Double salary;
    private String address;
//此处省略getter/setter，toString
EmpServlet

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
@WebServlet("/EmpServlet")
public class EmpServlet extends HttpServlet {

    // 重写service方法
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取action请求参数
        String action = request.getParameter("action");
        // 判断
        if (action.equals("findAll")) {
            this.findAll(request, response);
        }
    }

    // 查询所有
    protected void findAll(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1.调用service查询
        EmpService empService = new EmpServiceImpl();
        List<Emp> list = empService.findAll();
        // 2.将list写入request域
        request.setAttribute("list", list);
        // 3.转发
        request.getRequestDispatcher("/list.jsp").forward(request, response);
    }
}
EmpServiceImpl

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
public class EmpServiceImpl implements EmpService {

    @Override
    public List<Emp> findAll() {
        // 通过mybatis工具类获取sqlSession
        SqlSession sqlSession = MyBatisUtils.openSession();
        // 创建EmpDao代理对象
        EmpDao empDao = sqlSession.getMapper(EmpDao.class);
        // 查询
        List<Emp> list= empDao.findAll();
        // 关闭sqlSession
        MyBatisUtils.close(sqlSession);
        return list;
    }
}
EmpDao（接口+映射）

1
2
3
4
5
6
7
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.test.dao.EmpDao">
    <select id="findAll" resultType="Emp">
        SELECT * FROM emp
    </select>
</mapper>
list.jsp

1
2
3
4
5
6
7
8
9
<c:forEach items="${list}" var="emp">
    <tr>
        <td>${emp.id}</td>
        <td>${emp.ename}</td>
        <td>${emp.joindate}</td>
        <td>${emp.salary}</td>
        <td>${emp.address}</td>
    </tr>
</c:forEach>
2.4 分页查询
2.4.1 导入数据
2.4.2 分页介绍
在实际开发中，如果数据库数据太多，一般我们需要进行分页查询，提高效率

分页技术实现

物理分页：数据库实现（MySQL、Oracle）

内存分页：查询全部，在通过java代码进行分页

使用MySQL操作物理分页

语法： select * from 表名 limit 开始索引,每页个数;

模拟百度分页，一个显示5条，数据库共有16条记录

第一页

select * from 表名 limit 0,5;

第二页

select * from 表名 limit 5,5;

第三页

select * from 表名 limit 10,5;

第四页

select * from 表名 limit 15,5;

索引公式

开始索引=(当前页-1) × 每页个数

如何获得当前页和每页个数

前端页提供

2.4.3 需求和效果实现
通过mysql物理分页，一个显示5条，数据库共有16条记录

2.4.3 需求分析


后端代码流程图



2.4.4 代码实现
index.jsp

1
2
3
4
<body>
<%--<a href="${pageContext.request.contextPath}/EmpServlet?action=findAll">员工列表</a>--%>
<a href="${pageContext.request.contextPath}/EmpServlet?action=findByPage&currentPage=1&pageSize=5">员工列表</a>
</body>
PageBean

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
public class PageBean<E> {

    private Integer totalCount; // 总记录数

    private Integer totalPage;// 总页数

    private List<E> list; // 结果集

    private Integer currentPage; // 当前页

    private Integer pageSize; // 每页个数
  
  //此处省略getter/setter，toString
EmpServlet

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
@WebServlet("/EmpServlet")
public class EmpServlet extends HttpServlet {

    // 重写service方法
    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 获取action请求参数
        String action = req.getParameter("action");
        // 判断
        if (action.equals("findAll")) {
            this.findAll(req, resp);
        } else if (action.equals("findByPage")) {
            this.findByPage(req, resp);
        }
    }

    EmpService empService = new EmpServiceImpl();

    // 分页查询
    protected void findByPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1.接收请求参数
        String currentPageStr = req.getParameter("currentPage");
        String pageSizeStr = req.getParameter("pageSize");
        // 2.转为整型
        int currentPage = Integer.parseInt(currentPageStr);
        int pageSize = Integer.parseInt(pageSizeStr);
        // 3.调用service查询
        PageBean<Emp> pb = empService.findByPage(currentPage, pageSize);
        // 4.设置到request域
        req.setAttribute("pb", pb);
        // 5.转发
        req.getRequestDispatcher("/list.jsp").forward(req, resp);
    }
EmpServiceImpl

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
public class EmpServiceImpl implements EmpService {
    @Override
    public List<Emp> findAll() {
        // 通过mybatis工具类获取sqlSession
        SqlSession sqlSession = MyBatisUtils.openSession();
        // 创建EmpDao代理对象
        EmpDao empDao = sqlSession.getMapper(EmpDao.class);
        // 查询
        List<Emp> list = empDao.findAll();
        // 关闭sqlSession
        MyBatisUtils.close(sqlSession);
        return list;
    }
    @Override
    public PageBean<Emp> findByPage(int currentPage,int pageSize){
        // 通过mybatis工具类获取sqlSession
        SqlSession sqlSession = MyBatisUtils.openSession();

        // 创建EmpDao代理对象
        EmpDao empDao = sqlSession.getMapper(EmpDao.class);

        // 1.创建 PageBean
        PageBean<Emp> pageBean = new PageBean();

        // 2.封装当前页和每页个数
        pageBean.setCurrentPage(currentPage);
        pageBean.setPageSize(pageSize);

        // 3.调用dao查询总记录数并封装
        Integer totalCount = empDao.findCount();
        pageBean.setTotalCount(totalCount);

        // 4.计算并封装总页数
        int totalPage = (int)Math.ceil(totalCount*1.0/pageSize);
        pageBean.setTotalPage(totalPage);

        // 5.计算开始索引
        int index = (currentPage - 1) * pageSize;

        // 6.调用dao查询结果集并封装
        List<Emp> list = empDao.findList(index,pageSize);
        pageBean.setList(list);

        // 关闭sqlSession
        MyBatisUtils.close(sqlSession);
        // 7.返回pageBean对象
        return pageBean;
    }
}
EmpDao（接口+映射）

1
2
3
4
5
6
7
8
9
public interface EmpDao {
    List<Emp> findAll();

    //查看总记录
    Integer findCount();

    //分页查询结果
    List<Emp> findList(@Param("index") int index,@Param("pageSize") int pageSize);
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
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.test.dao.EmpDao">
    <select id="findAll" resultType="Emp">
        SELECT * FROM emp
    </select>

    <!--  查看总记录数 -->
    <select id="findCount" resultType="java.lang.Integer">
        SELECT count(*) FROM emp
    </select>

    <!--    查看结果集-->
    <select id="findList" resultType="com.test.domain.Emp">
        SELECT * FROM emp limit #{index},#{pageSize}
    </select>
</mapper>
list.jsp

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
    <style>
        table {
            margin: 30px auto;
            text-align: center;
        }

        #page td {
            width: 20px;
            border: 1px solid gray;
        }
    </style>
</head>
<body>
<table border="1" cellpadding="0" cellspacing="0" width="600px">
    <tr>
        <td>姓名</td>
        <td>性别</td>
        <td>入职日期</td>
        <td>薪资</td>
        <td>住址</td>
    <c:forEach items="${emps}" var="emp">
        <tr>
            <td>${emp.name}</td>
            <td>${emp.sex}</td>
            <td>${emp.joindate}</td>
            <td>${emp.salary}</td>
            <td>${emp.address}</td>
        </tr>
    </c:forEach>
</table>
<table>
    <tr>
        <td style="text-align: left">总共检索到${pb.totalCount}条记录,共分${pb.totalPage}页</td>
    </tr>
</table>
<table id="page">
    <tr>
        <c:if test="${pb.currentPage>1}">
            <td style="width:50px">
                <a style="text-decoration: none"
                   href="${pageContext.request.contextPath}/EmpServlet?action=findByPage&currentPage=${pb.currentPage-1}&pageSize=5">上一页</a>
            </td>
        </c:if>
        <c:forEach begin="1" end="${pb.totalPage}" var="page">
            <c:if test="${page == pb.currentPage}">
                <td bgcolor="#ffd700">
                    <a style="text-decoration: none"
                       href="${pageContext.request.contextPath}/EmpServlet?action=findByPage&currentPage=${page}&pageSize=5">${page}</a>
                </td>
            </c:if>
            <c:if test="${page != pb.currentPage}">
                <td>
                    <a style="text-decoration: none"
                       href="${pageContext.request.contextPath}/EmpServlet?action=findByPage&currentPage=${page}&pageSize=5">${page}</a>
                </td>
            </c:if>

        </c:forEach>
        <c:if test="${pb.currentPage < pb.totalPage}">
            <td style="width:50px">
                <a style="text-decoration: none"
                   href="${pageContext.request.contextPath}/EmpServlet?action=findByPage&currentPage=${pb.currentPage+1}&pageSize=5">下一页</a>
            </td>
        </c:if>
    </tr>
</table>
<script>
    var txt = document.getElementById("uname");
    // var txt = document.querySelector（"#uname"）;
    txt.innerText = "admin";
</script>
</table>
</body>
</html>
```