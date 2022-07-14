---
title: Linux & Nginx
date: 2020-05-25 01:40:56
tags:
---

一.linux基础
1.1 远程连接工具使用
在实际开发中，Linux服务器都在其他的地方，我们要通过windows客户端工具远程去连接Linux并操作 它，连接Linux的windows客户端工具有很多，企业中常用的有secureCRT、Putty、xshell、SSH Secure等。

1.2 Linux目录结构
root目录:超级管理员所在的目录，用~表示
home目录:普通用户所在的目录
usr目录:安装用户文件所在的目录
etc目录:Linux系统管理和配置文件所在的目录

1.3 文件夹(目录)操作命令
查看

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
ls

List directory contents.

- List files one per line:
    ls -1

- List all files, including hidden files:
    ls -a

- Long format list (permissions, ownership, size and modification date) of all files:
    ls -la

- Long format list with size displayed using human readable units (KB, MB, GB):
    ls -lh

- Long format list sorted by size (descending):
    ls -lS

- Long format list of all files, sorted by modification date (oldest first):
    ls -ltr
跳转

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
cd

Change the current working directory.

- Go to the given directory:
    cd path/to/directory

- Go to home directory of current user:
    cd

- Go up to the parent of the current directory:
    cd ..

- Go to the previously chosen directory:
    cd -
创建

1
2
3
4
5
6
7
8
9
mkdir

Creates a directory.

- Create a directory in current directory or given path:
    mkdir directory

- Create directories recursively (useful for creating nested dirs):
    mkdir -p path/to/directory
搜索

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
find

Find files or directories under the given directory tree, recursively.

- Find files by extension:
    find root_path -name '*.ext'

- Find files by matching multiple patterns:
    find root_path -name '*pattern_1*' -or -name '*pattern_2*'

- Find directories matching a given name, in case-insensitive mode:
    find root_path -type d -iname '*lib*'

- Find files matching a path pattern:
    find root_path -path '**/lib/**/*.ext'

- Find files matching a given pattern, excluding specific paths:
    find root_path -name '*.py' -not -path '*/site-packages/*'

- Find files matching a given size range:
    find root_path -size +500k -size -10M

- Run a command for each file (use `{}` within the command to access the filename):
    find root_path -name '*.ext' -exec wc -l {} \;

- Find files modified in the last 7 days, and delete them:
    find root_path -mtime -7 -delete
修改

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

mv

Move or rename files and directories.

- Move files in arbitrary locations:
    mv source target

- Do not prompt for confirmation before overwriting existing files:
    mv -f source target

- Prompt for confirmation before overwriting existing files, regardless of file permissions:
    mv -i source target

- Do not overwrite existing files at the target:
    mv -n source target

- Move files in verbose mode, showing files after they are moved:
    mv -v source target
剪切

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

mv

Move or rename files and directories.

- Move files in arbitrary locations:
    mv source target

- Do not prompt for confirmation before overwriting existing files:
    mv -f source target

- Prompt for confirmation before overwriting existing files, regardless of file permissions:
    mv -i source target

- Do not overwrite existing files at the target:
    mv -n source target

- Move files in verbose mode, showing files after they are moved:
    mv -v source target
复制

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
cp

Copy files and directories.

- Copy a file to another location:
    cp path/to/file.ext path/to/copy.ext

- Copy a file into another directory, keeping the filename:
    cp path/to/file.ext path/to/target_parent_directory

- Recursively copy a directory's contents to another location (if the destination exists, the directory is copied inside it):
    cp -r path/to/directory path/to/copy

- Copy a directory recursively, in verbose mode (shows files as they are copied):
    cp -vr path/to/directory path/to/copy

- Copy text files to another location, in interactive mode (prompts user before overwriting):
    cp -i *.txt path/to/target_directory

- Dereference symbolic links before copying:
    cp -L link path/to/copy
删除

1
2
3
4
5
6
7
8
9
rmdir

Removes a directory.

- Remove directory, provided it is empty. Use `rm` to remove not empty directories:
    rmdir path/to/directory

- Remove directories recursively (useful for nested dirs):
    rmdir -p path/to/directory            
1.4 文件操作命令
创建

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
touch

Change a file access and modification times (atime, mtime).

- Create a new empty file(s) or change the times for existing file(s) to current time:
    touch filename

- Set the times on a file to a specific date and time:
    touch -t YYYYMMDDHHMM.SS filename

- Use the times from a file to set the times on a second file:
    touch -r filename filename2
查看

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
cat

Print and concatenate files.

- Print the contents of a file to the standard output:
    cat file

- Concatenate several files into the target file:
    cat file1 file2 > target_file

- Append several files into the target file:
    cat file1 file2 >> target_file

- Number all output lines:
    cat -n file

- Display non-printable and whitespace characters (with `M-` prefix if non-ASCII):
    cat -v -t -e file
    
    

tail

Display the last part of a file.

- Show last 'num' lines in file:
    tail -n num file

- Show all file since line 'num':
    tail -n +num file

- Show last 'num' bytes in file:
    tail -c num file

- Keep reading file until `Ctrl + C`:
    tail -f file

- Keep reading file until `Ctrl + C`, even if the file is rotated:
    tail -F file
    
    
head

Output the first part of files.

- Output the first few lines of a file:
    head -n count_of_lines filename

- Output the first few bytes of a file:
    head -c number_in_bytes filename
删除

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
rm

Remove files or directories.

- Remove files from arbitrary locations:
    rm path/to/file path/to/another/file

- Recursively remove a directory and all its subdirectories:
    rm -r path/to/directory

- Forcibly remove a directory, without prompting for confirmation or showing error messages:
    rm -rf path/to/directory

- Interactively remove multiple files, with a prompt before every removal:
    rm -i file(s)

- Remove files in verbose mode, printing a message for each removed file:
    rm -v path/to/directory/*
编辑

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
vim

Vim (Vi IMproved), a command-line text editor, provides several modes for different kinds of text manipulation.
Pressing `i` enters edit mode. `<Esc>` goes back to normal mode, which doesn't allow regular text insertion.
More information: <https://www.vim.org>.

- Open a file:
    vim path/to/file

- View Vim's help manual:
    :help<Enter>

- Save a file:
    :write<Enter>

- Quit without saving:
    :quit!<Enter>

- Open a file at a specified line number:
    vim +line_number path/to/file

- Undo the last operation:
    u

- Search for a pattern in the file (press `n`/`N` to go to next/previous match):
    /search_pattern<Enter>

- Perform a regex substitution in the whole file:
    :%s/pattern/replacement/g<Enter>
1.5 文件压缩命令
将文件打成压缩包

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
tar

Archiving utility.
Often combined with a compression method, such as gzip or bzip.
More information: <https://www.gnu.org/software/tar>.

- Create an archive from files:
    tar cf target.tar file1 file2 file3

- Create a gzipped archive:
    tar czf target.tar.gz file1 file2 file3

- Create a gzipped archive from a directory using relative paths:
    tar czf target.tar.gz -C path/to/directory .

- Extract a (compressed) archive into the current directory:
    tar xf source.tar[.gz|.bz2|.xz]

- Extract an archive into a target directory:
    tar xf source.tar -C directory

- Create a compressed archive, using archive suffix to determine the compression program:
    tar caf target.tar.xz file1 file2 file3

- List the contents of a tar file:
    tar tvf source.tar

- Extract files matching a pattern:
    tar xf source.tar --wildcards "*.html"

- Extract a specific file without preserving the folder structure:
    tar xf source.tar source.tar/path/to/extract --strip-components=depth_to_strip
解压缩包获得文件

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
tar

Archiving utility.
Often combined with a compression method, such as gzip or bzip.
More information: <https://www.gnu.org/software/tar>.

- Create an archive from files:
    tar cf target.tar file1 file2 file3

- Create a gzipped archive:
    tar czf target.tar.gz file1 file2 file3

- Create a gzipped archive from a directory using relative paths:
    tar czf target.tar.gz -C path/to/directory .

- Extract a (compressed) archive into the current directory:
    tar xf source.tar[.gz|.bz2|.xz]

- Extract an archive into a target directory:
    tar xf source.tar -C directory

- Create a compressed archive, using archive suffix to determine the compression program:
    tar caf target.tar.xz file1 file2 file3

- List the contents of a tar file:
    tar tvf source.tar

- Extract files matching a pattern:
    tar xf source.tar --wildcards "*.html"

- Extract a specific file without preserving the folder structure:
    tar xf source.tar source.tar/path/to/extract --strip-components=depth_to_strip
1.6 文件权限命令
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
chmod

Change the access permissions of a file or directory.

- Give the [u]ser who owns a file the right to e[x]ecute it:
    chmod u+x file

- Give the [u]ser rights to [r]ead and [w]rite to a file/directory:
    chmod u+rw file_or_directory

- Remove e[x]ecutable rights from the [g]roup:
    chmod g-x file

- Give [a]ll users rights to [r]ead and e[x]ecute:
    chmod a+rx file

- Give [o]thers (not in the file owner's group) the same rights as the [g]roup:
    chmod o=g file

- Remove all rights from [o]thers:
    chmod o= file

- Change permissions recursively giving [g]roup and [o]thers the abililty to [w]rite:
    chmod -R g+w,o+w directory
1.7 其他命令
显示工作目录

1
2
3
4
5
6
7
8
9
pwd

Print name of current/working directory.

- Print the current directory:
    pwd

- Print the current directory, and resolve all symlinks (i.e. show the "physical" path):
    pwd -P
查看进程

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
ps

Information about running processes.

- List all running processes:
    ps aux

- List all running processes including the full command string:
    ps auxww

- Search for a process that matches a string:
    ps aux | grep string

- List all processes of the current user in extra full format:
    ps --user $(id -u) -F

- List all processes of the current user as a tree:
    ps --user $(id -u) f

- Get the parent pid of a process:
    ps -o ppid= -p pid
杀死进程

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
kill

Sends a signal to a process, usually related to stopping the process.
All signals except for SIGKILL and SIGSTOP can be intercepted by the process to perform a clean exit.

- Terminate a program using the default SIGTERM (terminate) signal:
    kill process_id

- List available signal names (to be used without the `SIG` prefix):
    kill -l

- Terminate a background job:
    kill %job_id

- Terminate a program using the SIGHUP (hang up) signal. Many daemons will reload instead of terminating:
    kill -1|HUP process_id

- Terminate a program using the SIGINT (interrupt) signal. This is typically initiated by the user pressing `Ctrl + C`:
    kill -2|INT process_id

- Signal the operating system to immediately terminate a program (which gets no chance to capture the signal):
    kill -9|KILL process_id

- Signal the operating system to pause a program until a SIGCONT ("continue") signal is received:
    kill -17|STOP process_id

- Send a `SIGUSR1` signal to all processes with the given GID (group id):
    kill -SIGUSR1 -group_id
搜索

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
grep

Matches patterns in input text.
Supports simple patterns and regular expressions.

- Search for an exact string:
    grep search_string path/to/file

- Search in case-insensitive mode:
    grep -i search_string path/to/file

- Search recursively (ignoring non-text files) in current directory for an exact string:
    grep -RI search_string .

- Use extended regular expressions (supporting `?`, `+`, `{}`, `()` and `|`):
    grep -E ^regex$ path/to/file

- Print 3 lines of [C]ontext around, [B]efore, or [A]fter each match:
    grep -C|B|A 3 search_string path/to/file

- Print file name with the corresponding line number for each match:
    grep -Hn search_string path/to/file

- Use the standard input instead of a file:
    cat path/to/file | grep search_string

- Invert match for excluding specific strings:
    grep -v search_string
管道

1
2
3
4
|      ##管道符
管道只允许正确输出通过
 tee         ####复制一份输出
2>&1 |       ####转换错误输出为正确再通过管道
关机

1
poweroff
重启

1
2
3
4
5
6
7
8
9
reboot

Reboot the system.

- Reboot immediately:
    sudo reboot

- Reboot immediately without gracefully shutting down:
    sudo reboot -q
二.Linux网络
2.1 网络服务
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
ifconfig

Network Interface Configurator.

- View network settings of an ethernet adapter:
    ifconfig eth0

- Display details of all interfaces, including disabled interfaces:
    ifconfig -a

- Disable eth0 interface:
    ifconfig eth0 down

- Enable eth0 interface:
    ifconfig eth0 up

- Assign IP address to eth0 interface:
    ifconfig eth0 ip_address
    
ip addr :CentOS7版本
修改网卡ip
vim /etc/sysconfig/network-scripts/ifcfg-ens33
概要信息	
DEVICE=ens33	网卡名称
TYPE=Ethernet	网卡类型 以太网
ONBOOT=yes	是否开机就使用此网卡
BOOTPROTO=dhcp	启动网卡时指定获取IP地址的方式
IPADDR=	ip地址
GATEWAY=	网关
NETMASK=255.255.255.0	子网掩码
DNS1=	DNS服务器
重启网卡服务	
systemctl status network	查看指定服务的状态
systemctl stop network	停止指定服务
systemctl start network	启动指定服务
systemctl restart network	重启指定服务
2.2 防火墙服务
2.2.1 防火墙设置
防火墙设置	
开启防火墙	systemctl start firewalld
重启防火墙	systemctl restart firewalld
关闭防火墙	systemctl stop firewalld
设置开机启动	systemctl enable firewalld
停止并关闭开机启动	systemctl disable firewalld
查看防火墙状态	systemctl status firewalld 或者 firewall-cmd –state
查看防火墙开机时是否启动	systemctl list-unit-files | grep firewalld
2.2.2 端口设置
端口设置	
添加	firewall-cmd –zone=public –add-port=80/tcp –permanent
更新防火墙规则	firewall-cmd –reload
查看	firewall-cmd –zone=public –query-port=80/tcp
firewall-cmd –zone=public –list-ports
删除	firewall-cmd –zone=public –remove-port=80/tcp –permanent
常用端口	8080 tomcat
80 http协议
443 https协议
22 ssh远程连接
3306 mysql
6379 redis
三.Nginx
3.1 介绍
Nginx是一款轻量级的 Web 服务器,由俄罗斯的程序设计师伊戈尔·西索夫所开发。 Nginx性能非常优秀, 官方测试能够支撑5万并发链接，并且 cpu、内存等资源消耗却非常低，运行非常稳定。

Nginx的功能有很多，我们主要使用它来做静态资源服务器、负载均衡服务器和反向代理服务器。

3.2 应用场景
3.2.1 静态资源服务器
部署网站的静态资源(html、css、js),可与Tomcat等实现动静分离

3.2.2 反向代理服务器
代理

给某个对象提供一个代理对象，并由代理对象控制原对象的引用

正向代理

对客户端进行代理(例如VPN)

反向代理

对服务端进行代理

反向代理，就是对服务端进行代理，作为客户端,只需要将请求发送到反向代理服务器，由反向代理服务 器去选择目标服务器获取数据后，再响应给客户端，此时反向代理服务器和目标服务器对外就是一个服 务器，暴露的是代理服务器地址，隐藏了真实服务器IP地址。

3.2.3 负载均衡服务器
负载均衡 Load Balance 意思就是将一份负载分摊到多个操作单元上进行执行

3.3 配置文件介绍(nginx-1.13.9/conf/nginx.conf)
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
server {
    listen       80; #port
    server_name  localhost; #Server

    #charset koi8-r;

    #access_log  logs/host.access.log  main;

    location / {
        root   html; #Static resource directory
        index  index.html index.htm; #Default visit page
    }
3.5 nginx与tomcat区别
存放的文件(资源)形式
Nginx是http服务器,只能解析静态文件

Tomcat是web中间件(本质上是一个servlet),能解析jsp和静态文件

用途

nginx可以作为反向代理服务器,负责均衡服务器,静态资源存放服务器

tomcat能作为jsp容器使用,静态资源存放服务器

性能

nginx支持5W+并发,tomcat的并发只能在200-400之间

总结
# linux基础

## Linux基本命令

### 目录结构

- root

​ - 超级管理员所在的目录

- home

​ - 普通用户所在的目录

- usr

​ - 安装用户文件所在的目录

- etc

​ - Linux系统管理和配置文件所在的目录

### 目录操作

- 查看

​ - ll

​ - ls

- 切换

​ - cd

​ - 绝对路径

​ - 相对路径

- 创建

​ - mkdir -p

- 修改/剪切

​ - mv

- 复制

​ - cp -r

- 删除

​ - rmdir -p

### 文件操作

- 创建

​ - touch

- 查看

​ - cat/more/less/head/tail

- 删除

​ - rm -rf

- 编辑

​ - vim

​ - 插入模式

​ - i

​ - 命令行模式

​ - esc

​ - 底行模式

​ - :

​ - wq!

​ - q!

### 压缩命令

- 打包

​ - tar -zcvf

​ - xxxx.tar.gz

- 解压缩

​ - tar -zxvf

​ - xxxx.tar.gz

### 文件权限

- chmod -R 777

### 其他命令

- 查看进程

​ - ps -ef

- 杀死进程

​ - kill -9 PID

- 文本搜索

​ - grep -in

- 管道

​ - 一个命令的输出作为另一个命令的输入

## Linux网络

### 网络

- 查看ip

​ - ifconfig

​ - ip addr

### 防火墙

- 防火墙设置

​ - 关闭

​ - systemctl stop firewalld

​ - 关闭开机自启动

​ - systemctl disable firewalld

- 端口设置

​ - 放行端口

​ - firewall-cmd –zone=public –add-port=80/tcp –permanent

​ - 更新规则

​ - firewall-cmd –reload

## Nginx

### 由战斗民族开发的一款高性能的 http 服务器/反向代理服务器

- http服务器

- 反向代理（负载均衡）