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


        
## 二、nexus3 安装
参考：https://hub.docker.com/r/sonatype/nexus3/#notes  
    
    # 1.创建挂载目录
    mkdir /data/nexus-data
    
    # 2.运行镜像
    docker run -d -p 40016:8081 --name nexus -v /data/nexus-data:/nexus-data sonatype/nexus3
    

## 三、常见问题
* 私有仓库上传snapshot jar包，项目检出snapshot jar类文件找不到问题
 参考文档：https://segmentfault.com/a/1190000022068814

1. 配置pom.xml 拉取最新jar包  

       <repositories>
            <repository>
                <id>public</id>
                <url>http://47.108.13.34:40016/repository/maven-public/</url>
                <snapshots>
                    <!-- 始终下载最新的 snapshot 包 ，因为协议消息在其他项目，时刻改变 -->
                    <updatePolicy>always</updatePolicy>
                </snapshots>
            </repository>
        </repositories>

2. jar 包运行，pom.xml设置项目打包插件  
    
    
      <plugin>
         <groupId>org.apache.maven.plugins</groupId>
         <artifactId>maven-jar-plugin</artifactId>
         <version>3.2.0</version>
         <configuration>
             <archive>
                 <manifest>
                     <addClasspath>true</addClasspath>
                     <classpathPrefix>lib/</classpathPrefix>
                     <mainClass>com.dls.slots.gate.GateApp</mainClass>
                     <!--配置可使用快照版本-->
                     <useUniqueVersions>false</useUniqueVersions>
                 </manifest>
             </archive>
         </configuration>
     </plugin>
     
* maven setting.xml 镜像配置错误导致拉取不到存在的jar包问题
参考文档： https://segmentfault.com/q/1010000019941502/a-1020000019941560  

mirrorOf 最开始配置问`central`，导致上传到snapshot库中的jar包无法下载，改为`*`问题解决

