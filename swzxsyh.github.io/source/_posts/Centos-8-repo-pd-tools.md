---
title: Centos 8 repo & pd_tools
date: 2019-10-04 23:52:04
tags:
---

- Centos 8 repo & pd_tools

接上篇已配置好本地local.repo，安装好图形界面
进入网络设置，打开本地连接开关
1.将本地repo取消

```bash
cd /etc/yum.repo.d/
mv local.repo local.repo.bak
```

2.备份远程源

```bash
cp CentOS-AppStream.repo{,.bak}
cp CentOS-Base.repo{,.bak}
cp CentOS-Extras.repo{,.bak}
```

3.添加阿里源，修改如下

```bash
vi CentOS-AppStream.repo

[AppStream]
name=CentOS-$releasever - AppStream

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=AppStream&infra=$infra
#baseurl=http://mirror.centos.org/$contentdir/$releasever/AppStream/$basearch/os/
baseurl=https://mirrors.aliyun.com/centos/$releasever/AppStream/$basearch/os/

gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

vi CentOS-Base.repo

[BaseOS]
name=CentOS-$releasever - Base

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=BaseOS&infra=$infra
#baseurl=http://mirror.centos.org/$contentdir/$releasever/BaseOS/$basearch/os/
baseurl=https://mirrors.aliyun.com/centos/$releasever/BaseOS/$basearch/os/

gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

vi CentOS-Extras.repo

[extras]
name=CentOS-$releasever - Extras

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra
#baseurl=http://mirror.centos.org/$contentdir/$releasever/extras/$basearch/os/
baseurl=https://mirrors.aliyun.com/centos/$releasever/extras/$basearch/os/

gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
```



4.清理缓存并更新源

```bash
dnf clean all
dnf makecache
```

5.安装pd_tools
虚拟机光盘挂载prl-tools-lin.iso

```bash
#进入terminal
mount -t auto /dev/cdrom /mnt/cdrom
cd /mnt/cdrom
./install
```


如果一切正常则安装完毕，若遇到如下问题
dkms
hpijs

dkms
pjijs
则尝试安装

```bash
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
#手动安装dkms
yum install -y dkms
yum install -y hpijs
```

再次尝试
to be continued
//切勿尝试不同版本的prl_tools_lin.iso，会直接导致图形界面宕机