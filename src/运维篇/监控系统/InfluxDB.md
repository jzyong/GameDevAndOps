# InfluxDB

## 安装
### 1. InfluxDB安装
1. docker安装命令：  
```shell script
 docker run -d --name influxdb -p 8086:8086 --restart=always -e TZ="America/Chicago" quay.io/influxdb/influxdb:v2.0.3 --reporting-disabled
```
2. 浏览器访问：http://127.0.0.1:8086/   
  账号：root 密码： 123456  

### 2. Telegraf安装
参考地址：<https://docs.influxdata.com/telegraf/v1.17/introduction/installation/>    
配置文件路径：`/etc/telegraf/telegraf.conf`
```shell script
# 1.编辑安装源
cat <<EOF | sudo tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
EOF

# 2.安装
sudo yum install telegraf

# 3.启动
sudo systemctl start telegraf

# 4.停止（注意正式服需要停止默认服务，没有配置，开机自动启动）
systemctl stop telegraf
```

### 3. Telegraf配置
1. 自动配置  
服务器监控，docker，redis为自动配置  
参考：<https://docs.influxdata.com/influxdb/v2.0/write-data/no-code/use-telegraf/auto-config/>
2. 手动配置  
参考：<https://docs.influxdata.com/influxdb/v2.0/write-data/no-code/use-telegraf/manual-config/>


### 4. 删除数据库
参考文档：<https://docs.influxdata.com/influxdb/v2.0/write-data/delete-data/>
```shell script
# 1.进入容器
docker exec -it 7df65a67e3ba /bin/bash
    
# 2.删除命令
influx delete --org game-aws --bucket game-server \
  --token uf6uM-veNG_RcJVXdWfloYodv3pNFMQBSHxh9br8QMg9Qsr_6aT1pif_cdCiWAZ3mU5vIEc9K_2daCtK_V9g== \
  --start '1970-01-01T00:00:00Z' \
  --stop '2021-11-14T00:00:00Z' \
  --predicate '_measurement="game_info"'
```

### 5. 数据监控
&emsp;&emsp;配置文件参考：
[Linux](influxdb/LinuxTelegraf.conf)、[MongoDB](influxdb/MongodbTelegraf.conf)、
[Redis](influxdb/RedisTelegraf.conf)、[Docker](influxdb/DockerTelegraf.conf)
```shell script
# 1.设置环境变量
export INFLUX_TOKEN=m4jOs8bnYI05Gg7bXCqdKWVOQtTzZBDJby1pMfvKgvrq_sFxxmB3KvZjGzaZ1iXw-a0KnQSkib4i5euvzQw==

# 2.启动telegraf
nohup telegraf --config http://127.0.0.1:8086/api/v2/telegrafs/07a13141c3f98000 >/dev/null  &

# 3. linux本地配置启动
nohup telegraf --config /data/telegraf/LinuxTelegraf.conf >/dev/null  &
nohup telegraf --config /data/mongo/MongodbTelegraf.conf >/dev/null  &
nohup telegraf --config /data/mongo/Rediselegraf.conf >/dev/null  &
nohup telegraf --config /data/mongo/DockerTelegraf.conf >/dev/null  &

```     
    





