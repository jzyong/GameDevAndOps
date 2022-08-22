# Jenkins


### 安装
参考文档：  
<https://pkg.jenkins.io/redhat-stable/>  
<https://www.jianshu.com/p/368685768680>   

```shell script
# 1.安装
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum install jenkins
# 2.配置启动 
vi /etc/sysconfig/jenkins
   JENKINS_PORT=40015
   JENKINS_JAVA_OPTIONS="-server -Xms1024m -Xmx2048m -XX:PermSize=256m -XX:MaxPermSize=512m -Djava.awt.headless=true"
chkconfig jenkins on
service jenkins start
```     
   
* 错误处理：AWT is not properly configured on this server
https://blog.csdn.net/qq_44959735/article/details/104363491

* mvn 命令无法识别问题  
https://www.jianshu.com/p/993ffb82ee0e

### Windows 编码设置
&emsp;&emsp;进入 `E:\Program Files\Jenkins` 在jenkins.xml中设置启动参数 ` -Dfile.encoding=UTF-8`



TODO 结合docker进行流程介绍 
