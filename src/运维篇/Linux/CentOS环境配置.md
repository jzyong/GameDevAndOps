# CentOS环境配置

## 环境配置
### 1. 防火墙&端口

https://www.cnblogs.com/heqiuyong/p/10460150.html

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
    
    
    # 5.网络、端口状态
        # 查看端口
        netstat -lnpt
        
        # 查看指定端口
        netstat -lnpt |grep 5672
        
        # 网络状态统计信息
        netstat -an | awk '/^tcp/ {++y[$NF]} END {for(w in y) print w, y[w]}'
        
        # 连接数
        netstat -an |grep ESTABLISHED |wc -l
        
        # 每个ip连接数
        netstat -nat|grep "tcp"|awk ' {print$5}'|awk -F : '{print$1}'|sort|uniq -c|sort -rn
        
        # 每个ip ESTABLISHED连接数
        netstat -nat|grep ESTABLISHED|awk '{print$5}'|awk -F : '{print$1}'|sort|uniq -c|sort -rn
        
        # 查看指定端口的连接信息
        netstat -an | grep 7050


### 3. 网络设置 
* ulimit -n
参考文档： https://blog.csdn.net/hunhun1122/article/details/79391147   


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

* net.core.somaxconn   
参考文档： https://www.cnblogs.com/my-show-time/p/15206020.html
    
    
    # 1.查看参数
    sysctl -a | grep net.core.somaxconn
    
    # 2.设置 ，在末尾添加
    vim /etc/sysctl.conf
        net.core.somaxconn=32768
    sysctl -p

    # 3.查看
    sysctl -a | grep net.core.somaxconn
    
* 网络超时设置

参考文档： https://segmentfault.com/a/119000
https://docs.mongodb.com/v3.6/faq/diagnostics/#adjusting-the-tcp-keepalive-value  
具体配置参考：[sysctl.conf](内核参数/sysctl.conf)  

    # 1.使网络超时设置10分钟，超时后检测3次，每次30秒
    vim /etc/sysctl.conf
        net.ipv4.tcp_keepalive_time=600
        net.ipv4.tcp_keepalive_intvl=30
        net.ipv4.tcp_keepalive_probes=3
    sysctl -p
    sysctl -a | grep keepalive
* 常用网络设置
参考文档：https://help.aliyun.com/document_detail/41334.html  

### 4.日期时间设置
参考文档：https://www.cnblogs.com/lei0213/p/8723106.html  
    正式服使用美国纽约时间，默认情况下centos服务器运行一段时间会跑块   
    
    
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

### 5.主机名称设置
    
    # 1.查看主机名
    uname -n
    
    # 2.修改主机名
    hostnamectl set-hostname cd-linux-34
    hostnamectl set-hostname audit
    
### 6.主机登录提示设置

    # 1.登录linux提示主机功能
    echo "阿里云外网测试服、jenkins、gitlab、docker仓库、maven仓库...." >/etc/motd
    echo "亚马逊正式服大厅1、网关1、manage1、gate1、MongoDB、redis、zookeeper" >/etc/motd
    echo "亚马逊正式服大厅2、网关2、manage2、gate2" >/etc/motd
    echo "亚马逊正式服子游戏slots、influxdb、elasticsearch、kibana" >/etc/motd
    echo "亚马逊正式服子游戏slots-2" >/etc/motd
    echo "亚马逊提审服，部署了所有相关服务、外侧服登录服api" >/etc/motd
    
### 7.磁盘挂载
#### 1.成都34 jenkins 挂载到单独目录
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
    
### 8.用户创建及权限设置
参考文档：https://blog.51cto.com/u_14557673/2446952  
    
    # 1.创建账号
    useradd -M develop
    
    # 2.修改密码
    passwd develop
        123456
        123456
