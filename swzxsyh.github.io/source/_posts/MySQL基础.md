---
title: MySQL基础
date: 2020-04-27 01:31:31
tags:
---

一.数据库介绍
1.1 什么是数据库
存储数据的仓库,本质上就是存储数据的文件系统，方便我们管理数据。

1.2 数据库管理系统
数据库管理系统(DataBase Management System，DBMS):指一种操作和管理数据库的大型软件。
数据库管理系统—>MySQL软件–>多个仓库—>多张表—>多条记录(数据)
1.3 实体(java类)和表关系
一个实体对应一张表
一个对象对应一条记录
对象和记录产生映射关系【ORM: Object Relational Mapping】
1.4 常见关系型数据库
MySQL,Oracle,DB2,MSSQL,SQLite

二.MySQL的使用
2.1 配置
操作	本地登录	指定ip
登录	mysql -u用户名 -p密码	mysql -h主机地址 -u用户名 -p密码
退出	exit
quit	exit
quit
三.SQL
3.1 概述
3.1.1 什么是SQL?
结构化查询语言(Structured Query Language)
通过sql语句来操作数据，实现对记录的增删改查
【CRUD】:create 创建、retrieve(read) 检索、update 修改、delete 删除

3.1.2 SQL方言
SQL是一套标准，所有的数据库厂商都实现了此标准;但是各自厂商在此标准上增加了特有的语句，这部分内容我们称为方言。

3.1.3 SQL书写规范
sql语句可以单行或多行书写，最后以分号结尾
sql语句(在windows平台下)不区分大小写，建议关键字大写
1
SELECT * FROM student;
注释
1
2
3
4
5
单行
-- 所有数据库厂商支持
# 仅mysql厂商支持(方言)
多行
/* 注释内容 */
3.1.4 SQL分类
类别	说明
DDL(Data Definition Language)数据定义语言	用来定义数据库对象:数据库，表，列等。关键字:create,drop,alter等
DML(Data Manipulation Language)数据操作语言	用来对数据库中表的数据进行增删改。关键字:insert,delete, update等
DQL(Data Query Language) 数据查询语言	用来查询数据库中表的记录(数据)。关键字:select, where等
DCL(Data Control Language)数据控制语言	用来定义数据库的访问权限和安全级别，及创建用户。关键字:grant,revoke等
TCL(Transaction Control Language) 事务控制语言	用于控制数据库的事务操作，关键字; commit,savepoint,rollback等
四.SQL基础操作
4.1 DDL
4.1.1 操作数据库
C:创建

语法:	实例
直接创建数据库	create database 数据库名;	create database day18;
创建数据库并指定字符	create database 数据库 charset 字符集;	create database day18_1 charset gbk;
R:查询

语法:	实例
查看所有数据库	show databases;	
查看建库语句	show create database 数据库名;	show create database day18_1;
U:修改

语法:	实例
修改数据库字符集	alter database 数据库名 charset 新字符集;	alter database day18_1 charset utf8;
D:删除

语法:	实例
直接删除数据库	drop database 数据库名;	drop database day18_1;
使用数据库

语法:	实例
进入/切换某一个具体的数据库	use 数据库名;	use day18;
查看当前所在哪个数据库中	select database();	
4.1.2 操作表
C:创建

创建表
语法	create table 表名(
列名(字段名) 数据类型,
列名(字段名) 数据类型,
列名(字段名) 数据类型,
…);
实例	create table student(
id int,
name varchar(32),
birthday date
);
常用数据类型
类别	概述	说明
int	整型	
float	浮点型	
double	浮点型	
decimal	浮点型(保留精准度)	decimal(m,n) 指定范围
m 总长度
n 小数长度
varchar	字符型	varchar(n) 指定容纳多少个字符
1~65535 包含字母，符号，汉字
text	文本型	
date	日期类型	
datetime	日期时间类型	
克隆表:创建表表时，可以快速指定另一张表的结构
语法:	实例
克隆表	create table 新表 like 旧表;	create table teacher like student;
R:查询

语法:	实例
查看所有表	show tables;	
查看建表语句	show create table 表名;	show create table teacher;
查看表结构	desc 表名;	desc teacher;
U:修改

语法:	实例
添加一列	alter table 表名 add 列名 数据类型;	alter table teacher add jieshao varchar(50);
修改列类型	alter table 表名 modify 列名 新类型;	alter table teacher modify jieshao varchar(99);
修改列名和类型	alter table 表名 change 旧列名 新列名 新类型;	alter table teacher change jieshao intro varchar(999);
删除指定列	alter table 表名 drop 列名;	alter table teacher drop intro;
修改表字符集	alter table 表名 charset 字符集;	alter table teacher charset gbk;
修改表名	rename table 旧表名 to 新表名;	rename table teacher to tch;
D:删除

语法:	实例
直接删除表	drop table 表名;	drop table tch;
4.2 DML
4.2.1 添加记录
添加记录
语法	insert into 表名(列名1,列名2…)values(值1,值2….);
insert into 表名 values(值1,值2….);
要求	与表结构顺序一致，个数相等
查看	desc 表名
注意:
列名和值的数据类型要对应 字符串类型可以使用单双引号，推荐单引号 字符串可以插入一切(任意)类型，MySQL底层实现了隐式转换 个别列名字段名如果跟关键字冲突了，我们可以使用反引号包裹起来
例如:name

练习

1
2
3
4
5
6
7
8
insert into student(id,name)values(1,'jack');
insert into student values(4,'杰克马',null); 

insert into student(id,name,birthday)values('2','tom','1940-2-10');
insert into student values(3,'刘强东','1973-1-1');

-- 补充:同时添加多条记录
insert into student values(5,'王健林',null),(6,'撒贝宁',null);
蠕虫复制
作用:将一张表的记录，快速复制到另外一张表
应用场景:数据的迁移
需求:创建一张stu新表，表结构与student一致，实现数据的快速迁移 * 要求:二张表结构相同
步骤
克隆表

create table stu  like student;
数据迁移

insert into stu select * from student;
4.2.2 修改记录
修改记录
语法	update 表名 set 列名1=新值1,列名2=新值2…. [where条件]
解释	[] 里面的内容可以省略
实例	update stu set birthday=’1960-1-1’;
update stu set birthday=’2000-1-1’ where id = 4;
4.2.3 删除记录
删除记录	摧毁表，重构表
语法	delete from 表名 [where条件]	runcate table 表名;
解释	[] 里面的内容可以省略	先把表删除，再创建一个相同结构的新表
实例	delete from stu;
delete from student where id = 5;	truncate table student;
4.2.4 知识小结
新增:insert into 表名
修改:update 表名
删除:delete from 表名
4.3 DQL简单查询(检索)
导入数据
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
-- 创建表
create table student1(
    id int,
    name varchar(20),
    chinese double,
    english double,
    math double
);
-- 插入记录
insert into student1(id,name,chinese,english,math) values(1,'tom',89,78,90); 
insert into student1(id,name,chinese,english,math) values(2,'jack',67,98,56); 
insert into student1(id,name,chinese,english,math) values(3,'jerry',87,78,77); 
insert into student1(id,name,chinese,english,math) values(4,'lucy',88,NULL,90); 
insert into student1(id,name,chinese,english,math) values(5,'james',82,84,77); 
insert into student1(id,name,chinese,english,math) values(6,'jack',55,85,45); 
insert into student1(id,name,chinese,english,math) values(7,'tom',89,65,30);
语法
查询结果进行运算，不会影响原表中的记录

语法
格式	select * from 表名;
select 指定列名1,指定列名2…. from 表名;
去重关键字	select distinct 列名 from 表名;
注意:多个列去重，要求内容完全一致
null参与数学运算结果还是null	ifnull()函数
ifnull(列名,默认值)如果该列有值，直接返回，如果为null返回默认值
设置查询别名	select 列名 [as] 列别名 from 表名 [as] 表别名
练习
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
-- 查询表中所有学生的信息
SELECT * FROM student1;
-- 查询表中所有学生的姓名和对应的语文成绩
SELECT `name`,chinese FROM student1;
-- 查询表中学生姓名(去重)
SELECT DISTINCT `name` FROM student1;
SELECT DISTINCT `name`,chinese FROM student1; 
-- 在所有学生数学分数上加10分特长分
SELECT `name`,math+10 FROM student1;
-- 统计每个学生的总分
SELECT `name`, chinese+english+math FROM student1;
SELECT english FROM student1;
SELECT IFNULL(english,0) FROM student1;
-- 解决null值的问题
SELECT `name`, chinese+IFNULL(english,0)+math FROM student1;
-- 使用别名表示学生总分
SELECT `name` AS 姓名, (chinese+IFNULL(english,0)+math) AS 总分 FROM student1 AS stu1;
DQL条件查询
导入数据
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
-- 创建表
CREATE TABLE student2 (
  id int,
  name varchar(20),
  age int,
  sex varchar(5),
  address varchar(100),
  math int,
  english int
);
-- 插入记录
INSERT INTO student2(id,NAME,age,sex,address,math,english) VALUES 
(1,'马云',55,'男','杭州',66,78),
(2,'马化腾',45,'女','深圳',98,87),
(3,'马景涛',55,'男','香港',56,77),
(4,'柳岩',20,'女','湖南',76,65),
(5,'柳青',20,'男','湖南',86,NULL),
(6,'刘德华',57,'男','香港',99,99),
(7,'马德',22,'女','香港',99,99),
(8,'德玛西亚',18,'男','南京',56,65);
语法

语法
格式	select … from 表名 where 条件;
关系(比较)运算符	> < >= <= != =
逻辑运算符	&& and(条件同时成功)
|| or(条件满足一个)
! not(条件取反)
in关键字(某一个列，查询多个值)	select … from 表名 where 列名 in(值1,值2,值3…..);
between关键字(范围查询)	select … from 表名 where 列名 between 较小的值 and 较大的值;
特点:包头包尾
null值处理	is null 函数
is not null 函数
like关键字(模糊匹配)	select … from 表名 where 列名 like ‘通配符字符串’;
_ 单个任意字符
% 多个任意字符
练习

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
# 关系运算符
-- 查询math分数大于80分的学生
SELECT * FROM student2 WHERE math > 80;
-- 查询english分数小于或等于80分的学生
SELECT * FROM student2 WHERE english <= 80; 
-- 查询age等于20岁的学生
SELECT * FROM student2 WHERE age = 20;
-- 查询age不等于20岁的学生
SELECT * FROM student2 WHERE age != 20;
# 逻辑运算符
-- 查询age大于35且性别为男的学生(两个条件同时满足)
SELECT * FROM student2 WHERE age > 35 AND sex = '男';
-- 查询age大于35或性别为男的学生(两个条件其中一个满足)
SELECT * FROM student2 WHERE age > 35 OR sex = '男';
-- 查询id是1或3或5的学生
SELECT * FROM student2 WHERE id = 1 OR id =3 OR id = 5;
-- in关键字
-- 再次查询id是1或3或5的学生
SELECT * FROM student2 WHERE id IN(1,3,5);
-- 查询id不是1或3或5的学生
SELECT * FROM student2 WHERE id NOT IN(1,3,5);
-- 查询english成绩大于等于77，且小于等于87的学生
SELECT * FROM student2 WHERE english >=77 AND english <=87;
SELECT * FROM student2 WHERE english BETWEEN 77 AND 87;
-- 查询英语成绩为null的学生
SELECT * FROM student2 WHERE english = NULL; 
-- null这哥们六亲不认... 
SELECT * FROM student2 WHERE english IS NULL;
SELECT * FROM student2 WHERE english IS NOT NULL;
# like模糊匹配
-- 查询姓马的学生
SELECT * FROM student2 WHERE `name` LIKE '马%';
-- 查询姓名中包含'德'字的学生 
SELECT * FROM student2 WHERE `name` LIKE '%德%';
-- 查询姓马，且姓名有三个字的学生 
SELECT * FROM student2 WHERE  `name` LIKE '马__';
总结
数据库介绍
概述
本质就是存储数据库的仓库，就是文件系统，方便管理数据

DBMS（数据库管理系统）

MySQL软件

多个仓库

多张表

多条记录（数据）
实体和表关系

一个实体对应张表
一个对象对应一条记录
常见关系型数据库

MySQL
Oracle
数据库安装和使用
登录
直接登录本机

mysql -u用户名 -p
远程指定ip

mysql -h主机名 -u用户名 -p密码
退出
exit
quit
sql介绍
概述
结构化查询语言，通过sql语句可以实现对数据库的基础操作【CRUD】

create 创建
retrieve 检索
update 更新
delete 删除
方言
sql是一套标准，所有的数据库厂商都实现了这套标准，但各自厂商在这套标准上增加自己的特有语句，这部分就称为方言

例如：mysql注释 #
sql分类
DDL

操作数据库和表

create
alter
drop
DML

操作记录的增删改

insert
update
delete
DQL

操作记录的查询

select
DCL

操作用户的权限
TCL

操作数据的事务安全
总结
DDL
操作数据库

create database 数据库名;
show databases;
drop database 数据库名;
use 数据库名;
操作表

创建表

create table 表名(

列名 数据类型,

列名 数据类型,

…..

  );

- 常用数据类型

    - int
    - double
    - decimal
    - varchar(1~65535)
    - date
    - datetime

- 查看表

    - show tables;
    - desc 表名;

- 修改表

    - alter table 表名

        - add
        - modify
        - change
        - drop
        - charset

- 修改表名

    - rename table 旧表名 to 新表名;

- 删除表

    - drop table 表名;

- 摧毁表，重构表

    - truncate table 表名;
DML
添加记录

insert into 表名(列名1,列名2…) values(值1,值2…);

字符串可以使用单双引，推荐单引号
字符串可以插入任意类型，底层进行了隐式转换
修改记录

update 表名 set 列名1=值1,列名2=值2 [where 条件]
删除记录

delete from 表名 [where 条件]
DQL
简单查询

select … from 表名
去重关键字

select distinct 列名 from 表名
ifnull()高级函数

ifnull(列名,默认值) 如果该列有值直接返回，如果为null那么返回默认值
别名

select 列名 [as] 列别名 from 表名 [as] 表别名
条件
select … from 表名 where 条件

关系运算符

逻辑运算符

and
or
not
in关键字

select … from 表名 where 列名 in(值1,值2..);
between关键字

select … from 表名 where 列名 between 较小的值 and 较大的的值
is null关键字

null 六亲不认

is null 为空
is not null 不为空
like关键字

_ 单个任意字符
% 多个任意字符
