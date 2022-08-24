# Redis

## 安装
### Docker安装
参考文档： <https://hub.docker.com/_/redis/?tab=description&page=1&ordering=last_updated>  
```shell script
# 1. 创建挂载目录
cd data
mkdir redis

# 2. 拉取镜像并运行 
docker run --name redis-5.0.12 --restart=always -p 6379:6379 -v /data/redis:/data -d redis:5.0.12 redis-server --appendonly yes --requirepass 123456
```
    
### CentOS7安装
参考文档：<https://www.cnblogs.com/heqiuyong/p/10463334.html>  
* 安装路径： `/usr/local/redis`
* 配置|命令路径：`/usr/local/redis/bin`
* 数据|日志路径：`/data/redis`
* [redis.conf](Redis/redis.conf) 修改内容


#### 每日备份  
参考文档：<https://blog.csdn.net/Junetest/article/details/104796142/>  
* [脚本地址](Redis/backup.sh)：`/data/redis/backup.sh`  
* 日志路径：`/var/spool/mail/root`
```shell script
 # 1.编辑脚本
 cd /data/redis
 vim backup.sh
     #! /bin/bash
     PATH=/usr/local/redis/bin:$PATH
     redis-cli -p 6379 bgsave
     date=$(date +"%Y%m%d")
     cp /data/redis/dump.rdb /data/redis/backup/dump$date.rdb
     echo " 备份完成!"
     DAYS=7
     find /data/redis/backup/ -mtime +$DAYS -delete #删除7天前的备份文件
     echo "删除7天前数据备份完成！"
 chmod +x backup.sh

# 2.添加定时任务,每天凌晨两点半备份
crontab -e
  30 2 * * * sh /data/redis/backup.sh
crontab -l
```

#### 将备份数据赋值到另外一台主机
详细操作参考： [mongodb备份](MongoDB.md)/将备份数据赋值到另外一台主机  

##### 备份端配置 
```shell script
# 1.编辑服务器配置，末尾添加
vim /etc/rsyncd.conf
   #以下是全局配置
   [redisbackup]
   comment = sync rsync/data/redis/backup
   path = /data/redis/backup
   gid = root
   max connections = 10
   auth users = root
   secrets file = /etc/rsyncd.pass
   hosts allow = 172.31.49.33,127.0.0.1
   timeout = 600

 # 2.创建备份目录
mkdir /data/redis/backup
chown -R nobody:nobody /data/redis/backup

# 3.启动服务器 重启时记得删除rsyncd.pid：‘rm -rf /var/run/rsyncd.pid’
rsync --daemon --config=/etc/rsyncd.conf
```     


##### redis安装端
```shell script
# 1.同步目录测试
rsync -auvrtzopgP --progress --password-file=/etc/rsync_client.pwd /data/redis/backup root@172.31.55.20::redisbackup

# 2.回到 每日备份 在backeup.sh中添加如下代码
rsync -auvrtzopgP --progress --password-file=/etc/rsync_client.pwd /data/redis/backup/dump$date.rdb root@172.31.55.20::redisbackup
```


## 操作
### 常用系统命令  
```shell script
cd /usr/local/redis/bin/
# 1.查看redis状态
./redis-cli -p 6379 --stat	

# 2.查看统计最大键
./redis-cli --bigkeys -p 6379	

# 3.监控redis操作
./redis-cli -p 6379 monitor	

# 4.延迟测试
./redis-cli -p 6379 --latency	

# 5.历史延迟
./redis-cli -p 6379 --latency-history 

# 6.数据备份  https://blog.csdn.net/rentian1/article/details/93845092
./redis-cli -p 6379 --rdb /data/redis/backup/dump20201104.rdb	
```


   
### 性能测试  
参考文档：<https://redis.io/topics/benchmarks>    
```shell script
# 1.测试
./redis-benchmark -p 6379 -q -n 100000
    PING_INLINE: 82918.74 requests per second
    PING_BULK: 81900.09 requests per second
    SET: 80128.20 requests per second
    GET: 82304.52 requests per second
    INCR: 84317.03 requests per second
    LPUSH: 78678.20 requests per second
    RPUSH: 84961.77 requests per second
    LPOP: 84388.19 requests per second
    RPOP: 83194.67 requests per second
    SADD: 85543.20 requests per second
    HSET: 84674.01 requests per second
    SPOP: 83682.01 requests per second
    LPUSH (needed to benchmark LRANGE): 82576.38 requests per second
    LRANGE_100 (first 100 elements): 48828.12 requests per second
    LRANGE_300 (first 300 elements): 24576.06 requests per second
    LRANGE_500 (first 450 elements): 18484.29 requests per second
    LRANGE_600 (first 600 elements): 15130.88 requests per second
    MSET (10 keys): 69156.30 requests per second

# 2.测试
./redis-benchmark -p 6379 -r 1000000 -n 2000000 -t get,set,lpush,lpop -P 16 -q
    SET: 547195.62 requests per second
    GET: 893655.06 requests per second
    LPUSH: 672721.12 requests per second
    LPOP: 736106.00 requests per second

# 3.测试
./redis-benchmark -p 6379 -r 1000000 -n 2000000 -t get,set,lpush,lpop -q
    SET: 83329.86 requests per second
    GET: 82736.94 requests per second
    LPUSH: 84409.55 requests per second
    LPOP: 83710.03 requests per second
```


