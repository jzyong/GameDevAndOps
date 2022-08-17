# Nexus
Nexus 搭建公司内部maven私有仓库，便于公司内部包的版本管理，加速获取公共包。

### Nexus3 安装
参考文档：<https://hub.docker.com/r/sonatype/nexus3/#notes>  
```shell script
# 1.创建挂载目录
mkdir /data/nexus-data

# 2.运行镜像
docker run -d -p 8081:8081 --name nexus -v /data/nexus-data:/nexus-data sonatype/nexus3
```    


### 常见问题
#### 私有仓库上传snapshot jar包，项目检出snapshot jar类文件找不到问题  
参考文档：<https://segmentfault.com/a/1190000022068814>

1. 配置pom.xml 拉取最新jar包  
```xml
<repositories>
    <repository>
        <id>public</id>
        <url>http://192.168.0.1:8081/repository/maven-public/</url>
        <snapshots>
            <!-- 始终下载最新的 snapshot 包 ，因为协议消息在其他项目，时刻改变 -->
            <updatePolicy>always</updatePolicy>
        </snapshots>
    </repository>
</repositories>

```

2. jar 包运行，pom.xml设置项目打包插件  
```xml
<plugin>
 <groupId>org.apache.maven.plugins</groupId>
 <artifactId>maven-jar-plugin</artifactId>
 <version>3.2.0</version>
 <configuration>
     <archive>
         <manifest>
             <addClasspath>true</addClasspath>
             <classpathPrefix>lib/</classpathPrefix>
             <mainClass>com.game.gate.GateApp</mainClass>
             <!--配置可使用快照版本-->
             <useUniqueVersions>false</useUniqueVersions>
         </manifest>
     </archive>
 </configuration>
</plugin>
```  
    

     
### maven setting.xml 镜像配置错误导致拉取不到存在的jar包问题
参考文档： https://segmentfault.com/q/1010000019941502/a-1020000019941560  
```xml
 <mirror>
        <id>public</id>
        <mirrorOf>*</mirrorOf>
        <name>central repository</name>
        <url>http://192.168.0.1:80/repository/maven-public/</url>
    </mirror> 
```
mirrorOf 最开始配置问`central`，导致上传到snapshot库中的jar包无法下载，改为`*`问题解决

