---
title: Spring XML & Annotation,JDBCTemplate & Transaction
date: 2020-06-01 01:43:52
tags:
---

一.基于XML的AOP开发
1.1 XML配置详解
1.1.1 切点表达式
1
execution([修饰符] 返回值类型 包名.类名.方法名(参数列表))
访问修饰符可以省略

返回值类型、包名、类名、方法名可以使用星号 * 代替，代表任意

包名与类名之间一个点 . 代表当前包下的类，两个点 .. 表示当前包及其子包下的类

参数列表可以使用两个点 .. 表示任意个数，任意类型的参数列表

版本	
版本一	控制目标对象中，返回值类型void且public修饰的所有方法
execution(public void com.test.service.impl.AccountServiceImpl.*(..))
版本二	控制目标对象中，任意修饰符任意返回值的所有方法
execution(* com.test.service.impl.AccountServiceImpl.*(..))
版本三	版本三：控制service层所有对象的方法
execution(* com.test.service...(..))
切点表达式抽取

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

  <!--开启注解组件扫描-->
  <context:component-scan base-package="com.test"/>

  <bean id="myAdvice" class="com.test.advice.MyAdvice"></bean>
  <!--aop配置-->
  <aop:config>
    <!--切面-->
    <aop:aspect ref="myAdvice">
      <!--抽取切点表达式-->
      <aop:pointcut id="myPointcut" expression="execution(* com.test.service..*.*(..))"/>
      <!--织入过程...
            method="通知方法" 通知方法
            pointcut="切点表达式"
            execution([修饰符] 返回值类型  包名.类名.方法名(参数列表))
            -->
      <aop:before method="before" pointcut-ref="myPointcut"></aop:before>
    </aop:aspect>
  </aop:config>
</beans>
1.2.2 通知类型
通知的配置语法

1
<aop:通知类型 method="通知类中方法名" pointcut="切点表达式"></aop:通知类型>
四大通知

名称	标签	说明
前置通知	<aop:before>	在切入点方法之前执行
后置通知	<aop:afterReturning>	在切入点方法正常运行之后执行
异常通知	<aop:afterThrowing>	在切点方法发生异常的时候执行
最终通知	<aop:after>	无论切入点方法执行时是否有异常，都会执行
Myadvice

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
@Component
public class MyAdvice {

    // 前置增强
    public void before() {
        System.out.println("Advance Notice");
    }

    // 后置增强
    public void afterReturning(){
        System.out.println("Post Notification");
    }

    // 异常增强
    public void afterThrowing(){
        System.out.println("Exception Notification");
    }

    // 最终增强
    public void after(){
        System.out.println("Final Notice");
    }
}
applicationContext.xml

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
<!--开启注解组件扫描-->
<context:component-scan base-package="com.test"/>

<bean id="myAdvice" class="com.test.advice.MyAdvice"></bean>
<!--aop配置-->
<aop:config>
  <!--切面-->
  <aop:aspect ref="myAdvice">
    <!--抽取切点表达式-->
    <aop:pointcut id="myPointcut" expression="execution(* com.test.service..*.*(..))"/>
    <!--织入过程...
            method="通知方法" 通知方法
            pointcut="切点表达式"
            execution([修饰符] 返回值类型  包名.类名.方法名(参数列表))
            -->
    <aop:before method="before" pointcut-ref="myPointcut"/>
    <aop:after-returning method="afterReturning" pointcut-ref="myPointcut"/>
    <aop:after-throwing method="afterThrowing" pointcut-ref="myPointcut"/>
    <aop:after method="after" pointcut-ref="myPointcut"/>
  </aop:aspect>
</aop:config>
注意：四大通知一般单独使用，因为xml配置顺序可能会打乱我们执行计划，建议使用环绕通知

环绕通知(强无敌)

名称	标签	说明
环绕通知	<aop:around>	可以灵活实现四大通知的所有效果
环绕通知的代码编写，更贴近于动态代理的底层代码

注意：测试环绕通知，需要注释掉四大通知

Myadvice

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
// 环绕通知
// Proceeding（运行）JoinPoint（连接点）  = 切点
public void around(ProceedingJoinPoint proceedingJoinPoint) {
    try {
        System.out.println("Advance notice");
        // 执行切点(调用目标对象原有的方法)
        proceedingJoinPoint.proceed();
  
        System.out.println("Post Notification");
    } catch (Throwable throwable) {
        throwable.printStackTrace();
        System.out.println("Exception Notification");
    } finally {
        System.out.println("Final Notice");
    }
}
1
<aop:around method="around" pointcut-ref="myPointcut"></aop:around>
1.2 知识小结
aop织入的配置
1
2
3
4
5
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
二.基于注解的AOP开发
2.1 快速入门
复制上面的xml工程

目标对象

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
通知对象

1
2
3
//通知类(增强)
@Component
public class MyAdvice {
开启Spring的AOP注解支持

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

    <!--开启注解组件扫描-->
    <context:component-scan base-package="com.test"/>

    <!-- 开启Spring的AOP注解支持 -->
    <aop:aspectj-autoproxy/>
</beans>
将通知升级为切面(通知+切点= 切面)

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
//通知类(增强)
@Component
//升级为切面
@Aspect
public class MyAdvice {

    @Pointcut("execution(* com.test.service..*.*(..))")
    public void myPointcut(){}

    // 前置增强
    @Before("MyAdvice.myPointcut()")
    public void before() {
        System.out.println("Advance notice");
    }

    // 后置增强
    @AfterReturning("MyAdvice.myPointcut()")
    public void afterReturning() {
        System.out.println("Post Notification");
    }

    // 异常增强
    @AfterThrowing("MyAdvice.myPointcut()")
    public void afterThrowing() {
        System.out.println("Exception Notification");
    }

    // 最终增强
    @After("MyAdvice.myPointcut()")
    public void after() {
        System.out.println("Final Notice");
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
2.2 注解配置详解
2.2.1 切点表达式
1
execution([修饰符] 返回值类型 包名.类名.方法名(参数列表))
访问修饰符可以省略
返回值类型、包名、类名、方法名可以使用星号 * 代替，代表任意
包名与类名之间一个点 . 代表当前包下的类，两个点 .. 表示当前包及其子包下的类
参数列表可以使用两个点 .. 表示任意个数，任意类型的参数列表
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
//切面类中抽取表达式
@Pointcut("execution(* com.test.service..*.*(..))")
public void myPointcut(){}

//上面代码替代了XML文件中的
<aop:pointcut id="myPointcut" expression="execution(* com.test.service..*.*(..))"/>

  -------------------
  //直接调用
  @Before("MyAdvice.myPointcut()")
2.2.2 通知类型
四大通知

名称	标签	说明
前置通知	@Before	在切入点方法之前执行
后置通知	@AfterReturning	在切入点方法正常运行之后执行
异常通知	@AfterThrowing	在切点方法发生异常的时候执行
最终通知	@After	无论切入点方法执行时是否有异常，都会执行
注意:使用注解时，四大通知同时开启的顺序：@Before – > @After –> @AfterReturning(异常则@AfterThrowing)

​ 与XML版本相同，大于等于2个通知时，建议使用环绕通知

环绕通知(强无敌)

名称	标签	说明
环绕通知	@Around	可以灵活实现四大通知的所有效果
注意：测试时，注释掉四大通知的注解

当切点同时符合切点规则和环绕规则时，顺序：

@Around – >@Before – > @After –> @Around 执行proceedingJoinPoint.proceed()后的动作–> @AfterReturning(异常则@AfterThrowing)

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
//通知类(增强)
@Component
//升级为切面
@Aspect
public class MyAdvice {

    @Pointcut("execution(* com.test.service..*.*(..))")
    public void myPointcut(){}

    // 环绕通知
    // Proceeding（运行）JoinPoint（连接点）  = 切点
    @Around("MyAdvice.myPointcut()")
    public void around(ProceedingJoinPoint proceedingJoinPoint) {
        try {
            System.out.println("Advance notice");
            // 执行切点(调用目标对象原有的方法)
            proceedingJoinPoint.proceed();

            System.out.println("Post Notification");
        } catch (Throwable throwable) {
            throwable.printStackTrace();
            System.out.println("Exception Notification");
        } finally {
            System.out.println("Final Notice");
        }
    }
}
2.3 纯注解配置
删除Spring的配置文件

写出Spring配置类SpringConfig

1
2
3
4
5
6
@Configuration
@ComponentScan("com.test")
@EnableAspectJAutoProxy//<aop:aspectj-autoproxy>
public class SpringConfig {

}
修改测试代码

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
@ContextConfiguration(classes = SpringConfig.class)
public class AccountTest {

    // 配置了aop之后，这就是代理对象
    @Autowired
    private AccountService accountService;

    @Test
    public void testAOP() throws Exception{
        accountService.transfer();
    }
}
2.4 知识小结
使用注解	作用
使用@Aspect注解	标注切面类
使用@Before等注解	标注通知方法
使用@Pointcut注解	抽取切点表达式
配置aop自动代理	<aop:aspectj-autoproxy/> 或 @EnableAspectJAutoProxy
三.AOP优化转账案例
需求

依然使用前面的转账案例，将两个代理工厂对象直接删除！改为spring的aop思想来实现

3.1 XML实现
新建Java模块，配置依赖

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
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.test</groupId>
    <artifactId>Spring_online_Day04_04_transfer_XML</artifactId>
    <version>1.0-SNAPSHOT</version>

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

    <build>
        <plugins>
            <!-- 设置编译版本为1.8 -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.1</version>
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                    <encoding>UTF-8</encoding>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
Domain,Dao层对象

1
2
3
4
5
6
public class Account {
    private Integer id;
    private String name;
    private Double money;

//此处省略getter/setter/toString
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
public interface AccountDao {

    //转出
    void outUser(String outUser, Double money);

    //转入
    void inUser(String inUser, Double money);

    List<Account> findAll();

    //转出
    void outUser(Connection connection,String outUser, Double money);

    //转入
    void inUser(Connection connection,String inUser, Double money);
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
目标对象

1
2
3
4
public interface AccountService {
    //转账
    void transfer(String outUser,String inUser,Double money);
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
public class AccountServiceImpl implements AccountService {

    // 依赖AccountDao
    @Autowired
    private AccountDao accountDao;

    @Override
    public void transfer(String outUser, String inUser, Double money) {
        accountDao.outUser(outUser,money);
        accountDao.inUser(inUser,money);
    }
}

通知对象

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

    //环绕通知
    public void aroundTx(ProceedingJoinPoint proceedingJoinPoint){
        try {
            beginTransaction();
            proceedingJoinPoint.proceed();
            commit();
        } catch (Throwable throwable) {
            throwable.printStackTrace();
            rollback();
        } finally {
            release();
        }
    }
}
配置xml的切面

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

  <aop:config>
    <aop:aspect ref="transactionManager">
      <aop:pointcut id="myPointcut" expression="execution(* com.test.service..*.*(..))"/>
      <aop:around method="aroundTx" pointcut-ref="myPointcut"></aop:around>
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
@RunWith(SpringRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class AccountTest {
    @Autowired
    private AccountService accountService;

    @Test
    public void testTransferXML() throws Exception{
        accountService.transfer("jerry","tom",100.0);
    }
}

3.2 注解实现
复制java模块

目标对象

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

    // 依赖AccountDao
    @Autowired
    private AccountDao accountDao;

    @Override
    public void transfer(String outUser, String inUser, Double money) {
        accountDao.outUser(outUser,money);
        accountDao.inUser(inUser,money);
    }
}
通知对象

1
2
@Component
public class TransactionManager
开启AOP注解支持

SpringConfig

1
2
3
4
5
6
@Configuration
@ComponentScan("com.test")
@PropertySource("classpath:jdbc.properties")
@EnableAspectJAutoProxy
@Import({DataSourceConfig.class})
public class SpringConfig 
将通知升级为切面

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
@Component
@Aspect
public class TransactionManager {

  @Autowired
  private ConnectionUtils connectionUtils;

	  ......
    ......
    ......

    @Pointcut("execution(* com.test.service..*.*(..))")
    public void myPointcut(){}
  //环绕通知
  @Around("TransactionManager.myPointcut()")
  public void aroundTx(ProceedingJoinPoint proceedingJoinPoint){
    try {
      beginTransaction();
      proceedingJoinPoint.proceed();
      commit();
    } catch (Throwable throwable) {
      throwable.printStackTrace();
      rollback();
    } finally {
      release();
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
@RunWith(SpringRunner.class)
//@ContextConfiguration("classpath:applicationContext.xml")
@ContextConfiguration(classes = SpringConfig.class)
public class AccountTest {
    @Autowired
    private AccountService accountService;

    @Test
    public void testTransferANNO() throws Exception{
        accountService.transfer("jerry","tom",100d);
    }
}
四.Spring的JdbcTemplate
4.1 JdbcTemplate是什么
JdbcTemplate是Spring的一款用于简化Dao代码的工具包，它底层封装了JDBC技术。

核心对象

1
JdbcTemplate jdbcTemplate = new JdbcTemplate(DataSource dataSource);
核心方法

方法	作用
int update();	执行增、删、改语句
List<T> query();	查询多个
T queryForObject();	查询一个
RowMapper<>();	ORM映射接口
new BeanPropertyRowMapper<>();	实现ORM映射封装子类
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
public class JdbcTemplateTest {
  @Test
  public void testFindAll() throws Exception { 
    // 创建核心对象
    JdbcTemplate jdbcTemplate = new JdbcTemplate(JdbcUtils.getDataSource()); 
    // 编写sql
    String sql = "select * from account";
    // 执行sql
    List<Account> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<> (Account.class));
  } 
}
4.2 快速入门
创建maven的java模块

导入依赖坐标

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
    <!--spring-jdbc-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-jdbc</artifactId>
        <version>5.1.5.RELEASE</version>
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
复制JDBC连接池工具类和配置文件

1
public class JdbcUtils
编写新增代码

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
public class JdbcTemplateTest {
    // 新增
    @Test
    public void testJdbcTemplate() throws Exception{

        // 1.创建JdbcTemplate核心对象
        JdbcTemplate jdbcTemplate = new JdbcTemplate(JdbcUtils.getDataSource());

        // 2.编写sql
        String sql = "INSERT INTO account(name,money) VALUES (?,?)";

        // 3.执行sql
        int i = jdbcTemplate.update(sql, "testJdbcTemplate", 1000d);
    }
}
查询

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
@RunWith(SpringRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class JdbcTemplateTest {

    @Autowired
    private AccountService accountService;

    // 新增
    @Test
    public void testJdbcTemplate() throws Exception{

        // 1.创建JdbcTemplate核心对象
        JdbcTemplate jdbcTemplate = new JdbcTemplate(JdbcUtils.getDataSource());

        // 2.编写sql
        String sql = "INSERT INTO account(name,money) VALUES (?,?)";

        // 3.执行sql
        int i = jdbcTemplate.update(sql, "testJdbcTemplate", 1000d);
    }
  }
4.3 Spring整合JdbcTemplate
编写AccountDao

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
public interface AccountDao {

    List<Account> findAll();


    void save(Account account);
    void update(Account account);
    void delete(Integer id);
    Account findById(Integer id);
}
编写AccountDaoImpl

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

@Repository
public class AccountDaoImpl implements AccountDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;


    @Override
    public void save(Account account) {
        String sql = "INSERT INTO account (name, money) VALUES(?,?)";
        jdbcTemplate.update(sql,account.getName(),account.getMoney());

    }

    @Override
    public void update(Account account) {
        String sql = "UPDATE account SET name = ?,money = ? WHERE id=?";
        jdbcTemplate.update(sql, account.getName(),account.getMoney(),account.getId());

    }

    @Override
    public void delete(Integer id) {
        String sql = "DELETE FROM account WHERE id = ?";
        jdbcTemplate.update(sql, id);

    }

    @Override
    public Account findById(Integer id) {
        String sql = "SELECT * FROM account WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Account.class), id);
    }

    @Override
    public List<Account> findAll() {
        String sql = "SELECT * FROM account";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Account.class));
    }
}
编写AccountService

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
public interface AccountService {

    List<Account> findAll();

    void save(Account account);

    void update(Account account);

    void delete(Integer id);

    Account findById(Integer id);
}
编写AccountServiceImpl

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
@Service
public class AccountServiceImpl implements AccountService {

    @Autowired
    private AccountDao accountDao;

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
    public Account findById(Integer id) {
        return accountDao.findById(id);
    }

    @Override
    public List<Account> findAll() {
        return accountDao.findAll();
    }
}
编写Spring的配置文件

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
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
		http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/aop
		http://www.springframework.org/schema/aop/spring-aop.xsd
       http://www.springframework.org/schema/context
		http://www.springframework.org/schema/context/spring-context.xsd">

    <!--加载第三方配置文件-->
    <context:property-placeholder location="classpath:jdbc.properties"/>
    <!--开启注解组件扫描-->
    <context:component-scan base-package="com.test"/>
    <!--druid交给ioc-->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="${jdbc.driver}"/>
        <property name="url" value="${jdbc.url}"/>
        <property name="username" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>
    </bean>

    <!--jdbcTemplate交给ioc-->
    <bean  id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
        <constructor-arg name="dataSource" ref="dataSource"/>
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
@RunWith(SpringRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class JdbcTemplateTest {

    @Autowired
    private AccountService accountService;


    // 新增
    @Test
    public void testJdbcTemplate() throws Exception{

        // 1.创建JdbcTemplate核心对象
        JdbcTemplate jdbcTemplate = new JdbcTemplate(JdbcUtils.getDataSource());

        // 2.编写sql
        String sql = "INSERT INTO account(name,money) VALUES (?,?)";

        // 3.执行sql
        int i = jdbcTemplate.update(sql, "testJdbcTemplate", 1000d);
    }

    @Test
    public void testJdbcFindByID() throws Exception{
        JdbcTemplate jdbcTemplate = new JdbcTemplate(JdbcUtils.getDataSource());

        String sql = "SELECT * FROM account WHERE id = ?";

        Account account = jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Account.class), 5);

        System.out.println(account);
    }

    @Test
    public void testJdbcFindAll() throws Exception{

        List<Account> list = accountService.findAll();

        for (Account account : list) {
            System.out.println(account);
        }
    }

    @Test
    public void testJdbcFindById() throws Exception{

        Account byId = accountService.findById(4);
        System.out.println(byId);
    }

    @Test
    public void testJdbcDelete() throws Exception{
        accountService.delete(4);
    }

    @Test
    public void testJdbcUpdate() throws Exception{
        Account account = new Account();
        account.setId(5);
        account.setName("K");
        account.setMoney(100d);
        accountService.update(account);
    }

    @Test
    public void testJdbcCreate() throws Exception{
        Account account = new Account();
        account.setName("K");
        account.setMoney(100d);
        accountService.save(account);
    }
}
4.4 实现转账案例
Spring当时在设计时，就要求事务交给spring控制,因此无法操作自定义的事务管理器

AccountDao

1
2
3
4
5
6
7
8
9
public interface AccountDao {

    List<Account> findAll();


    void outUser(String outUser,Double money);
    void inUser(String inUser,Double money);

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
@Repository
public class AccountDaoImpl implements AccountDao {

  @Autowired
  private JdbcTemplate jdbcTemplate;


  @Override
  public void outUser(String outUser, Double money) {
    String sql = "update account set money = money - ? where name = ?";
    jdbcTemplate.update(sql,money,outUser);
  }

  @Override
  public void inUser(String inUser, Double money) {
    String sql = "update account set money = money + ? where name = ?";
    jdbcTemplate.update(sql,money,inUser);


  }
  @Override
  public List<Account> findAll() {
    String sql = "SELECT * FROM account";
    return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Account.class));
  }
}
AccountService

1
2
3
4
5
6
public interface AccountService {

    void transfer(String outUser,String inUser,Double money);

    List<Account> findAll();
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
14
15
16
@Service
public class AccountServiceImpl implements AccountService {

  @Autowired
  private AccountDao accountDao;

  @Override
  public void transfer(String outUser, String inUser, Double money) {
    accountDao.outUser(outUser,money);
    accountDao.inUser(inUser,money);
  }
  @Override
  public List<Account> findAll() {
    return accountDao.findAll();
  }
}
测试

1
2
3
4
@Test
public void testJdbcTransfer() throws Exception{
    accountService.transfer("tom","jerry",100d);
}
五.Spring的事务
Spring的事务控制可以分为编程式事务控制和声明式事务控制。

编程式事务

就是将业务代码和事务代码放在一起书写,它的耦合性太高,开发中不使用

声明式事务

将事务代码（spring内置）和业务代码隔离开发, 然后通过一段配置让他们组装运行, 最后达到事务控制的目的.

声明式事务就是通过AOP原理实现的.

5.1 编程式事务
5.1.1 Platform TransactionManager
spring事务管理器的顶级接口，里面提供了我们常用的操作事务的方法(需要坐标 spring-orm)

1
2
3
4
5
6
7
8
    <!--spring的orm-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-orm</artifactId>
        <version>5.1.5.RELEASE</version>
    </dependency>
</dependencies>

事务	功能
TransactionStatus getTransaction(TransactionDefinition definition);	获取事务的状态信息
void commit(TransactionStatus status)；	提交事务
void rollback(TransactionStatus status)；	回滚事务
5.1.2 TransactionDefinition
Spring事务定义参数的接口，例如定义：事务隔离级别、事务传播行为等

事务隔离级别

事务的隔离级别	
ISOLATION_DEFAULT	使用数据库默认级别
MySQL可重复读;Oracle读已提交
ISOLATION_READ_UNCOMMITTED	读未提交
ISOLATION_READ_COMMITTED	读已提交
ISOLATION_REPEATABLE_READ	可重复读
ISOLATION_SERIALIZABLE	串行化
事务传播行为

事务传播行为指的就是当一个业务方法 被 另一个业务方法调用时，应该如何进行事务控制。

行为	说明
REQUIRED（默认传播行为）	如果当前没有事务，就新建一个事务，如果已经存在一个事务中，加入到这个事务中。
如果单独调用方法B时，没有事务，spring就给当前方法创建一个新事物
如果方法A中已经存在了事务，调用方法B时，方法B加方法A的事务中
SUPPORTS	支持当前事务，如果当前没有事务，就以非事务方式执行
如果单独调用方法B时没有事务，咱们就以非事务方法运行
如果方法A中已经存在了事务，调用方法B时，方法B加方法A的事务中
MANDATORY	使用当前的事务，如果当前没有事务，就抛出异常
REQUERS_NEW	新建事务，如果当前在事务中，把当前事务挂起
NOT_SUPPORTED	以非事务方式执行操作，如果当前存在事务，就把当前事务挂起
NEVER	以非事务方式运行，如果当前存在事务，抛出异常
NESTED	如果当前存在事务，则在嵌套事务内执行。如果当前没有事务，则执行 REQUIRED 类似的操作






是否只读

是否只读	
read-only	只读事务(增 删 改不能使用,只能查询使用)
超时时间

超时时间	
timeout	默认值是-1，没有超时限制。如果有，以秒为单位进行设置
5.1.3 TransactionStatus
获取spring当前事务运行的状态

5.1.4 知识小结
Spring中的事务控制主要就是通过这三个API实现的

API	
PlatformTransactionManager	负责事务的管理，它是个接口，其子类负责具体工作
TransactionDefinition	定义了事务的一些相关参数
TransactionStatus	代表事务运行的一个实时状态
可以简单的理解三者的关系:事务管理器通过读取事务定义参数进行事务管理，然后会产生一系列的事务状态。

5.2 使用编程式事务
5.2.1 配置事务管理器
1
2
3
4
<!--事务管理器-->
<bean id="transactionManager"
class="org.springframework.jdbc.datasource.DataSourceTransactionManager"> <property name="dataSource" ref="dataSource"/>
</bean>
5.2.2 修改service层代码
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
@Service
public class xxxServiceImpl implements xxxService{
  @Autowired
  private PlatformTransactionManager transactionManager;
  public void method() {
    DefaultTransactionDefinition def = new DefaultTransactionDefinition(); 
    // 设置是否只读，为false才支持事务
    def.setReadOnly(false);
    // 设置隔离级别 
    def.setIsolationLevel(TransactionDefinition.ISOLATION_DEFAULT);
    // 设置事务的传播行为 
    def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED); 
    // 对事务管理器进行配置
    TransactionStatus status = transactionManager.getTransaction(def);
    try {
      // 业务操作
      // 提交事务
      transactionManager.commit(status); 
    } catch (Exception e) {
      e.printStackTrace(); // 回滚事务
      transactionManager.rollback(status); }
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
43
@Service
public class AccountServiceImpl implements AccountService {

    // 依赖dao
    @Autowired
    private AccountDao accountDao;

    @Override
    public List<Account> findAll() {
        return accountDao.findAll();
    }


    @Autowired
    private PlatformTransactionManager transactionManager;

    @Override
    public void transfer(String outUser, String inUser, Double money) {
        DefaultTransactionDefinition def = new DefaultTransactionDefinition();
        // 设置是否只读，为false才支持事务
        def.setReadOnly(false);
        // 设置隔离级别
        def.setIsolationLevel(TransactionDefinition.ISOLATION_DEFAULT);
        // 设置事务的传播行为
        def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
        // 对事务管理器进行配置
        TransactionStatus status = transactionManager.getTransaction(def);
        try {
            // 核心业务
            accountDao.outUser(outUser, money);
            // 模拟异常..
            int i = 1/0;
            accountDao.inUser(inUser, money);

            // 提交事务
            transactionManager.commit(status);
        } catch (Exception e) {
            e.printStackTrace();
            // 回滚事务
            transactionManager.rollback(status);
        }
    }
}
总结
# spring04

## 一 基于XML的AOP开发

### aop织入的配置

- aop:config

​ <aop:aspect ref=“通知类”>

​ <aop:before method=“通知方法名称” pointcut=“切点表达式”>

​

### 切点表达式

- <aop:pointcut id=”myPointcut” expression=”execution(* com.test.service...(..))”>

### 通知的类型

- aop:before

- aop:after-returning

- aop:after-throwing

- aop:after

- aop:around

## 二 基于注解的AOP开发

### 切面类

- @Aspect

public class MyAdvice {}

### 切点表达式

- @Pointcut(“execution(void com.test.service...(..))”)

public void myPoint(){}

### 通知类型

- @Before

- @AfterReturning

- @AfterThrowing

- @After

- @Around

### AOP自动代理

- aop:aspectj-autoproxy/

- @EnableAspectJAutoProx

## 三 AOP优化转账案例

### xml配置实现

### 注解配置实现

## 四 Spring的JdbcTemplate

### 介绍

- JdbcTemplate是Spring的一款用于简化Dao代码的工具，它底层封装了JDBC技术

- 核心对象

​ - JdbcTemplate jdbcTemplate = new JdbcTemplate(DataSource dataSource);

- 核心方法

​ - DML

​ - int update();

​ - DQL

​ - List query();

​ - T queryForObject();

​ - 查询ORM映射处理实现类

​ - BeanPropertyRowMapper<>(Class 字节码对象)

### Spring整合JdbcTemplate

### 实现转账案例

- 我们发现了无法使用自己定义的事务管理器（LOW）、需要引出spring内置事务管理器

## 五 Spring的事务

### 编程式事务控制（了解）

- 开发者直接把事务的代码和业务代码耦合到一起，在实际开发中不用。

- 相关对象

​ - PlatformTransactionManager

​ - DataSourceTransactionManager

​ - TransactionDefinition

​ - 隔离级别

​ - 传播行为

​ - REQUIRED

​ - SUPPORTS