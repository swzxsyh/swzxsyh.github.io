---
title: Thinkpad E450C 物理机安装黑群晖
date: 2019-04-17 23:51:05
tags:
---

安装机型：Thinkpad E450C
安装版本：DS3617xs-6.17

镜像下载地址：
http://www.nasyun.com/thread-64575-1-1.html

工具：
空U盘（16G），img写盘工具，win8 PE盘一块

步骤：
使用二合一包比自行安装少很多步骤，仅需恢复后重置引导即可。

1.下载3617xs UEFI镜像后解压出约15G文件，存入16G空U盘
2.下载img写盘工具，一并存入（若PE已有该工具可跳过。img写盘工具比win32diskimager写入快3倍左右，建议使用）
3.使用PE引导Thinkpad进入PE界面
4.打开img写盘工具，选择解压后的镜像，目标选择 物理盘 Physical Disk，进行写入。
5.写入完成后已有一台可以直接硬盘启动的黑群晖，但是空间仅9G

接下来按照教程进行：
http://www.nasyun.com/forum.php?mod=viewthread&tid=65425&page=1#pid486522

1.删除存储空间和RAID空间，新建硬盘获得所有空间
3.重启进入winPE，打开DiskGenius，读取14G镜像
4.在刚刚创建的存储空间前有一个127M的小分区，创建63M和64M两个分区后删除63MB的，保存下一步
5.将虚拟镜像的EFI分区克隆进64MB分区中，重启
6.重启后硬盘自动引导，可以通过群晖安装助手查询该机器IP，登陆后即可操作