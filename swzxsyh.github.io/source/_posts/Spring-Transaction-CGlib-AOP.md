---
title: Spring Transaction,CGlib & AOP
date: 2020-05-31 01:42:58
tags:
---

一.转账案例基础
需求

使用Spring框架整合DbUtils技术，实现用户转账功能

1.1 转账基础功能
Java环境与数据库准备

IDEA new moudle==>MAVEN==>创建moudle==>导入包，复制applicationContext.xml和jdbc.properties

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
<!--依赖管理-->
<dependencies>
    <!--mysql-->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>5.1.47</version>
    </dependency>
    <!--druid-->
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>druid</artifactId>
        <version>1.1.15</version>
    </dependency>
    <!--dbUtils-->
    <dependency>
        <groupId>commons-dbutils</groupId>
        <artifactId>commons-dbutils</artifactId>
        <version>1.6</version>
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
16
17
18
19
20
21
<!-- 省略约束 -->

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
编写AccountDao

1
2
3
4
5
6
7
8
public interface AccountDao {

    //转出
    void outUser(String outUser, Double money);

    //转入
    void inUser(String inUser, Double money);
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
@Repository
public class AccountDaoImpl implements AccountDao {

    @Autowired
    private QueryRunner queryRunner;

    @Override
    public void outUser(String outUser, Double money) {

        try {
            String sql = "UPDATE account SET money=money-? WHERE name = ?";
            queryRunner.update(sql, money, outUser);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

    }

    @Override
    public void inUser(String inUser, Double money) {

        try {
            String sql = "UPDATE account SET money=money+? WHERE name = ?";
            queryRunner.update(sql, money, inUser);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
}
编写AccountService

1
2
3
4
5
public interface AccountService {
    //转账
    void transfer(String outUser,String inUser,Double money);
}

AccountServiceImpl

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
public class AccountServiceImpl implements AccountService {

    @Autowired
    private AccountDao accountDao;

    @Override
    public void transfer(String outUser, String inUser, Double money) {

        accountDao.outUser(outUser,money);
        accountDao.inUser(inUser,money);
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
11
12
@RunWith(SpringRunner.class)
@ContextConfiguration({"classpath:applicationContext.xml"})
public class AccountTest {

    @Autowired
    private AccountService accountService;

    @Test
    public void testTransfer() throws Exception{
        accountService.transfer("tom","jerry",100d);
    }
}
目前问题

若服务器出现宕机等事故，事务无回滚，导致只执行一半的问题

1.2 事务控制
解决方案

将service方法的多个dao层代码，看做一个事务，要么都成功，要么都失败

Version_1:手动控制事务，通过一个connection来操作核心业务

修改AccountServiceImpl

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
@Service
public class AccountServiceImpl implements AccountService {

    // 依赖dataSource
    @Autowired
    private AccountDao accountDao;

    //Version_1
    @Autowired
    private DataSource dataSource;

    @Override
    public void transfer(String outUser, String inUser, Double money) {
        Connection connection = null;

        try {
            // 获取conn手动控制事务
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            // 业务代码-------- start
            // 转出
            accountDao.outUser(connection, outUser, money);

            // 转入
            accountDao.inUser(connection, inUser, money);
            // 提交事务
            connection.commit();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
            try {
                // 回滚事务
                connection.rollback();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } finally {
            try {
                // 再改为自动提交
                connection.setAutoCommit(true);
                // 释放资源
                connection.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }
  }
修改AccountDao

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
@Repository
public class AccountDaoImpl implements AccountDao {

    @Autowired
    private QueryRunner queryRunner;

    @Autowired
    private ConnectionUtils connectionUtils;

    @Override
    public void outUser(String outUser, Double money) {

        try {
            String sql = "UPDATE account SET money=money-? WHERE name = ?";
            Connection threadConnection = connectionUtils.getThreadConnection();
            queryRunner.update(threadConnection,sql, money, outUser);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

    }

    @Override
    public void inUser(String inUser, Double money) {

        try {
            String sql = "UPDATE account SET money=money+? WHERE name = ?";
            Connection threadConnection = connectionUtils.getThreadConnection();
            queryRunner.update(threadConnection,sql, money, inUser);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    @Override
    public List<Account> findAll() {

        List<Account> list = null;

        try {
            String sql = "SELECT * FROM account";
            list=queryRunner.query(sql,new BeanListHandler<>(Account.class));
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

        return list;
    }

    @Override
    public void outUser(Connection connection, String outUser, Double money) {

        try {
            String sql = "UPDATE account SET money=money-? WHERE name = ?";
            queryRunner.update(connection,sql, money, outUser);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    @Override
    public void inUser(Connection connection, String inUser, Double money) {
        try {
            String sql = "UPDATE account SET money=money+? WHERE name = ?";
            queryRunner.update(connection,sql, money, inUser);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
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
@RunWith(SpringRunner.class)
@ContextConfiguration({"classpath:applicationContext.xml"})
public class AccountTest {

  @Test
  public void testTransferVersionOne() throws Exception{
    accountService.transfer("tom","jerry",100d);
  } 
}
问题

不应该将service的conn对象传递到dao层，这种方式，就产生了dao层与service的耦合性问题

1.3 ThreadLocal
解决方案

ThreadLocal是一个线程的局部变量,此处用作线程K-V 线程map集合的存取

编写ConnectionUtils

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
/*
ThreadLocal操作的工具类
1. 从当前线程内绑定并获取conn对象
2. 移除当前线程的conn对象
*/

// 交给ioc容器
@Component
public class ConnectionUtils {
    @Autowired
    private DataSource dataSource;

    // 线程隔离
    private static final ThreadLocal<Connection> tl = new ThreadLocal<>();

    // 1.从当前线程内绑定并获取conn对象
    public Connection getThreadConnection(){
        // 第一次执行get，肯定获取不到
        Connection connection = tl.get();
        if(connection==null){

            try {
                connection = dataSource.getConnection();
                tl.set(connection);
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
        return connection;
    }
    // 2.移除当前线程的conn对象
    public void removeThreadConnection(){
        tl.remove();
    }
}
修改AccountServiceImpl

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
@Service
public class AccountServiceImpl implements AccountService {

  // 依赖dataSource
  @Autowired
  private AccountDao accountDao;

  //Version_2

  @Autowired
  private ConnectionUtils connectionUtils;

  @Override
  public void transfer(String outUser, String inUser, Double money) {
    Connection connection=null;

    try {
      // 获取conn手动控制事务
      connection = connectionUtils.getThreadConnection();
      connection.setAutoCommit(false);
      // 业务代码-------- start
      // 转出
      accountDao.outUser(outUser,money);
      // 转入
      accountDao.inUser(inUser,money);
      // 业务代码-------- end
      // 提交事务
      connection.commit();
    } catch (SQLException throwables) {
      throwables.printStackTrace();
      try {
        // 回滚事务
        connection.rollback();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }finally {
      try {
        // 再改为自动提交
        connection.setAutoCommit(true);
        // 释放资源
        connection.close();
      } catch (SQLException throwables) {
        throwables.printStackTrace();
      }
    }

  }
}
修改AccountDao

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
@Repository
public class AccountDaoImpl implements AccountDao {

    @Autowired
    private QueryRunner queryRunner;

    @Autowired
    private ConnectionUtils connectionUtils;

    @Override
    public void outUser(String outUser, Double money) {

        try {
            // 1.编写sql
            String sql = "UPDATE account SET money=money-? WHERE name = ?";
            // 获取当前线程内的 conn
            Connection threadConnection = connectionUtils.getThreadConnection();
            // 2.执行sql
            queryRunner.update(threadConnection,sql, money, outUser);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

    }

    @Override
    public void inUser(String inUser, Double money) {

        try {
            String sql = "UPDATE account SET money=money+? WHERE name = ?";
            Connection threadConnection = connectionUtils.getThreadConnection();
            queryRunner.update(threadConnection,sql, money, inUser);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
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
11
12
13
@RunWith(SpringRunner.class)
@ContextConfiguration({"classpath:applicationContext.xml"})
public class AccountTest {

  @Autowired
  private AccountService accountService;


  @Test
  public void testTransferVersionTwo() throws Exception{
    accountService.transfer("tom","jerry",100d);
  }
}
翻看源码

向当前线程map集合存值

1
2
3
4
5
6
7
8
public void set(T value) {
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    if (map != null)
        map.set(this, value);
    else
        createMap(t, value);
}
当前线程map取值

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
public T get() {
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    if (map != null) {
        ThreadLocalMap.Entry e = map.getEntry(this);
        if (e != null) {
            @SuppressWarnings("unchecked")
            T result = (T)e.value;
            return result;
        }
    }
    return setInitialValue();
}
从当前线程map移出值

1
2
3
4
5
public void remove() {
  ThreadLocalMap m = getMap(Thread.currentThread());
  if (m != null)
    m.remove(this);
}
问题

在企业开发时，我们基础每一个业务层方法都需要进行事务的控制，这部分代码属于公共业务且重复 的，出现了大量的代码冗余

1.4 事务管理器
解决方案

这时候我们可以把这部分代码抽取到工具类(事务管理器)

编写TransactionManager

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
@Component
public class TransactionManager {

    @Autowired
    private ConnectionUtils connectionUtils;

    // 1.开启事务
    public void beginTransaction(){
        try {
            connectionUtils.getThreadConnection().setAutoCommit(false);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    // 2.提交事务
    public void commit(){
        try {
            connectionUtils.getThreadConnection().commit();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    // 3.回滚事务
    public void rollback(){
        try {
            connectionUtils.getThreadConnection().rollback();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    // 4.释放资源
    public void release(){

        try {
            // 恢复自动提交
            connectionUtils.getThreadConnection().setAutoCommit(true);
            // 归还到连接池
            connectionUtils.getThreadConnection().close();
            // 从当前线程删除conn对象
            connectionUtils.removeThreadConnection();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
}
修改AccountService

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
@Service
public class AccountServiceImpl implements AccountService {
    

	//Version_3

    @Autowired
    private TransactionManager transactionManager;

    @Override
    public void transfer(String outUser, String inUser, Double money) {

        try {
            // 开启事务
            transactionManager.beginTransaction();
            // 业务代码-------- start
            // 转出
            accountDao.outUser(outUser,money);
            // 转入
            accountDao.inUser(inUser,money);
            // 业务代码-------- end
            // 提交事务
            transactionManager.commit();
        } catch (Exception e) {
            e.printStackTrace();
            // 回滚事务
            transactionManager.rollback();
        } finally {
            // 释放资源
            transactionManager.release();
        }
    }
   }  
测试

1
2
3
4
@Test
public void testTransferVersionThree() throws Exception{
    accountService.transfer("tom","jerry",100d);
}
问题

所有事务都不可避免使用事务管理器控制
事务管理器属于通用业务，与核心代码产生耦合性
二.转账案例进阶
可以将业务代码和事务代码进行拆分，通过动态代理的方式，对业务方法进行事务的增强。这样就 不会对业务层产生影响，解决了耦合性的问题

常用的动态代理技术

JDK 代理 : 基于接口的动态代理技术

CGLIB代理:基于父类的动态代理技术



修改AccountService代码

企业开发时业务层，只有核心业务代码，不会出现事务相关代码

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
public class AccountServiceImpl implements AccountService {

    // 依赖dataSource
    @Autowired
    private AccountDao accountDao;

    @Override
    public void transfer(String outUser, String inUser, Double money) {
        accountDao.outUser(outUser,money);
        accountDao.inUser(inUser,money);
    }
}
2.1 JDK动态代理
思想

JDKProxyFactory工厂，生产多个代理对象，进行事务增强

目标对象——目标接口——基于接口，创建代理对象(method.invoke调用目标对象原有功能进行增强)

目标对象

1
public class AccountServiceImpl implements AccountService 
编写JdkProxyFactory

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
/*
基于jdk，实现对目标对象，进行事务的增强
*/
@Component
public class JdkProxyFactory {

    @Autowired
    private TransactionManager transactionManager;

    public Object createJDKProxyTx(Object target) {
        Object proxy = null;


        // 使用sun公司提供的jdk代理工具类
/*
        1.目标对象类加器
        2.目标对象接口数组
        3.实现增强的业务逻辑(匿名内部类、lambda)
                */

        //目标对象类 加载器
        ClassLoader classLoader = target.getClass().getClassLoader();
        // 目标对象实现的接口数组
        Class<?>[] interfaces = target.getClass().getInterfaces();
        proxy = Proxy.newProxyInstance(classLoader, interfaces, new InvocationHandler() {

            /*
invoke 方法是代理对象的入口
proxy:jdk工具类生产的代理对象 method:当前用户执行的某个具体方法
args:当前用户执行的某个具体方法传递的实际参数列表
*/
            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                Object result = null;

                try {
                    // 开启事务
                    transactionManager.beginTransaction();
                    // 执行目标对象原有的功能
                    result = method.invoke(target, args);

                    // 提交事务
                    transactionManager.commit();
                } catch (Exception e) {
                    e.printStackTrace();
                    // 回滚事务
                    transactionManager.rollback();
                } finally {
                    // 释放资源
                    transactionManager.release();
                }
                return result;
            }
        });
        // 返回增强后的代理对象
        return proxy;
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
@RunWith(SpringRunner.class)
@ContextConfiguration({"classpath:applicationContext.xml"})
public class AccountTest {

    // 目标对象
    @Autowired
    private AccountService accountService;

    // jdk生产代理对象工厂
    @Autowired
    private JdkProxyFactory jdkProxyFactory;

    @Test
    public void testJDKProxy() throws Exception{
        // 目标对象没有事务增强
        // accountService.transfer("tom", "jerry", 100d);
        // 使用jdk对目标对象事务增强
        AccountService jdkProxy = (AccountService) jdkProxyFactory.createJDKProxyTx(accountService);
        jdkProxy.transfer("tom","jerry",100d);
    }
 
  }
2.2 CGLIB动态代理
问题

进入公司，可能有些代码没有接口，但又需要动态代理进行增强，这时候sun公司提供jdk工具就无法实 现了

解决方案

基于CGLIB技术，对普通java类型实现代理增强(第三方，需导包)

代理对象获取父对象所有方法(method.invoke)，用户访问代理增强对象即可

目标对象

1
public class AccountServiceImpl implements AccountService 
编写CglibProxyFactory

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
/*
基于cglib，实现对目标对象，进行事务的增强
*/
@Component
public class CglibProxyFactory {

    @Autowired
    private TransactionManager transactionManager;

    public Object createCglibProxyTx(Object target) {
        Object proxy = null;


        // 使用cglib提供的工具类
        /*
        1. 目标对象class类
        2. 实现增强的业务逻辑(匿名内部类、lambda) */

        proxy = Enhancer.create(target.getClass(), new MethodInterceptor() {
            /*
            intercept 代理对象方法入口
            1.o cglib生产出来的代理对象
            2.method 执行代理对象(子)，被拦截的方法
            3.objects 执行代理对象，被拦截的方法的参数列表
            4.methodProxy 目标对象(父)，被拦截的方法，功能与method一样的
            */
            @Override
            public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
                Object result = null;

                try {
                    // 开启事务
                    transactionManager.beginTransaction();
                    // 调用目标对象原有的功能
                    result=method.invoke(target,objects);
                    // 提交事务
                    transactionManager.commit();
                } catch (Exception e) {
                    e.printStackTrace();
                    // 回滚事务
                    transactionManager.rollback();
                } finally {
                    // 释放资源
                    transactionManager.release();
                }

                return result;
            }
        });
        // 返回增强后的代理对象
        return proxy;
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
11
12
13
14
15
16
17
@RunWith(SpringRunner.class)
@ContextConfiguration({"classpath:applicationContext.xml"})
public class AccountTest {

  // 目标对象
  @Autowired
  private AccountService accountService;

  @Autowired
  private CglibProxyFactory cglibProxyFactory;

  @Test
  public void testCglibProxy() throws Exception{
    // 使用cglib对目标对象事务增强
    AccountService jdkProxy = (AccountService) cglibProxyFactory.createCglibProxyTx(accountService);
    jdkProxy.transfer("tom","jerry",100d);
  }
2.3 总结
2.3.1 jdk和cglib两种代理方式的选择?
优先使用jdk，性能高于cglib

如果目标对象有接口，一定使用jdk创建代理对象

如果目标对象没有接口，没办法只能使用cglib创建代理对象

2.3.2 当核心业务(转账)和通用业务(事务、日志)同时出现时?
开发阶段

拆分(核心业务在service，事务管理在单独工具类中):解耦

运行阶段

通过动态代理技术，进行组合:功能增强



三.SpringAOP简介
3.1 概述
AOP( 面向切面编程 )是一种思想, 它的目的就是在不修改源代码的基础上,对原有功能进行增强。 Spring AOP是对AOP思想的一种实现, Spring底层同时支持jdk和cglib动态代理。

优势
在程序运行期间，在不修改源码的情况下对方法进行功能增强
逻辑清晰，开发核心业务的时候，不必关注增强业务的代码
减少重复代码，提高开发效率，便于后期维护
Spring会根据被代理的类是否有接口自动选择代理方式
如果有接口,就采用jdk动态代理
没有接口就采用cglib的方式
3.2 相关术语
术语	解释	目标对象
Target	目标对象	service层的核心业务
JoinPoint	连接点	目标对象中的所有方法
Pointcut	切点	目标对象需要增强的方法
Advice	通知(增强)	实现增强的功能的
Weaving	织入	将通知和切点进行织入(动作)
Aspect	切面(spring术语)	通知 + 切点 = 切面
Proxy	代理对象(底层实现)	通知 + 切点 = 代理对象
3.3 明确注意事项
开发阶段

编写核心业务代码(开发主线):要求熟悉业务需求。
把公用代码抽取出来，制作成通知，要求熟悉AOP思想。
在配置文件中，声明切入点与通知间的关系，即切面，要求熟悉AOP思想。
运行阶段(Spring框架完成的)

Spring读取配置文件中的切面信息，根据切面中的描述，将增强功能增加在目标对象的切点方法上，动 态创建代理对象，最后将经过代理之后对象放入ioc容器中

必知必会

能够编写目标对象(转账)
能够看懂通知类(事务管理器)
能够配置aop切面(切点+通知)，spring自动创建代理对象
四.基于XML的AOP开发
4.1 快速入门
需求

实现对转账方法的增强

创建maven的java模块，导入坐标

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
  <!--spring的核心-->
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.1.5.RELEASE</version>
  </dependency>
  <!--aspectj-->
  <dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.9.5</version>
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
</dependencies>
编写目标类(AccountService)

1
2
3
4
public interface AccountService {
    void transfer();
    void save();
}
AccountServiceImpl

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
public class AccountServiceImpl implements AccountService {
    @Override
    public void transfer() {
        System.out.println("Transfer");
    }

    @Override
    public void save() {
        System.out.println("Save");
    }
}
编写通知类(增强)

1
2
3
4
5
6
7
//通知类(增强)
public class MyAdvice {

    public void before(){
        System.out.println("Advance notice");
    }
}
配置spring的AOP(切点+通知)

如果spring要使用aop，需要再引入schema约束+命名空间

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
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:p="http://www.springframework.org/schema/p"
       xsi:schemaLocation="
       	http://www.springframework.org/schema/beans
		http://www.springframework.org/schema/beans/spring-beans.xsd
       	http://www.springframework.org/schema/context
		http://www.springframework.org/schema/context/spring-context.xsd
	    http://www.springframework.org/schema/aop
		http://www.springframework.org/schema/aop/spring-aop.xsd">

<bean id="accountService" class="com.test.service.impl.AccountServiceImpl">
    </bean>

    <bean id="myAdvice" class="com.test.advice.MyAdvice"></bean>

    <aop:config>
        <aop:aspect ref="myAdvice">
            <aop:before method="before" pointcut="execution(public void com.test.service.impl.AccountServiceImpl.transfer())"></aop:before>
        </aop:aspect>
    </aop:config>
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
13
@RunWith(SpringRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class AccountTest {

    // 配置了aop之后，这就是代理对象
    @Autowired
    private AccountService accountService;

    @Test
    public void testAOP() throws Exception{
        accountService.transfer();
    }
}
4.2 xml配置详解
4.2.1 切点表达式
表达式语法

1
execution([修饰符] 返回值类型 包名.类名.方法名(参数列表))
访问修饰符可以省略

返回值类型、包名、类名、方法名可以使用星号 * 代替，代表任意

包名与类名之间一个点 . 代表当前包下的类，两个点 .. 表示当前包及其子包下的类

参数列表可以使用两个点 .. 表示任意个数，任意类型的参数列表

4.2.2 通知类型
通知的配置语法

1
<aop:通知类型 method="通知类中方法名" pointcut="切点表达式"></aop:通知类型>
四大通知

名称	标签	说明
前置通知	<aop:before>	在切入点方法之前执行
后置通知	<aop:afterReturning>	在切入点方法正常运行之后执行
异常通知	<aop:afterThrowing>	在切点方法发生异常的时候执行
最终通知	<aop:after>	无论切入点方法执行时是否有异常，都会执行
环绕通知

名称	标签	说明
环绕通知	<aop:around>	可以灵活实现四大通知的所有效果
4.2.3 知识小结
aop织入的配置
1
2
3
4
5
6
<aop:config>

<aop:aspect ref=“通知类”>
<aop:before method=“通知方法名称” pointcut=“切点表达式">\</aop:before>
</aop:aspect>
</aop:config>
通知的类型

前置通知、后置通知、异常通知、最终通知

环绕通知

切点表达式

1
execution([修饰符] 返回值类型 包名.类名.方法名(参数列表))
总结
# spring03

## 一 转账案例基础

### 基础功能

- 转出

- 转入

### 传统事务控制

- ConnectionUtils

​ - ThreadLocal

​ - 线程局部变量，存储空间（Thread.ThreadLocalMap）

- TransactionManager

​ - 事务管理器

### 问题：

- 核心业务 和 通用业务 产生了代码入侵

## 二 转账案例进阶

### 代理事务控制

- JDK

- CGLIB

## 三 SpringAOP简介

### AOP：面向切面编程

- 在不修改源代码情况下，实现对方法的增强

### spring的AOP

- 简化了增强部分的配置，使开发者只关注业务本身

### AOP底层实现

- 动态代理

### AOP相关概念

- Target

​ - 目标对象

- Joinpoint

​ - 连接点

- Pointcut

​ - 切点

- Advice

​ - 通知

- Weaving

​ - 织入

- Aspect

​ - 切面

- Proxy

​ - 代理对象

## 四 基于XML的AOP开发

### aop织入的配置

- aop:config

​ <aop:aspect ref=“通知类”>

​ <aop:before method=“通知方法名称” pointcut=“切点表达式”></aop:before>

​ </aop:aspect>

</aop:config>