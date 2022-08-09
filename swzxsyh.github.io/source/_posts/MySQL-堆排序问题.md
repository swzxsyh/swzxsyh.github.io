---
layout: post
title: MySQL-堆排序问题
date: 2022-07-02 18:23:47
tags:
---

# MySQL-堆排序查询慢

## 问题：

根据主键排序，获取一条时，查询异常缓慢，测试260万数据需2.8s-3s

如果根据唯一键排序，则需要6s

## 原因：

由于MySQL 5.6的 priority queue ，在5.7 出现问题：

```mysql
ORDER BY id DESC LIMIT 1
```

此问题应仅发生在MySQL 5.7版本 ORDERBY 排序 配合 LIMIT 1 使用时发生。测试分页以及批量暂未发生相同异常

## 解决方案：

- 使用FORCE INDEX 可修复部分问题，但需针对性加索引

  ```sql
  -- 强制使用索引
  EXPLAIN 
  SELECT * FROM	`table_name` 
  FORCE INDEX (`index_name`)
  WHERE	(`conditions`) 
  ORDER BY `id` DESC
  LIMIT 1;
  ```

  

- 根据 主键 && 唯一键 排序, 全表条件查询可缩短至0.3s,增加条件筛选可在0.03左右查询结束

  ORDER BY id,code DESC LIMIT 1

  

具体原因: 

https://blog.csdn.net/wolfchenxing/article/details/88947577
