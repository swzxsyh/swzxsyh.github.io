---
title: MySQL函数 & 事务
date: 2020-05-04 01:34:03
tags:
---

一.MySQL函数
1.1 字符串函数
函数	描述	实例
CONCAT(s1,s2…sn)	字符串 s1,s2 等多个字符串合并为一个字符串	select concat(‘A’,’-‘,’B’);
CHAR_LENGTH(str)	返回字符串 str 的字符数	select char_length(‘Hello，World’);
LENGTH(str)	返回字符串 s 的字节数	select length(‘你好,World’);
UCASE(s) | UPPER(s)	将字符串转换为大写	select ucase(‘oracle’);
LCASE(s) | LOWER(s)	将字符串转换为小写	select lcase(‘MySQL’);
LOCATE(s1,s)	从字符串 s 中获取 s1 的开始位置	select locate(‘wo’,’world’);
TRIM(str) | LTRIM(str) | RTRIM(str)	字符串去空格	select trim(‘ 莘莘学子 ‘);
REPLACE(s,s1,s2)	将字符串 s2 替代字符串 s 中的字符串 s1	select replace(‘abc’,’b’,’x’);
SUBSTR(s, start, length)	从字符串 s 的 start 位置截取长度为 length 的子字符串	select substr(‘itcast’,’2’,’3’);
STRCMP(str1,str2)	比较字符串大小,左大于右时返回1，左等于右时返回0，，左小于于右时返回-1，	select strcmp(‘a’,’b’);
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
-- 1.将所有员工的昵称改为大写
SELECT UCASE(nickname) FROM emp;
-- 2.显示所有员工的姓氏，截取
SELECT ename,SUBSTR(ename,1,1) FROM emp;
-- 3.显示所有员工姓名字符长度
SELECT CHAR_LENGTH(ename) FROM emp;
-- 4.显示所有员工姓名字节长度 SELECT LENGTH(ename) FROM emp;
-- 5.将所有姓李的员工，姓氏替换为li
SELECT REPLACE(ename,'李','li') FROM emp;
-- 6.将所有员工的姓名和昵称拼接在一起
SELECT CONCAT(ename,nickname) FROM emp;
1.2 日期函数
函数	描述	实例
NOW() | CURDATE() | CURTIME()	获取系统当前日期时间、日期、时间	select now();
YEAR(DATE) | MONTH(DATE) | DAY(DATE)	从日期中选择出年、月、日	select year(now());
LAST_DAY(DATE)	返回月份的最后一天	select last_day(now());
ADDDATE(DATE,n) | SUBDATE(DATE,n)	计算起始日期 DATE 加(减) n 天的日期	select subdate(now(),10);
QUARTER(DATE)	返回日期 DATE 是第几季节，返回 1 到 4	select quarter(now());
DATEDIFF(d1,d2)	计算日期 d1->d2 之间相隔的天数	select datediff(now(),’1999-1-1’);
DATE_FORMAT(d,f)	按表达式 f的要求显示日期 d	select date_format(now(),’%Y-%m-%d’);
练习
1
2
3
4
5
6
7
8
-- 1.统计每个员工入职的天数
SELECT ename,DATEDIFF(NOW(),joindate) FROM emp;
-- 2.统计每个员工的工龄
SELECT ename,DATEDIFF(NOW(),joindate)/365 FROM emp;
-- 3.查询2011年入职的员工
SELECT * FROM emp WHERE YEAR(joindate) = '2011';
-- 4.统计入职10年以上的员工信息
SELECT * FROM emp WHERE DATEDIFF(NOW(),joindate)/365 >10;
1.3 数字函数
函数	描述	实例
ABS(x)	返回 x 的绝对值	select abs(-10);
CEIL(x)|FLOOR(x)	向上(下)取整	select ceil(1.5);
MOD(x,y)	返回x mod y的结果，取余	select mod(5,4);
RAND()	返回 0 到 1 的随机数	select rand();
ROUND(x)	四舍五入	select round(1.2345);
TRUNCATE(x,y)	返回数值 x 保留到小数点后 y 位的值	select truncate(5633.123324,2);
练习
1
2
3
4
5
6
7
8
-- 1.统计每个员工的工龄，超过半年的算一年
SELECT ename,ROUND( DATEDIFF(NOW(),joindate)/365) FROM emp;
-- 2.统计每个部门的平均薪资,保留2位小数
SELECT dept_id,TRUNCATE( AVG(salary),2 )FROM emp GROUP BY dept_id;
-- 3.统计每个部门的平均薪资,小数向上取整
SELECT dept_id,CEIL( AVG(salary) )FROM emp GROUP BY dept_id;
-- 4.统计每个部门的平均薪资,小数向下取整
SELECT dept_id,FLOOR( AVG(salary) )FROM emp GROUP BY dept_id;
1.4 高级函数
1.4.1 CASE表达式
相当于java中swtich语句

语法

1
2
3
4
5
6
7
8
SELECT
CASE [字段,值] WHEN 判断条件1
THEN 希望的到的值1 WHEN 判断条件2
THEN 希望的到的值2
ELSE 前面条件都没有满足情况下得到的值
END
FROM
table_name;
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
-- 查询每个员工的工资等级并排序
-- 工资等级在1显示为 '努力赚钱'
-- 工资等级在2显示为 '小康生活'
-- 工资等级在3显示为 '可以娶媳妇'
-- 工资等级在4显示为 '可以买车'
-- 工资等级在5显示为 '可以买房'
-- 工资等级不在以上列表中显示为 '土豪'
-- 1.确定几张表
SELECT * FROM emp e INNER JOIN salarygrade sg;
-- 2.确定连接条件
SELECT * FROM emp e INNER JOIN salarygrade sg ON e.`salary` BETWEEN sg.`losalary` AND sg.`hisalary`;
-- 3.确定显示字段
SELECT e.ename,e.`salary`,sg.`grade` FROM emp e INNER JOIN salarygrade sg ON e.`salary` BETWEEN sg.`losalary` AND sg.`hisalary`;
-- 4.确定业务条件
SELECT e.ename,e.`salary`,
CASE sg.`grade` WHEN 1 THEN WHEN 2 THEN WHEN 3 THEN WHEN 4 THEN WHEN 5 THEN
ELSE '土豪' END AS '生活状态'
'努力赚钱' '小康生活' '可以娶媳妇' '可以买车' '可以买房'
FROM emp e INNER JOIN salarygrade sg ON e.`salary` BETWEEN sg.`losalary` AND sg.`hisalary` ORDER BY sg.`grade` ASC;
1.4.2 IF表达式
相当于java中三元运算符

语法

1
SELECT IF(1 > 0,'真','假') from 表名;
练习

1
2
-- 工资+奖金大于20000的员工 显示家有娇妻，否则显示单身狗
SELECT ename,IF(salary+IFNULL(bonus,0) > 20000,'家有娇妻','单身狗') AS 家里有啥 FROM emp;
二.MySQL综合练习
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
-- 1.计算员工的日薪(按30天)，保留二位小数
SELECT ename,TRUNCATE(salary/30,2) FROM emp;
-- 2.计算出员工的年薪(12月)，并且以年薪排序 降序
SELECT ename,(salary + IFNULL(bonus,0)) * 12 AS 年薪 FROM emp ORDER BY 年薪 DESC;
-- 3.找出奖金少于5000或者没有获得奖金的员工的信息 
SELECT * FROM emp WHERE IFNULL(bonus,0) < 5000;

-- 4.返回员工职务名称及其从事此职务的最低工资 
-- 4.1 确定几张表
SELECT * FROM emp e INNER JOIN job j; 
-- 4.2 确定连接条件
SELECT * FROM emp e INNER JOIN job j ON e.`job_id` = j.`id`;
-- 4.3 确定显示字段
SELECT j.`jname` FROM emp e INNER JOIN job j ON e.`job_id` = j.`id`;
-- 4.4 确定业务条件(分组+最低工资)
SELECT j.`jname`,MIN(e.`salary`) FROM emp e INNER JOIN job j ON e.`job_id` = j.`id` GROUP BY j.`jname`;

-- 5.返回工龄超过10年，且2月份入职的员工信息
SELECT * FROM emp WHERE DATEDIFF(NOW(),joindate)/365 > 10 AND MONTH(joindate) = 2;
-- 6.返回与 林冲 同一年入职的员工
SELECT YEAR(joindate) FROM emp WHERE ename = '林冲';
SELECT * FROM emp WHERE YEAR(joindate) = (SELECT YEAR(joindate) FROM emp WHERE ename = '林 冲');
-- 7.返回每个员工的名称及其上级领导的名称(自关联)
SELECT a.`ename`,b.`ename` FROM emp a LEFT OUTER JOIN emp b ON a.`mgr` = b.`id`;

-- 8.返回工资为二等级(工资等级表)的职员名字(员工表)、部门名称(部门表) 
-- 8.1 确定几张表
SELECT * FROM emp e
    INNER JOIN dept d
INNER JOIN salarygrade sg; 
-- 8.2 确定连接条件
SELECT * FROM emp e
INNER JOIN dept d ON e.`dept_id` = d.`id`
INNER JOIN salarygrade sg ON e.`salary` BETWEEN sg.`losalary` AND sg.`hisalary`;
-- 8.3 确定显示字段
SELECT sg.`grade`,e.`ename`,d.`dname` FROM emp e
INNER JOIN dept d ON e.`dept_id` = d.`id`
INNER JOIN salarygrade sg ON e.`salary` BETWEEN sg.`losalary` AND sg.`hisalary`;
-- 8.4 确定业务条件
SELECT sg.`grade`,e.`ename`,d.`dname` FROM emp e
INNER JOIN dept d ON e.`dept_id` = d.`id`
INNER JOIN salarygrade sg ON e.`salary` BETWEEN sg.`losalary` AND sg.`hisalary` WHERE sg.`grade` = 2;

-- 9.涨工资:董事长2000 经理1500 其他800
-- 9.1
SELECT
-- 9.2
SELECT
确定几张表和连接条件
* FROM emp e INNER JOIN job j ON e.`job_id` = j.`id`; 显示字段(case表达式)
e.`ename`,j.`jname`,e.`salary` AS 涨前,
CASE j.`jname`
WHEN '董事长' THEN e.salary + 2000 WHEN '经理' THEN e.salary + 1500 ELSE e.salary + 800
END AS 涨后
FROM emp e INNER JOIN job j ON e.`job_id` = j.`id`;

三.事务安全 TCL
3.1 概述
如果一个包含多个步骤的业务操作，被事务管理，那么这些操作要么同时成功，要么同时失败。

应用场景:用户转账

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
-- 创建库
create database day46_pro;
-- 使用库
use day46_pro;
-- 创建数据表
CREATE TABLE account ( -- 账户表
id INT PRIMARY KEY AUTO_INCREMENT, `name` VARCHAR(32),
money DOUBLE
);
-- 添加数据
INSERT INTO account (`name`, money) VALUES ('蝴蝶姐', 1000), ('罗志祥', 1000);
模拟转账
1
2
3
4
5
-- 罗志祥扣钱(转出)
UPDATE account SET money = money -100 WHERE id = 2;
-- 机器故障了
-- 蝴蝶姐加强(转入)
UPDATE account SET money = money + 100 WHERE id = 1;
3.2 操作事务
3.2.1 手动提交事务
开启事务 begin

提交事务 commit

回滚事务 rollback

转账成功
1
2
3
4
5
6
7
-- 1. 开启事务 begin;
-- 2. 罗志祥扣钱
UPDATE account SET money = money -100 WHERE id = 2;
-- 3. 蝴蝶姐加钱
UPDATE account SET money = money + 100 WHERE id = 1;
-- 4. 提交事务 
commit;
转账失败
1
2
3
4
5
6
-- 1.开启事务 begin;
-- 2.罗志祥扣钱
UPDATE account SET money = money -100 WHERE id = 2;
-- 3.机器故障
-- 4.回滚事务 
rollback;
3.2.2 自动提交事务
默认情况下，在MySQL中每一条DML(增删改)语句，就是一个独立的事务

查看MySQL是否开启自动提交

1
show variables like 'autocommit';
临时关闭自动提交(手动)

1
set autocommit=off;
3.3 事务工作原理
注意:
在同一个事务中，出现bug(异常)，必须执行rollback命令，不然会影响同一个事务中下一次提交

3.4 保存(回滚)点
当事务开启后，一部分sql执行成功，添加一个保存点，后续操作报错了，回滚到保存点，保证之前的操作可以成功提交

设置保存点	savepoint 保存点名;
回滚到保存点	rollback to 保存点名;
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
-- 1.开启事务 begin;
-- 2.罗志祥扣钱一次(凤姐)
UPDATE account SET money = money -100 WHERE id = 2;
-- 3.罗志祥扣钱二次(芙蓉姐姐)
UPDATE account SET money = money -100 WHERE id = 2;
-- 4.设置一个保存点 savepoint ol;
-- 5.罗志祥扣钱三次(石榴姐)
UPDATE account SET money = money -100 WHERE id = 2;
-- 6.机器故障
-- 7.回滚点保存点 rollback to ol;
-- 8.提交事务 commit;
3.5 事务特性 ACID
原子性 A atomicity

如果一个包含多个步骤的业务操作，被事务管理，那么这些操作要么同时成功，要么同时失败。

一致性 C consistency

事务在执行前后，保证数据的一致性

隔离性 I isolation

多个事务之间，相互独立，互不干扰….

持久性 D durability

事务一旦成功提交，保存到磁盘文件，不可逆….

3.6 事务隔离性
多个事务之间隔离的，相互独立的。但是如果多个事务操作同一批数据，则会引发一些问题，设置不同的隔离级别就

可以解决这些问题。

脏读【必须要避免】

一个事务中，读取到另一个事务，未提交的数据

不可重复读

一个事务中，二次读取的内容不一致，另外一个事务做了update操作

幻读
一个事务中，二次读取的数量不一致，另外一个事务做了insert、delete操作

3.6.1 MySQL数据库隔离级别
级别	名字	隔离级别	脏读	不可重复读	幻读	数据库默认隔离级别
1	读未提交	read uncommitted	是	是	是	
2	读已提交	read committed	否	是	是	Oracle和SQL Server
3	可重复读	repeatable read	否	否	是	MySQL
4	串行化	serializable	否	否	否	
性能角度:1>2>3>4

安全角度:4>3>2>1

综合考虑:2 or 3

3.6.2 演示隔离级别产生的问题
级别	代码
查看当前数据库隔离级别	show variables like ‘%isolation%’;
临时修改隔离级别	set session transaction isolation level 级别字符串;
演示脏读
设置数据库隔离级别 read uncommitted;
1
set session transaction isolation level read uncommitted;
解决脏读问题(引出:不可重复读问题) 设置数据库隔离级别 read committed;
1
set session transaction isolation level read committed;
解决不可重复读问题(出现幻读问题) 设置数据库隔离级别 repeatable read;
1
set session transaction isolation level repeatable read;
解决幻读问题
设置数据库隔离级别 serializable;
1
set session transaction isolation level serializable;
总结
一 MySQL函数
字符串
concat()

拼接
char_length()

字符长度
trim()

去掉前后空格
replace()

替换
substr()

截取
日期
now()、curdate()、curtime()

year()、month()、day()

adddate()、subdate()

datediff()

日期间之间的计算
数学
ceil()、floor()

向上向下取整
rand()

随机数
round()

四舍五入
truncate()

保留指定小数位
高级函数
case表达式

相当于java中swtich
if表达式

相当于java中三元运算符
二 MySQL综合练习
课下必须写二遍
三 事务安全 TCL
什么是事务：
是指的是多个步骤的一组业务操作，要么都成功，要么都失败
操作
手动提交

begin
commit
rollback
自动提交

默认

我们使用JDBC时，手动关闭自动提交事务
事务原理
临时日志文件
保存点
设置保存点

savepoint 保存点名
回滚保存点

rollback to 保存点名
事务特性
A

原子性
C

一致性
I

隔离性
D

持久性
隔离性会出现问题
脏读
不可重复读
幻读（虚读）
数据库隔离级别
读未提交

读已提交

oracle 和 sqlServer 默认
可重复读

MySQL 默认
串行化