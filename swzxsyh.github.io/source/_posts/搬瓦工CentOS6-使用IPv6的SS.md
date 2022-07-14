---
title: 搬瓦工CentOS6 使用IPv6的SS
date: 2019-10-07 23:52:52
tags:
---

- 搬瓦工CentOS6 使用IPv6的SS

当前IPv4 IP被封，需要Google查资料，使用v6 IP勉强使用，此方法延迟大约是v4的10倍，原因可能与路由出口以及IP转化有关，但是方法十分简单。

当前系统环境（均为KVM自带）：
centos6-bbr，
ss
网络环境：
电信网，支持IPv6

首先使用如下教程，获取IPv6的IP，并使其在server自启动
https://www.bandwagonhost.net/2144.html

我这ping通Google但是没有显示IP，不影响使用。
可以使用ip -6 route查看一下，自带的内容会error 113，但是自己添加的在最后4条，没有error。

到此，IPv6已经配置完成，本地也已经可以ping通服务器的IPv6地址。

但是CentOS的IPv6还有防火墙，会导致即使ping通，服务启动也无法使用ss。可以使用命令开启端口，我这里选择直接关闭。
service ip6tables stop
chkconfig ip6tables off

至此，本机可以ping通、telnet通IPv6的主机地址。重启ss服务后，将IPv6地址添加到本地Client，其他配置文件不需修改，即可使用。
（若多人账号，需要自行配置json文件并添加自启动）

```bash
相关ip6tables命令：
/sbin/ip6tables -A INPUT -m state –state NEW -m tcp -p tcp –dport 8080 -j ACCEPT;
/sbin/ip6tables -A INPUT -m state –state NEW -m tcp -p udp –dport 8080 -j ACCEPT;

ss相关：
多人用户自行配置ss.json，并添加至rc.local自启动
/usr/bin/ssserver -c /etc/ss.json -d start
/usr/bin/ssserver -c /etc/ss.json -d stop
```