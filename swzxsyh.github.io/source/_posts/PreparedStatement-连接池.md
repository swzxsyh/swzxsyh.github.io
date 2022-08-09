---
title: PreparedStatement & 连接池
date: 2020-05-08 01:35:47
tags:
---


一.PreparedStatement
1.1 概述
SQL注入问题

我们让用户输入的信息和SQL语句进行字符串拼接。用户输入的内容作为了SQL语句语法的一部分，改变了原有SQL

真正的意义，以上问题称为SQL注入。

1
2
3
-- 这条sql语句原有的含义是根据用户名和密码查询
-- 现在用户输入了一些特殊字符，改变了sql原有的含义，这种行为成为sql注入 
SELECT * FROM USER WHERE username ='admin'# ' and password =''
解决SQL注入问题

我们就不能让用户输入的信息和SQL语句进行字符串拼接。需要使用PreparedSatement对象解决SQL注入。

1
2
3
4
-- 在java语言中修复sql注入问题，通过占位符代替实际参数
SELECT * FROM USER WHERE username = ? AND password = ?
-- 仅仅模拟sql解决思想，非真实解决方案
SELECT * FROM USER WHERE username = "admin'#" AND PASSWORD = ""
PreparedSatement基础语法

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
// 1.获取连接
// 2.编写sql【占位符代替实际参数】
String sql = "SELECT * FROM USER WHERE username = ? AND password = ?";
// 3.获取sql预编译执行对象，先发送给数据库进行预编译 
PreparedStatement pstmt = connection.prepareStatement(sql);
// 4.设置占位符实际参数 
pstmt.setString(1,"admin'#"); 
pstmt.setString(2,"");
// 5.执行sql语句，并返回结果【注意，不需要传递sql参数】 
ResultSet resultSet = pstmt.executeQuery();
// 6.处理结果 // 7.释放资源
优点

防止sql注入，提高安全性

参数与sql分离，提高代码可读性

减少编译次数，提高性能

1.2 操作
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

public class CRUD_DEMO {
    //新增
    @Test
    public void testInsert() throws Exception {
        //获取连接
        Connection connection = JdbcUtils.getConnection();
        //编写sql
        String sql = "INSERT INTO user VALUES (NULL ,?,?);";
        //获取sql预编译执行对象
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        //设计实际参数
        preparedStatement.setString(1, "Jerry");
        preparedStatement.setString(2, "999");
        //执行sql并返回结果
        int i = preparedStatement.executeUpdate();
        //处理结果
        if (i > 0) {
            System.out.println("First Recording Add Successful");
        }
        preparedStatement.setString(1, "Ming");
        preparedStatement.setString(2, "999");
        i = preparedStatement.executeUpdate();
        if (i > 0) {
            System.out.println("Second Recording Add Successful");
        }
        //释放资源
        JdbcUtils.close(preparedStatement, connection);
    }

    //修改
    @Test
    public void testUpdate() throws Exception {
        //获取连接
        Connection connection = JdbcUtils.getConnection();
        //编写sql
        String sql = "UPDATE user SET username = ? where id = ?;";
        //获取预编译sql执行对
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        //设计实际参数
        preparedStatement.setString(1, "RRR");
        preparedStatement.setInt(2, 3);
        //执行sql,并返回结果
        int i = preparedStatement.executeUpdate();
        //处理结果
        if (i > 0) {
            System.out.println("Update Successful");
        }
        //释放资源
        JdbcUtils.close(preparedStatement, connection);
    }

    //删除
    @Test
    public void testDelete() throws Exception {
        Connection connection = JdbcUtils.getConnection();
        String sql = "DELETE FROM user WHERE id=?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, 6);
        int i = preparedStatement.executeUpdate();
        if (i > 0) {
            System.out.println("Delete Successful");
        }
        JdbcUtils.close(preparedStatement, connection);
    }

    //查询
    @Test
    public void testFindAll() throws Exception {
        Connection connection = JdbcUtils.getConnection();
        String sql = "SELECT * FROM user;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        ResultSet resultSet = preparedStatement.executeQuery();
        while (resultSet.next()) {
            int id = resultSet.getInt("id");
            String username = resultSet.getString("username");
            String password = resultSet.getString("password");
            System.out.println("\tID:" + id + "\tUSERNAME:" + username + "\tPASSWORD:" + password);

        }
        JdbcUtils.close(preparedStatement, connection);
    }
}
二.连接池
2.1 概述
连接池其实就是一个容器(集合)，存放数据库连接的容器。

当系统初始化好后，容器被创建，容器中会申请一些连接对象，当用户来访问数据库时，从容器中获取连接对象，用 户访问完之后，会将连接对象归还给容器。

优点

节约资源，减轻服务器压力

提高连接复用性，用户访问高效

常见连接池

DBCP	Apache提供的数据库连接池技术。
C3P0	数据库连接池技术，目前使用它的开源项目有Hibernate、Spring等。
HikariCP	日本开发的连接池技术，性能之王,目前使用它的开源项目有SpringBoot等。
Druid(德鲁伊)	阿里巴巴提供的数据库连接池技术
实现

Java为数据库连接池提供了公共的接口: DataSource ，各个连接池厂商去实现这套接口，提供jar包。

功能	
获取连接	Connection getConnection()
归还连接	connection.close()
若连接对象通过连接池获取，执行 connection.close() 方法时，是归还到连接池，非销毁对象
底层通过动态代理技术对close()方法进行了增强
2.2 Druid连接池
2.2.1 快速入门
导入jar包

druid-1.1.10.jar

mysql-connector-java-8.0.16.jar

编写测试代码(耦合版本)

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
public class DruidDemo1 {
    public static void main(String[] args) throws SQLException {

        // 1.创建druid连接池对象
        DruidDataSource dataSource = new DruidDataSource();

        // 2.与mysql建立连接(初始化一些连接个数)，设置数据库基本四项
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://localhost:3306/Day48");
        dataSource.setUsername("root");
        dataSource.setPassword("root");

        // 3.从连接池中获取连接
        Connection connection = dataSource.getConnection();

        // 4.处理业务
        System.out.println(connection);
        // 5.归还连接,注意，非销毁
        connection.close();

    }
}
2.2.2 配置文件
参数设置	作用
initialSize	初始化建立物理连接的个数。初始化发生在显示调用init方法，或者第一次getConnection时
maxActivve	最大连接池数量
MinIdle	最小连接池数量
maxWait	获取连接时最大等待时间，ms
定义配置文件

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
#druid.properties
#基本4项，必须有，左边名称限定
driverClassName=com.mysql.jdbc.Driver
url=jdbc:mysql://127.0.0.1:3306/Day48
username=root
password=root

# 初始化个数
initialSize=5
#最大连接个数
maxActivve=10
#等待时间，ms
maxWait=3000
编写代码(解耦合版)

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
public class DruidDemo2 {

    public static void main(String[] args) throws Exception {
        // 通过类加载器读取src目录下配置文件，获取io流
        InputStream is = DruidDemo2.class.getClassLoader().getResourceAsStream("druid.properties");
        // 创建 Properties对象
        Properties properties = new Properties();
        properties.load(is);

        // druid连接池工厂对象，初始化连接池
        DataSource dataSource = DruidDataSourceFactory.createDataSource(properties);

        // 获取连接
        for (int i = 0; i <= 11; i++) {
            Connection connection = dataSource.getConnection();
            System.out.println(connection);
            if (i == 10) {
                connection.close();
            }
        }
            // 归还连接
            //connection.close();

    }
}
2.3 连接工具类
我们每次操作数据库都需要创建连接池，获取连接，关闭资源，都是重复的代码。我们可以将创建连接池和获取连接

池的代码放到一个工具类中。

保证连接池对象，只创建一次

目的:简化书写，提高效率

1
2
3
4
5
public class JdbcUtils{
// 1.初始化连接池对象(druid)，一个项目只有一个 static{} // 2.提供获取连接池对象静态方法
// 3.提供连接对象的静态方法
// 4.提供释放资源的静态方法(connection是归还)
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
public class JdbcUtils {

    private static DataSource dataSource = null;

    // 1.初始化连接池对象(druid)，一个项目只有一个 static{}
    static {
        try {
            // 通过类加载器读取src目录下配置文件，获取io流
            InputStream is = JdbcUtils.class.getClassLoader().getResourceAsStream("druid.properties");
            // 创建 Properties对象
            Properties properties = new Properties();
            properties.load(is);
            // druid连接池工厂对象，初始化连接池
            dataSource = DruidDataSourceFactory.createDataSource(properties);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 2.提供获取连接池对象静态方法
    public static DataSource getDataSource() {
        return dataSource;
    }

    // 3.提供连接对象的静态方法
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    // 4.提供释放资源的静态方法(connection是归还)
    public static void close(ResultSet resultSet, Statement statement, Connection connection) {
        if (resultSet != null) {
            try {
                resultSet.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (statement != null) {
            try {
                statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 重载关闭方法
    public static void close(Statement statement, Connection connection) {
        close(null, statement, connection);
    }
}
三.案例:用户登录
需求

使用三层架构+JDBC连接池技术(面向接口编程)，实现用户登录案例

3.1 需求分析
Login.jsp			Server			数据库
web层	service层	dao层		
UserName
Password	➡
⬅	Servlet接口	UserService接口	UserDao接口	➡
⬅	SQL
Login		⬆	⬆	⬆		
LoginServlet
1.接收请求
2.调用service
3.判断转发/重定向	UserServiceImpl实现类	UserDaoImpl实现类		
Login.jsp			Server			数据库
LoginServlet	UserServiceImpl	UserDaoImpl		
UserName
Password	➡
⬅	实现了Servlet接口	实现了UserService接口	实现了UserDao接口	➡
⬅	SQL
Login		1.接收请求参数
username
password
2.调用service，返回User对象
3.判断User对象
转发，提示用户名/密码错误
重定向list.jsp	public User login(user, pwd) {
调用dao，返回user对象
}	public User login(user, pwd) {
使用JDBC连接池获取连接
查询数据库
将结果封装到user对象中 }		
3.2 环境搭建
使用昨天的数据库和user表

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
CREATE TABLE USER
(
    id       INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50),
    password VARCHAR(50)
);
INSERT INTO USER (username, password)
VALUES ('admin', '123'),
       ('tom', '123'),
       ('jack', '123');

创建web工程，导入相关jar包

commons-beanutils-1.8.3.jar

commons-logging-1.1.1.jar

druid-1.1.10.jar

javax.servlet.jsp.jstl.jar

jstl-impl.jar

mysql-connector-java-8.0.16.jar

导入页面资源

创建三层包目录结构

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
src
├── com
│   └── case
│       ├── dao
│       │   ├── UserDao.java
│       │   └── UserDaoImpl.java
│       ├── domain
│       │   └── User.java
│       ├── service
│       │   ├── UserService.java
│       │   └── UserServiceImpl.java
│       ├── util
│       │   └── JdbcUtils.java
│       └── web
│           ├── filter
│           │   └── EncodeFilter.java
│           └── servlet
│               └── LoginServlet.java
└── druid.properties


9 directories, 9 files
导入JbdcUtils工具类

编写User实体类

1
2
3
4
5
6
public class User {
    private Integer id;
    private String username;
    private String password;

    //省略getter/setter，toString，全参构造
3.3 代码实现
LoginServlet
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
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 处理编码
//        req.setCharacterEncoding("utf-8");
//        resp.setContentType("text/html;charset=utf-8");

        // 1.接收请求参数
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // 2.调用service
        UserServiceImpl userService = new UserServiceImpl();
        User user = userService.login(username, password);

        // 3.判断
        if(user==null){
            // 登录失败，友情提示
            req.setAttribute("error","Username/Password Wrong");
            req.getRequestDispatcher("/login.jsp").forward(req,resp);
        }else {
            // 登录成功
            req.getSession().setAttribute("user",user);
            resp.sendRedirect(req.getContextPath()+"/list.jsp");
        }
    }
}
UserService 接口

1
2
3
4
5
public interface UserService {
    //根据用户名密码查询User对象
    public User login(String username, String password);
}

UserServiceImpl 实现类

1
2
3
4
5
6
7
public class UserServiceImpl implements UserService {
    @Override
    public User login(String username, String password) {
        UserDaoImpl userDao = new UserDaoImpl();
        return userDao.login(username,password);
    }
}
UserDao 接口

1
2
3
4
public interface UserDao {
    //根据用户名密码查询User对象
    public User login(String username, String password);
}
UserDaoImpl 实现类

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
public class UserDaoImpl implements UserDao {
    @Override
    public User login(String username, String password) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            // 1.获取连接【从连接池】
            connection = JdbcUtils.getConnection();
            // 2.编写sql
            String sql = "SELECT * FROM user WHERE username= ? AND password = ?;";
            // 3.获取sql预编译执行对象
            preparedStatement = connection.prepareStatement(sql);
            // 4.设置实际参数
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            // 5.执行sql并返回结果
            resultSet = preparedStatement.executeQuery();
            // 6.处理结果
            User user = null;

            if (resultSet.next()) {
                // 获取 id 用户名、密码
                int id = resultSet.getInt("id");
                username = resultSet.getString("username");
                password = resultSet.getString("password");
                user = new User();
                user.setId(id);
                user.setUsername(username);
                user.setPassword(password);
            }
            return user;

        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            // 7.释放资源
            JdbcUtils.close(resultSet, preparedStatement, connection);
        }
        return null;
    }
}
总结
## PreparedStatement

### 介绍

- 预编译sql执行对象

### 优点

- 1）防止sql注入，提高安全性

- 2）减少编译次数，提高效率

- 3）参数与sql语句分离，提高可读性

### 步骤

- 1）注册驱动

- 2）建立连接

- 3）编写sql ?占位符代替参数

- 4）获取sql预编译执行对象 先将sql发送到数据库

- 5）设置实际参数

- 6）执行sql并返回结果

- 7）处理结果

- 8）释放资源

### 作业

- 重写登录案例

- CRUD练习

## datasource

### 介绍：

- 在系统初始化时，创建一个连接池生成一些连接对象，用户访问数据库时，从连接池获取连接，使用完毕归还到连接池

### 优点

- 1）减轻服务器压力

- 2）提高连接复用性

### dataSource

- 是sun公司提供连接池规范（接口），连接池厂商根据接口编写实现类

​ - c3p0

​ - hikariCP

​ - Druid

### 作业

- druid快速入门

​ - 1）导入jar包

​ - 2）定义配置文件

​ - 3）编写代码

- druid连接池工具类