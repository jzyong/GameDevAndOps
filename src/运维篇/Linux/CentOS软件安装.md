# CentOS软件安装

## 一、程序安装




### 2. JDK安装
* JDK8：
https://www.cnblogs.com/wandoupeas/p/centos_jdk_install.html

* JDK11：
https://www.cnblogs.com/biem/p/13307438.html

* JDK14：
上传安装包到 /data/java


    //安装jdk14
    tar -xzvf jdk-14.0.2_linux-x64_bin.tar.gz



### 4.git安装

https://www.cnblogs.com/jhxxb/p/10571227.html


    

### 7. dstat命令安装

https://www.cnblogs.com/shoufeng/p/9739805.html

### 8. iostat安装及使用
   https://www.cnblogs.com/architectforest/p/12628399.html


    iostat -xmt 1
    Key fields from iostat:
    %util: this is the most useful field for a quick check, it indicates what percent of the time the device/drive is in use.
    avgrq-sz: average request size. Smaller number for this value reflect more random IO operations.



### 10. Nginx安装
安装参考：http://nginx.org/en/linux_packages.html
    配置路径：`/etc/nginx/`
    [正式服配置](nginx/aws/正式服nginx配置.md)

    //安装前置软件
    sudo yum install yum-utils

    vim /etc/yum.repos.d/nginx.repo

    [nginx-stable]
    name=nginx stable repo
    baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true

    [nginx-mainline]
    name=nginx mainline repo
    baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
    gpgcheck=1
    enabled=0
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true

    # 安装
    sudo yum install nginx

    # 退出
    nginx -s quit
    service nginx stop
    # 启动
    nginx
    service nginx start
    # 重载配置
    nginx -s reload
    sudo systemctl reload nginx
    # 重启
    nginx -c /etc/nginx/nginx.conf
    
    



### 12. zookeeper 安装
安装参考：https://www.cnblogs.com/zhiyouwu/p/11546097.html

### 13. vim安装
    yum -y install vim*

### 14. tree安装
    yum install tree -y
    tree /data/game

### 15. lsof安装
    yum install lsof

### 16. wireshark 
参考文档：https://www.wireshark.org/docs/wsug_html_chunked/ChBuildInstallUnixInstallBins.html

    yum install wireshark wireshark-qt


