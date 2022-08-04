# CentOS命令参考
&emsp;&emsp;主要记录常用的系统命令使用及CentOS7中的安装使用。


## 系统资源
&emsp;&emsp;磁盘、CPU、内存、IO等常见命令使用。
游戏服务器程序可能出现死循环，定时器泄露等占用CPU；未正常释放对象占用过多的内存或者内存一直飙升等问题；
存储数据，网路请求太多，消耗IO过高等问题；日志输出太多，没有正常删除照成磁盘占满等问题。

### top命令

&emsp;&emsp;top命令经常用来监控linux的系统状况，常用的性能分析工具，能够实时显示系统中各个进程的各种资源占用情况。
[参考地址][1] ：<https://blog.csdn.net/yjclsx/article/details/81508455>。进入top界面安如下安静可安需求显示。
* 1：展开每个CPU的信息
* P：以CPU的使用资源排序显示 
* M：以内存的使用资源排序显示 
* N：以pid排序显示 
* T：由进程使用的时间累计排序显示    

```shell script
# 1.查看指定进程 内存，cpu等信息
top -p 2913

# 2.查看进程详细信息，具体条目说明参考 https://blog.csdn.net/weixin_40584007/article/details/88847745  
cat /proc/1308/status
```

[1]:https://blog.csdn.net/yjclsx/article/details/81508455

### dstat命令
&emsp;&emsp;多功能系统资源统计生成工具 ( versatile tool for generating system resource statistics), 
可提供包含 `top、free、iostat、ifstat、vmstat`等多个工具的功能。详细使用可参考:<https://www.cnblogs.com/shoufeng/p/9739805.html>
```shell script
# 1.安装
yum -y install dstat

# 2.查看
dstat
```

### iostat
&emsp;&emsp;统计CPU和IO信息，详细使用可参考：<https://www.cnblogs.com/architectforest/p/12628399.html>
```shell script
# 1.查看
iostat -xmt 1
```

### ps命令
&emsp;&emsp;查看具体进程相关信。
```shell script
# 1.查询进程id
ps -ef | grep game-hall | awk '{print "kill "$2}'
```      
   
   
## 文件操作
&emsp;&emsp;常用地文件上传，下载，打包，日志查看操作等。游戏服务器出现bug，有时候为了方便查看日志，需要将大的日志文件进行压缩打包，然后下载到本地进行操作。
### re|sz上传下载命令
&emsp;&emsp;可在Xshell中快速上传，下载文件。    
```shell script
# 1.安装
yum -y install lrzsz

# 2.上传
rz

# 3.下载
sz [文件名]
```

### tar解压缩  

```shell script
# 1.打包压缩目录
tar -czvf game_hall_20201209.tar.gz game_hall_20201209121360/
```
   
###  目录文件操作  
```shell script
# 1.删除backups目录30天之前修改的文件
find backups/ -mtime +30 -delete
```
    
### 系统日志
&emsp;&emsp;系统日志文件含义：
* `/var/log/message` 系统启动后的信息和错误日志，是Red Hat Linux中最常用的日志之一  
* `/var/log/secure` 与安全相关的日志信息  
* `/var/log/maillog` 与邮件相关的日志信息  
* `/var/log/cron` 与定时任务相关的日志信息  
* `/var/log/spooler` 与UUCP和news设备相关的日志信息  
* `/var/log/boot.log` 守护进程启动和停止相关的日志消息  

```shell script
# 1.显示所有日志：
journalctl

# 2.查看最后10条日志
journalctl -n 10

# 3.跟踪日志：
journalctl -f

# 4只显示冲突、告警和错误
journalctl -p err..alert
```    

  
## 网络操作
&emsp;&emsp;新服务器部署过程中需要查看两台服务器直接网络是否联通需要用`ping`命令；
检测网络端口是否开放，能否访问通需要使用`telent`命令；
在主机上下载安装包通常需要`wget`命令；
经常需要调用http请求进行后台管理操作需要使用`curl`命令。

### Telnet
    
```shell script
# 1.检查是否安装
rpm -qa | grep telnet

# 2.查看yum列表
yum list | grep telnet

# 3.安装
yum install -y telnet-server.x86_64
yum install -y telnet.x86_64

# 4.执行
telnet 192.168.1.11 80
```      
   
### wget
```shell script
# 1.安装
yum -y install wget
```
    
### curl
```shell script
# 1.安装
yum -y install curl
```

### 16. wireshark 
&emsp;&emsp;监听服务器、客户端指定端口是否收到远端的消息包。用于网络消息包的分析。官方文档：<https://www.wireshark.org/docs/wsug_html_chunked/index.html>

```shell script
# 1.安装
yum install wireshark wireshark-qt

# 2.服务器获取网络包
# 2.1.创建文件&添加权限
touch packet.txt
chmod o+x packet.txt

# 2.2.查看网络接口
tshark -D

# 2.3.记录
tshark -w packet.txt -i eth0 -q

# 2.4.控制台查看指定端口(非常消耗内存)
tshark -i eth0 -Y "tcp.port == 4019"
tshark -i ens5 -Y "tcp.port == 7050"
```
   
### firewall-cmd

```shell script
# 1.查看防火墙所有开放的端口
firewall-cmd --zone=public --list-ports
firewall-cmd --list-all
  
# 2.开放端口
firewall-cmd --zone=public --add-port=27017/tcp --permanent

# 3.生效
firewall-cmd --reload

# 4.防火墙开关，状态查看
systemctl stop firewalld
systemctl start firewalld
systemctl status firewalld
```

### netstat    
&emsp;&emsp;压测时可使用该命令查看网络连接是否正常创建，释放。
```shell script

# 1.查看端口
netstat -lnpt
 
# 2.查看指定端口
netstat -lnpt |grep 5672

# 3.网络状态统计信息
netstat -an | awk '/^tcp/ {++y[$NF]} END {for(w in y) print w, y[w]}'

# 4.连接数
netstat -an |grep ESTABLISHED |wc -l

# 5.每个ip连接数
netstat -nat|grep "tcp"|awk ' {print$5}'|awk -F : '{print$1}'|sort|uniq -c|sort -rn

# 6.每个ip ESTABLISHED连接数
netstat -nat|grep ESTABLISHED|awk '{print$5}'|awk -F : '{print$1}'|sort|uniq -c|sort -rn

# 7.查看指定端口的连接信息
netstat -an | grep 7050
```   
    
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
    
    
    

    
    
    
    
    

    
    
    




