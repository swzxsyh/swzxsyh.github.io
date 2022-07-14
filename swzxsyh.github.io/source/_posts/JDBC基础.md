---
title: JDBC基础
date: 2020-05-06 01:35:06
tags:
---

一.JDBC基础
1.1 概述
Java 数据库连接(Java DataBase Connectivity)

作用:通过Java语言操作数据库

本质:是官方(sun公司)定义的一套操作所有关系型数据库的规则(接口)。各个数据库厂商去实现这套接口，提 供数据库驱动jar包。我们可以使用这套接口(JDBC)编程，运行时的代码其实是驱动jar包中的实现类。

1.2 快速入门
需求

通过java代码向数据库user表插入一条记录

准备数据库和表

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
CREATE DATABASE Day48;
USE Day48;
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

SELECT * FROM USER;
创建java工程，导入MySQL驱动jar包

mysql-connector-java-5.1.45-bin.jar

编写插入代码

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
public class JDBCDEMO {
    public static void main(String[] args) throws Exception {
        //1.注册驱动
//        DriverManager.registerDriver(new Driver());
        Class.forName("com.mysql.jdbc.Driver");
        //2.建立连接
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/Day48", "root", "root");
        //3.编写sql
        String sql = "insert into user values(4,'lucy',666)";
        //4.获取sql执行对象
        Statement statement = connection.createStatement();
        //5.执行sql并返回结果
        int i = statement.executeUpdate(sql);
        //6.处理结果
        if (i > 0) {
            System.out.println("Success");
        } else {
            System.out.println("Failed");
        }
        //7.释放资源
        statement.close();
        connection.close();
    }
}
1.3 API介绍
sun公司提供的:java.sql包下

DriverManager:驱动管理对象

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
1.注册驱动
        1)static void registerDriver(Driver driver)
        我们通过翻看MySQL Driver实现类的源码发现内部的静态代码已经提供了注册驱动功能
static {
        try{
        		DriverManager.registerDriver(new Driver());
        }catch(SQLException var1){
        		throw new RuntimeException("Can't register driver!");
        	}
        }
        2)反射 
        Class.forName("com.mysql.jdbc.Driver");
        3)SPI 服务提供接口 【Service Provider Interface】
2.建立连接
static Connection getConnection(String url,String user,String password)
参数说明:
        url:连接指定数据库地址【固定格式】 
        格式:jdbc:mysql://ip地址+端口/数据库名 
        实例:
        jdbc:mysql://localhost:3306/day23
        jdbc:mysql:///day23 
      user:用户名
      password:密码
Connection:数据库连接对象

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
1. 获取sql执行对象【小货车】
  Statement createStatement() 
  PreparedStatement prepareStatement(String sql)  
2. 事务管理 
    1)关闭自动提交(开启事务)
            void setAutoCommit(boolean autoCommit)
      参数: 
          true:自动提交【默认值】 
          false:手动提交
    2)提交事务
        void commit()
    3)回滚事务
        void rollback()
Statement:执行sql的对象

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
1. 执行所有类型sql语句【了解】
	boolean execute(String sql)
2. 仅执行DML类型sql语句
	int executeUpdate(String sql)
      参数:dml类型sql(insert、update、delete) 
      返回值:影响行数
3. 仅执行DQL类型sql语句
	ResultSet executeQuery(String sql)
    参数:dql类型sql(select) 
    返回值:结果集
ResultSet:结果集对象,封装查询结果

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
1. 指针下移
    boolean next()
			返回值: 
          true:表示此行有数据 
          false:表示此行没有数据
    while(resultSet.next){
    		//获取一行数据
    }
2. 获取数据
  根据制定列编号和数据类型获取
    T getXxx(int 列编号)
  根据指定列名和数据类型获取
    T getXxx(String 列名)
    
    补充:获取所有类型
        Object getObject(String 列名) 
        String getString(String 列名)
1.4 CRUD操作
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
// 1.注册驱动
// 2.建立连接
// 3.编写sql
// 4.获取sql执行对象 // 5.执行sql并返回结果 // 6.处理结果
// 7.释放资源

public class CRUDDEMO {
    //新增
    @Test
    public void testInsert() throws Exception {
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/Day48", "root", "root");
        String sql = "insert into user values(NULL,'testInsert',666)";
        Statement statement = connection.createStatement();
        int i = statement.executeUpdate(sql);
        if (i > 0) {
            System.out.println("Successful");
        } else {
            System.out.println("Failed");
        }
        statement.close();
        connection.close();
    }

    //修改
    @Test
    public void testUpdate() throws Exception {
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/Day48", "root", "root");
        String sql = "UPDATE user SET username='testUpdate' WHERE id = 4";
        Statement statement = connection.createStatement();
        int i = statement.executeUpdate(sql);
        if (i > 0) {
            System.out.println("Successful");
        } else {
            System.out.println("Failed");
        }
        statement.close();
        connection.close();
    }

    //删除
    @Test
    public void testAlter() throws Exception {
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/Day48", "root", "root");
        String sql = "delete from user WHERE id = 2";
        Statement statement = connection.createStatement();
        int i = statement.executeUpdate(sql);
        if (i > 0) {
            System.out.println("Successful");
        } else {
            System.out.println("Failed");
        }
        statement.close();
        connection.close();
    }

    //查询
    @Test
    public void testFindAll() throws Exception {
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/Day48", "root", "root");
        String sql = "SELECT * FROM user";
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);

        while (resultSet.next()) {
            int id = resultSet.getInt("id");
            String username = resultSet.getString("username");
            String password = resultSet.getString("password");
            System.out.println("\tID:" + id + "\tUSERNAME:" + username + "\tPASSWORD:" + password);
        }
        resultSet.close();
        statement.close();
        connection.close();
    }
}
1.5 工具类
通过上面案例需求我们会发现每次去执行SQL语句都需要注册驱动，获取连接，得到Statement，以及释放资源。发

现很多重复的劳动，我们可以将重复的代码定义到一个工具类中。

目的:简化书写，一劳永逸

步骤分析

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
public class JdbcUtils{
// 1.注册驱动【保证一次】
static{ }
// 2.提供获取连接的静态方法
public static Connection getConnection(){
        return null;
    }
// 3.提供释放资源的方法 
  public void close(){
		}
}
1.5.1 版本一
该版本具有耦合性
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
public class JdbcUtils1 {
    // 1.注册驱动【保证一次】
    static {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Load JDBC Driver Failed");
        }
    }

    // 2.提供获取连接的静态方法
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/Day48", "root", "root");
    }

    // 3.提供释放资源的方法
    public void close(ResultSet resultSet, Statement statement, Connection connection) {
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
        close(statement, connection);
    }
}

1.5.2 版本二
解耦合版本

1
2
3
4
5
#K-V
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
public class JdbcUitls {

    // 声明变量
    private static String driver = null;
    private static String url = null;
    private static String user = null;
    private static String password = null;

    // 加载jdbc.properties配置文件，初始化变量
    static {
        ResourceBundle jdbc = ResourceBundle.getBundle("jdbc");
        driver = jdbc.getString("jdbc.driver");
        url = jdbc.getString("jdbc.url");
        user = jdbc.getString("jdbc.user");
        password = jdbc.getString("jdbc.password");
    }

    // 1.注册驱动【保证一次】
    static {
        try {
            Class.forName(driver);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Load Driver Failed");
        }
    }

    // 2.提供获取连接的静态方法
    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(url, user, password);
    }

    // 3.提供释放资源的方法
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

1.6 事务操作
事务

如果一个包含多个步骤的业务操作，被事务管理，那么这些操作要么同时成功，要么同时失败

MySQL事务操作

事务	
开启事务	begin | start transaction;
提交事务	commit;
回顾事务	rollback;
Java操作(使用Connection对象)

事务	
关闭自动提交(开启事务)	void setAutoCommit(false);
提交事务	void commit();
回顾事务	void rollback();
需求:

通过Java代码实现转账案例

导入账户表

1
2
3
4
5
6
7
CREATE TABLE account(
  id INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(10),
  money DOUBLE
);
INSERT INTO account(`name`,money) VALUES ('UserA',1000),('UserB',1000);

编写转账代码

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
public class TXDemo{
@Test
    public void testTX(){
        try{
          // 1.获取连接【JdbcUtils工具类】 
          // 2.开启事务
					// 3.UserA扣钱
					// 机器故障
					// 4.UserB加钱
					// 5.提交事务 
        }catch(Exception e){ 
          // 6.回滚事务
				}finally{
					// 7.释放资源
			} 
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
public class TXDemo {
@Test
    public void testTX() {
        Connection connection = null;
        Statement statement = null;
        try {
          // 1.获取连接【JdbcUtils工具类】
					connection = JdbcUitls.getConnection(); 
          // 2.开启事务 
          connection.setAutoCommit(false); 
          tatement = connection.createStatement(); 
          // 3.UserA扣钱
          // 机器故障
          // 4.UserB加钱
          // 5.提交事务 
          connection.commit();
          } catch (Exception e) {
    try {
					// 6.回滚事务
					connection.rollback(); 
    } catch (SQLException e1) {
					e1.printStackTrace(); 
    }
} finally {
					// 7.释放资源
					JdbcUitls.close(statement, connection); 
        }
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
41
42
public class TXDemo {
    @Test
    public void testTX() {
        Connection connection = null;
        Statement statement = null;
        try {
            // 1.获取连接【JdbcUtils工具类】
            connection = JdbcUitls.getConnection();
            // 2.开启事务
            connection.setAutoCommit(false);
            statement = connection.createStatement();

            // 3.UserA扣钱
            String ASql = "update account set money = money-100 where id=2;";
            int AResult = statement.executeUpdate(ASql);
            if (AResult > 0) {
                System.out.println("User A Payment Successful");
            }
            // 机器故障
            int a = 1 / 0;
            String BSql = "update account set money = money +100 where id =1;";
            // 4.UserB收到钱
            int BResult = statement.executeUpdate(BSql);
            if (BResult > 0) {
                System.out.println("User B Get the Payment");
            }
            // 5.提交事务
            connection.commit();
        } catch (Exception e) {
            e.printStackTrace();
            try {
                // 6.回滚事务
                connection.rollback();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        } finally {
            // 7.释放资源
            JdbcUitls.close(statement, connection);
        }
    }
}
二.案例:用户登陆
2.1 需求分析
浏览器登录		
⬇		
服务器LoginServlet		
接收用户请求
用户名，密码		
⬇		
操作JDBC
根据用户名和密码查询数据库	➡
⬅	Server
⬇		
判断用户是否登录成功		
⬇正确	➡错误	转发登录页面提示
重定向至list.jsp		
2.2 代码实现
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
package com.test.web;


import com.test.util.JdbcUitls;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //统一编码
        req.setCharacterEncoding("utf-8");
        resp.setContentType("text/html;charset=utf-8");
        //接收请求
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            // 2.操作JDBC
            // 2.1 获取连接
            Connection connection = JdbcUitls.getConnection();

            // 2.2 编写sql
            // String sql = "select * from user where username ='admin' and password='123'";
            String sql = "SELECT * FROM user WHERE username='" + username + "'AND password ='" + password + "'";
            System.out.println(sql);

            // 2.3 获取sql执行对象
            Statement statement = connection.createStatement();

            // 2.4 执行sql并返回结果
            ResultSet resultSet = statement.executeQuery(sql);

            // 3.判断是否登录成功
            if (resultSet.next()) {// 成功
                String loginUsername = resultSet.getString("username");
                req.getSession().setAttribute("loginUsername", loginUsername);
                resp.sendRedirect(req.getContextPath() + "/list.jsp");
            } else {// 失败
                req.setAttribute("error", "Username/Password Wrong");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
# 总结
## jdbc

### 概述

- 通过java语言操作数据库

### 本质

- 面向接口编程思想

- sun公司通过操作关系型数据库的一套规范（接口），所有的数据库厂商都需要实现这套接口，对于开发者只需要学习这套接口的API就可以操作所有类型的关系型数据库，真正的执行者是实现类（jar包驱动）

### 快速入门

- 1.注册驱动

- 2.建立连接

- 3.编写sql

- 4.获取sql执行对象

- 5.执行sql并返回结果

- 6.处理结果

- 7.释放资源

### API详解

- DriverManager

​ - 1.注册驱动

​ - Class.forName()

​ - 2.建立连接

- Connection

​ - 1.获取sql执行对象

​ - Statement

​ - PreparedStatement

​ - 2.事务安全

- Statement

​ - 1.仅执行DML类型sql语句

​ - int executeUpdate(String sql)

​ - 2.仅执行DQL类型sql语句

​ - ResultSet executeQuery(String sql)

- ResultSet

​ - 1.指针下移

​ - boolean next()

​ - 2.获取数据

​ - T getXxx(String 列名)

### crud练习

- 新增

- 修改

- 删除

- 查询所有

### JdbcUtils

- 版本一

- 版本二

### 事务安全

- 模拟转账

