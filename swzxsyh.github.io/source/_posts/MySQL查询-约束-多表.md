---
title: MySQL查询 & 约束 & 多表
date: 2020-04-29 01:31:57
tags:
---

一.DQL高级查询
创建表
1.1 排序
语法:
1
2
select ... from 表名 order by 排序列 [asc|desc],排序列 [asc|dex]
asc:升序 (默认值) desc:降序
注意:
多字段排序，后面的排序结果是在前面排序的基础之上
1
2
3
4
-- 查询所有数据,使用年龄降序排序
select * from Day44.student order by age desc;
-- 查询所有数据,在年龄降序排序的基础上，如果年龄相同再以数学成绩降序排序
SELECT * FROM student ORDER BY  age DESC,math DESC ;
1.2 聚合函数
作用:对一列数据进行计算，返回一个结果，忽略null值
语法:
关键字	说明
count(列名)	统计一列个数
max(列名)	求出一列的最大值
min(列名)	求出一列的最小值
sum(列名)	对一列求和
avg(列名)	求出一列的平均值
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
# 聚合函数
-- 查询学生总数（null值处理）
SELECT COUNT(id) FROM student;
SELECT COUNT(isnull(english)) FROM student;
SELECT COUNT(*) FROM student;
-- 查询年龄大于40的总数
SELECT COUNT(*) FROM student WHERE age>40;

-- 查询数学成绩总分
SELECT SUM(math) FROM student;
-- 查询数学成绩平均分
SELECT AVG(math) FROM student;
-- 查询数学成绩最高分
SELECT MAX(math) FROM student;

-- 查询数学成绩最低分
SELECT MIN(math) FROM student;
1.3 分组
作用:对一列数据进行分组，相同的内容分为一组，通常与聚合函数一起使用，完成统计工作
语法:
1
select 分组列 from 表名 group by 分组列 having 分组后的过滤条件;
where和having区别
where在分组前进行条件过滤，不支持聚合函数 having在分组后今天条件过滤，支持聚合函数
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
# 分组
-- 按性别分组
SELECT sex FROM student GROUP BY sex;

-- 查询男女各多少人
SELECT sex,COUNT(*) FROM student GROUP BY sex;

-- 查询年龄大于25岁的人,按性别分组,统计每组的人数
SELECT sex,COUNT(*) FROM student WHERE age>25 GROUP BY sex;

-- 查询年龄大于25岁的人,按性别分组,统计每组的人数,并只显示性别人数大于2的数据
SELECT sex,COUNT(*) FROM student WHERE age>25 GROUP BY sex having COUNT(*)>2;
1.4 分页
语法:
1
select ... from 表名 limit 开始索引,每页显示个数;
索引特点:
索引是从0开始，0也是默认值，可以省略
分页索引公式:
索引 = (当前页-1) × 每页个数
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
# 分页
-- 查询学生表中数据，显示前6条
SELECT * FROM student LIMIT 0,6;
SELECT * FROM student LIMIT 6;

-- 查询学生表中数据，从第三条开始显示，显示6条
SELECT * FROM student LIMIT 2,6;

-- 模拟百度分页，一页显示5条
SELECT * FROM student LIMIT 5;
SELECT * FROM student LIMIT 5,5;
SELECT * FROM student LIMIT 10,5;
1.5 知识小结
1
select * from 表名 where 条件 group by 分组 having 分组后条件 order by 排序 limit 分页;
二.数据库约束
2.1 概述
作用
对表中的数据进行限定，保证数据的正确性、有效性和完整性。
关键字	说明
primary key	主键约束。要求表中有一个字段 唯一 且 非空，通常我们使用id作为主键
unique	唯一约束
not null	非空约束
default	默认值
foreign key	外键约束
2.2 实现
2.2.1 主键约束
作用:限定某一列的值非空且唯一， 主键就是表中记录的唯一标识。
设置主键约束
1)创建表
1
2
3
4
create table 表名(
id int primary key, ...
...
);
2)已有表
1
alter tabe 表名 add primary key(id);
特点: 一张表只能有一个主键约束，但是我们可以设置联合主键(多个字段)
自增器
1)创建表
1
2
3
4
create table 表名(
id int priamry key auto_increment, ...
...
);
2)特点:自增器起始值为1，可以手动指定
1
alter table 表名 auto_increment=起始值;
删除主键约束
语法:
1
alter table 表名 drop primary key;
1
2
3
4
5
# 1)先移出自增器
alter table stu3 modify id int;
# 2)才能删除主键约束
alter table stu3 drop primary key;
# 解释:因为只有主键约束才有意义设置自增器...(保证唯一性....)
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
-- 主键约束
-- 给student表添加主键约束
ALTER TABLE student ADD PRIMARY KEY(id);
-- 创建表时指定主键约束 
CREATE TABLE stu1(
id INT PRIMARY KEY, 
`name` VARCHAR(32)
);
-- 插入数据测试
INSERT INTO stu1 VALUES(1,'jack');
-- Duplicate entry '1' for key 'PRIMARY' 错误:主键不能重复 
INSERT INTO stu1 VALUES(1,'lucy');
-- Column 'id' cannot be null 错误:主键不能为空
INSERT INTO stu1 VALUES(NULL,'lucy');
-- 我想让name字段，也作为主键使用...
-- Multiple primary key defined -- 错误:主键被重复定义了 
ALTER TABLE stu1 ADD PRIMARY KEY(`name`);


-- 联合主键(主键字段完全相同，在进行约束的限定) CREATE TABLE stu2(
id INT ,
`name` VARCHAR(32), 
PRIMARY KEY(id,`name`)
);
-- 插入数据测试
INSERT INTO stu2 VALUES(1,'jack');
INSERT INTO stu2 VALUES(1,'lucy');
-- Duplicate entry '1-lucy' for key 'PRIMARY' 错误 
INSERT INTO stu2 VALUES(1,'lucy');


-- 自增器
CREATE TABLE stu3(
id INT PRIMARY KEY AUTO_INCREMENT, 
`name` VARCHAR(32)
);
-- 插入数据测试
INSERT INTO stu3 VALUES(1,'jack'); 
INSERT INTO stu3 VALUES(NULL,'jack'); 
INSERT INTO stu3 VALUES(3,'jack'); 
INSERT INTO stu3 VALUES(NULL,'jack'); 
INSERT INTO stu3 VALUES(10,'jack'); 
INSERT INTO stu3 VALUES(NULL,'jack');
-- 设置自增器起始值
ALTER TABLE stu3 AUTO_INCREMENT=1000;
INSERT INTO stu3 VALUES(NULL,'jack');

-- delete(橡皮擦) 和 truncat(撕纸) 区别 
DELETE FROM stu3;
INSERT INTO stu3 VALUES(NULL,'jack');
TRUNCATE TABLE stu3;
INSERT INTO stu3 VALUES(NULL,'jack');

-- 1)先移出自增器
ALTER TABLE stu3 MODIFY id INT;
-- 2)才能删除主键约束
ALTER TABLE stu3 DROP PRIMARY KEY;
2.2.2 唯一约束
作用:限定某一列的值不能重复，可以出现多个null
创建表时设置唯一约束
1
2
3
4
create table 表名(
列名 数据类型 unique, ...
...
);
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
-- 唯一约束
CREATE TABLE stu4(
id INT PRIMARY KEY AUTO_INCREMENT, 
`name` VARCHAR(32) UNIQUE
);
INSERT INTO stu4 VALUES(1,'jack');
-- Duplicate entry 'jack' for key 'name' 错误:名称重复了 
INSERT INTO stu4 VALUES(2,'jack');
INSERT INTO stu4 VALUES(3,NULL);
INSERT INTO stu4 VALUES(4,NULL);

-- 删除唯一约束
ALTER TABLE stu4 DROP INDEX name;

-- 创建表后添加唯一约束
ALTER TABLE stu4 MODIFY name VARCHAR(20) UNIQUE ;
2.2.3 非空约束
作用:限定某一列的值不能为null
创建表时设置非空约束
1
2
3
4
create table 表名(
列名 数据类型 not null,-- 非空约束
列名 数据类型 unique not null,-- (唯一+非空)
);
注意:唯一 + 非空 != 主键，主键约束一张表只能有一个，唯一+非空 设置多个

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
-- 唯一+非空
CREATE TABLE stu5(
id INT PRIMARY KEY AUTO_INCREMENT, 
`name` VARCHAR(32) UNIQUE NOT NULL
);
INSERT INTO stu5 VALUES(1,'jack');
-- Column 'name' cannot be null 错误:名称不能为空 
INSERT INTO stu5 VALUES(2,NULL);

-- 移除非空约束
ALTER TABLE stu5 MODIFY name VARCHAR(20);
-- 恢复
ALTER TABLE stu5 MODIFY name VARCHAR(20) NOT NULL;

2.2.4 默认值
创建表设置默认值
1
2
3
4
create table 表名(
列名 数据类型 default 默认值, ...
...
);
1
2
3
4
5
6
7
8
-- 默认值
CREATE TABLE stu6(
id INT PRIMARY KEY AUTO_INCREMENT, `name` VARCHAR(32),
sex VARCHAR(5) DEFAULT '男'
);
INSERT INTO stu6(id,`name`) VALUES(1,'小张');
INSERT INTO stu6(id,`name`,sex) VALUES(2,'小刘','女'); -- 因为我们指定了默认值为男，你再插入null，会把默认值覆盖... 
INSERT INTO stu6 VALUES(3,'小王',NULL);
三.表关系
3.1 概述
简称:关系型数据库(Relation DBMS)
3.2 实现
3.2.1 一对多
在多的一方建立外键，指向一的一方的主键
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
-- 创建新库
CREATE DATABASE day19_pro; USE day19_pro;
-- 一对多
-- 班级表(主表) 
CREATE TABLE class(
id INT PRIMARY KEY AUTO_INCREMENT, 
`name` VARCHAR(32)
);
INSERT INTO class VALUES(1,'java一班'); 
INSERT INTO class VALUES(2,'java二班');
-- 学生表(从表) 
CREATE TABLE student(
id INT PRIMARY KEY AUTO_INCREMENT, 
`name` VARCHAR(32),
class_id INT -- 外键字段
);
INSERT INTO student VALUES(1,'流川枫',1); 
INSERT INTO student VALUES(2,'樱木花道',1); 
INSERT INTO student VALUES(3,'大猩猩',2); 
INSERT INTO student VALUES(4,'赤木晴子',2);
-- 通过班级找学生
SELECT * FROM student WHERE class_id =1;
-- 通过学生找班级
SELECT * FROM class WHERE id = 2;
-- 给学生表添加外键约束
ALTER TABLE student ADD CONSTRAINT class_id_fk FOREIGN KEY(class_id) REFERENCES class(id);
-- 删除学生表的外键约束
ALTER TABLE student DROP FOREIGN KEY class_id_fk;
3.2.2 多对多
多对多关系实现需要借助第三张表。中间表至少包含2个字段，这两个字段作为第三张表的外键，分别指向两张表的主键
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
-- 多对多
-- 课程表(主表) 
CREATE TABLE course(
id INT PRIMARY KEY AUTO_INCREMENT, 
`name` VARCHAR(32)
);
INSERT INTO course VALUES(1,'java'); 
INSERT INTO course VALUES(2,'ui'); 
INSERT INTO course VALUES(3,'美容美发'); 
INSERT INTO course VALUES(4,'挖掘机'); 
-- 中间表(从表)
CREATE TABLE sc(
  s_id INT,
  c_id INT,
  PRIMARY KEY(s_id,c_id)
);
INSERT INTO sc VALUES(1,1);
INSERT INTO sc VALUES(1,2);
INSERT INTO sc VALUES(2,1);
INSERT INTO sc VALUES(2,3);
-- 联合主键，可以帮我们校验重复选修问题 
INSERT INTO sc VALUES(1,1);
-- 给中间表增加外键约束
ALTER TABLE sc ADD CONSTRAINT s_id_fk FOREIGN KEY(s_id) REFERENCES student(id); 
ALTER TABLE sc ADD CONSTRAINT c_id_fk FOREIGN KEY(c_id) REFERENCES course(id);
-- 流川枫不能选修，不存在的课程 
INSERT INTO sc VALUES(1,6);
3.2.3 一对一
一对一关系实现，可以在任意一方添加唯一外键指向另一方的主键
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
-- 一对一
-- 公司表
CREATE TABLE company(
id INT PRIMARY KEY AUTO_INCREMENT, 
`name` VARCHAR(32)
);
INSERT INTO company VALUES(1,'拼多多'); 
INSERT INTO company VALUES(2,'传智播客'); 
-- 地址表
CREATE TABLE address(
id INT PRIMARY KEY AUTO_INCREMENT, -- 同时也作为外键 
`name` VARCHAR(32),
CONSTRAINT id_fk FOREIGN KEY(id) REFERENCES company(id)
);
INSERT INTO address VALUES(1,'上海'); 
INSERT INTO address VALUES(2,'江苏沭阳');
3.3 外键约束
作用:限定二张表有关系的数据，保证数据的正确性、有效性和完整性
在从表中添加外键约束
1)创建表
1
2
create table 表名( 列名 数据类型,
[constraint] [约束名] foreign key(外键列) references 主表(主键) );
2)已有表
1
alter table 表名 add [constraint] [约束名] foreign key(外键列) references 主表(主键);
外键约束特点
1)主表不能删除从表已引用的数据
2)从表不能添加主表未拥有的数据
3)先添加主表数据再添加从表数据
4)先删除从表数据再删除主表数据
5)外键约束允许为空但不能是错的
删除外键约束
1
alter table 表名 drop foreign key 约束名;
总结
dql单表高级查询
排序
select … from 表名 order by 排序列 [asc | desc]

asc 升序 默认值
desc 降序
聚合函数
count

count(*) ，统计包含null数据
max

min

sum

avg

分组
select 分组 表名 group by 分组 having 分组后条件

where在分组前条件过滤，不能使用聚合函数
having在分组后条件过滤，可以使用聚合函数
分页
select … from 表名 limit 开始索引,每页显示个数

索引公式：

索引= （当前页-1）× 每页显示个数
数据库约束
对数据进一步限定，保证数据的正确性，有效性和完整性
分类
1）主键

primary key

给每一条记录增加唯一标识，非空且唯一
2）唯一

unique
3）非空

not null
4）默认值

default
5）外键

foreign key
创建表时候设置主键约束
create table 表名(

id int primary key auto_increment,

…

..

);

表关系
一对多
应用场景

班级和学生
部门和员工
实例

一个班级下面有多名学生，多名学生属于同一个班级
建表原则

在从表中添加一个字段（列），字段名（主表名_id）类型与主表的主键一致，这个字段称为外键，通过外键指向主表的主键，建立关联关系
多对多
应用场景

老师和学生
学生和课程
实例

一个学生可以选修多门课程，一门课程可以被多个学生选修
建表原则

多对多其实由二个一对多组成
需要借助于第三张表（中间表），需要有二个外键字段分别指向各自的主键，通常还会作为联合主键
一对一
应用场景

公民和身份证号
公司和注册地
实例

一个公民只能有一个身份证号，一个身份证号只能属于一个公民
建表原则

主键是外键