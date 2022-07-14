---
title: ESXi 安装 黑群晖
date: 2019-03-21 23:45:20
tags:
---

方法来源：
http://www.myxzy.com/post-462.html

下载上述链接中的“6.1引导点击下载”解压并上传至ESXi存储中（2个文件，但上传后会自动合并为一个）
另下载“DS3617xs_15284.pat”

ESX中创建虚拟机，选择Linux（必须选择Linux 3.x或ubuntu等，不能选择其他，否则无SATA驱动器无法找到硬盘）
到自定义设置，首先删除已存在的硬盘，添加本地U盘（Esxi存储中找到对应引导vmdk文件），下拉选择SATA模式
添加新硬盘，同样更改SATA模式，SATA（0：1）
开启虚拟机，自动载入引导，登录网址，安装PAT文件，即可安装好群晖系统

若使用macOS，可以使用如下文章方法添加TimeMachine（需先将硬盘空间格式化NAS空间）
https://sspai.com/post/48372