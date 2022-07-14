---
title: Esxi安装LEDE系统
date: 2019-03-21 23:45:50
tags:
---

使用上一篇文章安装Exsi后，通过自己设置的IP进入Exsi（web端即可操作）

软件需求：
openwrt.vmdk

下载网站：
http://firmware.koolshare.cn/LEDE_X64_fw867/
下载固件：
openwrt-koolshare-mod-v2.30-r10402-51ad900e2c-x86-64-combined-squashfs.vmdk
我这时是2.3.0，combined版本

进入Exsi，选择存储，点击数据存储浏览器——创建目录——lEDE——上传openwrt-koolshare-mod-v2.30-r10402-51ad900e2c-x86-64-combined-squashfs.vmdk 退出存储界面。

若直接使用该vmdk会提示：无法打开磁盘 scsi0:0: 磁盘类型 7 不受支持或无效。请确保磁盘已导入。
使用另一台电脑ssh进入Exsi，进入目录 cd /vmfs/volumes/DATA卷/LEDE/
使用命令：
vmkfstools –i openwrt-koolshare-mod-v2.30-r10402-51ad900e2c-x86-64-combined-squashfs.vmdk LDED.vmdk -d thin
精简后即可使用

接下来创建虚拟机：
创建新虚拟机——输入名称，选择Linux、Linux（64）——选择存储——自定义设置——————此时，删除硬盘，点击添加硬盘-现有硬盘，加入刚刚更改过的LDED.vmdk，完成

启动虚拟机，等命令行不动时回车即可进入（root权限）
安装后自动配置王官192.168.1.1，若有冲突，可以通过ssh更改为其他地址。

Web端使用自带或更改后的地址进入界面，默认密码为koolshare

左边选项中进入：网络——接口——LAN编辑——添加网关、DNS（114.114.114.114，223.5.5.5）保存并应用

这时可以正常安装并使用酷软中的软件了

其他功能有待探索
//TODO

