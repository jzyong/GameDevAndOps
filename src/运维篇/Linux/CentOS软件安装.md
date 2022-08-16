# CentOS软件安装

&emsp;&emsp;一些常用软件安装，配置。



### JDK安装
&emsp;&emsp;JDK安装可参考下面连接，生产环境使用docker运行程序，因此可跳过安装JDK。
* [JDK8][1]：<https://www.cnblogs.com/wandoupeas/p/centos_jdk_install.html>
* [JDK11][2]：<https://www.cnblogs.com/biem/p/13307438.html>

[1]: https://www.cnblogs.com/wandoupeas/p/centos_jdk_install.html
[2]: https://www.cnblogs.com/biem/p/13307438.html


  
### vim安装
```shell script
# 1.安装
yum -y install vim*
```
    

### tree安装
&emsp;&emsp;展示目录的树形结构。
```shell script
# 1.安装
yum install tree -y

# 2.展示目录
tree /data/game
```
    





