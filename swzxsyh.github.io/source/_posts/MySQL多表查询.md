---
title: MySQL多表查询
date: 2020-04-30 01:32:27
tags:
---

一.多表查询
准备数据
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
-- 多表查询
create database day20; use day20;
-- 创建部门表(主表) 
CREATE TABLE dept (
  id INT PRIMARY KEY AUTO_INCREMENT,
  NAME VARCHAR(20)
);
INSERT INTO dept (NAME) VALUES ('开发部'),('市场部'),('财务部'),('销售部');
-- 创建员工表(从表) CREATE TABLE emp (
id INT PRIMARY KEY AUTO_INCREMENT, NAME VARCHAR(10),
gender CHAR(1), -- 性别(sex) salary DOUBLE, -- 工资
join_date DATE, -- 入职日期
dept_id INT -- 外键字段 );
INSERT INTO emp(NAME,gender,salary,join_date,dept_id) VALUES('孙悟空','男',7200,'2013-02- 24',1);
INSERT INTO emp(NAME,gender,salary,join_date,dept_id) VALUES('猪八戒','男',3600,'2010-12- 02',2);
INSERT INTO emp(NAME,gender,salary,join_date,dept_id) VALUES('唐僧','男',9000,'2008-08- 08',2);
INSERT INTO emp(NAME,gender,salary,join_date,dept_id) VALUES('白骨精','女',5000,'2015-10- 07',3);
INSERT INTO emp(NAME,gender,salary,join_date,dept_id) VALUES('蜘蛛精','女',4500,'2011-03- 14',1);
INSERT INTO emp(NAME,gender,salary,join_date,dept_id) VALUES('沙僧','男',6666,'2017-03- 04',null);
1.1 笛卡尔积
功能
多张表的记录进行组合，这种现象称为笛卡尔积(交叉连接)
语法
select … from 左表,右表;
1
2
3
-- 查询二张表
SELECT * FROM emp,dept;
SELECT COUNT(*) FROM emp,dept;
将两张表记录组合，emp个数*dept个数=笛卡尔积个数

1.2 内连接
功能
拿左表的记录去匹配由标的记录，若符合条件显示(二张表的交集)
语法
隐式内连接	select … from 左表,右表 where 连接条件;
显示内连接	select … from 左表 [inner] join 右表 on 连接条件;
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
-- 内连接
-- 隐式内连接
SELECT * FROM emp e,dept d WHERE e.dept_id = d.id;
-- 显示内连接
SELECT * FROM emp e INNER JOIN dept d ON e.dept_id = d.id;
-- 查询唐僧的 id，姓名，性别，工资和所在部门名称 
-- 1.确定查询表
SELECT * FROM emp e INNER JOIN dept d;
-- 2.确定连接条件
SELECT * FROM emp e INNER JOIN dept d ON e.dept_id = d.id;
-- 3.确定显示字段
SELECT e.id,e.name,e.gender,e.salary,d.name FROM emp e INNER JOIN dept d ON e.dept_id = d.id;
-- 4.确定业务条件
SELECT e.id,e.name,e.gender,e.salary,d.name FROM emp e INNER JOIN dept d ON e.dept_id = d.id WHERE e.name = '唐僧';
1.3 外连接
功能	语法
左外连接	展示左表全部，再去匹配右表记录，若条件符合显示，若条件不符合显示NULL	select … from 左表 left [outer] join 右表 on 连接条件;
右外连接	展示右表全部，再去匹配左表记录，若条件符合显示，若条件不符合显示NULL	select …from 左表 right [outer] join 右表 on 连接条件;
1
2
3
4
5
6
7
# 左外连接(推荐)
-- 查询所有员工信息及对应的部门名称
SELECT * FROM emp e LEFT OUTER JOIN dept d ON e.dept_id = d.id; -- 查询所有部门及对应的员工信息
SELECT * FROM dept d LEFT JOIN emp e ON e.dept_id = d.id;
# 右外连接(了解)
-- 查询所有部门及对应的员工信息
SELECT * FROM emp e RIGHT OUTER JOIN dept d ON e.dept_id = d.id;
1.4 子查询(嵌套)
功能
一条select语句执行结果，作为另一条select语法的一部分
语法
查询结果单值	SELECT MAX(salary) FROM emp;
查询结果单列多值	SELECT salary FROM emp;
查询结果多列多值	SELECT * FROM emp;
规律	语法
子查询结果为单列，肯定作为条件在where后面使用	select … from 表名 where 字段 in (子查询);
子查询结果为多列，一般作为虚拟表在from后面使用	select … from (子查询) as 表别名;
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
# 子查询
# 子查询结果为单值
-- 1 查询工资最高的员工是谁?
SELECT * FROM emp WHERE salary = (SELECT MAX(salary) FROM emp); 
-- 2 查询工资小于平均工资的员工有哪些?
-- 2.1 先求出平均工资
SELECT AVG(salary) FROM emp;
-- 2.2 查询低于平均工资的员工
SELECT * FROM emp WHERE salary < (SELECT AVG(salary) FROM emp);
# 子查询结果为单列多行
-- 1 查询工资大于5000的员工，来自于哪些部门的名字
-- 1.1 查询工资大于5000的员工
SELECT dept_id FROM emp WHERE salary >5000;
-- 1.2 来自于哪些部门的名字
SELECT * FROM dept WHERE id IN(SELECT dept_id FROM emp WHERE salary >5000);
-- 2 查询开发部与财务部所有的员工信息
-- 2.1 根据部门名称，查询部门主键
SELECT id FROM dept WHERE `name` IN('开发部','财务部');
-- 2.2 根据部门id查询员工信息
SELECT * FROM emp WHERE dept_id IN (SELECT id FROM dept WHERE `name` IN('开发部','财务部'));
# 子查询结果为多列多行
-- 1 查询出`dept`，包括部门名称
-- 方案一
-- 1.1 查询出2011年以后入职的员工信息
SELECT * FROM emp WHERE join_date > '2011-1-1';
-- 1.2 通过临时表跟部门表关联
SELECT * FROM (SELECT * FROM emp WHERE join_date > '2011-1-1') e LEFT JOIN dept d ON e.dept_id = d.id;
-- 方案二
-- 1.1 先实现二张表关联
SELECT * FROM emp e LEFT OUTER JOIN dept d ON e.dept_id = d.id;
-- 1.2 再过滤2011年以后入职的
SELECT * FROM emp e LEFT OUTER JOIN dept d ON e.dept_id = d.id WHERE e.join_date > '2011-1- 1';
二.多表案例
准备数据
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
-- 1 查询所有员工信息。显示员工编号，员工姓名，工资，职务名称，职务描述 
-- 1.1 确定几张表?
SELECT * FROM emp e INNER JOIN job j;
-- 1.2 确定连接条件
SELECT * FROM emp e INNER JOIN job j ON e.job_id = j.id;
-- 1.3 确定显示字段(列)
SELECT e.id,e.ename,e.salary,j.jname,j.description FROM emp e INNER JOIN job j ON e.job_id = j.id;

-- 2 查询所有员工信息。显示员工编号，员工姓名，工资，职务名称，职务描述，部门名称，部门位置 
-- 2.1 确定几张表?
SELECT * FROM emp e
    INNER JOIN job j
    INNER JOIN dept d;
-- 2.2 确定连接条件 
SELECT * FROM emp e
INNER JOIN job j ON e.job_id = j.id INNER JOIN dept d ON e.dept_id = d.id;

-- 2.3 确定显示字段
SELECT e.id,e.ename,e.salary,j.jname,j.description,d.dname,d.loc FROM emp e
INNER JOIN job j ON e.job_id = j.id INNER JOIN dept d ON e.dept_id = d.id;

-- 3 查询所有员工信息。显示员工姓名，工资，职务名称，职务描述，部门名称，部门位置，工资等级 
-- 3.1 确定几张表
SELECT * FROM emp e
    INNER JOIN job j
    INNER JOIN dept d
    INNER JOIN salarygrade sg;
-- 3.2 确定连接条件 SELECT * FROM emp e
INNER JOIN job j ON e.job_id = j.id
INNER JOIN dept d ON e.dept_id = d.id
INNER JOIN salarygrade sg ON e.salary BETWEEN sg.losalary AND sg.hisalary;
-- 3.3 确定显示字段
SELECT e.ename,e.salary,j.jname,j.description,d.dname,d.loc,sg.grade FROM emp e
INNER JOIN job j ON e.job_id = j.id
INNER JOIN dept d ON e.dept_id = d.id
INNER JOIN salarygrade sg ON e.salary BETWEEN sg.losalary AND sg.hisalary;

-- 4 查询经理的信息。显示员工姓名，工资，职务名称，职务描述，部门名称，部门位置，工资等级
-- 直接将第三题代码粘过来
SELECT e.ename,e.salary,j.jname,j.description,d.dname,d.loc,sg.grade FROM emp e
INNER JOIN job j ON e.job_id = j.id
INNER JOIN dept d ON e.dept_id = d.id
INNER JOIN salarygrade sg ON e.salary BETWEEN sg.losalary AND sg.hisalary WHERE j.jname = '经理';

-- 5 查询出部门编号、部门名称、部门位置、部门人数 (这个代码至少要敲三遍) 
-- 5.1 查询出部门编号、部门名称、部门位置
SELECT * FROM dept;
-- 5.2 部门人数(员工表:分组+聚合 )
SELECT dept_id,COUNT(*) AS total FROM emp GROUP BY dept_id; 
-- 5.3 部门表左外关联临时表
SELECT d.id,d.dname,d.loc,e.total FROM dept d
LEFT JOIN (SELECT dept_id,COUNT(*) AS total FROM emp GROUP BY dept_id) e ON d.id = e.dept_id;

-- 6 查询每个员工的名称及其上级领导的名称(自关联) SELECT
yuangong.id, yuangong.ename, lingdao.id, lingdao.ename
FROM
  emp yuangong
  LEFT OUTER JOIN emp lingdao
ON yuangong.mgr = lingdao.id ;
多表查询会产生笛卡尔积
消除笛卡尔积
连接条件 = 表个数-1
步骤
1)确定几张表
2)确定连接条件
3)确定显示字段
4)确定业务条件

三.用户权限 DCL
语法	注意
创建用户	create user ‘用户名‘@’主机名’ identified by ‘密码’;	主机名:限定客户端登录ip
指定ip:127.0.0.1 (localhost)
任意ip:%
授权用户	grant 权限1,权限2… on 数据库名.表名 to ‘用户名‘@’主机名’;	权限: select、insert、delete、update、create…
all 所有权限
数据库名.* 指定库下面所有的表
查看权限	show grants for ‘用户名‘@’主机名’;	
撤销授权	revoke 权限1,权限2… on 数据库名.表名 from ‘用户名‘@’主机名’;	权限: select、insert、delete、update、create…
all 所有权限
数据库名.* 指定库下面所有的表
删除用户	drop user ‘用户名‘@’主机名’;	
密码管理	超级管理员set password for ‘用户名‘@’主机名’=password(‘新密码’);
普通用户set password=password(‘新密码’);	
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
-- 创建用户
CREATE USER 'tom'@'%' IDENTIFIED BY '123';
-- 授权
GRANT SELECT ON day20.dept TO 'tom'@'%' ;
-- 查看权限
SHOW GRANTS FOR 'tom'@'%' ;
-- 撤销权限
REVOKE SELECT ON day20.dept FROM 'tom'@'%' ;
-- 密码管理 -- 加密函数
SELECT PASSWORD('123'); -- 超级管理帮你找回密码
SET PASSWORD FOR 'tom'@'%'= PASSWORD('999');
-- 删除用户
DROP USER 'tom'@'%' ;
四.数据库备份与还原
备份	还原
格式	mysqldump -u用户名 -p 需要备份数据库名 > 导出路径(*.sql)	mysql -u用户名 -p < 导入路径(*.sql)
实例	mysqldump -uroot -p day20_pro > d:bak.sql	mysql -uroot -p < d:bak.sql
缺点	通过命令备份的只有表结构和数据，没有建库语句	
总结
一 多表查询
笛卡尔积
多表中每一条记录的进行组合，又称为交叉连接
内连接
查询二张表的交集部分

语法

隐式内连接

select … from 左表,右表 where 连接条件;
显示内连接

select … from 左表 inner join 右表 on 连接条件;
外连接
左外连接

查询左表全部，再去匹配右表，有就显示，没有显示null

语法

select … from 左表 left outer join 右表 on 连接条件;
右外连接

子查询
子查询结果为单值

子查询结果为单列多行

子查询结果为多列多行

规律

子查询结果只要为单列，肯定在where后作为条件使用
子查询结果只要为多列，一般在from后作为虚拟表使用
二 多表案例
规律
1。确定几张表

2。确定连接条件

on关键字
3。确定显示字段

4。确定业务条件

where关键字
三 DCL用户权限
创建用户
create user ‘用户名‘@’主机名’ identifield by ‘密码’
授予权限
grant 权限1,权限2…. on 数据库.表名 to ‘用户名‘@’主机名’
查看权限
show grants for ‘用户名‘@’主机名’
撤销权限
revoke 权限1,权限2… on 数据库.表名 from ‘用户名‘@’主机名’
删除用户
drop user ‘用户名‘@’主机名’
密码管理
set password for ‘用户名‘@’主机名’=password(‘新密码’);
四 数据库还原与备份
dos命令行