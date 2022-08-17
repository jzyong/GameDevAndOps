# Maven

### Maven安装
参考文档：<https://blog.csdn.net/djrm11/article/details/106340433>  
setting配置 [setting.xml](settings.xml)

```shell script
# 1.官网下注包上传到 data目录
tar -xzvf apache-maven-3.6.3-bin.tar.gz
  
# 2.设置环境变量，在profile末尾添加
vi /etc/profile
    MAVEN_HOME=/data/apache-maven-3.6.3
    export PATH=${MAVEN_HOME}/bin:${PATH}
source /etc/profile

# 3.设置jdk版本
cd /data/apache-maven-3.6.3/bin
vim mvn
    JAVA_HOME=/data/java/jdk-14.0.2
    
# 4.修改setting配置
```


        
