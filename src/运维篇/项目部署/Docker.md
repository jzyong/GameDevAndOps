# Docker
&emsp;&emsp;因为slots类游戏有上百个子游戏，每个子游戏都是单独的服务，如果使用传统的服务器部署一整套或更新将是恶魔般的存在，因此用docker搭建了一套自动化部署流程。

## 部署流程
TODO 画流程图，结合jenkins


## 环境搭建
### Linux环境搭建

#### 安装
安装参考：<https://www.linuxprobe.com/install-use-docker-in-centos7.html>

```shell script
# 1.安装
yum install docker

# 2.查看版本号
docker version

# 3.启动
systemctl  start docker.service

# 4.开机启动
systemctl  enable docker.service
``` 

#### 私有仓库安装
参考文档：  
<https://hub.docker.com/_/registry>   
<https://docs.docker.com/registry/>  
```shell script
docker run -d -p 5000:5000 --restart=always -v /data/registry:/var/lib/registry --name registry registry:2
```
    
#### 配置远程访问
```shell script
# 1.配置远程访问 替换如下内容，记得开放2375端口的访问权限
vi /lib/systemd/system/docker.service
    ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock -H tcp://0.0.0.0:7654

# 2.配置docker参数，添加如下内容
vi /etc/docker/daemon.json
    {
        "insecure-registries":[
            "192.168.0.1:5000"
        ],
        "registry-mirrors":[
            "https://6kx4zyno.mirror.aliyuncs.com"
        ],
        "log-driver":"json-file",
        "log-opts":{
            "max-size":"1000m",
            "max-file":"1"
        }
    }
```
    
#### 错误处理

* exec: "docker-proxy": executable file not found in $PATH  
参考文档:
<https://www.cnblogs.com/cxbhakim/p/9149596.html>    
```shell script
ln -s /usr/libexec/docker/docker-proxy-current /usr/bin/docker-proxy
ln -s /usr/libexec/docker/docker-proxy-current /usr/bin/docker-proxy
```

    

* Bind for 0.0.0.0:80 failed: port is already allocated.  
参考文档:<https://www.maoyuanrun.com/2017/01/12/docker-port-is-already-allocated/>  
```shell script
ps -aux | grep -v grep | grep docker-proxy
systemctl stop docker.service
docker rm $(docker ps -aq)
systemctl status docker.service
```

* error: docker-runc not installed on system  
参考文档：<https://blog.51cto.com/michaelkang/2160171>     
```shell script
cd /usr/libexec/docker/
sudo ln -s docker-runc-current docker-runc 
```

### Windows环境搭建

TODO






















### windows docker数据盘设置

&emsp;&emsp;docker 安装默认镜像目录在C盘中，使用一段时间后此文件特别大，然而电脑C盘空间太小，
因此需要将此文件移动到空间大的磁盘上。  
参考文档：<https://blog.csdn.net/weixin_47513022/article/details/120083726>




## 维护

### 常用命令
```shell script
# 1.进入容器
docker exec -it d1412927d331 /bin/sh
# 管理员进入才可编辑配置文件
docker exec -it --user root  a6882651c45b /bin/sh

# 2. 内存 cpu查看
docker stats
# 2.1 不显示名称处理方案
docker stats $(docker ps --format '{{.Names}}')

# 3.日志查看
docker logs -f 8da217c8723a

# 4.docker信息
docker info
docker container inspect 73a656d7fe44

# 5.网络
docker network ls
```
### 磁盘清理 
```shell script
# 1.目录磁盘占用
du -h

# 2.统计当前目录大小
du -sh ./*
du -sh /data

# 3.系统磁盘
df -h

# 4.docker查看磁盘
docker system df

# 5.清理磁盘，删除关闭的容器、无用的数据卷和网络，以及dangling镜像
docker system prune

# 6.删除所有没使用的镜像
docker system prune -a
```   

### 线上问题
* failed to retrieve docker-init version
Mar 26 01:25:00 ip-172-31-62-192.us-west-2.compute.internal dockerd[1458]: 
time="2021-03-26T02:25:00.103411934-04:00" level=warning msg="failed to retrieve docker-init version"  
&emsp;&emsp;官方解释版本太老，已经不维护， 版本1.13,正式服docker需要更新，现在是17年版本了
 
* Cannot connect to the Docker daemon at tcp://0.0.0.0:2375. Is the docker daemon running
&emsp;&emsp;因为阿里云服务器进行yum update 所有软件，导致docker版本更新到 1.41 （20.10.12）导致之前的配置失效，从新`配置远程访问`

* ERROR: ZONE_CONFLICT: 'docker0' already bound to a zone  
&emsp;&emsp;因为阿里云服务器进行yum update 所有软件，导致docker版本更新到 1.41 （20.10.12）,更新防火墙设置。
参考文档：<https://www.cnblogs.com/wxbn/p/15057806.html>
    
    
```shell script
 # 1.检查firewall-cmd中是否存在docker zone 
 firewall-cmd --get-active-zones
 
 # 2.如果“docker”区域可用，将接口更改为 docker0（非持久化）
 sudo firewall-cmd --zone=docker --change-interface=docker0
 
 # 3.如果“docker”区域可用，请将接口更改为 docker0（持久化）
 sudo firewall-cmd --permanent --zone=docker --change-interface=docker0 
 sudo systemctl restart firewalld
 
 # 4.启动docker 
 systemctl  start  docker
 
 # 5。查看
 systemctl status docker
```

### docker中查看 java堆栈信息  
参考文档： http://t.zoukankan.com/duanxz-p-10238570.html
```shell script
# 1.查看容器id
docker ps

# 2.进入docker
docker exec -it 26612c5d62a2 /bin/sh

# 3.查看java进程
jps

# 4.输出堆栈信息
jstack 1
```

    
