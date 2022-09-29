# Elasticsearch
&emsp;&emsp;使用Elasticsearch进行集中日志查询管理；Linux主机，Docker，数据库等监控；应用程序性能，运行状态监控。

## 安装
### 1.ElasticSearch安装
参考文档：<https://www.elastic.co/guide/en/elasticsearch/reference/7.10/docker.html>

```shell script
# 1.拉取镜像
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.10.2

# 2.创建数据挂载目录并授权
cd /data
mkdir elasticsearch
chmod g+rwx elasticsearch
chgrp 0 elasticsearch

# 3.启动单个节点
docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 -v /data/elasticsearch:/usr/share/elasticsearch/data -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.10.2

# 4.测试查看信息
http://127.0.0.1:9200/_cat/nodes?v=true&pretty
```

### 2.Kibana安装
&emsp;&emsp;Web查询客户端。参考文档：<https://www.elastic.co/guide/en/kibana/7.10/docker.html>

```shell script
# 1.拉取镜像
docker pull docker.elastic.co/kibana/kibana:7.10.2

# 2.运行
docker run -d --name kibana --link elasticsearch:elasticsearch -p 5601:5601 docker.elastic.co/kibana/kibana:7.10.2

# 3.配置 
docker ps -f name=kibana
docker exec -it e431d5f8c92b /bin/sh
cd config
vi kibana.yml
# 3.1中文显示 添加如下内容
    i18n.locale: "zh-CN"

# 4.访问地址：http://127.0.0.1:5601/     
```
  
### 3.Filebeat安装
&emsp;&emsp;使用filebeat将本地日志文件传送到Elasticsearch数据库中。
参考文档：<https://www.elastic.co/guide/en/beats/filebeat/7.10/filebeat-installation-configuration.html>  
配置文件参考：[filebeat.yml](Elasticsearch/filebeat.yml)  
```shell script
# 1.下载运行包
cd /data/elasticsearch
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.10.2-linux-x86_64.tar.gz
tar xzvf filebeat-7.10.2-linux-x86_64.tar.gz

# 2.连接elasticsearch
cd filebeat-7.10.2-linux-x86_64
vim filebeat.yml
    output.elasticsearch:
      hosts: ["127.0.0.1:9200"] 
    setup.kibana:
      host: "127.0.0.1:5601"
    
    - type: log
      enabled: true
      paths:
        - /var/log/*.log
        - /data/game/*/*.log

# 3.查看|使用模块
./filebeat modules list
./filebeat modules enable system
./filebeat setup -e

# 4.启动
sudo chown root filebeat.yml 
sudo chown root modules.d/system.yml 
nohup ./filebeat -e >/dev/null  &
#必须exit退出一下，不然filebeat进程运行一段时间会退出
exit
```    

### 4.APM Server 安装
&emsp;&emsp;监控应用程序，安装的`7.10`版本最大支持到Jdk11，可用Skywalking替代。  
参考文档：    
<https://www.elastic.co/guide/en/apm/get-started/7.10/install-and-run.html>  
<https://www.elastic.co/guide/en/apm/server/7.10/installing.html>  
<https://www.elastic.co/guide/en/apm/server/7.10/running-on-docker.html>  
<https://www.elastic.co/guide/en/apm/server/7.10/configuration-process.html>  
<http://47.108.13.34:40014/app/home#/tutorial/apm>  
配置文件参考：hall/[apm-server.yml](hall1/apm-server.yml)  
```shell script
# 1.下载并解压缩 APM Server
curl -L -O https://artifacts.elastic.co/downloads/apm-server/apm-server-7.10.2-x86_64.rpm
sudo rpm -vi apm-server-7.10.2-x86_64.rpm

# 2.启动
service apm-server start

# 3.常用配置
vim apm-server.yml 
    apm-server:
      host: "0.0.0.0:8200
    kibana:
        enabled: true
        host: "127.0.0.1:5601"
    rum:
        enabled: true
        
    output.elasticsearch:
      hosts: ["127.0.0.1:9200"]
```

### 5.Heartbeat 安装
&emsp;&emsp;监控引用程序是否在运行状态中，实际生产中使用较少。例如应用程序像InfluxDB写数据，结合Grafana来监控。
参考文档：<https://www.elastic.co/guide/en/observability/7.10/ingest-uptime.html>    
配置文件参考：[heartbeat.yml](Elasticsearch/heartbeat.yml)
```shell script
# 1.下载运行包
cd /data/elasticsearch
curl -L -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-7.10.2-linux-x86_64.tar.gz
tar xzvf heartbeat-7.10.2-linux-x86_64.tar.gz

# 2.连接elasticsearch
cd heartbeat-7.10.2-linux-x86_64
vim heartbeat.yml
    heartbeat.monitors:
    - type: http
      id: ElasticSearch
      name: ElasticSearch
      urls: ["http://127.0.0.1:9200"]
      schedule: '@every 10s'
    - type: tcp
      id: GateClient1
      name: GateClient1
      schedule: '@every 5s'
      hosts: ["127.0.0.1:2012"]
      mode: any

    output.elasticsearch:
      hosts: ["127.0.0.1:9200"] 
    setup.kibana:
      host: "127.0.0.1:5601"

# 3.查看|使用模块
./heartbeat setup -e

# 4.启动
sudo chown root heartbeat.yml 
nohup ./heartbeat -e >/dev/null  &
#必须exit退出一下，不然heartbeat进程运行一段时间会退出
exit

# 5.配置http，tcp网络监控
cd monitors.d
cp sample.http.yml.disabled register.http.yml
vim register.http.yml
```    

### 6.Metricbeat安装
&emsp;&emsp;监控linux服务器内存、CPU、网络、磁盘，MongoDB数据库，Docker等，可使用InfluxDB替代。
参考文档：<https://www.elastic.co/guide/en/beats/metricbeat/7.10/metricbeat-installation-configuration.html>
```shell script
# 1.下载运行包
cd /data/elasticsearch
mkdir metricbeat
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.10.2-linux-x86_64.tar.gz
tar xzvf metricbeat-7.10.2-linux-x86_64.tar.gz

# 2.连接elasticsearch
cd metricbeat-7.10.2-linux-x86_64
vim metricbeat.yml

    output.elasticsearch:
      hosts: ["localhost:9200"] 
    setup.kibana:
      host: "localhost:5601"
 cd modules.d
 #修改mongodb数据库连接地址用户名和密码
 vim mongodb.yml 
 

# 3.查看|使用模块（系统，docker，mongodb）
./metricbeat modules list
./metricbeat modules enable system mongodb docker
./metricbeat setup -e

# 4.启动
sudo chown root metricbeat.yml 
sudo chown root modules.d/system.yml 
sudo chown root modules.d/docker.yml 
sudo chown root modules.d/mongodb.yml 
nohup ./metricbeat -e >/dev/null  &
#必须exit退出一下，不然filebeat进程运行一段时间会退出
exit
```

## 查询
#### 1.查询匹配的日志内容
```shell script
curl -X GET "localhost:20011/filebeat-*/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "message": "国家"
    }
  }
}
'
```

    
#### 2.kibana查询
参考文档：  
<https://www.jianshu.com/p/9d511ea3a49d>  
<https://blog.csdn.net/jack1liu/article/details/102531714>  
* 全词查询  
    message:"正常退出游戏"  
