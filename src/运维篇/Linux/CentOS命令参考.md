# CentOS命令参考
&emsp;&emsp;主要记录常用的系统自带命令使用

## 系统资源
&emsp;&emsp;磁盘、CPU、内存、IO等常见命令使用。
游戏服务器程序可能出现死循环占用CPU；未正常释放对象占用过多内存或者内存一直飙升等问题；
存储数据，网路请求太多，消耗IO过高等问题。
### top命令

https://blog.csdn.net/xujiamin0022016/article/details/89072116

* P：以CPU的使用资源排序显示 
* M：以内存的使用资源排序显示 
* N：以pid排序显示 
* T：由进程使用的时间累计排序显示    

    
    # 1.查看指定进程 内存，cpu等信息
    top -p 2913

查看内存详细信息：  
https://blog.csdn.net/weixin_40584007/article/details/88847745  

    cat /proc/1308/status

## 文件操作
### tar解压缩  

    // 1.打包压缩目录
    tar -czvf kdnn_hall_20201209.tar.gz kdnn_hall_20201209121360/
    
###  目录文件操作  

    // 1.删除backups目录30天之前修改的文件
    find backups/ -mtime +30 -delete

### 系统日志命令
  /var/log/message 系统启动后的信息和错误日志，是Red Hat Linux中最常用的日志之一  
  /var/log/secure 与安全相关的日志信息  
  /var/log/maillog 与邮件相关的日志信息  
  /var/log/cron 与定时任务相关的日志信息  
  /var/log/spooler 与UUCP和news设备相关的日志信息  
  /var/log/boot.log 守护进程启动和停止相关的日志消息  
    
    
    # 显示所有日志：
    journalctl
    
    #查看启动只有的所有日志：
    journalctl -b
    
    #查看最后10条日志
    journalctl -n 10
    
    #跟踪日志：
    journalctl -f
    
    只显示冲突、告警和错误：journalctl -p err..alert

## 其他
### 时间修正
    # 正式服因为时区问题，经常跑块，时间修正命令：  
    date -s '2022-02-11 04:15:30'
    
### 批量关闭进程
    # 1.查询进程id
    ps -ef | grep slots-game | awk '{print "kill "$2}'
    

