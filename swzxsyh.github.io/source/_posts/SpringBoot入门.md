---
title: SpringBoot入门
date: 2020-07-11 01:53:05
tags:
---


一.SpringBoot简介
1.1 Spring Boot 整合了所有的框架以及中间件
SpringBoot不是对Spring功能的增强，而是提供一种快速使用Spring的开发方式。

springboot与第三方框架以及MOM（中间件 MQ、Redis）进行了集成（整合）
开发过程中简化开发:
无需编写框架相关以及框架整合配置文件了
jar无需管理
springboot开发的程序：
只需要“run”一下就能发布一个应用（项目启动起来）—内嵌tomcat
建议打jar包
1.2 小结：
快速构建项目（引入jar依赖）
对主流开发框架的无配置集成（开箱即用）
项目可独立运行，无需依赖外部的servlet容器（tomcat）
提供运行时的应用监控【dubbo admin】
极大的提高了开发效率、部署效率

<!-- more -->

二.SpringBoot快速入门
2.1 需求
开发一个web应用并完成字符串“hello boot”在浏览器显示。

2.2 步骤
创建jar工程
添加依赖
添加starter-parent
添加web依赖（加载springmvc相关依赖）
编写启动类
编写Controller
2.3 SpringBoot实现
2.3.1 构建工程方式一
2.3.1.1 创建maven工程
创建maven工程 springboot_day01_demo1_quickstart

添加起步依赖

1
2
3
4
5
6
7
<!--添加起步依赖-->
<!--该依赖中包含了集成主流框架的jar的版本-->
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
</parent>
添加web依赖

1
2
3
4
5
6
7
8
<!--添加web依赖-->
<!--该依赖中已包含了springmvc需要常见jar包-->
<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>
</dependencies>
2.3.1.2 工程jar依赖情况
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
#
spring-boot-starter-2.1.4.RELEASE.jar
#springboot程序启动需要
spring-boot-starter-web-2.1.4.RELEASE.jar
#Jackson解析
spring-boot-starter-json-2.1.4.RELEASE.jar
#内嵌Tomcat服务器
spring-boot-starter-tomcat-2.1.4.RELEASE.jar
#服务器数据校验
hibernate-validator-6.0.16.Final.jar
#Springmvc相关依赖
spring-web-5.1.6.RELEASE.jar
spring-webmvc-5.1.6.RELEASE.jar
2.3.1.3 编写启动类
1
2
3
4
5
6
7
8
// 只需要run一下，就能发布一个springboot应用
// 相当于之前将web工程发布到tomcat服务器，只是在springboot中集成了tomcat插件
@SpringBootApplication
public class QuickStartApplication {
  public static void main(String[] args) {
    SpringApplication.run(QuickStartApplication.class,args);
  }
}
2.3.1.4 编写HelloController
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
@RestController
@RequestMapping("/HelloController")
public class HelloController {

  @RequestMapping("/hello")
  public String hello(){
    System.out.println("Done");
    return "AAA";
  }
}
2.3.1.5 测试
运行main方法，访问 localhost:8080/springboot/hello

2.4 总结
springboot入门程序：

创建工程
编写启动类
编写配置文件（application.properties/yml/yaml）
编写相关业务代码
如有页面和静态资源：在resources目录下创建：
templates：存放HTML页面
static：存放静态资源

三.SpringBoot版本控制原理
版本控制（添加了parent工程 spring-boot-starter-parent 规定了jar的版本）

3.1 spring-boot-starter-parent
起步依赖：SpringBoot工程继承Spring-boot-starter-parent后，已经锁定了版本等配置。起步依赖的作用是进行依赖传递 。

3.2 @SpringBootApplication
复合注解,内部如下

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
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
//与之前@Configuration注解一样，声明为一个配置类
@SpringBootConfiguration
/**自动配置
*自动将相关的bean注册到spring IoC容器中
*开发人员可以直接使用jedis/jedispool/jediscluster/RedisTemplate/JdbcTemplate
*/
@EnableAutoConfiguration
//spring IoC容器的扫描包，默认扫描引导程序下的包以及子包，如果我们写的程序不在该包范围内，可以通过该注解指定。
@ComponentScan(
  excludeFilters = {@Filter(
    type = FilterType.CUSTOM,
    classes = {TypeExcludeFilter.class}
  ), @Filter(
    type = FilterType.CUSTOM,
    classes = {AutoConfigurationExcludeFilter.class}
  )}
)
自动装配：最好不配置，默认的配置都给配好了。
四.SpringBoot配置文件使用
springboot应用配置文件格式：两种

系统级别
bootstrap.properites
应用级别
application.properties/application.yml/yaml
4.1 application.properties
4.1.1 语法
格式：key=value

如果是修改SpringBoot中的默认配置，那么key则不能任意编写，必须参考SpringBoot官方文档。

application.properties官方文档

docs.spring.io/spring-boot/docs/2.1.14.RELEASE/reference/html

4.1.2 案例
在springboot-day01-demo1-quickstart工程的resources目录下添加application.properties文件

application.properties

1
2
3
4
#tomcat port
server.port=8081
#app context
server.servlet.context-path=/demo
启动后地址更改为 localhost:8081/demo/springboot/hello

4.2 application.yml/yaml
4.2.1 语法
要求：
区分大小写
数据值前必须有空格，作为分隔符
缩进的空格数目不重要，只需要对齐即可
4.2.2 案例
首先删除application.properties文件，properties优先级高于yml/yaml，会被覆盖

application.yml

1
2
3
4
server:
  port: 8082
  servlet:
    context-path: /testYaml
4.3 获取配置文件中的值
获取值的方式：
@Value注解的方式
注入Environment的方式
@ConfigurationProperties
4.3.1 在yml文件中配置如下内容
application.yml

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
# 基本格式 key: value
name: A
# 数组   - 用于区分
city:
  - B
  - C
  - D
  - E
# 集合中的元素是对象形式
students:
  - name: F
    age: 18
    score: 99.99
  - name: G
    age: 19
    score: 88
  - name: H
    age: 20
    score: 90
# map集合形式
maps: {"name":"I", "age": 21}
# 参数引用
person:
  name: ${name} # 该值可以获取到上边的name定义的值
4.3.2 通过@Value取值
HelloController

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
@RestController
@RequestMapping("/HelloController")
public class HelloController {

  @Value("${name}")
  private String name;

  @Value("${city[0]}")
  private String city0;

  @Value("${students[1].name}")
  private String student1Name;

  @Value("${maps.age}")
  private Integer age;

  @Value("${person.name}")
  private String personName;

  @RequestMapping("/hello")
  public String hello(){
    System.out.println("Done");

    System.out.println(name);
    System.out.println(city0);
    System.out.println(student1Name);
    System.out.println(age);
    System.out.println(personName);
    
    return "AAA";
  }
}
4.3.3 通过Environment取值
HelloController

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
@RestController
@RequestMapping("/HelloController")
public class HelloController {
  // 通过注入Environment取值
  @Autowired
  private Environment env;

  @RequestMapping("/hello2")
  public String hello2(){
    System.out.println("Done");

    System.out.println(env.getProperty("name"));
    System.out.println(env.getProperty("city[0]"));
    System.out.println(env.getProperty("students[1].name"));
    System.out.println(env.getProperty("maps.age"));
    System.out.println(env.getProperty("person.name"));
    
    return "BBB";
  }
}
4.3.4@ConfigurationProperties取值
作用：前缀定义了哪些外部属性将绑定到指定类的字段上

使用场景：

如果只是某个业务中需要获取配置文件中的某项值或者设置具体值，可以使用@Value或Environment；
如果一个JavaBean中大量属性值要和配置文件进行映射，可以使用@ConfigurationProperties；
4.3.4.1 在yml文件中添加如下内容
1
2
3
4
myapp:
  mail:
    address: abc@test.com
    message: This is test
4.3.4.2 创建一个pojo
Mail.java

1
2
3
4
5
6
7
8
@Component
@ConfigurationProperties(prefix = "myapp.mail")
public class Mail {
  private String address;
  private String message;

//TODO getter & setter
}
4.3.4.3 取值
HelloController

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
@RestController
@RequestMapping("/HelloController")
public class HelloController {

  @Autowired
  private Mail mail;

  @RequestMapping("/hello3")
  public String hello3(){
    System.out.println("Done");

    System.out.println(mail.getAddress());
    System.out.println(mail.getMessage());
    
    return "CCC";
  }
}
4.4 spring.profiles.active指定开发环境
spring.profiles.active=test/dev/pro
test，测试环境
dev，开发环境
pro，生产环境
4.4.1 properties文件
application.properties

1
2
# 指定开发环境 test：测试环境  dev：开发环境  pro：生产环境
spring.profiles.active=test  
application-dev.properties

1
server.port=8082
application-pro.properties

1
server.port=8081
application-test.properties

1
server.port=8080
五.SpringBoot与其他框架集成
5.1 集成mybatis
5.1.1 需求
查询所有用户列表。

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
create database springboot_quickstart;
use springboot_quickstart;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO `user` VALUES ('1', 'zhangsan', '123', '北京');
INSERT INTO `user` VALUES ('2', 'lisi', '123', '上海');
5.1.2 创建Maven工程并添加依赖
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
<!--添加起步依赖-->
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
</parent>

<dependencies>

  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>
  <dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>2.0.1</version>
  </dependency>

  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
  </dependency>
  <dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <scope>runtime</scope>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
  </dependency>
</dependencies>
5.1.3 编写启动类
MybatisApplication

1
2
3
4
5
6
@SpringBootApplication
public class MybatisApplication {
  public static void main(String[] args) {
    SpringApplication.run(MybatisApplication.class, args);
  }
}
5.1.4 添加application.properties文件
application.properties

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
#连接数据库
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://localhost/springboot_quickstart?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=root
#mybatis别名
mybatis.type-aliases-package=com.test.pojo
#加载映射文件
mybatis.mapper-locations=classpath:mapper/*.xml
#设置日志，com.test：只查看该包下程序的日志
logging.level.com.test=debug
5.1.5 编写pojo
User.java

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
    private String password;
    private String address;
    // TODO getters、setters
}
5.1.6 编写mapper接口以及映射文件
在接口中添加@Mapper注解（标记该类是一个Mapper接口，可以被SpringBoot自动扫描）

1
2
3
4
@Mapper
public interface UserDao {
    List<User> findUsers();
}
编写映射文件：在工程的resources/mapper目录下创建UserDao.xml

1
2
3
4
5
6
7
8
9
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.test.dao.UserDao">

  <select id="findUsers" resultType="com.test.pojo.User">
    SELECT * FROM user
  </select>
</mapper>
5.1.7 编写service接口以及实现类
UserService.java

1
2
3
public interface UserService {
    List<User> findUsers();
}
UserServiceImpl.java

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
@Service
public class UserServiceImpl implements UserService{

  @Autowired(required = false)
  private UserDao userDao;

  @Override
  public List<User> findUsers() {
    return userDao.findUsers();
  }
}
5.1.8 编写controller
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
@RestController
@RequestMapping("/user")
public class UserController {

  @Autowired
  private UserService userService;

  @RequestMapping("/findUsers")
  public List<User> findUsers(){
    System.out.println("AAAAA");
    List<User> users = userService.findUsers();

    return users;
  }
}
5.2 集成Spring Data Redis
Spring Data

Spring 的一个子项目。用于简化数据库访问，支持NoSQL和关系数据库存储。其主要目标是使数据库的访问变得方便快捷。

5.2.1 在同一工程Maven文件中配置Redis启动器
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
<!--redis-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
<!--json解析-->
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <version>1.2.51</version>
</dependency>
5.2.2 配置application.properties
application.properties

1
2
3
#redis，本地可以不配置，默认配置
spring.redis.host=localhost
spring.redis.port=6379
5.2.3 更新UserServiceImpl
UserServiceImpl.java

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
@Service
public class UserServiceImpl implements UserService {

  @Autowired(required = false)
  private UserDao userDao;

  @Autowired
  private StringRedisTemplate stringRedisTemplate;

  @Autowired
  private RedisTemplate redisTemplate;

  @Override
  public List<User> findUsers() {
    // 首先判断缓存中是否有数据
    String text = stringRedisTemplate.boundValueOps("A:springboot:user:id:1").get();
    List<User> users = JSON.parseArray(text, User.class);
    if (users == null) {
      // 从数据库中查询
      users = userDao.findUsers();
      // 放入缓存      		
      stringRedisTemplate.boundValueOps("A:springboot:user:id:1").set(JSON.toJSONString(users));
    }

    return users;
  }
}
5.2.5 扩展-了解
使用RedisTemplate对象操作Redis服务，代码如下

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
@Autowired
private RedisTemplate redisTemplate;

@Override
public List<User> findUsers() {
    List<User> users = (List<User>) redisTemplate.boundValueOps("A:springboot:user:id:1").get();
    if (users == null) {
        users = userDao.findUsers();
        redisTemplate.boundValueOps("A:springboot:user:id:1").set(users);
    }
    return users;
}
需要对User实现序列化接口，否则报未序列化错误，同时清除缓存，否则报序列号错误

1
2
3
4
5
6
7
public class User implements Serializable {
  private Integer id;
  private String username;
  private String password;
  private String address;
  //TODO getter/setter
}
RedisTemplate 和 StringRedisTemplate的区别

RedisTemplate 的序列化采用的是 JdkSerializationRedisSerializer,在存储到 Redis 的时候会将 对象 序列化为 字节数组

StringRedisTemplate 的序列化采用的是 StringRedisSerializer,适用于存储的 value 为 String 的情况

结论：
Redis 中存储对象使用 RedisTemplate ，存储字符串使用 StringRedisTemplate

JdkSerializationRedisSerializer 和 StringRedisSerializer

JdkSerializationRedisSerializer底层还是通过调用JDK的IO操作ObjectInputStream和ObjectOutputStream类实现POJO的序列化和反序列化，优点是反序列化时不需要提供类型信息(class)，但缺点是需要实现Serializable接口，还有序列化后的结果非常庞大，是JSON格式的5倍左右，这样就会消耗redis服务器的大量内存。

使用Jackson库将对象序列化为JSON字符串。优点是速度快，序列化后的字符串短小精悍，不需要实现Serializable接口。但缺点也非常致命，那就是此类的构造函数中有一个类型参数，必须提供要序列化对象的类型信息(.class对象)

5.3 集成定时器
在SpringBoot启动类中添加开启定时任务注解：@EnableScheduling

1
2
3
4
5
6
7
@SpringBootApplication
@EnableScheduling
public class MybatisApplication {
  public static void main(String[] args) {
    SpringApplication.run(MybatisApplication.class, args);
  }
}
TimeProgarm.java

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
@Component
public class TimeProgarm {
  /**
     * 掌握：cron表达式是一个字符串，字符串以5或6个空格隔开，分开共6或7个域，每一个域代表一个含义
     *  [秒] [分] [小时] [日] [月] [周] [年]
     *  [年]不是必须的域，可以省略[年]，则一共7个域
     *
     * 了解：
     *  fixedDelay：上一次执行完毕时间点之后多长时间再执行（单位：毫秒）
     *  fixedDelayString：同等，唯一不同的是支持占位符，在配置文件中必须有time.fixedDelay=5000
     *  fixedRate：上一次开始执行时间点之后多长时间再执行
     *  fixedRateString：同等，唯一不同的是支持占位符
     *  initialDelay：第一次延迟多长时间后再执行
     *  initialDelayString：同等，唯一不同的是支持占位符
     */
  //    @Scheduled(fixedDelay = 5000)
  //    @Scheduled(fixedDelayString = "5000")
  //    @Scheduled(fixedDelayString = "${time.fixedDelay}")
  //    @Scheduled(fixedRate = 5000)
  //    // 第一次延迟1秒后执行，之后按fixedRate的规则每5秒执行一次
  //    @Scheduled(initialDelay=1000, fixedRate=5000)
  @Scheduled(cron = "30 45 15 08 07 *")
  public void myTask(){
    System.out.println("DDD");
  }
}
5.4 集成单元测试
5.4.1 添加依赖
1
2
3
4
5
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
5.4.2 编写单元测试
单元测试类需要在启动类包或者子包下

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
@RunWith(SpringRunner.class)
@SpringBootTest
public class MybatisTest {

	@Autowired
	private UserService userService;
	
	@Test
	public void contextLoad(){
	    List<User> users = userService.findUsers();
	    for (User user : users) {
	        System.out.println(user);
	    }
	}
}
六.SpringBoot自动配置使用
6.1 自动注入RedisTemplate
6.1.1 需求
6.1.2 代码实现
6.1.2.1 创建maven工程并添加依赖
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
<!--起步依赖-->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.1.4.RELEASE</version>
</parent>

<dependencies>
    <!--加入springboot的starter起步依赖-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
    </dependency>
    <!--Redis依赖-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
    </dependency>
</dependencies>
6.1.2.2 创建启动类
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
@SpringBootApplication
public class AutoConfigApplication {

    public static void main(String[] args) {
        // 获取Spring IoC容器
        ConfigurableApplicationContext context = SpringApplication.run(AutoConfigApplication.class, args);
        // 获取容器中的bean
        Object redisTemplate = context.getBean("redisTemplate");
        System.out.println(redisTemplate);
    }
}
6.1.2.3 启动服务并测试
1
org.springframework.data.redis.core.RedisTemplate@5d1b9c3d
如果将pom文件中的redis启动器的依赖给注释掉，我们在启动服务则报错

6.1.3 总结
通过SpringBoot开发程序，需要获取Spring容器中注册的Bean，那么我们只需要在pom文件中添加相关的启动器即可。如果没有该启动器，我们可以自定义。

6.2 Spring之Conditional条件注解
Conditional 是在spring4.0 增加的条件注解，当你注册bean时，可以对这个bean添加一定的自定义条件，当满足这个条件时，注册这个bean，否则不注册。

6.2.1 需求
在Spring的IoC容器中注入User的Bean，但是要求如下：

如果pom文件中依赖了Jedis则创建该User实例
如果pom文件中没有依赖了Jedis则不创建该User实例
6.2.2 代码实现
6.2.2.1 添加依赖
1
2
3
4
5
<!--Jedis依赖-->
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
</dependency>
6.2.2.2 创建User对象
1
2
public class User {
}
6.2.2.3 创建ClassCondition
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
public class ClassCondition implements Condition {

  @Override
  public boolean matches(ConditionContext conditionContext, AnnotatedTypeMetadata annotatedTypeMetadata) {
    boolean flag = false;

    try {
       // 判断是否有该jedis字节码
      Class<?> aClass = Class.forName("redis.clients.jedis.Jedis");
      flag=true;
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    }
    return flag;
  }
}
6.2.2.3 创建配置类
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
@Configuration
public class UserConfig {

  @Bean
  // 判断ClassCondition中内容是否成立，如果成立则创建user的bean，否则不创建
  @Conditional(value = {ClassCondition.class})
  public User user() {
    return new User();
  }
}
6.2.3 代码优化
在ClassCondition类中，只能判断是否有jedis依赖，我们的代码硬编码了。因此我们可以对该程序优化。

6.2.3.1 分析
在实现类ClassCondition的matches方法中有个annotationTypeMetadata参数，而该参数的作用是获取注解中的属性值的。那么我们可以从这里下手。

1
2
3
4
5
6
7
8
9

/**     
* @param conditionContext      上下文对象，获取属性值、获取类加载器、获取BeanFactory
* @param annotatedTypeMetadata 元数据对象，获取注解属性
*/

@Override
public boolean matches(ConditionContext conditionContext, AnnotatedTypeMetadata annotatedTypeMetadata) {
}
6.2.3.2 自定义Conditional注解
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
//注解的作用目标
//@Target(ElementType.TYPE)——接口、类、枚举、注解
//@Target(ElementType.METHOD)——方法
@Target({ElementType.TYPE, ElementType.METHOD})
//@Retention作用是定义被它所注解的注解声明周期
//注解不仅被保存到class文件中，jvm加载class文件之后，仍然存在
@Retention(RetentionPolicy.RUNTIME)
//生成接口文档带有注释
@Documented
@Conditional(value = {ClassCondition.class})
public @interface ConditionOnClass {
    String[] value() default {};
}
6.2.3.3 修改UserConfig
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
@Configuration
public class UserConfig {

  @Bean
  // 判断ClassCondition中内容是否成立，如果成立则创建user的bean，否则不创建
  @ConditionOnClass(value = {"redis.clients.jedis.Jedis"})
  public User user() {
    return new User();
  }
}
6.2.3.4 修改ClassCondition
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
public class ClassCondition implements Condition {
  @Override
  public boolean matches(ConditionContext conditionContext, AnnotatedTypeMetadata annotatedTypeMetadata) {
    boolean flag = false;
    try {
      Map<String, Object> map = annotatedTypeMetadata.getAnnotationAttributes(ConditionOnClass.class.getName());
      //获取该注解中的属性值
      String[] values = (String[]) map.get("value");
      for (String className : values) {
        Class<?> aClass = Class.forName(className);
      }
      flag=true;
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    }
    return flag;
  }
}
七.SpringBoot自动配置原理
7.1 SpringBoot常用条件注解
ConditionalOnBean	判断spring容器中有某个bean时初始化该Bean
ConditionalOnClass	判断程序中有某个class字节码文件时初始化该Bean
ConditionalOnMissingBean	判断spring容器中没有该Bean时会初始化该Bean
ConditionalOnMissingClass	判断程序中没有某个class字节码文件时初始化该Bean
ConditionalOnProperty	判断配置文件中是否有对应的属性和值才初始化该bean
spring-boot-autoconfigure

org.springframework.boot:spring-boot-autoconfigure:2.1.4.RELEASE
⬇
org.springframework.boot.autoconfigure
⬇
condition
⬇
ConditionalOnClass
ConditionalOnMissingClass
ConditionalOnBean
ConditionalOnMissingBean
ConditionalOnProperty
7.2 如何初始化RedisTemplate
查看spring-boot-autoconfigure源码

org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration

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
@Configuration
@ConditionalOnClass(RedisOperations.class)
@EnableConfigurationProperties(RedisProperties.class)
@Import({ LettuceConnectionConfiguration.class, JedisConnectionConfiguration.class })
public class RedisAutoConfiguration {

  @Bean
  // 如果spring的IoC容器中没有该对象，则实例化RedisTemplate对象
  @ConditionalOnMissingBean(name = "redisTemplate")
  public RedisTemplate<Object, Object> redisTemplate(
    RedisConnectionFactory redisConnectionFactory) throws UnknownHostException {
    RedisTemplate<Object, Object> template = new RedisTemplate<>();
    template.setConnectionFactory(redisConnectionFactory);
    return template;
  }

  @Bean
  @ConditionalOnMissingBean
  public StringRedisTemplate stringRedisTemplate(
    RedisConnectionFactory redisConnectionFactory) throws UnknownHostException {
    StringRedisTemplate template = new StringRedisTemplate();
    template.setConnectionFactory(redisConnectionFactory);
    return template;
  }
}
八.SpringBoot切换内置服务器
SpringBoot提供了4种内置服务器供我们选择，我们可以很方便的进行切换。

Tomcat	默认使用tomcat作为内置服务器
Tomcat	一个开源的servlet容器，它为基于Java的web容器
Netty	Netty是由JBOSS提供的一个java开源框架。Netty 是一个基于NIO的客户、服务器端的编程框架，使用Netty 可以确保你快速和简单的开发出一个网络应用，例如实现了某种协议的客户、服务端应用。Netty相当于简化和流线化了网络应用的编程开发过程，例如：基于TCP和UDP的socket服务开发。
Undertow	红帽公司开发的一款基于 NIO 的高性能 Web 嵌入式服务器
jboss	
org/springframework/boot/autoconfigure/web/embedded

UndertowWebServerFactoryCustomizer
JettyWebServerFactoryCustomizer
TomcatWebServerFactoryCustomizer
NettyWebServerFactoryCustomizer

8.1 默认使用
springBoot的web环境默认使用tomcat作为内置服务器。我们只需要在工程中的pom文件中添加如下依赖即可

1
2
3
4
5
<!--添加web依赖-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
8.2 切换其他服务器
在pom文件中，排除掉tomcat依赖

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
<!--添加web依赖-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <!--排除掉tomcat依赖-->
    <exclusions>
        <exclusion>
            <artifactId>spring-boot-starter-tomcat</artifactId>
            <groupId>org.springframework.boot</groupId>
        </exclusion>
    </exclusions>
</dependency>
在pom文件中添加jetty依赖

1
2
3
4
5
<!--添加jetty依赖-->
<dependency>
    <artifactId>spring-boot-starter-jetty</artifactId>
    <groupId>org.springframework.boot</groupId>
</dependency>
思考：打成war包，properties配置文件是否还生效？

如果打成了war包，放到外部的tomcat中运行。
使用的端口是tomcat中配置文件中的端口（server.xml文件）
九.@SpringBootApplication注解
9.1 注册第三方Bean的三种方式
@ComponentScan(basePackages = {“扫描的包”})
@Import(T.class)
@EnableUser：自定义注解
9.1.1 需求
SpringBoot工程是否可以直接获取第三方jar包中的bean

9.1.2 代码实现
9.1.2.1 创建maven工程springboot_enable_other
pom.xml

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
<!--起步依赖-->
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
</parent>

<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
  </dependency>
</dependencies>
创建User

1
2
public class User {
}
创建UserConfig配置类

1
2
3
4
5
6
7
8
@Configuration
public class UserConfig {

    @Bean
    public User user(){
        return new User();
    }
}
9.1.2.2 创建maven工程springboot_enable
pom.xml

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
<!--起步依赖-->
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
</parent>

<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
  </dependency>
  <!--依赖第三方jar包-->
  <dependency>
    <groupId>org.example</groupId>
    <artifactId>springboot_enable_other</artifactId>
    <version>1.0-SNAPSHOT</version>
  </dependency>
</dependencies>
创建SpringBootEnableApplication启动类获取该bean的实例

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
@SpringBootApplication
public class SpringBootEnableApplication {

  public static void main(String[] args) {
    ConfigurableApplicationContext context = SpringApplication.run(SpringBootEnableApplication.class, args);
    Object user = context.getBean("user");
    // 可以查看Spring IoC容器中的内容
    // Map<String, User> map = context.getBeansOfType(User.class);
    System.out.println(user);
  }
}
9.1.2.3 启动服务并测试
无法获取该bean的实例

9.1.2.4 @ComponentScan注解
无法获取该bean的实例原因是，启动类默认加载当前包以及子包下的类。而我们的User/UserConfig与启动类并不在同一个包下，因此我们可以通过@ComponentScan指定扫描的包。

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
@SpringBootApplication
@ComponentScan(basePackages = {"org.example"})
public class SpringBootEnableApplication {
  public static void main(String[] args) {
    ConfigurableApplicationContext context = SpringApplication.run(SpringBootEnableApplication.class, args);

    Object user = context.getBean("user");
    
    System.out.println(map);
  }
}
即可获取

9.1.2.5 @Import注解
可以通过@Import注解，直接指定UserConfig.class字节码文件。

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
@SpringBootApplication
@Import(UserConfig.class)
public class SpringBootEnableApplication {
  public static void main(String[] args) {
    ConfigurableApplicationContext context = SpringApplication.run(SpringBootEnableApplication.class, args);

    Object user = context.getBean("user");
    
    Map<String, User> map = context.getBeansOfType(User.class);
    System.out.println(map);
  }
}
9.1.2.6 自定注解@EnableUser
我们可以自定义注解，本质上就是封装@Import注解而已。

enable-other工程：在annotation包下自定注解EnableUser

1
2
3
4
5
6
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Import(UserConfig.class)
public @interface EnableUser {
}
enable工程：在启动类上开启该注解@EnableUser

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
@SpringBootApplication
@EnableUser
public class SpringBootEnableApplication {
  public static void main(String[] args) {
    ConfigurableApplicationContext context = SpringApplication.run(SpringBootEnableApplication.class, args);

     Object user = context.getBean("user");
    
    Map<String, User> map = context.getBeansOfType(User.class);
    System.out.println(map);
  }
}
9.2 @Import注解使用方式
9.2.1 直接注入Bean
注意：如果直接注入Bean，那么Spring Ioc容器中的bean的名称则为该类的全限定名称。

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
@SpringBootApplication
@Import(User.class)
public class SpringBootEnableApplication {
  public static void main(String[] args) {
    ConfigurableApplicationContext context = SpringApplication.run(SpringBootEnableApplication.class, args);

    // 通过@Import直接导入Bean，那么Spring IoC容器中的bean的名称则为该类的全限定名称
    //        Object user = context.getBean("com.test.pojo.User");
    // 也可以通过类型获取该Bean
    User user = context.getBean(User.class);
    System.out.println(user);
    // 可以查看Spring IoC容器中的内容
    Map<String, User> map = context.getBeansOfType(User.class);
    System.out.println(map);

  }
}
9.2.2 导入配置类
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
@SpringBootApplication
@Import(UserConfig.class)
public class SpringBootEnableApplication {
  public static void main(String[] args) {
    ConfigurableApplicationContext context = SpringApplication.run(SpringBootEnableApplication.class, args);

    User user = context.getBean(User.class);
    System.out.println(user);
    
    Map<String, User> map = context.getBeansOfType(User.class);
    System.out.println(map);
  }
}
9.2.3 导入ImportSelector实现类
ImportSelector接口只定义了一个selectImports()，用于指定需要注册为bean的Class名称（类的权限定名称，然后进行反射进行实例化）。然后在启动类上使用@Import引入了一个ImportSelector实现类后，会把实现类中返回的Class名称都定义为bean。

9.2.3.1 创建MyImportSelector
在enable-other工程中创建MyImportSelector

1
2
3
4
5
6
public class MyImportSelector implements ImportSelector {
  @Override
  public String[] selectImports(AnnotationMetadata annotationMetadata) {
    return new String[]{"com.test.pojo.User"};
  }
}
9.2.3.2 更新启动类
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
@SpringBootApplication
@Import(MyImportSelector.class)
public class SpringBootEnableApplication {
    public static void main(String[] args) {
        ConfigurableApplicationContext context = SpringApplication.run(SpringBootEnableApplication.class, args);

        User user = context.getBean(User.class);
        System.out.println(user);
    
        Map<String, User> map = context.getBeansOfType(User.class);
        System.out.println(map);
    }
}
9.2.4 导入ImportBeanDefinitionRegistrar实现类
ImportBeanDefinitionRegistrar的实现类，则会调用接口方法，将其中要注册的类注册成bean

9.2.4.1创建MyImportBeanDefinitionRegistrar
enable-other工程中创建MyImportBeanDefinitionRegistrar

1
2
3
4
5
6
7
public class MyImportBeanDefinitionRegistrar implements ImportBeanDefinitionRegistrar {
  @Override
  public void registerBeanDefinitions(AnnotationMetadata annotationMetadata, BeanDefinitionRegistry beanDefinitionRegistry) {
    AbstractBeanDefinition beanDefinition = BeanDefinitionBuilder.rootBeanDefinition(User.class).getBeanDefinition();
    beanDefinitionRegistry.registerBeanDefinition("user",beanDefinition);
  }
}
9.2.4.2 更新启动类
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
@SpringBootApplication
@Import(MyImportBeanDefinitionRegistrar.class)
public class SpringBootEnableApplication {
  public static void main(String[] args) {
    ConfigurableApplicationContext context = SpringApplication.run(SpringBootEnableApplication.class, args);

    User user = context.getBean(User.class);
    System.out.println(user);
    
    Map<String, User> map = context.getBeansOfType(User.class);
    System.out.println(map);

  }
}
9.3 @EnableAutoConfiguration注解详解
SpringBoot中提供了很多以@Enable开头的注解，这些*注解都是用于启动某些功能的**。而其底层是使用@Import注解导入了一些配置类，实现Bean的动态加载。

例如，@EnableAutoConfiguration。

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
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@AutoConfigurationPackage
@Import({AutoConfigurationImportSelector.class})
public @interface EnableAutoConfiguration {
  String ENABLED_OVERRIDE_PROPERTY = "spring.boot.enableautoconfiguration";

  Class<?>[] exclude() default {};

  String[] excludeName() default {};
}
可以继续查看AutoConfigurationImportSelector的源码

selectImport方法：选择导入的配置类并转成一个数组

1
2
3
4
5
6
7
8
9
public String[] selectImports(AnnotationMetadata annotationMetadata) {
  if (!this.isEnabled(annotationMetadata)) {
    return NO_IMPORTS;
  } else {
    AutoConfigurationMetadata autoConfigurationMetadata = AutoConfigurationMetadataLoader.loadMetadata(this.beanClassLoader);
    AutoConfigurationImportSelector.AutoConfigurationEntry autoConfigurationEntry = this.getAutoConfigurationEntry(autoConfigurationMetadata, annotationMetadata);
    return StringUtils.toStringArray(autoConfigurationEntry.getConfigurations());
  }
}
getAutoConfigurationEntry方法：获取配置类实体对象

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
protected AutoConfigurationImportSelector.AutoConfigurationEntry getAutoConfigurationEntry(AutoConfigurationMetadata autoConfigurationMetadata, AnnotationMetadata annotationMetadata) {
  if (!this.isEnabled(annotationMetadata)) {
    return EMPTY_ENTRY;
  } else {
    AnnotationAttributes attributes = this.getAttributes(annotationMetadata);
    List<String> configurations = this.getCandidateConfigurations(annotationMetadata, attributes);
    configurations = this.removeDuplicates(configurations);
    Set<String> exclusions = this.getExclusions(annotationMetadata, attributes);
    this.checkExcludedClasses(configurations, exclusions);
    configurations.removeAll(exclusions);
    configurations = this.filter(configurations, autoConfigurationMetadata);
    this.fireAutoConfigurationImportEvents(configurations, exclusions);
    return new AutoConfigurationImportSelector.AutoConfigurationEntry(configurations, exclusions);
  }
}
getCandidateConfigurations：获取配置文件中的需要加载的类

1
2
3
4
5
protected List<String> getCandidateConfigurations(AnnotationMetadata metadata, AnnotationAttributes attributes) {
  List<String> configurations = SpringFactoriesLoader.loadFactoryNames(this.getSpringFactoriesLoaderFactoryClass(), this.getBeanClassLoader());
  Assert.notEmpty(configurations, "No auto configuration classes found in META-INF/spring.factories. If you are using a custom packaging, make sure that file is correct.");
  return configurations;
}
SpringFactoriesLoader.loadFactoryNames，加载META-INF/spring.factories文件中所有bean的名称，并且放入map中（IoC容器就是一个map）

META-INF/spring.factories文件内容如下

查看Redis

当服务启动时，就会自动注册RedisTemplate的bean到Spring的IoC容器中

十.SpringBoot自定义第三方starter
10.1 思路分析
SpringBoot启动器starter命名规则：

自带的：spring-boot-starter-xxx，例如Redis启动器：spring-boot-starter-data-redis
第三方：xxx-spring-boot-starter，例如mybatis启动器：mybatis-spring-boot-starter
参考第三方的mybatis的starter。我们可以在任意一个SpringBoot工程中添加mybatis启动器依赖。

1
2
3
4
5
6
<!--mybatis启动器-->
<dependency>
  <groupId>org.mybatis.spring.boot</groupId>
  <artifactId>mybatis-spring-boot-starter</artifactId>
  <version>2.0.1</version>
</dependency>
10.1.1 myredis_spring_boot_starter
该工程就是pom文件，负责定义规范，指定mybatis需要依赖的jar包，不需要编码。

10.1.2 myredis_spring_boot_starter_autoconfigure
spring.factories文件：指定需要加载的Bean
MyRedisAutoConfiguration：自动创建redis的相关的Bean（例如：SqlSessionFactoryBean）
MyRedisProperties：连接redis信息
10.2 结论
如果我们想要自定义第三方的starter，例如我们本次创建自定义的Redis的starter。因此我们需要实现的步骤如下

创建myredis-spring-boot-starter-autoconfigure工程

创建META-INF/spring.factories文件

创建MyRedisAutoConfiguration

创建MyRedisProperties

创建myredis-spring-boot-starter工程，并且需要依赖autoconfigure工程

在测试工程中引入myredis-spring-boot-starter依赖，并且进行测试

10.3 代码实现
10.3.1 创建myredis-spring-boot-starter-autoconfigure工程
10.3.1.1 创建工程并且添加依赖
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
<!--起步依赖-->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.1.4.RELEASE</version>
</parent>

<dependencies>
    <!--springboot的starter-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
    </dependency>

    <!--redis的依赖jedis-->
    <dependency>
        <groupId>redis.clients</groupId>
        <artifactId>jedis</artifactId>
        <version>3.2.0</version>
    </dependency>
</dependencies>
10.3.1.2 创建MyRedisProperties
1
2
3
4
5
6
7
8
@ConfigurationProperties(prefix = "myredis")
public class MyRedisProperties {

    private String host = "localhost";
    private int port = 6379;

// TODO setter/getter
}
10.3.1.3 创建MyRedisAutoConfiguration
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
// 配置类
@Configuration
// 加载Redis配置
@EnableConfigurationProperties(MyRedisProperties.class)
public class MyRedisAutoConfiguration {
    @Bean
    @ConditionalOnMissingBean(name = "myJedis")
    public Jedis myJedis(MyRedisProperties myRedisProperties){
        System.out.println(myRedisProperties.getHost());
        System.out.println(myRedisProperties.getPort());
        return new Jedis(myRedisProperties.getHost(),myRedisProperties.getPort());
    }
}
10.3.1.4 创建spring.factories文件
在工程的resources下创建`<META-INF/spring.factories文件

1
2
3
# Auto Configure
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
com.test.spring.boot.autoconfigure.MyRedisAutoConfiguration
10.3.2 创建myredis-spring-boot-starter工程
创建该工程，什么都不用写，我们只需要在pom文件中添加相关依赖即可。

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
<!--起步依赖-->
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
</parent>

<dependencies>
  <!--springboot的starter-->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
  </dependency>

  <!--依赖myredis autoconfigure工程-->
  <dependency>
    <groupId>org.example</groupId>
    <artifactId>springboot_day02_demo03_myredis_spring_boot_starter_autoconfigure</artifactId>
    <version>1.0-SNAPSHOT</version>
  </dependency>
</dependencies>
10.4 测试
10.4.1 创建测试工程
创建测试工程myredis-test工程，并且添加依赖

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
<groupId>org.example</groupId>
<artifactId>springboot_day02_demo03_myredis_test</artifactId>
<version>1.0-SNAPSHOT</version>

<!--起步依赖-->
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
</parent>

<dependencies>
  <!--springboot的starter-->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
  </dependency>

  <!--依赖自定义的myredis的starter-->
  <dependency>
    <groupId>org.example</groupId>
    <artifactId>springboot_day02_demo03_myredis_spring_boot_starter</artifactId>
    <version>1.0-SNAPSHOT</version>
  </dependency>
</dependencies>
10.4.2 测试bean是否自动配置
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
@SpringBootApplication
public class MyRedisApplication {
    public static void main(String[] args) {
        ConfigurableApplicationContext context = SpringApplication.run(MyRedisApplication.class, args);
        Jedis myJedis = (Jedis) context.getBean("myJedis");

        myJedis.set("A","B");
        System.out.println(myJedis.get("A"));
    }
}
10.4.3 测试配置文件是否生效
myredis-test工程中创建application.properties文件

1
myredis.port=6666
结果证明：可以获取配置文件中的属性信息。后期可以根据redis环境不同配置不同的地址以及端口。

十一.SpringBoot事件监听
11.1 介绍
在实际的场景中，在服务启动时经常会加载一些数据和执行一些应用的初始化动作，如：删除临时文件，清除缓存信息，读取配置文件信息，数据库连接等等。而SpringBoot提供了了4个常见的监听器接口，我们可以实现这些接口在项目启动时完成一些初始化工作。该4个接口如下：CommandLineRunner、ApplicationRunner、ApplicationContextInitializer、SpringApplicationRunListener

11.2 CommandLineRunner和ApplicationRunner使用
11.2.1 创建maven工程
创建springboot-listener工程，并且添加pom依赖

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
<!--起步依赖-->
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
</parent>

<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
  </dependency>
</dependencies>
11.2.2 编写启动类
1
2
3
4
5
6
7
@SpringBootApplication
public class ListenerDemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(ListenerDemoApplication.class, args);
    }
}
11.2.3 自定义监听器
MyCommandLineRunner

1
2
3
4
5
6
7
8
@Component
public class MyCommandLineRunner implements CommandLineRunner {
    @Override
    public void run(String... args) throws Exception {
        System.out.println("MyCommandLineRunner");
        System.out.println(Arrays.asList(args));
    }
}
MyApplicationRunner

1
2
3
4
5
6
7
8
9
@Component
public class MyApplicationRunner implements ApplicationRunner {
    @Override
    public void run(ApplicationArguments args) throws Exception {
        System.out.println("MyApplicationRunner");
        String[] sourceArgs = args.getSourceArgs();
        System.out.println(Arrays.asList(sourceArgs));
    }
}
11.2.4 启动测试可以看到控制台打印信息
11.3 SpringApplicationRunListenerer和ApplicationContextInitializ使用
11.3.1 自定义监听器
创建MyApplicationContextInitializer、MySpringApplicationRunListener两个监听器

MyApplicationContextInitializer

1
2
3
4
5
6
public class MyApplicationContextInitializer implements ApplicationContextInitializer {
    @Override
    public void initialize(ConfigurableApplicationContext configurableApplicationContext) {
        System.out.println("MyApplicationContextInitializer");
    }
}
MySpringApplicationRunListener

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
public class MySpringApplicationRunListener implements SpringApplicationRunListener {

  // 需要提供该构造方法，否则该方法无法运行
  public MySpringApplicationRunListener(SpringApplication springApplication, String[] args){
  }


  @Override
  public void starting() {
    System.out.println("MySpringApplicationRunListener ... starting");
  }

  @Override
  public void environmentPrepared(ConfigurableEnvironment environment) {
    System.out.println("MySpringApplicationRunListener ... environmentPrepared");
  }

  @Override
  public void contextPrepared(ConfigurableApplicationContext context) {
    System.out.println("MySpringApplicationRunListener ... contextPrepared");
  }

  @Override
  public void contextLoaded(ConfigurableApplicationContext context) {
    System.out.println("MySpringApplicationRunListener ... contextLoaded");
  }

  @Override
  public void started(ConfigurableApplicationContext context) {
    System.out.println("MySpringApplicationRunListener ... started");
  }

  @Override
  public void running(ConfigurableApplicationContext context) {
    System.out.println("MySpringApplicationRunListener ... running");
  }

  @Override
  public void failed(ConfigurableApplicationContext context, Throwable exception) {
    System.out.println("MySpringApplicationRunListener ... failed");
  }
}
11.3.2 创建spring.factories文件
在resources目录下创建META-INF/spring.factories文件

1
2
org.springframework.boot.SpringApplicationRunListener=com.test.listener.MySpringApplicationRunListener
org.springframework.context.ApplicationContextInitializer=com.test.listener.MyApplicationContextInitializer
11.3.3 启动服务并测试，可以发现控制台打印信息包含Listener输出
11.4 总结
CommandLineRunner和ApplicationRunner

外部资源的一些初始化工作(例如：缓存预热、清除缓存、清除临时文件等等—应用级别)

SpringApplicationRunListenerer和ApplicationContextInitializ

系统级别的应用初始化工作（判断是否为web环境、初始化Spring工厂等等—系统/框架级别）

十二.SpringBoot监控
12.1 介绍
SpringBoot自带监控功能Actuator，可以帮助实现对程序内部运行情况监控，比如监控状况、Bean加载情况、环境变量、日志信息、线程信息等。

12.2 Actuator入门
12.2.1 创建maven工程
创建 springboot-actuator工程，添加依赖并且编写启动类。

pom.xml

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
<!--起步依赖-->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.1.4.RELEASE</version>
</parent>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
    </dependency>

    <!--web依赖-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <!--springboot监控-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
</dependencies>
ActuatorApplication

1
2
3
4
5
6
7
@SpringBootApplication
public class ActuatorApplication {

  public static void main(String[] args) {
    SpringApplication.run(ActuatorApplication.class, args);
  }
}
12.2.2 启动服务并访问 localhost:8080/actuator
可以看到页面中有应用信息

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
{
  "_links": {
    "self": {
      "href": "http://localhost:8080/actuator",
      "templated": false
    },
    "auditevents": {
      "href": "http://localhost:8080/actuator/auditevents",
      "templated": false
    },
    "beans": {
      "href": "http://localhost:8080/actuator/beans",
      "templated": false
    },
    "caches-cache": {
      "href": "http://localhost:8080/actuator/caches/{cache}",
      "templated": true
    },
    "caches": {
      "href": "http://localhost:8080/actuator/caches",
      "templated": false
    },
    //应用的健康状态信息
    "health": {
      "href": "http://localhost:8080/actuator/health",
      "templated": false
    },
    "health-component": {
      //应用中其他组件的健康信息
      "href": "http://localhost:8080/actuator/health/{component}",
      "templated": true
    },
    "health-component-instance": {
      "href": "http://localhost:8080/actuator/health/{component}/{instance}",
      "templated": true
    },
    "conditions": {
      "href": "http://localhost:8080/actuator/conditions",
      "templated": false
    },
    "configprops": {
      "href": "http://localhost:8080/actuator/configprops",
      "templated": false
    },
    "env-toMatch": {
      "href": "http://localhost:8080/actuator/env/{toMatch}",
      "templated": true
    },
    "env": {
      "href": "http://localhost:8080/actuator/env",
      "templated": false
    },
    //配置文件中info相关信息
    "info": {
      "href": "http://localhost:8080/actuator/info",
      "templated": false
    },
    "loggers-name": {
      "href": "http://localhost:8080/actuator/loggers/{name}",
      "templated": true
    },
    "loggers": {
      "href": "http://localhost:8080/actuator/loggers",
      "templated": false
    },
    "heapdump": {
      "href": "http://localhost:8080/actuator/heapdump",
      "templated": false
    },
    "threaddump": {
      "href": "http://localhost:8080/actuator/threaddump",
      "templated": false
    },
    "metrics-requiredMetricName": {
      "href": "http://localhost:8080/actuator/metrics/{requiredMetricName}",
      "templated": true
    },
    "metrics": {
      "href": "http://localhost:8080/actuator/metrics",
      "templated": false
    },
    "scheduledtasks": {
      "href": "http://localhost:8080/actuator/scheduledtasks",
      "templated": false
    },
    "httptrace": {
      "href": "http://localhost:8080/actuator/httptrace",
      "templated": false
    },
    "mappings": {
      "href": "http://localhost:8080/actuator/mappings",
      "templated": false
    }
  }
}
12.3 Actuator使用说明
12.3.1 info信息
info配置相关信息 localhost:8080/actuator/info，在application.properties文件中配置内容

1
2
3
# info相关配置
info.name=test
info.age=18
12.3.2 健康信息
应用以及组件健康状态信息 localhost:8080/actuator/health,在application.peroperties文件中开启端点详情

1
2
# 显示暴露的端点详情
management.endpoint.health.show-details=always
1
2
3
4
5
6
还可以在pom文件中添加redis依赖，然后再去查看健康状态信息。
<!--Redis依赖-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
12.3.3 开放web相关端点信息
在application.properties文件中配置

1
2
# 开放web相关的端点信息
management.endpoints.web.exposure.include=*
12.3.4 Actuator暴露的端点说明
Actuator提供了以下端点，默认除了/shutdown都是Enabled。使用时需要加/actuator前缀，

ID	Description	Enabled by default
auditevents	显示当前应用程序的审计事件信息	Yes
beans	显示应用上下文中创建的所有Bean	Yes
caches	获取缓存信息	Yes
conditions	显示配置类和自动配置类(configuration and auto-configuration classes) 的状态及它们被应用或未被应用的原因	Yes
configprops	该端点用来获取应用中配置的属性信息报告 （所有@ConfigurationProperties的集合列表）	Yes
env	获取应用所有可用的环境属性报告。包括： 环境变量、JVM属性、应用的配置配置、命令行中的参数	Yes
flyway	显示数据库迁移路径（如果有）	Yes
health	显示应用的健康信息	Yes
httptrace	返回基本的HTTP跟踪信息。 (默认最多100 HTTP request-response exchanges).	Yes
info	返回一些应用自定义的信息，我们可以在application.properties 配置文件中通过info前缀来设置这些属性：info.app.name=spring-boot-hello	Yes
integrationgraph	Shows the Spring Integration graph.	Yes
loggers	Shows and modifies the configuration of loggers in the application.	Yes
liquibase	Shows any Liquibase database migrations that have been applied.	Yes
metrics	返回当前应用的各类重要度量指标，比如：内存信息、线程信息、垃圾回收信息等	Yes
mappings	返回所有Spring MVC的控制器映射关系报告 （所有@RequestMapping路径的集合列表）	Yes
scheduledtasks	显示应用程序中的计划任务	Yes
sessions	允许从Spring会话支持的会话存储中检索和删除(retrieval and deletion) 用户会话。使用Spring Session对反应性Web应用程序的支持时不可用	Yes
shutdown	允许应用以优雅的方式关闭（默认情况下不启用）	No
threaddump	执行一个线程dump	Yes
如果使用web应用(Spring MVC, Spring WebFlux, 或者 Jersey)，还可以使用以下端点：

ID	Description	Enabled by default
heapdump	返回一个GZip压缩的hprof堆dump文件	Yes
jolokia	通过HTTP暴露JMX beans（当Jolokia在类路径上时，WebFlux不可用）	Yes
logfile	返回日志文件内容（如果设置了logging.file或logging.path属性的话）， 支持使用HTTP Range头接收日志文件内容的部分信息	Yes
prometheus	以可以被Prometheus服务器抓取的格式显示metrics信息	Yes
12.4 Spring Boot Admin
12.4.1 介绍
类似dubbo admin，用于管理和监控SpringBoot应用程序。

应用程序作为Spring Boot Admin Client向为Spring Boot Admin Server注册（通过HTTP）或使用SpringCloud注册中心（例如Eureka，Consul）发现。 UI是的AngularJs应用程序，展示Spring Boot Admin Client的Actuator端点上的一些监控。

12.4.2 入门程序
12.4.2.1 创建admin server工程
创建工程springboot-admin-server并且添加依赖

pom.xml

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
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
</parent>

<dependencies>
  <!--spring boot启动器-->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
  </dependency>

  <!--web依赖-->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>

  <!--admin server-->
  <dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-server</artifactId>
    <version>2.1.6</version>
  </dependency>

</dependencies>
编写AdminServerApplication

1
2
3
4
5
6
7
8
@SpringBootApplication
@EnableAdminServer      // 开启admin服务
public class AdminServerApplication {

  public static void main(String[] args) {
    SpringApplication.run(AdminServerApplication.class, args);
  }
}
编写application.properties

1
2
# tomcat端口
server.port=9090
12.4.2.2 创建admin client工程
创建工程 springboot-admin-client 并且添加依赖

pom.xml

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
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
</parent>

<dependencies>
  <!--spring boot启动器-->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
  </dependency>

  <!--web依赖-->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>

  <!--admin client-->
  <dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-client</artifactId>
    <version>2.1.6</version>
  </dependency>
</dependencies>
编写application.properties

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
# 配置注册到的admin server的地址
spring.boot.admin.client.url=http://localhost:9090
# 启用健康检查 默认就是true
management.endpoint.health.enabled=true
# 配置显示所有的监控详情
management.endpoint.health.show-details=always
# 开放所有端点
management.endpoints.web.exposure.include=*
# 设置应用的名称
spring.application.name=test
编写启动类

1
2
3
4
5
6
7
@SpringBootApplication
public class AdminClientApplication {

    public static void main(String[] args) {
        SpringApplication.run(AdminClientApplication.class, args);
    }
}
编写HelloController

1
2
3
4
5
6
7
8
9
@RestController
@RequestMapping("/hello")
public class HelloController {
    
    @RequestMapping("/show")
    public String show(){
        return "success";
    }
}
12.4.3 测试
启动SpringBoot Admin Server
启动SpringBoot Admin Client
访问 localhost:9090
先点击【应用名称】—>在点击【实例id】即可查看到详细信息