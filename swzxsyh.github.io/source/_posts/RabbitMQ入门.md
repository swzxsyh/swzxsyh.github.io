---
title: RabbitMQ入门
date: 2020-07-15 01:58:20
tags:
---


安装mq

```shell
# 下载
$ docker pull rabbitmq

# 启动
# 设置容器名Myrabbitmq
# 设置 用户名/密码 admin
# 映射网页端口 15672
# 映射 协议端口，基于此协议的客户端与消息中间件之间可以传递消息
$ docker run -dit --name Myrabbitmq -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=admin -p 15672:15672 -p 5672:5672 rabbitmq

#未开启网页端口，需要进入容器开启
$ docker exec -ti 75d79fb9dc6f /bin/bash 

#开启网页端
root@75d79fb9dc6f:/# rabbitmq-plugins enable rabbitmq_management

#访问 http://localhost:15672 即可
```