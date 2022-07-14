---
title: Docker安装使用Oracle 11g
date: 2020-04-23 01:28:17
tags:
---

一.拉取镜像
1
docker pull registry.cn-hangzhou.aliyuncs.com/helowin/oracle_11g
1.1 可以改名
1
docker tag xxxxxxxxxx oracle:oracle_11g  
二.启动
2.1 启动镜像
1
docker run -d -p 1521:1521 --name oracle_11g oracle_11g:latest               
2.2 查看容器是否运行
1
docker ps -a
三.配置
3.1 进入容器
1
docker exec -it oracle_11g bash  
3.2 切换到root
1
2
su root
#密码:helowin
3.3 编辑profile文件
1
vi /etc/profile
最后行添加如下环境变量

1
2
3
export ORACLE_HOME=/home/oracle/app/oracle/product/11.2.0/dbhome_2
export ORACLE_SID=helowin
export PATH=$ORACLE_HOME/bin:$PATH
3.4 创建软链接
1
ln -s $ORACLE_HOME/bin/sqlplus /usr/bin
3.5 切换回oracle
1
su - oracle
3.6 登陆sqlplus
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
sqlplus /nolog
conn /as sysdba
//修改system密码为123123
alter user system identified by 123123;
//修改sys密码为123123
alter user sys identified by 123123;
//修改密码规则策略为密码永不过期
ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;
//修改数据库最大连接数据；
alter system set processes=1000 scope=spfile; 

alter user scott account unlock;
alter user scott identified by abc;
commit;
3.7 重启数据库
1
2
3
4
//关闭数据库
shutdown immediate; 
//启动数据库
startup; 
四.Navicat连接数据库
Connection Name	任意
Connection Type	Basic
Host:	如果是本机起的Docker，不填
Port:	1521
Service Name:	helowin
SID
Role	Default
Username	scott
password	123123