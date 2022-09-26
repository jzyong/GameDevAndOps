# Arthas
&emsp;&emsp;进行线上Java应用问题排查。参考文档：    
* <https://arthas.aliyun.com/doc>  
* <https://developer.aliyun.com/article/921780>  


## 环境部署
```shell script
# 1.运行，因为有多个java版本，需要指定路径
cd /data/java/
/data/java/jdk-14.0.2/bin/java -jar arthas-boot.jar --target-ip 0.0.0.0
```    



## 命令参考
### 1.docker运行 arthas
docker里出现arthas无法工作的问题，是因为应用没有安装 JDK ，而是安装了 JRE
```shell script
# 1.docker 运行（官方使用，实际不行，docker容器没有wget 命令）
docker exec -it  ${containerId} /bin/bash -c "wget https://arthas.aliyun.com/arthas-boot.jar && java -jar arthas-boot.jar"

# 2.使用curl 方式进行
docker exec -it bcd75 /bin/bash
curl https://arthas.aliyun.com/arthas-boot.jar --output arthas-boot.jar
java -jar arthas-boot.jar
    dashboard
    thread -all
```


### 2.仪表盘查看概要信息
    dashboard
### 3.查看线程
* thread -b, 找出当前阻塞其他线程的线程  
* thread –all, 显示所有匹配的线程  
* thread -n 3 3个最忙的线程  
* thread 49 显示线程id为49的堆栈信息  
* thread --state WAITING 查看等待状态的线程  
### 4.查看内存
* memory 查看内存信息

### 5.日志修改
```shell script
# 1.查看指定名称日志
logger -n com.dls

# 2.修改日志级别
logger --name com.dls --level info
```

### 6.调优，性能、bug排查
```shell script
# 1.查看类信息
sc -d com.dls.slots.gate.service.GateService

# 2.查看方法信息
sm -d com.dls.slots.gate.service.GateService init

# 3.查看类加载信息
classloader

# 4.监控方法执行次数和耗时
monitor -c 5 com.dls.slots.gate.tcp.user.UserTcpServerHandler channelRead

# 5.跟踪函数执行，统计耗时
trace com.dls.slots.gate.tcp.user.UserTcpServerHandler channelRead

# 6.方法调用栈
stack com.dls.slots.gate.tcp.user.UserTcpServerHandler channelRead

# 7. 查看方法返回值，参数，执行时间，是否异常等
tt -t com.dls.slots.gate.sturct.User sendToUser
```
