# CentOS环境配置
&emsp;&emsp;本节主机介绍生产环境中linux内核调优，网络连接设置；时间设置，服务器部署在国外，还需要考虑时区的配置。

###  网络连接数限制设置 

#### ulimit -n
参考文档：<https://blog.csdn.net/hunhun1122/article/details/79391147>   
```shell script
# 1.修改连接数，重启后生效
vim /etc/security/limits.conf
    * soft nofile 204800
    * hard nofile 204800
    * soft nproc 204800
    * hard nproc 204800
# 2.分别新建下面两个文件，并加入 如下内容
vim /etc/security/limits.d/90-nproc.conf 
    * soft nproc 204800  
    * hard nproc 204800  
vim /etc/security/limits.d/def.conf
    * soft nofile 204800  
    * hard nofile 204800  
 
# 3.临时设置连接数
ulimit -n 204800
```

#### net.core.somaxconn   
参考文档：<https://www.cnblogs.com/my-show-time/p/15206020.html>

```shell script
# 1.查看参数
sysctl -a | grep net.core.somaxconn
# 2.设置 ，在末尾添加
vim /etc/sysctl.conf
    net.core.somaxconn=32768
sysctl -p
# 3.查看
sysctl -a | grep net.core.somaxconn
```    
    
### 网络超时设置
参考文档：<https://docs.mongodb.com/v3.6/faq/diagnostics/#adjusting-the-tcp-keepalive-value>
```shell script
# 1.使网络超时设置10分钟，超时后检测3次，每次30秒
vim /etc/sysctl.conf
    net.ipv4.tcp_keepalive_time=600
    net.ipv4.tcp_keepalive_intvl=30
    net.ipv4.tcp_keepalive_probes=3
sysctl -p
sysctl -a | grep keepalive
```


### 常用网络设置
参考文档：<https://help.aliyun.com/document_detail/41334.html>
```shell script
#表示当keepalive起用的时候，TCP发送keepalive消息的频度。缺省是2小时，
net.ipv4.tcp_keepalive_time=600
net.ipv4.tcp_keepalive_intvl=30
net.ipv4.tcp_keepalive_probes=3

#web应用中listen函数的backlog默认会给我们内核参数的net.core.somaxconn限制到128，而nginx定义的NGX_LISTEN_BACKLOG默认为511，所以有必要调整这个值
net.core.somaxconn=32688

#表示开启SYN Cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭  
net.ipv4.tcp_syncookies = 1  

#表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭  
net.ipv4.tcp_tw_reuse = 1  

#表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭  
net.ipv4.tcp_tw_recycle = 1

#表示如果套接字由本端要求关闭，这个参数决定了它保持在FIN-WAIT-2状态的时间  
net.ipv4.tcp_fin_timeout=30

#表示SYN队列的长度，默认为1024，加大队列长度为8192，可以容纳更多等待连接的网络连接数。
net.ipv4.tcp_max_syn_backlog = 8192

#表示系统同时保持TIME_WAIT套接字的最大数量，如果超过这个数字，TIME_WAIT套接字将立刻被清除并打印警告信息。
#默认为180000，改为5000。对于Apache、Nginx等服务器，上几行的参数可以很好地减少TIME_WAIT套接字数量，但是对于 Squid，效果却不大。此项参数可以控制TIME_WAIT套接字的最大数量，避免Squid服务器被大量的TIME_WAIT套接字拖死。
net.ipv4.tcp_max_tw_buckets = 5000

#对外连接端口范围
net.ipv4.ip_local_port_range = 10240 65000
##表示文件句柄的最大数量
fs.file-max = 102400

# 多网卡防止丢包
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
```
 
---------

### 日期时间设置
  
&emsp;&emsp;服务器部署在国外，使用美国时间会有夏时令问题；之前服务器未同步网络时间，会存在系统时间运行一段时间跑块，导致多台主机时间不一致。因此采用如下配置：
```shell script
# 1.查看系统时间
timedatectl status
date

# 2.查看可用时区
timedatectl list-timezones

# 3.设置时区
timedatectl set-timezone America/New_York

# 4.设置时间同步
timedatectl set-ntp yes

# 5.设置硬件时钟为UTC时间
timedatectl set-local-rtc 0

# 6.设置系统读取GST时区，美国纽约涉及到夏时令，会存在时间调快和调慢1小时问题
vi /etc/profile
    export TZ='GST+5'
source /etc/profile
```
参考文档：<https://www.cnblogs.com/lei0213/p/8723106.html> 

### 主机名称设置
```shell script
# 1.查看主机名
uname -n

# 2.修改主机名
hostnamectl set-hostname cd-linux-34
hostnamectl set-hostname audit
``` 
    
    
### 主机登录提示设置
```shell script
# 1.登录linux提示主机功能
echo "正式服Gate、Login、Hall服务器..." >/etc/motd
```
   
    
### 磁盘挂载
&emsp;&emsp;下面是测试服磁盘空间不足，单独给jenkins挂载一个磁盘。
```shell script
# 1.查看磁盘
df -kh
fdisk -l

# 2.创建挂载目录
cd /mnt/
mkdir jenkins

# 3.挂载，及开机自动挂载
mount /dev/vdb1 /mnt/jenkins/
echo '/dev/vdb1 /mnt/jenkins ext4 defaults 0 0' >> /etc/fstab

# 4.关闭jenkins 移动目录到新位置
mv /var/lib/jenkins/ /mnt/jenkins/

# 5.创建软连接，重启jenkins
ln -s /mnt/jenkins/jenkins /var/lib
service jenkins start
```

### 用户创建及权限设置
参考文档：<https://blog.51cto.com/u_14557673/2446952>  
```shell script
# 1.创建账号
useradd -M develop
# 2.修改密码
passwd develop
    123456
    123456
```   
    
    
    
    
    
    
    
