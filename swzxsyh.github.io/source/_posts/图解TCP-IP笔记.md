---
title: 图解TCP/IP笔记
date: 2020-04-03 01:00:25
tags:
---

7 应用层	<应用层>
Telnet,SSH,HTTP,SMTP,POP,SSL/TLS,FTP,MIME,HTML,SNMP,MIB,SIP,RTP...
6 表示层
5 会话层
4 传输层	<传输层>
TCP,UDP,UDP-Lite,SCTP,DCTP
3 网络层	<网络层>
ARP,IPv4,IPv6,ICMP,IPsec
2 数据链路层	
以太网,无线Lan,PPP...
(双绞线，无线，光纤)
1 物理层
一.网络基础知识
1.1 以网络互联方式使用计算机
计算机网络，根据规模可划分为WAN(Wide Area Network,广域网),和LAN(Local Area Network,局域网)

1.2 计算机网络发展的7个阶段
年代	内容
20C 50Y	批处理(Batch Processing)时代
20C 60Y	分时系统(TSS)时代
20C 70Y	计算机间的通信时代
20C 80Y	计算机网络时代
20C 90Y	互联网普及时代
2000 年	以互联网技术为中心时代
IP(Internet Protocol)取代电话网
2010 年	从”单纯建立连接”到”安全建立连接”
手握金刚钻的TCP/IP
互联网许多独立发展的通信技术最终融合成 TCP/IP(通信协议统称)
1.3 协议
“计算机网络体系结构”将现有网络协议进行了系统归纳，TCP/IP就是IP、TCP、HTTP等协议的集合。

网络体系结构	协议	主要用途
TCP/IP	IP,ICMP,TCP,UDP,HTTP,TELNET,SNMP,SMTP…	互联网，局域网
IPX/SPX
(Netware)	IPX,SPX,NPC…	个人电脑局域网
AppleTalk	DDP,RTMP,AEP,ATP,ZIP…	Apple产品局域网
DECnet	DPR,NSP,SCP…	前DEC小型机
OSI	FTAM,MOTIS,VT,CMIS/CMIP,CLNP,CONP…	–
XNS	IDP,SPP,PEP…	施乐公司网络
协议必要性
在计算机通信中，通信可能因为软硬件不同遇到各种异常，因此要实现达成一个详细的约定，并遵循这一约定，这种约定就是”协议”。
两台计算机必须支持相同的协议，并遵守相同协议进行处理，才能实现相互通信

分组交换协议
分组交换是指将大数据分割为一个个称为Packet的较小单位进行传输。
计算机通信会在每一个分组附上source地址和destination地址，这些地址以及分组序号写入的部分称为”报文首部”
一个较大的数据被分为多个组时，为了标明是原始数据的哪一部分，将有必要将序号写入Packet中。接收端会按照顺序重新装配原始数据

1.4 协议的标准化
为了解决每家都有各自协议无法通信的情况，ISO制定了一个国际标准OSI，对通信系统进行了标准化，但是没有得到普及。
IETF推动了TCP/IP的标准化进程，目前是业界标准。

1.5 协议分层与OSI参考模型
1.6
1.7
1.8
1.9
1.10
二.TCP/IP基础知识
三.数据链路
四.IP协议
五.IP协议相关技术
六.TCP与UDP
七.路由协议
八.应用协议
九.网络安全