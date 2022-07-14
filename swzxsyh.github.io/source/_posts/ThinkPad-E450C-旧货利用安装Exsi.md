---
title: ThinkPad E450C 旧货利用安装Exsi
date: 2019-03-21 23:44:20
tags:
---

处理器：i3 4005U
内存： 4G
环境： win10

需要软件：
UltraISO（试用版）、Esxi

需要硬件：
U盘（1G以上），网线连接网络设备

ESXI下载地址：
VM官网：https://my.vmware.com/web/vmware/details?downloadGroup=OEM-ESXI67-LENOVO&productId=742
Lenovo官网：https://vmware.lenovo.com/content/custom_iso/6.5/6.5u1/

这里使用的是联想官网的版本，将ISO文件刻录进U盘后，重启抹盘重装。
重启，Enter选择F1进入Bios，关闭安全加载，开启通用加载，在安全选项中开启虚拟化。
保存后再次重启，Enter选择F12使用U盘加载。

接下来菜单中，选择电脑型号——等待加载，直至跳过黄色界面，进入Welcome界面后，由于内存仅有4G，实际仅剩3.75G，所以需要照如下流程操作，若内存大于4G，则跳过此流程

放入光盘或U盘，开始安装，一直普通流程到Welcome画面，按ALT+F1
登陆界面账号：root 密码为空
cd /usr/lib/vmware/weasel/util
rm upgrade_precheck.pyc（这个我进入时还未编译出来）
mv upgrade_precheck.py upgrade_precheck.py.old
cp upgrade_precheck.py.old upgrade_precheck.py #如果直接把这个文件备份.old
chmod 666 upgrade_precheck.py　　　　　　　　　　#增加权限后在原文件修改提示权限不允许
vi upgrade_precheck.py
编辑文本界面中查找 MEM_MIN
MEM_MIN_SIZE= (41024) 改成 MEM_MIN_SIZE= (21024)
wq! 强制保存退出
ps -c |grep weasel #不结束进程，直接适用ALT+F2貌似无效
kill -9 进程ID
此时正常情况下会跳回欢迎界面，如不跳回按ALT+F2返回继续安装
方法来源：https://www.bbsmax.com/A/RnJW2BbOzq/

回到欢迎界面后，Enter——F11——选择你要安装的硬盘——Enter——选择键盘模式（US，Enter）——设置root密码——F11开始安装——安装完毕后Enter重启

重启后若见到黄色界面则安装成功。

F2输入账户密码进入控制界面，找到Configure Management Network，进入后，查看Network Adapter是否connect，我的无线网卡换了一块BCM的暂不处理，后期再看
//TODO 处理无线网卡

若connect，配置IPv4 Configuration，将IP和自身网络环境配置进去
由此，已可以通过同一网络环境的其他电脑进行访问ESXI

来源：http://koolshare.cn/thread-132810-1-1.html