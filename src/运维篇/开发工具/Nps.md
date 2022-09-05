# Nps
&emsp;&emsp;Nps内网穿透工具，可以实现外网连接公司电脑进行办公，特别是疫情期间居家办公和线上问题处理。

## 搭建
参考文档：  
<https://blog.csdn.net/qq_41225906/article/details/125888457>  
<https://ehang-io.github.io/nps/#/>
```shell script
# 1.服务器搭建
# 1.1 下载
cd /data
mkdir nps
cd nps
wget https://github.com/ehang-io/nps/releases/download/v0.26.10/linux_amd64_server.tar.gz
tar -xzvf linux_amd64_server.tar.gz
# 1.2安装，启动，关闭
./nps install
nps start
nps stop

# 2.进入网页后台进行配置，创建用户，TCP隧道

# 3.Windows 连接服务器
npc.exe -server=127.0.0.1:8024 -vkey=7fx8smcst1cp0rw3 -type=tcp
# 3.1注册服务，运行，停止
npc.exe install -server=127.0.0.1:8024 -vkey=7fx8smcst1cp0rw3 -type=tcp
npc.exe start
npc.exe stop

# 4.远程连接地址
mstsc
127.0.0.1:8888     
```
