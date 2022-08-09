---
title: Spring 注解开发 & 单元测试
date: 2020-05-29 01:42:05
tags:
---

一.DbUtils
1.1 DbUtils是什么
DbUtils是Apache的一款用于简化Dao层代码的工具类，它底层封装了JDBC技术。

核心对象

1
QueryRunner queryRunner = new QueryRunner(DataSource dataSource);
核心方法

方法	
int update();	执行增、删、改语句
T query();
      ResultSetHandler<T>	执行查询语句
      这是一个接口，主要作用是将数据库返回的记录封装到实体对象
例

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
public class DbUtilsTest {
    @Test
    public void findAllTest() throws Exception {
        // 创建DBUtils工具类，传入连接池
        QueryRunner queryRunner = new QueryRunner(JdbcUtils.getDataSource());
        // 编写sql
        String sql = "select * from account";
        // 执行sql
        List<Account> list = queryRunner.query(sql, new BeanListHandler<Account>
                (Account.class));
        // 打印结果
        for (Account account : list) {
            System.out.println(account);
        }
    }
}
1.2 DbUtils快速入门
准备数据库环境

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
CREATE DATABASE spring_db` 

USE `spring_db`;

DROP TABLE IF EXISTS `account`;

CREATE TABLE `account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `money` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


insert  into `account`(`id`,`name`,`money`) values (1,'tom',1000),(2,'jerry',1000);
创建maven的java模块

IDEA new moudle==>Maven==>moudle_name

导入相关jar包

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
    <!--dbUtils工具包-->
    <dependency>
        <groupId>commons-dbutils</groupId>
        <artifactId>commons-dbutils</artifactId>
        <version>1.6</version>
    </dependency>
    <!--junit单元测试-->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
    </dependency>
    <!--spring核心-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>5.1.5.RELEASE</version>
    </dependency>
</dependencies>
JdbcUtils工具类(需组合jdbc.properties)

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
public class JdbcUtils {

  private static DruidDataSource dc =  new DruidDataSource();

  static {
    ResourceBundle bundle = ResourceBundle.getBundle("jdbc");
    String driverClass = bundle.getString("jdbc.driver");
    String jdbcUrl = bundle.getString("jdbc.url");
    String username = bundle.getString("jdbc.username");
    String password = bundle.getString("jdbc.password");

    dc.setDriverClassName(driverClass);
    dc.setUrl(jdbcUrl);
    dc.setUsername(username);
    dc.setPassword(password);
  }

  public static Connection getConnection() throws SQLException {
    return dc.getConnection();
  }

  public static DataSource getDataSource(){
    return dc;
  }
}
新增/修改/删除一条记录

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
public class DbUtilsTest {
  // 新增记录
  @Test
  public void testCreate() throws Exception{
    // 1.创建QueryRunner核心对象
    QueryRunner queryRunner = new QueryRunner(JdbcUtils.getDataSource());
    // 2.编写sql语句
    String sql = "INSERT INTO account(name,money) VALUES(?,?)";
    // 3.执行sql
    queryRunner.update(sql,"TEST_CREATE",0);
  }

  // 修改记录
  @Test
  public void testUpdate() throws Exception{

    QueryRunner queryRunner = new QueryRunner(JdbcUtils.getDataSource());

    String sql = "UPDATE account SET name=?,money=? WHERE id = ?";
    queryRunner.update(sql,"test_Update",100,2 );
  }
  // 删除记录
  @Test
  public void testDelete() throws Exception{

    QueryRunner queryRunner = new QueryRunner(JdbcUtils.getDataSource());
    String sql = "DELETE FROM account WHERE id = ?";
    queryRunner.update(sql,3);

  }
}
查询记录

实体类

1
2
3
4
5
6
7
8
package com.test.domain;

public class Account {
    private Integer id;
    private String name;
    private Double money;

//省略getter/setter，toString方法
api介绍

1
2
3
4
public <T> T query(String sql, ResultSetHandler<T> rsh, Object... params) throws SQLException {
  Connection conn = this.prepareConnection();
  return this.query(conn, true, sql, rsh, params);
}
参数	说明
String sql	执行的sql语句
ResultSetHandler<T> rsh	返回查询结果的映射处理
Object… params	设置的实际参数
查询结果映射介绍

1
2
3
4
5
//查询多条记录
public class BeanListHandler<T> implements ResultSetHandler<List<T>> 
  
//查询单条记录
public BeanHandler(Class<T> type)
测试代码

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
// 根据id查询
@Test
public void testFindById() throws Exception{
  QueryRunner queryRunner = new QueryRunner(JdbcUtils.getDataSource());

  String sql = "SELECT * FROM account WHERE id = ?";

  Account query = queryRunner.query(sql, new BeanHandler<>(Account.class),2);

  System.out.println(query);
}

// 查询所有
@Test
public void testFindAll() throws Exception{
  QueryRunner queryRunner = new QueryRunner(JdbcUtils.getDataSource());

  String sql = "SELECT * FROM account";

  List<Account> query = queryRunner.query(sql, new BeanListHandler<>(Account.class));

  System.out.println(query);
}
1.3 Spring的xml整合DbUtils
需求

基于Spring的xml配置实现账户的CRUD案例

编写AccountDao接口

1
2
3
4
5
6
7
public interface AccountDao {
    void save(Account account);
    void update(Account account);
    void delete(Integer id);
    List<Account> findAll();
    Account findById(Integer id);
}
AccountDaoImpl

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
public class AccountDaoImpl implements AccountDao {

  // 声明 QueryRunner 对象
  private QueryRunner queryRunner;

  public void setQueryRunner(QueryRunner queryRunner) {
    this.queryRunner = queryRunner;
  }

  @Override
  public void save(Account account) {
    try {
      String sql = "INSERT INTO account(name,money) VALUES(?,?)";
      queryRunner.update(sql, account.getName(), account.getMoney());
    } catch (SQLException throwables) {
      throwables.printStackTrace();
    }
  }

  @Override
  public void update(Account account) {
    try {
      String sql = "UPDATE account SET name=?,money=? WHERE id = ?";
      queryRunner.update(sql, account.getName(), account.getMoney(), account.getId());
    } catch (SQLException throwables) {
      throwables.printStackTrace();
    }
  }

  @Override
  public void delete(Integer id) {
    try {
      String sql = "DELETE FROM account WHERE id = ?";
      queryRunner.update(sql, id);
    } catch (SQLException throwables) {
      throwables.printStackTrace();
    }
  }

  @Override
  public List<Account> findAll() {
    List<Account> list = null;

    try {
      String sql = "SELECT * FROM account";
      list = queryRunner.query(sql, new BeanListHandler<>(Account.class));
    } catch (SQLException throwables) {
      throwables.printStackTrace();
    }
    return list;
  }

  @Override
  public Account findById(Integer id) {

    Account account = null;

    try {
      String sql = "SELECT * FROM account WHERE id = ?";
      account = queryRunner.query(sql, new BeanHandler<>(Account.class), id);
    } catch (SQLException throwables) {
      throwables.printStackTrace();
    }
    return account;
  }
}
编写AccountService接口

1
2
3
4
5
6
7
8
public interface AccountService {

    void save(Account account);
    void update(Account account);
    void delete(Integer id);
    List<Account> findAll();
    Account findById(Integer id);
}
AccountServiceImpl实现类

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
public class AccountServiceImpl implements AccountService {

    private AccountDao accountDao;

    public void setAccountDao(AccountDao accountDao) {
        this.accountDao = accountDao;
    }

    @Override
    public void save(Account account) {
        accountDao.save(account);
    }

    @Override
    public void update(Account account) {
        accountDao.update(account);
    }

    @Override
    public void delete(Integer id) {
        accountDao.delete(id);
    }

    @Override
    public List<Account> findAll() {
        return accountDao.findAll();
    }

    @Override
    public Account findById(Integer id) {
        return accountDao.findById(id);
    }
}
编写spring的核心配置文件

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
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.2.xsd">

    <!--druid连接交给ioc容器-->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/spring_db"/>
        <property name="username" value="root"/>
        <property name="password" value="root"/>
    </bean>

    <!--queryRunner交给ioc容器-->
    <bean id="queryRunner" class="org.apache.commons.dbutils.QueryRunner">
        <constructor-arg name="ds" ref="dataSource"/>
    </bean>
    <!--accountDao交给ioc容器-->
    <bean id="accountDao" class="com.test.dao.impl.AccountDaoImpl">
        <property name="queryRunner" ref="queryRunner"/>
    </bean>
    <!--accountService交给ioc容器-->
    <bean id="accountService" class="com.test.service.impl.AccountServiceImpl">
        <property name="accountDao" ref="accountDao"/>
    </bean>
</beans>
测试代码

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
public class AccountTest {

  @Test
  public void testCreate() throws Exception{
    ClassPathXmlApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
    AccountService accountService = app.getBean(AccountService.class);
    Account account = new Account();
    account.setMoney(100.0);
    account.setName("testCreate");
    accountService.save(account);
  }
  @Test
  public void testUpdate() throws Exception{
    ClassPathXmlApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
    AccountService accountService = app.getBean(AccountService.class);
    Account account = new Account();
    account.setId(4);
    account.setMoney(100.0);
    account.setName("testUpdate");
    accountService.update(account);
  }

  @Test
  public void testDelete() throws Exception{

    ClassPathXmlApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
    AccountService accountService = app.getBean(AccountService.class);
    accountService.delete(3);
  }
  @Test
  public void testFindAll() throws Exception{
    ClassPathXmlApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
    AccountService accountService = app.getBean(AccountService.class);
    List<Account> list = accountService.findAll();

    for (Account account : list) {
      System.out.println(account);
    }
  }
  @Test
  public void testFindById() throws Exception{
    ClassPathXmlApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
    AccountService accountService = app.getBean(AccountService.class);
    Account byId = accountService.findById(2);
    System.out.println(byId);
  }
}
1.4 jdbc配置文件抽取
引入context命名空间(约束)

1
2
3
4
5
6
7
8
9
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.2.xsd
       http://www.springframework.org/schema/context
       http://www.springframework.org/schema/context/spring-context.xsd">
修改配置文件标签

1
2
<!-- 加载第三方配置文件 -->
<context:property-placeholder location="classpath:jdbc.properties"/>
二.Spring注解开发
Spring是轻代码而重配置的框架，配置比较繁重，影响开发效率，所以注解开发是一种趋势，注解代替

xml配置文件可以简化配置，提高开发效率。

2.1 Spring常用注解
Spring常用注解主要是替代 <bean> 的配置

2.2.1 IOC:控制反转
注解	作用
@Component	相当于 <bean></bean>
@Repository	专门处理dao层，交给ioc容器
@Service	专门处理service层，交给ioc容器
@Controller	专门处理web层，交给ioc容器
如果使用注解开发，必须开启注解组件扫描

1
2
<!-- 开启注解组件扫描 -->
<context:component-scan base-package="com.test"/>
UserDaoImpl

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
7
8
9
// @Component("userDao") value 属性相当于 id="userDao"
// @Repository("userDao")
@Repository // 如果我们在此处省略了value属性，那么id的默认值就是 类名首字母小写 userDaoImpl
public class UserDaoImpl implements UserDao {
    @Override
    public void save() {
        System.out.println("UserDao Saved!");
    }
}
UserService

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
8
9
10
11
12
13
14
@Service
public class UserServiceImpl implements UserService {

    private UserDao userDao;

    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public void save() {
        userDao.save();
    }
}
2.2.2 DI:依赖注入
注解	作用
@Autowired	相当于 <property></property> ，根据类型注入
@Qualifies	与@Autowired一起使用，根据id查找同类型下的实例
@Resource	JDK提供的注解(@Autowired+@Qualifies)
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
12
@Service
public class UserServiceImpl implements UserService {

  //使用注解完成注入，代替set方法
  @Autowired
  private UserDao userDao;

  @Override
  public void save() {
    userDao.save();
  }
}
IOC容器结构图

Type	id	Class
UserDao	userDaoImpl	com.test.dao.impl.userDaoImpl
UserDao	userDaoImplPro	com.test.dao.impl.userDaoImplPro
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
@Service
public class UserServiceImpl implements UserService {

    //使用注解完成注入，代替set方法
    @Autowired//根据类型注入
    @Resource(name = "userDaoImpl")//JDK提供，ID+类型
    private UserDao userDao;

    @Override
    public void save() {
        userDao.save();
    }
}
2.2.3 补充
注解	作用
@Scope	相当于 <bean scope=””></bean>
@PostConstruct	相当于 <bean init-method=””></bean>
@PreDestroy	相当于 <bean detroy-method=””></bean>
@Value	通过${} SPEL,从配置文件中获取数据
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
@Service
public class UserServiceImpl implements UserService {

  //使用注解完成注入，代替set方法
  @Autowired//根据类型注入
  @Resource(name = "userDaoImpl")//JDK提供，ID+类型
  private UserDao userDao;

  @Value("A")
  private String name;

  @Value("${jdbc.driver}")
  private String driver;


  @Override
  public void save() {
    userDao.save();
  }

  @PostConstruct
  public void init(){
    System.out.println("Init Run");
  }
  @PreDestroy
  public void destory(){
    System.out.println("Destory Run");
  }
}
2.2 Spring常用注解整合DbUtils
复制java模块并改名导入

IDEA new==>Exist moudle==>SELECT Moudle==>Rename Moudle==>修改pom.xml

AccountDao

1
2
3
4
5
6
@Repository
public class AccountDaoImpl implements AccountDao {

    @Autowired
    // 声明 QueryRunner 对象
    private QueryRunner queryRunner;
AccountService

1
2
3
4
5
@Service
public class AccountServiceImpl implements AccountService {

    @Autowired
    private AccountDao accountDao;
修改spring配置文件

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
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.2.xsd
       http://www.springframework.org/schema/context
       http://www.springframework.org/schema/context/spring-context.xsd">


    <!-- 开启注解组件扫描 -->
    <context:component-scan base-package="com.test"/>

    <!-- 加载第三方配置文件 -->
    <context:property-placeholder location="classpath:jdbc.properties"/>

    <!--druid连接交给ioc容器,第三方类目前仅能用bean标签-->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="${jdbc.driver}"/>
        <property name="url" value="${jdbc.url}"/>
        <property name="username" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>
    </bean>

    <!--queryRunner交给ioc容器,第三方类目前仅能用bean标签-->
    <bean id="queryRunner" class="org.apache.commons.dbutils.QueryRunner">
        <constructor-arg name="ds" ref="dataSource"/>
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
@Test
public void testFindAll() throws Exception{
    ClassPathXmlApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
    AccountService accountService = app.getBean(AccountService.class);
    List<Account> list = accountService.findAll();
  
    for (Account account : list) {
        System.out.println(account);
    }
}
2.3 Spring新注解
使用上面的注解还不能全部替代xml配置文件，还需要使用注解替代的配置

注解	作用
@Configuration	相当于applicationContext.xml
@Bean	加载第三方类(对象)，交给ioc容器
@PropertySource	相当于 <context:property-placeholder location=””/>
@ComponentScan	相当于 <context:component-scan base-package=””/>
@Import	相当于 <import resource=””></import>
2.4 Spring纯注解整合DbUtils
创建SpringConfig配置类

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
@Configuration
@ComponentScan("com.test")
@PropertySource("classpath:jdbc.properties")
public class SpringConfig {

  @Value("${jdbc.driver}")
  private String driverClassName;

  @Value("${jdbc.url}")
  private String url;

  @Value("${jdbc.username}")
  private String username;

  @Value("${jdbc.password}")
  private String password;


  // 自定义druid对象，交给ioc容器
  /*
<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
    <property name="driverClassName" value="${jdbc.driver}"></property>
    <property name="url" value="${jdbc.url}"></property>
    <property name="username" value="${jdbc.username}"></property>
    <property name="password" value="${jdbc.password}"></property>
</bean>
*/

  @Bean("dataSource")
  public DataSource createDataSource() {
    DruidDataSource druidDataSource = new DruidDataSource();
    druidDataSource.setDriverClassName(driverClassName);
    druidDataSource.setUrl(url);
    druidDataSource.setUsername(username);
    druidDataSource.setPassword(password);
    return druidDataSource;
  }

  // 自定义queryRunner对象，交给ioc容器
  /*
<bean id="queryRunner" class="org.apache.commons.dbutils.QueryRunner">
    <constructor-arg name="ds" ref="dataSource"></constructor-arg>
</bean>
*/
  @Bean("queryRunner")
  public QueryRunner createQueryRunner(@Autowired DataSource dataSource) {
    QueryRunner queryRunner = new QueryRunner(dataSource);
    return queryRunner;
  }
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
@Test
public void testAnnoQueryRunner() throws Exception {

  AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(SpringConfig.class);

  AccountService accountService = app.getBean(AccountService.class);

  Account byId = accountService.findById(1);
  System.out.println(byId);
}
2.5 配置类模块化
编写DataSourceConfig

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
public class DataSourceConfig {
    @Value("${jdbc.driver}")
    private String driverClassName;

    @Value("${jdbc.url}")
    private String url;

    @Value("${jdbc.username}")
    private String username;

    @Value("${jdbc.password}")
    private String password;


// 自定义druid对象，交给ioc容器
/*
<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
    <property name="driverClassName" value="${jdbc.driver}"></property>
    <property name="url" value="${jdbc.url}"></property>
    <property name="username" value="${jdbc.username}"></property>
    <property name="password" value="${jdbc.password}"></property>
</bean>
*/

    @Bean("dataSource")
    public DataSource createDataSource() {
        DruidDataSource druidDataSource = new DruidDataSource();
        druidDataSource.setDriverClassName(driverClassName);
        druidDataSource.setUrl(url);
        druidDataSource.setUsername(username);
        druidDataSource.setPassword(password);
        return druidDataSource;
    }
}
修改主配置类

1
2
3
4
5
6
7
8
@Configuration
@ComponentScan("com.test")
@PropertySource("classpath:jdbc.properties")
@Import({DataSourceConfig.class})
public class SpringConfig {
/*
    @Value("${jdbc.driver}")
    private String driverClassName;
三.Spring整合Junit
3.1 介绍
Junit是一个单元测试工具，点击run的执行测试方法时，其实底层是通过runner(运行器)来工作的， 默认的Junit是不会自动加载spring环境。

1
2
public class BlockJUnit4ClassRunner extends ParentRunner<FrameworkMethod> {
  private final ConcurrentHashMap<FrameworkMethod, Description> methodDescriptions = new ConcurrentHashMap<FrameworkMethod, Description>();
如果想在Junit中直接获取spring的容器，我们需要导入spring提供的测试整合包，切换为spring的运行 器，就可以直接获取IOC容器中的对象了。

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
<!--junit单元测试-->
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
3.2 使用
在进行单元测试时，指定junti的运行器为spring的

1
2
@RunWith(SpringRunner.class) // 将单元测试的运行器，切换为spring的

指定加载配置文件或者配置类

1
@ContextConfiguration(classes = SpringConfig.class) // 加载配置类的
总结
# spring02

## 一 DbUtils

### 介绍

- DbUtils是Apache一款用于简化jdbc操作的工具类

- 核心对象

​ - QueryRunner queryRunner = new QueryRunner(DataSource dataSource);

- 核心方法

​ - int update();

​ - DML类型

​ - T query();

​ - DQL类型

### Spring的xml整合DbUtils

- spring整合第三方数据源

​ - Druid

- spring整合DbUtils

​ - QueryRunner

- 加载第三方配置文件

​ - <context:property-placeholder location=”classpath:jdbc.properties”/>

- 使用SPEL

​ - ${xxxxxx}

## 二 Spring注解开发

### 常用注解

- IOC

​ - @Component

​ - @Controller

​ - @Service

​ - @Repository

- DI

​ - @Autowired

​ - 根据类型

​ - @Qualifier

​ - 在@Autowired基础上+id

​ - @Resource

​ - @Autowired + @Qualifier

​ - @Value

​ - 通过SPEL表达式，获取第三方配置文件的值

- 生命周期

​ - @Scope

​ - 作用范围

​ - singleton

​ - prototype

​ - @PostConstruct

​ - 初始化执行方法

​ - @PreDestroy

​ - 销毁执行方法

### 新注解

- @Configuration

​ - spring的配置文件

​ - applicationContext.xml

- @Bean

​ - 将第三方类，交给ioc容器

- @PropertySource

​ - 加载第三方配置文件

- @ComponentScan

​ - 开启注解组件扫描

- @Import

​ - 配置类模块化

## 三 Spring整合Junit

### @Runwith注解替换原来的运行器

- @RunWith(SpringRunner.class)

### 使用@ContextConfiguration指定配置文件或配置类

- @ContextConfiguration(value = {“classpath:applicationContext.xml”})

- @ContextConfiguration(classes = {SpringConfig.class})

## 作业

### DBUtil快速入门

### spring的xml版本整合DBUtils

### spring的常用注解版本整合DBUtils

### spring的纯注解版本整合DBUtils

### spring整合junit

