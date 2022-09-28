# Zookeeper

## 安装
### Docker 安装
参考文档：<https://hub.docker.com/_/zookeeper>
```
# 1.拉取镜像并运行
docker run --name zookeeper -p 2181:2181 --restart always -d zookeeper
```

## 控制台命令
```shell script
# 1.进入服务器
cd /data/apache-zookeeper-3.6.1-bin/bin

# 2.连接zookeeper
./zkCli.sh -timeout 5000 -server 127.0.0.1:2181

# 3.查看帮助命令
h

# 4.查看节点及状态
ls /
stat game

# 6.创建&获取路径数据
create /game/online/log/grpc 127.0.0.1:8305,127.0.0.1:8306
get /game/online/log/grpc

# 7.退出
quit
```
    
## 参数配置
### 最大连接数配置
&emsp;&emsp;最大连接数默认每台主机最大连接60个客户端
```shell script
# 1.进入目录
cd /data/apache-zookeeper-3.6.1-bin/conf

# 2.编辑
vim zoo.cfg 
    maxClientCnxns=600

# 3.重启
./zkServer.sh restart

