---
title: Elasticsearch初识
date: 2020-07-16 01:59:30
tags:
---

Single Node
```bash
# 下载
$ docker pull elasticsearch:5.6.8
#启动，需要配置JVM，否则报OOM
# 9200为  ES节点 和 外部 通讯使用
# 9300是tcp通讯端口，集群间和TCPClient走它
# 单点模式
$ docker run -d -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" --name es -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:5.6.8

#如果要使用kibana，最好先在此开启映射，否则需要更改container内部json数据
# 单点模式
$ docker run -d -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" --name es -p 9200:9200 -p 9300:9300 -p 5601:5601 -e "discovery.type=single-node" elasticsearch:5.6.8



# 访问 localhost:9200 可以看到JSON格式数据
####################################################
{
  "name" : "wCWV0cR",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "5krSWTgVQUuxvyQvF8LCTw",
  "version" : {
    "number" : "5.6.8",
    "build_hash" : "688ecce",
    "build_date" : "2018-02-16T16:46:30.010Z",
    "build_snapshot" : false,
    "lucene_version" : "6.6.1"
  },
  "tagline" : "You Know, for Search"
}
####################################################

# 进入容器，安装ik
$ docker exec -it es /bin/bash     

# 要安装对应版本 
root@b340ba8042f5:/usr/share/elasticsearch# ./bin/elasticsearch -version
Version: 5.6., Build: cfe3d9f/2018-09-10T20:12:43.732Z, JVM: 1.8.0_181

# 解决跨域问题
# container没有vi，使用echo添加到最后
root@a604792a79ad:/usr/share/elasticsearch# cd config/
root@a604792a79ad:/usr/share/elasticsearch/config# echo "http.cors.enabled: true">> elasticsearch.yml 
root@a604792a79ad:/usr/share/elasticsearch/config# echo -e "http.cors.allow-origin: \"*\"">> elasticsearch.yml 


# 解决宿主机无法访问问题
# 让所有IP都可访问
root@a604792a79ad:/usr/share/elasticsearch/config# sed -i 's/^#\(transport.host: 0.0.0.0\)/\1/' elasticsearch.yml 


# 查看是否写入成功
root@a604792a79ad:/usr/share/elasticsearch/config# cat elasticsearch.yml 
http.host: 0.0.0.0
# Uncomment the following lines for a production cluster deployment
transport.host: 0.0.0.0
#discovery.zen.minimum_master_nodes: 1
http.cors.enabled: true
http.cors.allow-origin: "*"
network.host: 127.0.0.1


# 下载对应版本的ik
./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v5.6.8/elasticsearch-analysis-ik-5.6.8.zip

# 后面分词器用的上，先配置
# 配置自己的扩展字典
# 配置自己设置的停止词字典
# sed 用法 在某个单词后添加某语句
root@fa9104ef06a1:/usr/share/elasticsearch/plugins/ik/config# sed -i 's/<entry key="ext_dict">/&ext.did/' IKAnalyzer.cfg.xmllocation</entry> -->
root@fa9104ef06a1:/usr/share/elasticsearch/plugins/ik/config# sed -i 's/<entry key="ext_stopwords">/&stopword.dic/' IKAnalyzer.cfg.xml
root@fa9104ef06a1:/usr/share/elasticsearch/plugins/ik/config# cat IKAnalyzer.cfg.xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
<properties>
	<comment>IK Analyzer 扩展配置</comment>
	<!--用户可以在这里配置自己的扩展字典 -->
	<entry key="ext_dict">ext.dic</entry>
	 <!--用户可以在这里配置自己的扩展停止词字典-->
	<entry key="ext_stopwords">stopword.dic</entry>
	<!--用户可以在这里配置远程扩展字典 -->
	<!-- <entry key="remote_ext_dict">words_location</entry> -->
	<!--用户可以在这里配置远程扩展停止词字典-->
	<!-- <entry key="remote_ext_stopwords">words_location</entry> -->
</properties>
root@fa9104ef06a1:/usr/share/elasticsearch/plugins/ik/config# 

# 配置ik/config/stopword.dic，添加自定义停止词
# 在ik/config/目录下添加ext.dic文件，并自定义扩展词语

# 重启container
$ docker restart es

# head图形化界面
# 下载镜像(head属于本地端，可以直接本机安装)
$ docker pull mobz/elasticsearch-head:5 
# 启动
$ docker run -d -p 9100:9100 docker.io/mobz/elasticsearch-head:5   
#访问 localhost:9100 ，可以连接上9200的es

# kibana数据显示页面，需要与ES版本匹配
# 注意，此处使用了 --network ，因安全限制无法再暴露端口，若要使用则由es暴露端口，建议在es启动时直接暴露
$ docker run -it -d -e ELASTICSEARCH_URL=http://127.0.0.1:9200 --name kibana --network=container:es  kibana:5.6.8  

# 若ES未暴露Port，又不想重新经历步骤，只能修改container内部json数据
# 停止容器->修改两个json文件->停止docker->启动docker->启动容器。否则container会恢复为旧版本
# macOS 需screen进入tty
$ vim /var/lib/docker/containers/[hash_of_the_container]/hostconfig.json
# 在PortBindings中添加
"5601/tcp": [{"HostIp": "","HostPort": "5601"}]

$ vim /var/lib/docker/containers/[hash_of_the_container]/config.v2.json
# 在ExposedPorts中添加
"5601/tcp": {}

```


https://shipengliang.com/software-exp/docker-%E5%AE%B9%E5%99%A8%E7%9A%84%E7%BD%91%E7%BB%9C%E6%A8%A1%E5%BC%8F.html

http://www.amd5.cn/atang_4301.html