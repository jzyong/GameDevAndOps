# Skywalking
&emsp;&emsp;监控java 进程信息，elasticsearch apm 有类似功能，但是只支持到了jdk11。

## 安裝
    
```shell script
# 1.下载
cd /data/
wget https://archive.apache.org/dist/skywalking/8.7.0/apache-skywalking-apm-es7-8.7.0.tar.gz
tar -xzvf apache-skywalking-apm-es7-8.7.0.tar.gzrm
rm -rf apache-skywalking-apm-es7-8.7.0.tar.gz

# 2.配置 数据存储为elasticsearch
cd apache-skywalking-apm-bin-es7/config
vim application.yml
    storage:
    selector: ${SW_STORAGE:elasticsearch7}
    
    elasticsearch7:
      nameSpace: ${SW_NAMESPACE:""}
      clusterNodes: ${SW_STORAGE_ES_CLUSTER_NODES:127.0.0.1:9000}
      
  # 3.配置web查看端口
  cd  apache-skywalking-apm-bin-es7/webapp
  vim webapp.yml
  
      server:
        port: 9001
        
  # 4.启动
  cd apache-skywalking-apm-bin-es7/bin
  ./startup.sh
```
     
    
## Java docker agent 配置   
参考：<https://blog.csdn.net/gre_999/article/details/101726367>  

见项目dockerfile文件和docker启动脚本


## 常见问题
### 1.谷歌浏览器不显示仪表盘数据
    清除缓存，或者换个浏览器，使用Edge
