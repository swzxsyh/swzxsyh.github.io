---
title: SpringCloud入门
date: 2020-07-13 01:53:41
tags:
---

一.SpringCloud介绍
1.1 介绍
Spring Cloud是在Spring Boot的基础上构建的，用于简化分布式系统构建的工具集。该工具集为微服务架构中所涉及的配置管理、服务发现、智能路由、熔断器、控制总线等操作提供了一种简单的开发方式。也就是说Spring Cloud把非常流行的微服务的技术（组件）整合到一起，方便开发。

注册中心：Eureka
负载均衡：Ribbon
熔断器：Hystrix
服务通信：Feign
网关：Gateway
配置中心 ：config
消息总线：Bus

<!-- more -->

1.2 版本
Spring Cloud的版本号是根据英文字母的顺序，采用伦敦的“地名+版本号”的方式来命名的，

1.2.1 与SpringBoot版本匹配关系
建议使用2.1.x版本，旧版本功能不全且bug多

SpringBoot	SpringCloud
1.2.x	Angel版本
1.3.x	Brixton版本
1.4.x	Camden版本
1.5.x	Dalston版本、Edgware
2.0.x	Finchley版本
2.1.x	Greenwich GA版本 (2019年2月发布)
二.使用RestTemplate发送请求
2.1 介绍
当A服务需要调用B服务的数据时，可以使用RestTemplate。

Spring RestTemplate 是 Spring 提供的用于访问 Rest 服务的客户端，RestTemplate 提供了多种便捷访问远程Http服务的方法，能够大大提高客户端的编写效率，所以很多客户端比如 Android或者第三方接口调用都可以使用 RestTemplate 请求 restful 服务。 它的底层是对HttpClient进行了封装。

RestTemplate是Rest的HTTP客户端模板工具类
对基于Http的客户端进行封装
实现对象与JSON串的相互转换
常见的HTTP客户端工具：HttpClient、OKHttp、URLConnection。

2.2 HTTP客户端工具
2.2.1 在工程中添加HttpClient依赖
创建 springcloud-resttemplate 并添加依赖

pom.xml

```xml
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
  <relativePath/>
</parent>
<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>

  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
  </dependency>

  <!--httpclient依赖-->
  <dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
  </dependency>
</dependencies>
```

2.2.2 在工程中添加HttpClient工具类
HttpClient

```java

public class HttpClient {
  private String url;
  private Map<String, String> param;
  private int statusCode;
  private String content;
  private String xmlParam;
  private boolean isHttps;
  public boolean isHttps() {
    return isHttps;
  }

  public void setHttps(boolean isHttps) {
    this.isHttps = isHttps;
  }

  public String getXmlParam() {
    return xmlParam;
  }

  public void setXmlParam(String xmlParam) {
    this.xmlParam = xmlParam;
  }

  public HttpClient(String url, Map<String, String> param) {
    this.url = url;
    this.param = param;
  }

  public HttpClient(String url) {
    this.url = url;
  }

  public void setParameter(Map<String, String> map) {
    param = map;
  }

  public void addParameter(String key, String value) {
    if (param == null){
      param = new HashMap<String, String>();
    }

    param.put(key, value);
  }

  public void post() throws ClientProtocolException, IOException {
    HttpPost http = new HttpPost(url);
    setEntity(http);
    execute(http);
  }

  public void put() throws ClientProtocolException, IOException {
    HttpPut http = new HttpPut(url);
    setEntity(http);
    execute(http);
  }

  public void get() throws ClientProtocolException, IOException {
    if (param != null) {
      StringBuilder url = new StringBuilder(this.url);
      boolean isFirst = true;
      for (String key : param.keySet()) {
        if (isFirst){
          url.append("?");
        }
        else{
          url.append("&");
        }

        url.append(key).append("=").append(param.get(key));
      }
      this.url = url.toString();
    }
    HttpGet http = new HttpGet(url);
    execute(http);
  }

  /**
 * set http post,put param
 */
  private void setEntity(HttpEntityEnclosingRequestBase http) {
    if (param != null) {
      List<NameValuePair> nvps = new LinkedList<NameValuePair>();
      for (String key : param.keySet()){
        nvps.add(new BasicNameValuePair(key, param.get(key))); // 参数
      }

      http.setEntity(new UrlEncodedFormEntity(nvps, Consts.UTF_8)); // 设置参数
    }
    if (xmlParam != null) {
      http.setEntity(new StringEntity(xmlParam, Consts.UTF_8));
    }
  }

  private void execute(HttpUriRequest http) throws ClientProtocolException,
  IOException {
    CloseableHttpClient httpClient = null;
    try {
      if (isHttps) {
        SSLContext sslContext = new SSLContextBuilder()
          .loadTrustMaterial(null, new TrustStrategy() {
            // 信任所有
            @Override
            public boolean isTrusted(X509Certificate[] chain,
                                     String authType)
              throws CertificateException {
              return true;
            }
          }).build();
        SSLConnectionSocketFactory sslsf = new SSLConnectionSocketFactory(
          sslContext);
        httpClient = HttpClients.custom().setSSLSocketFactory(sslsf)
          .build();
      } else {
        httpClient = HttpClients.createDefault();
      }
      CloseableHttpResponse response = httpClient.execute(http);
      try {
        if (response != null) {
          if (response.getStatusLine() != null){
            statusCode = response.getStatusLine().getStatusCode();
          }

          HttpEntity entity = response.getEntity();
          // 响应内容
          content = EntityUtils.toString(entity, Consts.UTF_8);
        }
      } finally {
        response.close();
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      httpClient.close();
    }
  }

  public int getStatusCode() {
    return statusCode;
  }

  public String getContent() throws ParseException, IOException {
    return content;
  }
}
```

2.2.3 测试
开启一台之前创建的服务器，含有findusers方法的,如springboot中的mybatis服务

在test中创建测试类(需跟src中包名路径相同)

```JAVA

public class HttpClientTest {
  @Test
  public void testHttpClient() throws IOException, ParseException {
    String url = "http://localhost:8080/user/findUsers";
    HttpClient httpClient = new HttpClient(url);

    httpClient.get();

    String content = httpClient.getContent();
    System.out.println(content);
  }
}
```
可以获取结果
[{"id":1,"username":"zhangsan","password":"123","address":"北京"},{"id":2,"username":"lisi","password":"123","address":"上海"}]
2.3 RestTemplate入门程序
2.3.1 在springcloud-resttemplate添加依赖
pom.xml

```xml
<!--web依赖中包含了RestTemplate-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

2.3.2 注入RestTemplate

```java
@SpringBootApplication
public class RestTemplateApplication {

  public static void main(String[] args) {
    SpringApplication.run(RestTemplateApplication.class, args);
  }

  // 注入RestTemplate
  @Bean
  public RestTemplate restTemplate() {
    return new RestTemplate();
  }
}
```

2.3.3 在测试类中测试
创建RestTemplateTest

```JAVA
@SpringBootTest
@RunWith(SpringRunner.class)
public class RestTemplateTest {
  @Autowired
  private RestTemplate restTemplate;

  @Test
  public void contextLoad(){

    String url = "http://localhost:8080/user/findUsers";
    //返回JSON格式
    String json = restTemplate.getForObject(url, String.class);
    System.out.println(json);
  }
}
```

获取结果:
1
[{"id":1,"username":"zhangsan","password":"123","address":"北京"},{"id":2,"username":"lisi","password":"123","address":"上海"}]
三.模拟服务调用
创建两个服务

服务提供方
服务消费方
需求

根据id获取用户信息。

sql

```sql
CREATE DATABASE springcloud;
USE springcloud;

CREATE TABLE `tb_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) DEFAULT NULL COMMENT '用户名',
  `password` varchar(100) DEFAULT NULL COMMENT '密码',
  `name` varchar(100) DEFAULT NULL COMMENT '姓名',
  `age` int(11) DEFAULT NULL COMMENT '年龄',
  `sex` int(11) DEFAULT NULL COMMENT '性别，1男，2女',
  `birthday` date DEFAULT NULL COMMENT '出生日期',
  `created` date DEFAULT NULL COMMENT '创建时间',
  `updated` date DEFAULT NULL COMMENT '更新时间',
  `note` varchar(1000) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='用户信息表';

INSERT INTO `tb_user` VALUES ('1', 'zhangsan', '123456', '张三', '13', '1', '2006-08-01', '2019-05-16', '2019-05-16', 'A');
INSERT INTO `tb_user` VALUES ('2', 'lisi', '123456', '李四', '13', '1', '2006-08-01', '2019-05-16', '2019-05-16', 'B');
```


3.1 创建服务提供方
3.1.1 创建工程
创建工程<springcloud-user-provider>添加依赖：

```xml
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
  <relativePath/>
</parent>

<properties>
  <java.version>1.8</java.version>
</properties>

<dependencies>
  <dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>2.0.1</version>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
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
```


3.1.2 创建pojo

​    

```java
public class User {
  private Integer id;
  private String username;
  private String password;
  private String name;
  private Integer age;
  private Integer sex;
  private Date birthday;
  private Date created;
  private Date updated;
  private String note;

  // TODO:getters/setters
}
```
3.1.3 编写Dao层

```java
@Mapper
public interface UserDao {

  @Select("SELECT * FROM tb_user WHERE id = #{id}")
  User findById(Integer id);
}
```

3.1.4 编写Service层

```java
public interface UserService {

  User findById(Integer id);
}


@Service
public class UserServiceImpl implements UserService {
  @Autowired
  private UserDao userDao;

  @Override
  public User findById(Integer id) {
    return userDao.findById(id);
  }
}
```


3.1.5 编写Controller层

```java

@RestController
@RequestMapping("/api/user")
public class UserController {
  @Autowired
  private UserService userService;

  @GetMapping("/findById/{id}")
  public User findById(@PathVariable(value = "id")Integer id){
    return userService.findById(id);
  }
}
```


3.1.6 编写application.yml文件

```yaml
server:
    port: 9091
```



# DB 配置

```yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/springcloud?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
    password: root
    username: root
```

3.1.7 编写启动类

    @SpringBootApplication
    public class ProviderApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProviderApplication.class, args);
    }

3.1.8 发布程序并访问测试
访问 localhost:9091/api/user/findById/1

{
  "id": 1,
  "username": "zhangsan",
  "password": "123456",
  "name": "张三",
  "age": 13,
  "sex": 1,
  "birthday": "2006-08-01T00:00:00.000+0000",
  "created": "2019-05-16T00:00:00.000+0000",
  "updated": "2019-05-16T00:00:00.000+0000",
  "note": "好好学习"
}

3.2 创建服务消费方
3.2.1 创建工程
创建工程springcloud-user-consumer 并且添加依赖

```xml
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
  <relativePath/>
</parent>

<properties>
  <java.version>1.8</java.version>
</properties>

<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
  </dependency>
</dependencies>
```


3.2.2 编写启动类



```java
@SpringBootApplication
public class ConsumerApplication {
  public static void main(String[] args) {
    SpringApplication.run(ConsumerApplication.class, args);
  }

  // 注入RestTemplate
  @Bean
  public RestTemplate restTemplate() {
    return new RestTemplate();
  }
}
```
3.2.3 编写Controller层



    @RestController
    @RequestMapping("/consumer")
    public class ConsumerController {
    @Autowired
    private RestTemplate restTemplate;
    
    @GetMapping("/findById/{id}")
    public String findById(@PathVariable(value = "id") Integer id) {
        String url = "http://localhost:9091/api/user/findById/" + id;
        String json = restTemplate.getForObject(url, String.class);
        System.out.println(json);
        return json;
    }
    }

3.3 调用测试
访问 localhost:8080/consumer/findById/1 同样可以获取


{
  "id": 1,
  "username": "zhangsan",
  "password": "123456",
  "name": "张三",
  "age": 13,
  "sex": 1,
  "birthday": "2006-08-01T00:00:00.000+0000",
  "created": "2019-05-16T00:00:00.000+0000",
  "updated": "2019-05-16T00:00:00.000+0000",
  "note": "好好学习"
}
3.4 问题总结
目前硬编码服务器地址，需解耦
consumer无法判断provider是否存活
未配置负载均衡，无HA高可用
四.搭建Eureka注册中心
4.1 Eureka介绍
类似于dubbo+zk，但不同的是dubbo以zk为注册中心，dubbo配置谁为provider，谁为consumer。

eureka默认有register，provider/consumer，但服务可能同时作为provider与consumer，相对于register都是client端。

Eureka是Netflix开发的一个服务发现框架，本身是一个基于REST的服务，主要用于定位运行在AWS（Amazon Web Services ）域中的中间层服务，以达到负载均衡和中间层服务故障转移的目的。Spring Cloud将其集成在自己的子项目Spring Cloud Netflix中，以实现Spring Cloud的服务发现功能。

Eureka的服务发现包含两大组件：服务端发现组件（Eureka Server）和客户端发现组件（Eureka Client）。服务端发现组件也被称之为服务注册中心，主要提供了服务的注册功能，而客户端发现组件主要用于处理服务的注册与发现。

![image](./SpringCloud%E5%85%A5%E9%97%A8/1562666010564.png)

当客户端服务通过注解等方式嵌入到程序的代码中运行时，客户端发现组件就会向注册中心注册自身提供的服务，并周期性地发送心跳来更新服务（默认时间为30s，如果连续三次心跳都不能够发现服务，那么Eureka就会将这个服务节点从服务注册表中移除）。与此同时，客户端发现组件还会从服务端查询当前注册的服务信息并缓存到本地，即使Eureka Server出现了问题，客户端组件也可以通过缓存中的信息调用服务节点的服务。各个服务之间会通过注册中心的注册信息以Rest方式来实现调用，并且也可以直接通过服务名进行调用。

![image](./SpringCloud%E5%85%A5%E9%97%A8/1562666652758.png)

在Eureka的服务发现机制中，包含了3个角色：服务注册中心、服务提供方和服务消费方。

服务注册中心即Eureka Server，而服务提供者和服务消费者是Eureka Client。这里的服务提供者是指提供服务的应用，可以是Spring Boot应用，也可以是其他技术平台且遵循Eureka通信机制的应用，应用在运行时会自动的将自己提供的服务注册到Eureka Server以供其他应用发现。

服务消费者就是需要服务的应用，该服务在运行时会从服务注册中心获取服务列表，然后通过服务列表知道去何处调用其他服务。服务消费者会与服务注册中心保持心跳连接，一旦服务提供者的地址发生变更时，注册中心会通知服务消费者。

需要注意的是，Eureka服务提供者和服务消费者之间的角色是可以相互转换的，因为一个服务既可能是服务消费方，同时也可能是服务提供方。

4.2 Eureka入门程序
4.2.1 创建parent工程
创建一个maven工程springcloud-microservice，并将其作为父工程用来管理子工程（父工程，需要删src目录），因为需要创建Eureka的注册中心及Eureka提供方以及消费方，因此方便管理。

创建好的maven工程中需要添加如下依赖

```xml
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.4.RELEASE</version>
</parent>
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-dependencies</artifactId>
      <version>Greenwich.SR2</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```


4.2.2 创建Eureka服务-注册中心
4.2.2.1 创建工程
创建Eureka的服务（注册中心）eureka-server-registry工程并添加依赖

pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <parent>
    <artifactId>springcloud-microservice</artifactId>
    <groupId>org.example</groupId>
    <version>1.0-SNAPSHOT</version>
  </parent>
  <modelVersion>4.0.0</modelVersion>

  <artifactId>eureka-server-registry</artifactId>

  <dependencies>
    <!--eureka服务端-->
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
    </dependency>
  </dependencies>
</project>
```


4.2.2.2 编写启动类
在启动类中添加@EnableEurekaServer注解。申明该工程为Eureka的服务。

```java
@SpringBootApplication
@EnableEurekaServer		// 开启eureka注册中心服务
public class EurekaServerApplication {

  public static void main(String[] args) {
    SpringApplication.run(EurekaServerApplication.class, args);
  }
}
```

4.2.2.3 编写application.yml文件

```yaml
server:
port: 10086
eureka:
instance:
ip-address: 127.0.0.1         # 应用实例IP
client:
register-with-eureka: false   # 是否将自己注册到eureka中
fetch-registry: false         # 是否从eureka中获取信息
service-url:                  # 注册中心地址
defaultZone: http://127.0.0.1:10086/eureka/
#      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/

  server:
    enable-self-preservation: false # 是否开启自我保护机制
```




4.2.2.4 访问注册中心 localhost:10086 可以看到控制面板
4.2.3 创建Eureka客户端-提供方
4.2.3.1 创建工程
创建服务提供方工程eureka-client-provider

pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <parent>
    <artifactId>springcloud-microservice</artifactId>
    <groupId>org.example</groupId>
    <version>1.0-SNAPSHOT</version>
  </parent>
  <modelVersion>4.0.0</modelVersion>

  <artifactId>eureka-client-provider</artifactId>

  <dependencies>
    <dependency>
      <groupId>org.mybatis.spring.boot</groupId>
      <artifactId>mybatis-spring-boot-starter</artifactId>
      <version>2.0.1</version>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <!--eureka客户端-->
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
    </dependency>
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <scope>runtime</scope>
    </dependency>
  </dependencies>

</project>
```


4.2.3.2 编写代码
将 springcloud-user-provider 的mvc和实体类搬运来

4.2.3.3 编写启动类
在启动类中添加注解，表明为eureka的客户端。@EnableEurekaClient

```java
@SpringBootApplication
@EnableEurekaClient     // 开启eureka客户端
public class EurekaProviderApplication {

  public static void main(String[] args) {
    SpringApplication.run(EurekaProviderApplication.class, args);
  }
}
```

4.2.3.4 编写application.yml文件

```yaml


# 配置应用基本信息和DB

server:
  port: 9091
spring:
  application:
    name: eureka-client-provider
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    password: root
    url: jdbc:mysql://127.0.0.1:3306/springcloud?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
    username: root

# 配置eureka server

eureka:
  client:
    service-url:
      defaultZone: http://127.0.0.1:10086/eureka
```


4.2.3.5 发布工程
发布工程后，进入register可查看到provider已注册

4.2.4 创建Eureka客户端-消费方
4.2.4.1 创建工程
创建服务提供方工程eureka-client-consumer

pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>springcloud-microservice</artifactId>
        <groupId>org.example</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
  <artifactId>eureka-client-consumer</artifactId>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-netflix-eureka-client</artifactId>
        <version>2.2.1.RELEASE</version>
    </dependency>
</dependencies>
  </project>
```

4.2.4.2 编写启动类

```java
@SpringBootApplication
@EnableEurekaClient
public class EurekaConsumerApplication {

  public static void main(String[] args) {
    SpringApplication.run(EurekaConsumerApplication.class, args);
  }

  @Bean
  public RestTemplate restTemplate(){
    return new RestTemplate();
  }
}
```

4.2.4.3 编写Controller

```java
@RestController
@RequestMapping("/consumer")
public class ConsumerController {

  @Autowired
  private RestTemplate restTemplate;

  @GetMapping("/findById/{id}")
  public String findById(@PathVariable(value = "id") Integer id){
    String url = "http://localhost:9091/api/user/findById/" + id;
    String json = restTemplate.getForObject(url, String.class);
    return json;
  }
}
```

4.2.4.4 配置application.yml文件

```yaml
# 配置应用基本信息

server:
  port: 8080
spring:
  application:
    name: eureka-client-consumer

# 配置eureka server

eureka:
  client:
    service-url:
      defaultZone: http://127.0.0.1:10086/eureka
```




4.2.4.5 发布工程
发布工程后，进入register可查看到consumer已注册

4.2.5 调用测试
在消费方中调用 localhost:8080/consumer/findById/1

1
{"id":1,"username":"zhangsan","password":"123456","name":"张三","age":13,"sex":1,"birthday":"2006-08-01T00:00:00.000+0000","created":"2019-05-16T00:00:00.000+0000","updated":"2019-05-16T00:00:00.000+0000","note":"好好学习"}
4.2.6 Eureka其他（了解）
4.2.6.1 注解说明
注册服务或者发现服务注解。

```yaml
server:
  port: 10086
eureka:
  instance:
    hostname: 127.0.0.1
  client:
    register-with-eureka: false   # 是否将自己注册到eureka中
    fetch-registry: false         # 是否从eureka中获取信息
    service-url:
      defaultZone: http://127.0.0.1:10086/eureka/
  server:
    enable-self-preservation: false # 是否开启自我保护机制
```



系统在三种情况下会出现红色加粗的字体提示：

a.在配置上，自我保护机制关闭
RENEWALS ARE LESSER THAN THE THRESHOLD. THE SELF PRESERVATION MODE IS TURNED OFF.THIS MAY NOT PROTECT INSTANCE EXPIRY IN CASE OF NETWORK/OTHER PROBLEMS.

b.自我保护机制开启了
EMERGENCY! EUREKA MAY BE INCORRECTLY CLAIMING INSTANCES ARE UP WHEN THEY'RE NOT. RENEWALS ARE LESSER THAN THRESHOLD AND HENCE THE INSTANCES ARE
NOT BEING EXPIRED JUST TO BE SAFE.

c.在配置上，自我保护机制关闭了，但是一分钟内的续约数没有达到85% ， 可能发生了网络分区，会有如下提示
THE SELF PRESERVATION MODE IS TURNED OFF.THIS MAY NOT PROTECT INSTANCE EXPIRY IN CASE OF NETWORK/OTHER PROBLEMS.
4.2.6.3 eureka控制台说明

total-avail-memory : 总共可用的内存
environment : 环境名称，默认test
num-of-cpus : CPU的个数
current-memory-usage : 当前已经使用内存的百分比
server-uptime : 服务启动时间
registered-replicas : 相邻集群复制节点
unavailable-replicas ：不可用的集群复制节点，如何确定不可用？ 主要是server1 向 server2和server3发送接口查询自身的注册信息，

如果查询不到，则默认为不可用，也就是说如果Eureka Server自身不作为客户端注册到上面去，则相邻节点都会显示为不可用。
available-replicas ：可用的相邻集群复制节点

4.2.6.4 服务续约
服务注册完成以后，服务提供者会维持一个心跳，保存服务处于存在状态。这个称之为服务续约(renew).服务超过90秒没有发生心跳，Eureka Server会将服务从列表移除。我们可以在eureka的客户端配置如下内容：

```yaml
#向Eureka服务中心注册服务
eureka:
  instance:
  	# 租约到期，服务时效时间，默认值90秒
    lease-expiration-duration-in-seconds: 90 
    # 租约续约间隔时间，默认30秒
    lease-renewal-interval-in-seconds: 30 
```


4.2.6.5 失效剔除
服务中心每隔一段时间(默认60秒)将清单中没有续约的服务剔除。通过eviction-interval-timer-in-ms配置可以对其进行修改，单位是秒。我们可以在eureka客户端程序中配置如下内容：

```yaml
eureka:
  instance:
  	# 超过180秒没有续约的服务将被剔除
  	eviction-interval-timer-in-ms: 180
```


五.使用Ribbon实现负载均衡
5.1 Ribbon介绍
Spring Cloud Ribbon是一个基于HTTP和TCP的客户端负载均衡工具，它基于Netflix Ribbon实现。通过Spring Cloud的封装，可以让我们轻松地将面向服务的REST模版请求自动转换成客户端负载均衡的服务调用。Spring Cloud Ribbon虽然只是一个工具类框架，它不像服务注册中心、配置中心、API网关那样需要独立部署，但是它几乎存在于每一个Spring Cloud构建的微服务和基础设施中。因为微服务间的调用，API网关的请求转发等内容，实际上都是通过Ribbon来实现的，包括后续我们将要介绍的Feign，它也是基于Ribbon实现的工具。所以，对Spring Cloud Ribbon的理解和使用，对于我们使用Spring Cloud来构建微服务非常重要。

5.2 入门程序
场景说明：

开启多个（本次两个）服务提供方；
启动消费方进行调用测试
5.2.1 启动两个提供方
5.2.1.1 修改端口
修改提供方配置文件端口：${port:9091}

```yaml
# 配置应用基本信息和DB

server:
  port: ${port:9091}
spring:
  application:
    name: eureka-client-provider
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    password: root
    url: jdbc:mysql://127.0.0.1:3306/springcloud?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
    username: root

# 配置eureka server

eureka:
  client:
    service-url:
      defaultZone: http://127.0.0.1:10086/eureka
```




5.2.1.2 编辑启动应用配置
修改发布的应用名称
修改发布的应用端口：-Dport=9091
5.2.1.3 复制一份新应用
复制一份新的应用

修改端口以及名称

5.2.1.4 通过Eureka查看
启动服务，通过eureka控制面板查看服务

5.2.1.5 修改消费方
5.2.1.6 添加@LoadBalanced注解
在启动类的注入RestTemplate方法上添加客户端负载均衡的注解。@LoadBalanced




    @SpringBootApplication
    @EnableEurekaClient
    public class EurekaConsumerApplication {
        public static void main(String[] args) {
            SpringApplication.run(EurekaConsumerApplication.class, args);
        }
        @Bean
    @LoadBalanced
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
    }

5.2.1.7 修改ConsumerController
修改ConsumerController代码：




    @RestController
    @RequestMapping("/consumer")
    public class ConsumerController {
    @Autowired
    private RestTemplate restTemplate;
    
    @GetMapping("/findById/{id}")
    public String findById(@PathVariable(value = "id") Integer id){
    //        String url = "http://localhost:9091/api/user/findById/" + id;
            // 通过服务名称调用
            String url = "http://eureka-client-provider/api/user/findById/" + id;
            String json = restTemplate.getForObject(url, String.class);
            return json;
        }
    
    }

5.2.1.8 启动消费方
5.2.1.9 访问测试
我们可以在提供方的controller中打印port：
刷新四次，console控制查看结果：（分别访问两次，默认走的负载均衡的策略为轮询）
5.2.2 坑
使用ribbon实现负载均衡的时候，服务名称不能用下划线。

5.3 Ribbon负载均衡策略
5.3.1 默认策略
Ribbon默认的负载均衡策略是轮询。

```yaml
# 修改服务地址轮询策略，默认是轮询，配置之后变随机

eureka-client-provider: # 服务名称
  ribbon:
    NFLoadBalancerRuleClassName: com.netflix.loadbalancer.RandomRule
```




5.3.2 Ribbon支持的轮询算法
RoundRobinRule	轮询规则（默认方法）
RandomRule	随机
AvailabilityFilteringRule	先过滤掉由于多次访问故障而处于断路器跳闸状态的服务，还有并发的连接数量超过阈值的服务，然后对剩余的服务进行轮询
WeightedResponseTimeRule	根据平均响应时间计算服务的权重。统计信息不足时会按照轮询，统计信息足够会按照响应的时间选择服务
RetryRule	正常时按照轮询选择服务，若过程中有服务出现故障，在轮询一定次数后依然故障，则会跳过故障的服务继续轮询
BestAvailableRule	先过滤掉由于多次访问故障而处于断路器跳闸状态的服务，然后选择一个并发量最小的服务
ZoneAvoidanceRule	默认规则，符合判断server所在的区域的性能和server的可用性选择服务
六.使用Hystrix熔断器
6.1 Hystrix介绍
Hystrix，英文意思是豪猪，全身是刺，刺是一种保护机制。Hystrix也是Netflix公司的一款组件。
Hystrix是Netflix开源的一个延迟和容错库，用于隔离访问远程服务、第三方库、防止出现级联失败也就是雪崩效应。
6.2 雪崩效应
微服务中，一个请求可能需要多个微服务接口才能实现，会形成复杂的调用链路。
如果某服务出现异常，请求阻塞，用户得不到响应，容器中线程不会释放，于是越来越多用户请求堆积，越来越多线程阻塞。
单服务器支持线程和并发数有限，请求如果一直阻塞，会导致服务器资源耗尽，从而导致所有其他服务都不可用，从而形成雪崩效应。
6.3 熔断器原理
6.3.1 熔断器
在Spring Cloud中，Spring Cloud Hystrix就是用来实现断路器、线程隔离等服务保护功能的。Spring Cloud Hystrix是基于Netflix的开源框架Hystrix实现的，该框架的使用目标在于通过控制那些访问远程系统、服务和第三方库的节点，从而对延迟和故障提供更强大的容错能力。

6.3.1.1 熔断器状态
断路器是可以实现弹性容错的，在一定条件下它能够自动打开和关闭，其使用时主要有三种状态。

Closed：关闭状态（前健康状况高于设定阈值），所有请求正常访问
Open：打开状态（当前健康状况低于设定阈值），所有请求静止通过，如果设置了fallback方法，则进入该流程
Half Open：半开状态（当断路器开关处于打开状态，经过一段时间后，断路器会自动进入半开状态。这时断路器只允许一个请求通过；当该请求调用成功时，断路器恢复到关闭状态；若该请求失败，断路器继续保持打开状态，接下来的请求会被禁止通过）
断路器的开关由关闭到打开的状态是通过当前服务健康状况（服务的健康状况=请求失败数/请求总数）和设定阈值（默认为5秒内的20次故障）比较决定的。当断路器开关关闭时，请求被允许通过断路器，如果当前健康状况高于设定阈值，开关继续保持关闭；如果当前健康状况低于设定阈值，开关则切换为打开状态。当断路器开关打开时，请求被禁止通过；如果设置了fallback方法，则会进入fallback的流程。当断路器开关处于打开状态，经过一段时间后，断路器会自动进入半开状态，这时断路器只允许一个请求通过；当该请求调用成功时，断路器恢复到关闭状态；若该请求失败，断路器继续保持打开状态，接下来的请求会被禁止通过。

6.3.1.2 服务降级方法
pring Cloud Hystrix能保证服务调用者在调用异常服务时快速的返回结果，避免大量的同步等待，这是通过HystrixCommand的fallback方法实现的。

熔断器的核心：线程隔离和服务降级。

线程隔离：是指Hystrix为每个依赖服务调用一个小的线程池，如果线程池用尽，调用立即被拒绝，默认不采用排队。
服务降级(兜底方法)：优先保证核心服务，而非核心服务不可用或弱可用。触发Hystrix服务降级的情况：线程池已满、请求超时。
虽然A服务仍然不可用，但采用fallback的方式可以给用户一个友好的提示结果，这样就避免了其他服务的崩溃问题。

6.4 入门程序
目标：服务提供者的服务出现了故障，服务消费者快速失败给用户友好提示。体验服务降级好处。

6.4.1 添加依赖
在服务消费方工程（eureka-client-consumer）添加hystrix依赖

```xml
<!--熔断器-->
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
</dependency>
```


6.4.2 开启熔断器注解
在消费方工程的启动类中添加开启熔断器的注解：@EnableCircuitBreaker；

或者直接添加一个组合注解：@SpringCloudApplication。




    @SpringBootApplication
    @EnableEurekaClient
    @EnableCircuitBreaker
    //@SpringCloudApplication
    public class EurekaConsumerApplication {
        public static void main(String[] args) {
            SpringApplication.run(EurekaConsumerApplication.class, args);
        }
        @Bean
    @LoadBalanced
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
    }

6.4.3 编写服务降级方法
6.4.3.1 作用在方法 / 类 上
在消费方工程的controller中，添加服务降级方法：




    @RestController
    @RequestMapping("/consumer")
    //作用在类上，就近原则，如果方法上已有，则以方法为准
    @DefaultProperties(defaultFallback = "defaultFallBackMethod")
    public class ConsumerController {
    @Autowired
    private RestTemplate restTemplate;
    
    @GetMapping("/findById/{id}")
      //作用在方法上，就近原则
        @HystrixCommand(fallbackMethod = "fallBackFindById")
        public String findById(@PathVariable(value = "id") Integer id) {
    //        String url = "http://localhost:9091/api/user/findById/" + id;
          //添加使用register+lb后，必修使用定义的名称，不可再使用写死的IP
            String url = "http://eureka-client-provider/api/user/findById/" + id;
            String json = restTemplate.getForObject(url, String.class);
            System.out.println(json);
            return json;
        }
    
        @RequestMapping("/testFallBack/{id}")
    
      //需要添加该注解，实现类的兜底方法
        @HystrixCommand
        public String testEurekaById(@PathVariable(value = "id") Integer id) {
            String url = "http://eureka-client-provider/api/user/findById/" + id;
            String json = restTemplate.getForObject(url, String.class);
            System.out.println(json);
            return json;
        }
    
      //针对方法的，参数等必须相同
        public String fallBackFindById(@PathVariable(value = "id") Integer id) {
            return "Sorry...";
        }
    
      //针对类上的方法
        public String defaultFallBackMethod() {
            return "default Fall Back Method";
        }
    }

6.5 熔断策略
6.5.1 常见熔断策略
常见熔断策略配置：

熔断后休眠时间：sleepWindowInMilliseconds
熔断触发最小请求次数：requestVolumeThreshold
熔断触发错误比例阈值：errorThresholdPercentage
熔断超时时间：timeoutInMilliseconds
信号量隔离：strategy: SEMAPHORE
与调用线程相同
无线程切换，开销低
异步：不支持
并发支持：
6.5.2 配置熔断策略
在服务消费方工程【eureka-client-consumer】配置如下内容：

```yaml
# 配置熔断策略：

hystrix:
  command:
    default:
      circuitBreaker:
        # 触发熔断错误比例阈值，默认值50%
        errorThresholdPercentage: 50
        # 熔断后休眠时长，默认值5秒
        sleepWindowInMilliseconds: 5000
        # 熔断触发最小请求次数，默认值是20
        requestVolumeThreshold: 6
      execution:
        isolation:
          thread:
            # 熔断超时设置，默认为1秒
            timeoutInMilliseconds: 2000
```




6.5.3 测试熔断超时时间
在服务提供方，让线程休眠超过2秒中（例如休息5秒中），这个时候会走Fallback方法（因为在熔断策略配置当中，我们配置了熔断超时时间为2秒中，一旦超过2秒，则认为被调用的服务挂了，因此走Fallback【兜底】方法）。

5.5.4 测试熔断错误比例
把提供方线程休眠的代码删除

在服务消费方编写抛出异常的代码 1 2

如何测试：

访问<http://localhost:8080/consumer/findById/2> 访问3（50%）次以上，那么这个时候访问id=1的用户信息无法访问到，需要等待熔断休眠后（默认5秒），就可以正常访问id=1的用户了。

RPC与HTTP区别

1、传输协议
RPC，可以基于TCP协议，也可以基于HTTP协议
HTTP，基于HTTP协议

2、传输效率
RPC，使用自定义的TCP协议，可以让请求报文体积更小，或者使用HTTP2协议，也可以很好的减少报文的体积，提高传输效率
HTTP，如果是基于HTTP1.1的协议，请求中会包含很多无用的内容，如果是基于HTTP2.0，那么简单的封装一下是可以作为一个RPC来使用的，这时标准RPC框架更多的是服务治理

3、性能消耗，主要在于序列化和反序列化的耗时
RPC，可以基于thrift实现高效的二进制传输
HTTP，大部分是通过json来实现的，字节大小和序列化耗时都比thrift要更消耗性能   
WebService：数据的传输xml

4、负载均衡
RPC，基本都自带了负载均衡策略
HTTP，需要配置Nginx（10w），HAProxy、LVS（阿里2000年）来实现

5、服务治理
RPC，能做到自动通知，不影响上游（MQ）
HTTP，需要事先通知，修改Nginx/HAProxy配置

总结：
RPC主要用于公司内部的服务调用，性能消耗低，传输效率高，服务治理方便。HTTP主要用于对外的异构环境，浏览器接口调用，APP接口调用，第三方接口调用、支付接口调用等。
七.Feign进行远程调用
7.1 介绍
Feign 的英文表意为“假装，伪装，变形”， 是一个http请求调用的轻量级框架，可以以Java接口注解的方式调用Http请求，而不用像Java中通过封装HTTP请求报文的方式直接调用。Feign通过处理注解，将请求模板化，当实际调用的时候，传入参数，根据参数再应用到请求上，进而转化成真正的请求，这种请求相对而言比较直观。Feign被广泛应用在Spring Cloud 的解决方案中，是学习基于Spring Cloud 微服务架构不可或缺的重要组件。

![image](./SpringCloud%E5%85%A5%E9%97%A8/1563174971237.png)

Feign是声明式的web service客户端，它让微服务之间的调用变得更简单了，类似controller调用service。Spring Cloud集成了Ribbon和Eureka，可在使用Feign时提供负载均衡的http客户端。

7.1.1 小结
集成Ribbon的负载均衡功能
集成Eureka服务注册与发现功能
集成了Hystrix的熔断器功能
支持请求压缩
Feign以更加优雅的方式编写远程调用代码，并简化重复代码
7.2 入门程序
7.2.1 需求
使用Feign替代RestTemplate发送Rest请求

使用Feign编写程序的基本模板：

1、在消费方添加feign的依赖

2、编写XxxFeign

3、在启动类中要开启Feign

4、在Controller中注入Feign，完成调用

7.2.2 代码实现
7.2.2.1 添加依赖
在服务消费方【本次工程：eureka-client-consumer】添加Feign依赖：

```xml
<!--feign-->
<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```


7.2.2.2 编写Feign
在服务消费方编写Feign客户端接口UserFeign，用于发送请求。

```java
@FeignClient(name = "eureka-client-provsider")
public interface UserFeign {

  @GetMapping("/api/user/findById/{id}")
  String findById(@PathVariable(value = "id") Integer id);
}
```


7.2.2.3 编写Controller
在服务消费方编写FeignConsumerController，注入UserFeign并发送请求。

```java
@RestController
@RequestMapping("/feign")
public class FeignConsumerController {

  @Autowired(required = false)
  private UserFeign userFeign;

  @GetMapping("/findById/{id}")
  public String findById(@PathVariable(value = "id") Integer id){
    String json = userFeign.findById(id);
    return json;
  }
}
```


7.2.2.4 开启Feign功能
在启动类中添加@EnableFeignClients注解，开启Feign功能。

```java
@SpringCloudApplication
@EnableFeignClients	// 开启Feign客户端功能
public class EurekaClientConsumerApplication {

  public static void main(String[] args) {
    SpringApplication.run(EurekaClientConsumerApplication.class, args);
  }

  @Bean
  @LoadBalanced
  public RestTemplate restTemplate(){
    return new RestTemplate();
  }

}
```


7.2.2.5 测试
启动服务并且进行访问测试 localhost:8080/feign/findById/1

7.2.2.6 注意

使用Feign的时候,如果参数中带有@PathVariable形式的参数,则要用value属性去指定。
标明对应的参数,否则会抛出IllegalStateException异常，异常信息：Feign PathVariable annotation was empty on param 0.

7.3 负载均衡
Feign本身集成了Ribbon依赖和自动配置，因此不需要额外引入依赖，也不需要再注入RestTemplate对象。Feign内置的ribbon默认设置了请求超时时长，默认是1000ms，可以修改ribbon内部有重试机制，一旦超时，会自动重新发起请求。如果不希望重试可以关闭配置。

我们可以在服务消费方application.yml中配置如下内容：

```yaml
# 配置负载均衡

eureka-client-consumer:
  ribbon:
    NFLoadBalancerRuleClassName: com.netflix.loadbalancer.RandomRule # 配置为随机
    ConnectTimeout: 1000 # 指的是建立连接所用的时间
    ReadTimeout: 2000    # 指的是建立连接后从服务器读取到可用资源所用的时间
    MaxAutoRetries: 0    # 最大重试次数(第一个服务)
    MaxAutoRetriesNextServer: 0     # 最大重试下一个服务次数(集群的情况才会用到)
    OkToRetryOnAllOperations: false # 是否对所有的请求都重试
```




7.4 熔断支持(Feign默认对Hystrix支持)
代码模板：

1、在配置文件中开启熔断

2、在@FeignClient注解指定fallback属性=T.class

3、定义该类：需要实现UserFeign接口

7.4.1 需求
调用服务时，如果服务出现宕机，给用户响应一个友好提示。

7.4.2 代码实现
7.4.2.1 开起Feign对熔断器支持
开启Feign对熔断器支持，默认是关闭的。在服务消费方的application.yml文件中配置如下内容：

```yaml
feign:
  hystrix:
    enabled: true
```


7.4.2.2 编写Fallback处理类
创建熔断器的处理类，需要实现Feign客户端的接口。

```java
@Component
public class UserFeignFallback implements UserFeign {
  @Override
  public String findById(Integer id) {
    return "ERROR";
  }
}
```


7.4.2.3 调用Fallback
在Feign客户端需要调用熔断器的处理类。

```java
@FeignClient(name = "eureka-client-provider", fallback = UserFeignFallback.class)
public interface UserFeign {

    @GetMapping("/api/user/findById/{id}")
    String findById(@PathVariable(value = "id") Integer id);

}
```


7.4.2.4 测试
PS：在消费方的controller中就无需添加@HystrixCommand、@DefaultProperties相关注解了。

停止服务提供方程序，发送请求 localhost:8080/feign/findById/1 可以查看到输出“ERROR”

7.5 日志配置
7.5.1 介绍
Feign 提供了日志打印功能，可以通过配置来调整日志级别，从而了解 Feign 中 Http 请求的细节。 说白了就是对接口的调用情况进行监控和输出 。


日志级别： 
          NONE: 默认的，不显示任何日志

          BASIC：仅记录请求方法、URL、响应状态码以及执行时间
    
          HEADERS：除了BASIC中定义的信息以外，还有请求和响应的头信息
    
          FULL： 除了HEADERS中定义的信息之外，还有请求和响应的正文及元数据
7.5.2 代码实现
创建Feign的配置类

```java
@Configuration
public class FeignConfig {

    @Bean
    public Logger.Level feignLoggerLevel(){
        return Logger.Level.FULL;
    }

}
```


在配置文件中开Feign客户端日志

```yaml
#开启Feign客户端日志  也可以直接扫feign包 
logging:
  level:
    com.test.feign.UserFeign: debug
```


7.5.3 测试
重启消费方并发送请求，可在idea的控制台查看log日志

7.6 请求压缩
对文件上传、下载进行压缩【gzip xxx.tar.gz/bz2】，指定文件上传大小。

SpringCloudFeign支持对请求和响应进行GZIP压缩，以减少通信过程中的性能损耗。通过配置开启请求与响应的压缩功能：

开启压缩功能
```yaml
feign:
	compression:
        request:
            enabled: true # 开启请求压缩
        response:
            enabled: true # 开启响应压缩
            对请求类型以及压缩大小进行限制



# 无注释版

feign:
	compression:
		request:
			enabled: true
			mime-types:	text/html,application/xml,application/json
			min-request-size: 2048 

#  Feign配置

feign:
	compression:
		request:
			enabled: true # 开启请求压缩
			mime-types:	text/html,application/xml,application/json # 设置压缩的数据类型
			min-request-size: 2048 # 设置触发压缩的大小下限
			#以上数据类型，压缩大小下限均为默认值
```



八.Spring Cloud Gateway网关
8.1 API网关
API 网关出现的原因是微服务架构（分布式、soa）的出现，不同的微服务一般会有不同的网络地址，而外部客户端可能需要调用多个服务的接口才能完成一个业务需求，如果让客户端直接与各个微服务通信，会有以下的问题：

客户端会多次请求不同的微服务，增加了客户端的复杂性。
存在跨域请求（CORS A服务器—->B服务器资源），在一定场景下处理相对复杂。
CSRF：跨站的请求伪造
认证复杂，每个服务都需要独立认证。 url ：token（令牌or票据）
难以重构，随着项目的迭代，可能需要重新划分微服务。
某些微服务可能使用了不友好的协议，直接访问会有一定的困难。
以上这些问题可以借助 API 网关解决。API 网关是介于客户端和服务器端之间的中间层，所有的外部请求都会先经过 API 网关这一层。也就是说，API 的实现方面更多的考虑业务逻辑，而安全、性能、监控可以交由 API 网关来做，这样既提高业务灵活性又不缺安全性

使用 API 网关后的优点如下：

易于监控。可以在网关收集监控数据并将其推送到外部系统进行分析。
易于认证。可以在网关上进行认证，然后再将请求转发到后端的微服务，而无须在每个微服务中进行认证。
减少了客户端与各个微服务之间的交互次数。
8.2 网关选型
8.2.1 网关选型
常用网关
nginx
zuul
Spring cloud gateway
8.2.2 Spring Cloud Gateway
8.2.2.1 介绍
Spring Cloud Gateway 是 Spring Cloud 的一个全新项目，它旨在为微服务架构提供一种简单有效的统一的 API 路由管理方式。并且基于 Filter 链的方式提供了网关基本的功能，例如：安全、监控、限流等。

2.2.2.2 术语
Route（路由）：这是网关的基本构建块。它由一个 ID，一个目标 URI，一组断言和一组过滤器定义。如果断言为真，则路由匹配。
Predicate（断言）：这是一个 Java 8 的 Predicate。输入类型是一个 ServerWebExchange。我们可以使用它来匹配来自 HTTP 请求的任何内容，例如 headers 或参数。 请求做一些配置
Filter（过滤器）：这是org.springframework.cloud.gateway.filter.GatewayFilter的实例，我们可以使用它修改请求和响应
8.2.2.3 流程
客户端向 Spring Cloud Gateway 发出请求。然后在 Gateway Handler Mapping 中找到与请求相匹配的路由，将其发送到 Gateway Web Handler。Handler 再通过指定的过滤器链来将请求发送到我们实际的服务执行业务逻辑，然后返回。 过滤器之间用虚线分开是因为过滤器可能会在发送代理请求之前（“pre”）或之后（“post”）执行业务逻辑。

![image](./SpringCloud%E5%85%A5%E9%97%A8/1563263071310.png)

8.3 入门程序
8.3.1 创建maven工程
在springcloud-microservice工程下创建api-gateway子工程，并且添加需要的依赖

```xml
<dependencies>
  <dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-gateway</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
  </dependency>

  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
  </dependency>
</dependencies>
```


8.3.2 编写启动类
创建的工程也属于一个服务，因此我们也需要启动并且交个Eureka注册中心管理。在启动类中添加@EnableDiscoveryClient注解或者@EnableEurekaClient。

```java
@SpringBootApplication
@EnableEurekaClient
public class ApiGatewayApplication {

    public static void main(String[] args) {
        SpringApplication.run(ApiGatewayApplication.class, args);
    }

}
```


8.3.3 编写application.yml文件
配置Eureka

配置api的路由规则

```yaml
#注释
server:
  port: 10010
spring:
  application:
    name: api-gateway
  cloud:
    gateway:
      # 路由(集合， - 代表集合)
      routes:
        - id: eureka-client-provider-route  # id唯一标识，(可自定义)
          uri: http://127.0.0.1:9091        # 路由服务提供方地址
          predicates:                       # 路由拦截地址的规则(断言)
            - Path=/api/user/**             # 拦截以/api/user开头请求的url
eureka:
  client:
    service-url:
      defaultZone: http://127.0.0.1:10086/eureka
```


8.3.4 测试
启动所有服务，访问测试 localhost:10010/api/user/findById/1 会拦截以/api/user/开头的url

8.4 动态路由（LB）
刚才路由规则中，我们把路径对应服务地址写死了！如果服务提供者集群的话，这样做不合理。应该是根据服务名称，去Eureka注册中心查找服务对应的所有实例列表，然后进行动态路由！配置如下：

#          uri: http://127.0.0.1:9091
uri: lb://eureka-client-provider
启动网关服务再次访问 localhost:10010/api/user/findById/1，配置了lb会路由不到不同的服务提供方

PS：不同的负载均衡策略可能查看的结果不一样

8.5 过滤器
由filter工作流程点，可以知道filter有着非常重要的作用，在“pre”类型的过滤器可以做参数校验、权限校验、流量监控、日志输出、协议转换等，在“post”类型的过滤器中可以做响应内容、响应头的修改，日志的输出，流量监控等。 (类似于spring webmvc的interceptor)

当我们有很多个服务时，就出现了许多重复的工作。

在微服务的上一层加一个全局的权限控制、限流、日志输出的Api Gatewat服务，起到一个服务边界的作用，外接的请求访问系统，必须先通过网关层，抽出并解决了重复工作。

SpringCloud Gateway过滤器：

默认提供的过滤器-可以直接使用（出厂自带）
自定义过滤器
在Spring Cloud Gateway中，filter从作用范围可分为另外两种，一种是针对于单个路由的gateway filter，它在配置文件中的写法同predict类似；另外一种是针对于所有路由的global gateway filer。

自定义全局过滤器

要求

要实现GlobalFilter接口，还可以实现Ordered接口（指定过滤器的执行顺序）

编写的过滤器需要交给spring管理：@Component注解

需求：访问服务提供方需要认证的（登录成功后生成一个token）

代码实现：编写过滤器完成业务处理

自定义局部过滤器

要求

需要：extends AbstractGatewayFilterFactory

自定义的局部过滤器类名有要求的：XxxGatewayFilterFactory

需求：访问服务提供方的ip地址必须是本地的（ip限制）

如何指定启动顺序

yaml文件中按照filter书写顺序执行
在方法中@Order注解设定顺序
8.5.1 过滤器分类
默认过滤器：出厂自带，实现好了拿来就用，不需要实现
全局默认过滤器
局部默认过滤器
自定义过滤器：根据需求自己实现，实现后需配置，然后才能用。
全局过滤器：作用在所有路由上。
局部过滤器：配置在具体路由下，只作用在当前路由上。
默认过滤器几十个，常见如下：

过滤器名称	说明
AddRequestHeader	对匹配上的请求加上Header
AddRequestParameters	对匹配上的请求路由
AddResponseHeader	对从网关返回的响应添加Header
StripPrefix	对匹配上的请求路径去除前缀
8.5.2 配置过滤器
8.5.2.1 配置全局过滤器
例：设置响应的头信息

修改application.yml文件

```yaml
#注释
server:
  port: 10010
spring:
  application:
    name: api-gateway
  cloud:
    gateway:

      # 路由(集合， - 代表集合)
	      routes:

   - id: eureka-client-provider-route  # id唯一标识，(可自定义)

#          uri: http://127.0.0.1:9091        # 路由服务提供方地址

          uri: lb://eureka-client-provider   # 动态路由
          predicates:                       # 路由拦截地址的规则(断言)
            - Path=/api/user/**             # 拦截以/api/user开头请求的url
      default-filters:
        - AddResponseHeader=X-Response-Default-MyName,testGloble

eureka:
  client:
    service-url:
      defaultZone: http://127.0.0.1:10086/eureka
```


通过浏览器F12查看

Network——1——Response Headers——X-Response-Default-MyName

8.5.2.2 配置局部过滤器
添加请求路径前缀

修改application.yml文件

```yaml
#注释
server:
  port: 10010
spring:
  application:
    name: api-gateway
  cloud:
    gateway:

      # 路由(集合， - 代表集合)

​      routes:

   - id: eureka-client-provider-route  # id唯一标识，(可自定义)
     uri: lb://eureka-client-provider  # 动态路由
     predicates:                       # 路由拦截地址的规则(断言)

#            - Path=/api/user/**            # 拦截以/api/user开头请求的url

            - Path=/**                      # 匹配多级目录
          filters:
            - PrefixPath=/api/user/findById # 指定请求的前缀，我们在访问的时候就不需要添加了
      default-filters:
        - AddResponseHeader=X-Response-Default-MyName,testGloble

eureka:
  client:
    service-url:
      defaultZone: http://127.0.0.1:10086/eureka
```


重启网关服务

测试 localhost:10010/1

路由说明：

配置	访问api网关地址	路由地址
PrefixPath=/user	http://localhost:10010/8	http://localhost:9091/user/8
PrefixPath=/user/abc	http://localhost:10010/8	http://localhost:9091/user/abc/8
去除请求路径前缀


在gateway中通过配置路由过滤器StripPrefix，来指定路由要去掉的前缀个数。以实现映射路径中地址的去除。
例1：StripPrefix=1
路径/api/user/1将会被路由到/user/1

例2：StripPrefix=2
路径/api/user/1将会被路由到/1
修改application.yml文件

```yaml
#注释
server:
  port: 10010
spring:
  application:
    name: api-gateway
  cloud:
    gateway:

      # 路由(集合， - 代表集合)

​      routes:

   - id: eureka-client-provider-route  # id唯一标识，(可自定义)
     uri: lb://eureka-client-provider  # 动态路由
     predicates:                       # 路由拦截地址的规则(断言)

#            - Path=/api/user/**            # 拦截以/api/user开头请求的url

            - Path=/**                      # 匹配多级目录
          filters:
            - PrefixPath=/api/user/findById
            - StripPrefix=1                 # 带前缀
      default-filters:
        - AddResponseHeader=X-Response-Default-MyName,testGloble

eureka:
  client:
    service-url:
      defaultZone: http://127.0.0.1:10086/eureka
```


重启网关服务

测试 localhost:10010/xxx/api/user/findById/1

路由说明

配置	访问网关地址	路由地址（提供方）
StripPrefix=1	http://localhost:1001/api/user/1	http://localhost:9091/user/1
StripPrefix=2	http://localhost:10010/api/user/1	http://localhost:9091/1
8.5.3 自定义过滤器
自定义过滤器：参考官方的文档

自定义全局的过滤器：必须实现接口：GlobalFilter、可以实现Ordered接口（指定该过滤器的执行顺序)

需求：发送的请求中，必须携带令牌（无法访问）
自定义局部的过滤器：必须实现接口：AbstractGatewayFilterFactory

需求：限定请求的ip（A 可以访问 其他公司：不能访问）
自定义局部过滤器类的名称：不能随便写 XxxGatewayFilterFactory
8.5.3.1 自定义全局过滤器
Spring Cloud 中常见的内置过滤器如下

![image](./SpringCloud%E5%85%A5%E9%97%A8/1563268861501.png)

如果要自定义全局过滤，我们需要实现GlobalFilter接口（也可以实现Ordered接口，该接口中的方法代表该过滤器执行的优先级，值越小，优先级越高）。

PS：如果不会自定义全局过滤器，可以参考官方已实现的过滤器。（https://cloud.spring.io/spring-cloud-static/Greenwich.SR2/single/spring-cloud.html）[120 Developer Guide]

8.5.3.1.1 需求
判断请求是否包含了请求参数“token”，如果不包含请求参数“token”则不转发路由，否则执行正常的业务逻辑。

8.5.3.1.2 自定义全局过滤器
在网关服务工程中（在com.test.filter包下），自定义全局过滤器。

```java
@Component
public class TokenFilter implements GlobalFilter, Ordered{

  /**
     * @Description 判断请求中是否携带token
     * @param exchange 封装了request和response
     * @param chain 过滤器链
     * @return reactor.core.publisher.Mono<java.lang.Void>
     **/
  @Override
  public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
    // 1、获取request和response
    ServerHttpRequest request = exchange.getRequest();
    ServerHttpResponse response = exchange.getResponse();
    // 2、判断请求参数是否携带token
    String token = request.getQueryParams().getFirst("token");
    if (token == null) {
      System.out.println("token is empty!!!");
      response.setStatusCode(HttpStatus.UNAUTHORIZED);    // 设置响应状态码
      // 不放行
      return response.setComplete();
    }
    // 放行，加入过滤器链中
    return chain.filter(exchange);
  }


  // @Description 指定过滤器的执行顺序，值越小优先级越高
  @Override
  public int getOrder() {
    return 0;
  }

}
```



PS：方法参数说明
ServerWebExchange exchange：Contract for an HTTP request-response interaction. Provides access to the HTTP request and response and also exposes additional server-side processing related properties and features such as request attributes（官方）
ServerWebExchange是一个HTTP请求-响应交互的契约。提供对HTTP请求和响应的访问，并公开额外的 服务器 端处理相关属性和特性，如请求属性。（存放着重要的请求-响应属性、请求实例和响应实例等等，有点像 Context 的角色）

GatewayFilterChain chain：过滤器链（将所有的过滤器加入该链中，相当于我们之前学习的springmvc的拦截器链）
8.5.3.1.3 测试
启动网关服务，发送请求：

不携带token请求 localhost:10010/xxx/api/user/findById/1

返回401错误

携带token请求 localhost:10010/xxx/api/user/findById/1?token=666

正常访问

8.5.3.2 自定义局部过滤器
创建自定义局部过滤器，代码实现如下：（定义局部过滤器时，要求过滤器类的名称有一定的规范性。XxxGatewayFilterFactory ）

```java
@Component
public class IpForbidGatewayFilterFactory extends AbstractGatewayFilterFactory<IpForbidGatewayFilterFactory.Config> {

  public IpForbidGatewayFilterFactory() {
    super(Config.class);
  }

  //指定字段的顺序（必须）
  @Override
  public List<String> shortcutFieldOrder() {
    return Arrays.asList("ip");
  }

  @Override
  public GatewayFilter apply(Config config) {
    // grab configuration from Config object
    return (exchange, chain) -> {
      // 1、获取request和response
      ServerHttpRequest request = exchange.getRequest();
      ServerHttpResponse response = exchange.getResponse();
      // 2、获取服务器端ip
      String hostAddress = request.getRemoteAddress().getAddress().getHostAddress();
      // 3、获取配置文件中的ip
      String ip = config.getIp();
      System.out.println(ip);
      if (ip.equals(hostAddress)){
        // 放行
        return chain.filter(exchange);
      }
      // 设置响应的状态码
      response.setStatusCode(HttpStatus.FORBIDDEN);
      return response.setComplete();
    };
  }

  //将配置文件中的局部过滤器的值映射到该属性上
  public static class Config {
    private String ip;

    public String getIp() {
      return ip;
    }

    public void setIp(String ip) {
      this.ip = ip;
    }
  }

}
```


8.5.3.2.3 配置局部过滤器（坑）
1
坑：在定义局部过滤器时，要求过滤器类的名称有一定的规范性。例如：XxxGatewayFilterFactory。配置局部过滤的名称时，并不是任意写，默认截取该类的XxxGatewayFilterFactory的GatewayFilterFactory前半部分，例如为Xxx。
8.5.3.2.4 测试
启动网关服务，发送请求 localhost:10010/xxx/api/user/findById/1?token=666


温馨提示：
JAVA Web开发过程中,很多场景下需要获取访问终端的IP,对应方法getRemoteAddress。0:0:0:0:0:0:0:1，这个是IPv6地址,当前互联网环境下仍以ipv4为主。在较高版本的操作系统，Win7/Win10等启用了ipv6，大家需要手工禁止，或者通过参数控制。

在jvm命令行添加以下参数
-Djava.net.preferIPv4Stack=true
九.Spring Cloud Config配置中心
9.1 介绍
分布式系统中，由于服务数量非常多，配置文件分散在不同微服务项目中，管理极其不方便。为了便于集中配置的统一管理，在分布式架构中通常会使用分布式配置中心组件。Spring Cloud Config最大的优势就是和Spring的无缝集成，对于已有的Spring应用程序的迁移成本非常低，结合Spring Boot可使项目有更加统一的标准（包括依赖版本和约束规范），避免了因集成不同开发软件造成的版本依赖冲突等问题 。也支持配置文件放在远程仓库Git(GitHub、码云)。配置中心本质上是一个微服务，同样需要注册到Eureka服务中心！

9.2 GIT远程仓库配置
9.2.1 创建远程仓库
9.2.2 创建配置文件
第一步：创建配置文件：统一管理

配置文件命名规则：{application}-{profile}.yml或{application}-{profile}.properties
application：应用名称，例如：user
profile：指定应用环境，例如：开发环境dev，测试环境test，生产环境pro等
开发环境 user-dev.yml
测试环境 user-test.yml
生产环境 user-pro.yml
第二步：创建配置文件并提交：将工程服务提供方工程【eureka-client-provider】下的配置文件内容复制过来

9.3 搭建配置中心服务
9.3.1 创建工程
在父工程 springcloud-microservice 下继续创建配置中心服务工程config-center-server，并且需要注册到注册中心，因此需要添加如下依赖：

```xml
<dependencies>
  <!--配置中心-->
  <dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-config-server</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
  </dependency>

  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
  </dependency>

</dependencies>
```


9.3.2 编写启动类
在启动类中添加@EnableConfigServer、@EnableDiscoveryClient

```java
@SpringBootApplication
@EnableDiscoveryClient	// 开启eureka
@EnableConfigServer // 开启config服务支持
public class ConfigCenterServerApplication {

  public static void main(String[] args) {
    SpringApplication.run(ConfigCenterServerApplication.class, args);
  }
}
```


9.3.3 编写配置文件
application.yml

```yaml
server:
  port: 12000 # 端口号
spring:
  application:
    name: config-server # 应用名
  cloud:
    config:
      server:
        git:

          # 配置gitee的仓库地址

​          uri: https://gitee.com/projectname/project-spring-cloud-config.git

# Eureka服务中心配置

eureka:
  client:
    service-url:
      # 注册Eureka Server集群
      defaultZone: http://127.0.0.1:10086/eureka

# com.test 包下的日志级别都为Debug

logging:
  level:
    com: debug
```


9.3.4 启动测试
启动注册中心服务以及该服务进行测试 localhost:12000/user-dev.yml
9.4 服务获取配置中心配置信息
9.4.1 需求
服务提供方工程中，配置文件内容不在由该服务自己去提供，而是从配置中心上获取。

9.4.2 添加依赖
在服务提供方【eureka-client-provider】添加Spring Cloud Config依赖。

```xml
<!--spring cloud 配置中心-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-config</artifactId>
</dependency>
```


9.4.3 修改配置
删除提供方application.yml文件；

添加bootstrap.yml文件，配置内容如下

```yaml
spring:
  cloud:
    config:
      name: user # 与远程仓库中的配置文件的application保持一致，{application}-{profile}.yml
      profile: dev # 远程仓库中的配置文件的profile保持一致
      label: master # 远程仓库中的版本保持一致
      discovery:
        enabled: true # 使用配置中心
        service-id: config-server # 配置中心服务id

#向Eureka服务中心集群注册服务
eureka:
  client:
    service-url:
      defaultZone: http://127.0.0.1:10086/eureka
```


当使用 Spring Cloud 的时候，配置信息一般是从 config server 加载的，为了取得配置信息（比如密码等），你需要一些提早的或引导配置。因此，把 config server 信息放在 bootstrap.yml，用来加载真正需要的配置信息。

application.yml和bootstrap.yml文件的说明

bootstrap.yml文件是SpringBoot的默认配置文件，而且其加载时间相比于application.yml优先级更高（优先加载）
bootstrap.yml（系统级别）可以理解成系统级别的一些参数配置，一般不会变动
application.yml（应用级别）用来定义应用级别的参数
9.4.4 启动测试
启动注册中心、服务提供方、网关服务、配置中心服务，判断是否能够进行调用

十.Spring Cloud Bus消息总线
消息总线：修改配置文件后，程序无需重新启动。

Bus集成的：MQ（RabbitMQ 常见的消息队列ActiveMQ、kafka【大数据】、RocketMQ）

目前并不完全自动化，需要：手动的进行广播

建议使用zookeeper：watch 等其他工具

10.1 Spring Cloud Bus介绍
Spring Cloud Bus是用轻量的消息代理将分布式的节点连接起来,可以用于广播配置文件的更改或者服务的监控管理。一个关键的思想就是,消息总线可以为微服务做监控,也可以实现应用程序之间相互通信。 Spring Cloud Bus可选的消息代理线线泡括RabbitMQ、Kaka等。本次我们用 RabbitMQ作为 Spring Cloud的消息组件去刷新更改微服务的配置文件。

Spring Cloud Bus的一个功能就是让这个过程变得简单,当远程Git仓库的配置更改后,只需要向某一个微服务实例发送一个Post请求,通过消息组件通知其他微 服务实例重新拉取配置文件。

10.2 入门程序
10.2.1 安装RabbitMQ
10.2.2 更新配置中心服务
在工程中添加依赖

```xml
<!--消息总线依赖-->
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-bus</artifactId>
</dependency>
<!--RabbitMQ依赖-->
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-stream-binder-rabbit</artifactId>
</dependency>
```


修改application.yml文件

```yaml
# rabbitmq的配置信息；如下配置的rabbit都是默认值，其实可以完全不配置

spring:
  rabbitmq:
    host: localhost
    port: 5672
    username: guest
    password: guest

# 暴露触发消息总线的地址

management:
  endpoints:
    web:
      exposure:
        # 暴露触发消息总线的地址
        include: bus-refresh
```




10.2.3 更新服务提供方服务
在工程中添加依赖

```xml
<!--消息总线依赖-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-bus</artifactId>
</dependency>
<!--RabbitMQ依赖-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-stream-binder-rabbit</artifactId>
</dependency>
<!--健康监控依赖-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```


修改bootstrap.yml文件

```yaml
spring:
  rabbitmq:
    host: localhost
    port: 5672
    username: guest
    password: guest
```


修改UserController，添加@RefreshScope注解，刷新配置。

10.2.4 启动相关服务测试
广播：发送POST请求，地址 127.0.0.1:12000/actuator/bus-refresh 再测试

总结 Spring Cloud总架构
![image](./SpringCloud%E5%85%A5%E9%97%A8/1594713897762.png)