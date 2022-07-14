---
title: Java Web - Tomcat & Http
date: 2020-04-13 01:18:16
tags:
---
一.Web知识概述
JavaWeb:将编写好的代码，发布到互联网，可以让所有用户访问

1.1 软件架构
•网络中有很多的计算机，它们直接的信息交流，我们称之为:交互
•在互联网交互的过程的有两个非常典型的交互方式——B/S 交互模型(架构)和 C/S 交互模型(架构)

C/S架构

Client/Server 客户端/服务器
访问服务器资源必须安装客户端软件
优点:用户体验好
缺点:开发(客户端,服务器),部署和维护繁琐

B/S架构

Browser/Server 浏览器/服务器
访问服务器资源不需要专门安装客户端软件,而是直接通过浏览器访问服务器资源.
优点:开发、部署,更新简单
缺点:用户体验差

C/S架构也是一种特殊的B/S架构

1.2 Web服务器作用
开发者通过web服务器可以把本地资源发布到互联网
用户就可以通过浏览器访问这些资源
1.3 资源的分类
资源:计算机中数据文件

静态资源
对于同一个页面,不同用户看到的内容是一样的。
例如:体育新闻、网站门户等，常见后缀: .html、.js、*.css

动态资源 用对于同一个页面,不同用户看到的内容可能不一样。
例如:购物车、我的订单等，常见后缀: .jsp、.aspx、*.php

1.4 常见的Web服务器
Tomcat: Apache组织开源免费的web服务器,支持JavaEE规范(Servlet/Jsp).
Jetty:Apache组织开源免费的小型web服务器,支持JavaEE规范.
JBoss: RedHat红帽公司的开源免费的web服务器,支持JavaEE规范.
Glass Fish:Sun公司开源免费的web服务器,支持JavaEE规范.
WebLogic: Oracle公司收费的web服务器,支持JavaEE规范.
WebSphere:IBM公司收费的web服务器,支持JavaEE规范.
JavaEE规范
在Java中所有的服务器厂商都要实现一组Oracle公司规定的接口，这些接口是称为JavaEE规范。不同厂商的JavaWeb服务器都实现了这些接口，在JavaEE中一共有13种规范。实现的规范越多，功能越强。
二.Tomcat服务器
2.1 Tomcat使用
2.1.1 下载
Tomcat 官网下载地址:https://tomcat.apache.org/download-80.cgi

2.1.2 安装
解压即用

2.1.3 目录结构
ls -F | grep “/

目录	说明
bin/	启停命令
conf/	配置文件
lib/	运行时所依赖的jar包
logs/	运行日志
temp/	缓存
webapps/	发布自己的网站目录
work/	存放编译生产的.java与.class文件
cd webapps/

目录	说明
docs	tomcat的帮助文档
examples	web应用实例
host-manager	主机管理
manager	主机管理
ROOT	说默认站点根目录明
[root@localhost webapps]# cd ../conf/

目录	说明
Catalina	
catalina.policy	
catalina.properties	
context.xml	
logging.properties	
logs	
server.xml	tomcat 主配置文件
tomcat-users.xml	tomcat 管理用户配置文件
tomcat-users.xsd	
web.xml	
ls -l | grep ^- | awk ‘{print $9}’

文件	说明
BUILDING.txt	
CONTRIBUTING.md	
LICENSE	
NOTICE	
README.md	
RELEASE-NOTES	
RUNNING.txt	
2.1.4 启动和关闭
cd apache-tomcat-8.5.54/bin
chmod +x *.sh
./startup.sh
./shutdown.sh

2.1.5 启动报错问题
Java环境变量

解决方法:
配置JAVA_HOME

8080端口被占用
启动时报错

解决方式一:kill pid
netstat -anpl | grep ‘8080’

解决方式二:修改Tomcat端口号
进入Tomcat安装目录/conf/server.xml 文件修改
cat server.xml| grep ‘Connector port’
Connector port=”8080”


如果要启动多个tomcat，需要修改三个端口
2.1.6 发布项目的三种方式
webapps部署
直接放置在 webapps 目录下
cp -r myapp tomcat/webapps
这种方案,一般在开发完毕后使用

server.xml部署不建议使用
在tomcat/conf/server.xml中找到标签，添加标签

1
2
<!-- path虚拟路径 docBase 真实路径-->
     <Context path="myapp" docBase="apache-tomcat-8.5.54/webapps/myapp"/>
缺点:

I.配置文件修改完后，需要重启才生效
II.server.xml是tomcat核心配置文件，如果操作错误会导致tomcat启动失败

独立xml部署
在tomcat/conf/Catalina/localhost 目录下创建一个xml文件，添加标签

myapp.xml
文件名就是虚拟路径
localhost:8080/myapp/index.html

1
2
<!-- 这里没有path,真实路径就是docBase中的路径 -->
 <Context docBase="apache-tomcat-8.5.54/webapps/myapp"/>
2.2 Web项目结构
前端项目

1
2
3
4
5
6
|-- myapp(项目名称)
    |-- css 目录 
    |-- js 目录 
    |-- html目录 
    |-- img 目录 
    |-- index.html
Web项目

1
2
3
4
5
6
7
|-- myapp(项目名称)
    |-- 静态资源目录(html,css,js,img)
    |-- WEB-INF 目录 (浏览器无法直接访问内部资源)
            |-- classes 目录(java字节码文件)
            |-- lib     目录 (当前项目所需要的第三方jar包)
            |-- web.xml 文件 (当前项目核心配置文件,servlet3.0可以省略)
    |-- index.html or index.jsp
2.3 IDEA中使用Tomcat
2.3.1 配置Tomcat
IDEA->Edit Configuration->在Application server添加Tomcat解压的路径即可

2.3.2 创建Web项目
IDEA->New Moudle->左侧选Java Enterprise->右侧选Moudle SDK选1.8，JAVAEE Version选JAVAEE 7，Application Server选tomcat，下拉列表勾选Web Application并勾选创建web.xml，下一步即可

2.3.3 发布Web页面
IDEA->选择Edit Configurations->进入Deployment指定context(新版本会默认生成)

2.3.4 页面资源热更新
IDEA->选择Edit Configurations->On ‘Update’ action 和On frame deactivation都选择Update resources

注意:WEB-INF动态资源是无法被浏览器直接访问的，会出现404错误

三.Http协议
3.1 Http协议概述
超文本传输协议(Hyper Text Transfer Protocol)是互联网上应用最为广泛的一种网络协议。
传输协议:在客户端和服务器端通信时，规范了传输数据的格式
HTTP协议特点:
I.基于TCP协议
II.默认端口80
III.基于请求/响应模型
IV.无状态协议(多次请求之间都是独立，不能交互数据)

HTTPS协议:
本质就是HTTP，对通信对数据进行加密
默认端口号443

3.2 Http请求
3.2.1 浏览器查看Http请求协议
get方式(查看Inspect-Network-Request Headers)
请求行	GET /Day32_Tomcat/web/index.html?username=jack&password=123 HTTP/1.1
请求头	Host: localhost:63343
Connection: keep-alive
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.162 Safari/537.36 Edg/80.0.361.109
Sec-Fetch-Dest: document
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Sec-Fetch-Site: same-origin
Sec-Fetch-Mode: navigate
Sec-Fetch-User: ?1
Referer: http://localhost:63343/Day32_Tomcat/web/index.html
Accept-Encoding: gzip, deflate, br
Accept-Language: zh,en-CN;q=0.9,en-US;q=0.8,en;q=0.7
Cookie: Idea-b40ac89=cb70dd01-3e65-4870-9e53-e3ad801dd2b0;
If-Modified-Since: Mon, 13 Apr 2020 10:05:39 GMT
post方式(查看Inspect-Network-Request Headers)
请求头	POST /Day32_Tomcat/web/index.html?username=jack&password=123 HTTP/1.1
请求行	Host: localhost:63343
Connection: keep-alive
Content-Length: 26
Cache-Control: max-age=0
Origin: http://localhost:63343
Upgrade-Insecure-Requests: 1
Content-Type: application/x-www-form-urlencoded
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.162 Safari/537.36 Edg/80.0.361.109
Sec-Fetch-Dest: document
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Sec-Fetch-Site: same-origin
Sec-Fetch-Mode: navigate
Sec-Fetch-User: ?1
Referer: http://localhost:63343/Day32_Tomcat/web/index.html?username=jack&password=123
Accept-Encoding: gzip, deflate, br
Accept-Language: zh,en-CN;q=0.9,en-US;q=0.8,en;q=0.7
Cookie: Idea-b40ac89=cb70dd01-3e65-4870-9e53-e3ad801dd2b0;
请求体
(位于Form Data)	username=jack&password=123
3.2.2 HTTP请求消息格式
3.2.2.1 请求行
格式
请求方式 请求路径 协议/版本号
例如
POST /Day32_Tomcat/web/index.html?username=jack&password=123 HTTP/1.1
GET /Day32_Tomcat/web/index.html?username=jack&password=123 HTTP/1.1

请求方式区别
get
1.请求参数在地址栏显示(请求行)
2.请求参数大小有限制
3.数据不太安全


post
1.请求参数不在地址栏显示(请求体)
2.请求参数大小没有限制
3.数据相对安全
3.2.2.2 请求头
格式
请求头名称:请求头的值
例如
Host: localhost:8080
常见请求头:Accept开头的，都是浏览器告诉服务器的一些暗语

Host: 访问服务器的地址(域名+端口)

Host: localhost:8080

Connection: 长连接(http1.1协议)

Connection: keep-alive

Cache-Control: 设置缓存数据的存活时间，单位秒

Cache-Control: max-age=0

Upgrade-Insecure-Requests: 客户端支持https加密协议

Upgrade-Insecure-Requests:1

Content-Type: 发送数据的媒体类型

Content-Type: application/x-www-form-urlencoded

Accept: 客户端告诉服务器，客户端支持的数据类型

Accept: text/html,/;

Accept-Charset: 客户端告诉服务器，客户端支持的字符集

Accept-Charset: UTF-8

Accept-Encoding: 客户告诉服务器，客户端支持的压缩格式

Accept-Encoding: gzip, deflate

Accept-Language: 客户端告诉服务器，客户端系统语言环境 简体中文

Accept-Language: zh-CN,zh;q=0.9

Cookie:

Referer: http://baidu.com 上一次请求的地址

User-Agent: 客户端系统和浏览器版本
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) Chrome/63.0 Safari/537.36
浏览器兼容性

3.2.2.3 请求体(正文)
格式
参数名=参数值&参数名=参数值

例如
username=jack&password=123

注意
get方式没有请求体，post有请求体

3.3 Http响应
3.3.1 浏览器查看Http响应协议(查看Inspect-Network-Response Headers,响应体查看Network的Response栏)
响应行	HTTP/1.1 200 OK
响应头	HTTP/1.1 200 OK
content-type: text/html
server: IntelliJ IDEA 2020.1
date: Mon, 13 Apr 2020 10:25:17 GMT
X-Frame-Options: SameOrigin
X-Content-Type-Options: nosniff
x-xss-protection: 1; mode=block
accept-ranges: bytes
cache-control: private, must-revalidate
last-modified: Mon, 13 Apr 2020 10:12:12 GMT
content-length: 317
access-control-allow-origin: http://localhost:63343
vary: origin
access-control-allow-credentials: true
响应体	
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
<h3>Login</h3>
<form action="#" method="post">
    Name:<input type="text" name="username"/><br/>
    Password<input type="password" name="password"/><br/>
    <input type="submit" value="Login">
</form>
</body>
</html>
3.3.2 HTTP响应消息格式
3.3.2.1 响应行
格式
协议/版本号 状态码

例如
tomcat8:HTTP/1.1 200
tomcat7:HTTP/1.1 200 OK

• 常见状态码

状态码	说明
200	成功
302	重定向
304	从缓存中读取数据
404	请求资源未找到
405	请求的方法未找到
500	服务器内部错误
3.3.2.2 响应头
格式
响应头名称:响应头的值

例如
last-modified: Mon, 13 Apr 2020 10:12:12 GMT

常见响应头:Content开头都是服务器告诉客户端一些暗语

Location:通常与状态码302一起使用，实现重定向操作

Location:http://www.baidu.com

Content-Type:服务器告诉客户端，返回响应体的数据类型和编码方式

Content-Type:text/html;charset=utf-8

Content-Disposition:服务器告诉客户端，以什么样方式打开响应体

in-line(默认):浏览器直接打开相应内容，展示给用户
attachment;filename=文件名:浏览器以附件的方式保存文件 【文件下载】

Refresh::在指定间隔时间后，跳转到某个页面

Refresh:5;http://www.baidu.com

Last-Modified:通常与状态码304一起使用，实现缓存机制

last-modified: Mon, 13 Apr 2020 10:12:12 GMT

3.3.2.3 响应体
服务器返回的数据，由浏览器解析后展示给用户
用户看到页面所有的内容，都是在响应体中返回的
总结
web知识概述
架构分类
C/S

客户端专门安装软件
B/S

浏览器作为客户端
web服务器作用
将本地资源发布到互联网，用户可以通过浏览器访问
资源分类
静态

.html .css .js .jpg
动态

.jsp
常见服务器
Tomcat
tomcat服务器
下载
apache-tomcat-8.5.31-windows-x64.zip
安装
解压缩即可
目录结构
bin

startup.bat

启动
shutdown.bat

关闭
conf

server.xml

配置恩建
lib

logs

temp

webapps

存放自己编写web项目，对外发布
work

启停
startup.bat
shutdown.bat
启动有问题
JAVA_HOME环境变量

端口占用

找到占用端口软件，关闭掉，在启动tomcat
修改tomcat在启动
tomcat发布项目方式
webapps目录

热部署
conf/server.xml

不推荐
conf/catalina/localhost

热部署
web项目目录结构
WEB-INF

classes

lib

web.xml

web3.0之后可选
静态资源

index.html或index.jsp

idea中使用tomcat
配置tomcat

创建web项目

启动

重启tomcat
重新部署项目
http协议
概述
在客户端和服务器端通信时，规范了传输数据的格式
构成
请求格式

行

请求方式

get
post
URL

协议

头

请求的描述信息

Referer
User-Agent
体

数据内容

get方式没有，post才有
响应格式

行

协议

状态码

200
302
304
404
405
500
头

响应的描述信息

Location
Content-Type
Content-Disposition
refresh
Last-Modified
体

数据内容