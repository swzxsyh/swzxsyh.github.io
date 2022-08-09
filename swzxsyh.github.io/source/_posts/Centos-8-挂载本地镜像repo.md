---
title: Centos 8 挂载本地镜像repo
date: 2019-03-21 23:42:36
tags:
---

- Centos 8 挂载本地镜像repo

安装后命令行界面

```bash
#先挂载本地镜像
mkdir /mnt/cdrom
mount -t auto /dev/cdrom /mnt/cdrom

#验证是否存在
ll /mnt/cdrom

cd /etc/yum.repo.d/
touch local.repo

vi local.repo

[LocalRepo_BaseOS]
name=Centos Linux 8
baseurl=file:///mnt/cdrom/BaseOS
enabled=1
gpgcheck=1
gpgkep=file://etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

[LocalRepo_AppStream]
name=Centos Linux 8
baseurl=file:///mnt/cdrom/AppStream
enabled=1
gpgcheck=1
gpgkep=file://etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

#退出 :x

yum clean all
yum makecache

查看grouplist有什么可以安装的
yum grouplist
```



