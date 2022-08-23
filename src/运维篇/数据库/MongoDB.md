# MongoDB

## 安装
### Docker安装
参考文档：  
<https://www.runoob.com/docker/docker-install-mongodb.html>    
<https://hub.docker.com/_/mongo?tab=description>  

```shell script
 # 1. 运行镜像
docker run -itd --name mongo-3.6.23 -p 27017:27017 mongo:3.6.23 --auth

# 2. 进入容器创建账号
$ docker exec -it mongo-3.6.23 mongo admin
# 创建一个名为 admin，密码为 123456 的用户。
db.createUser({ user:'admin',pwd:'123456',roles:[ { role:'userAdminAnyDatabase', db: 'admin'},"readWriteAnyDatabase"]});
# 尝试使用上面创建的用户信息进行连接。
db.auth('admin', '123456')

# 3. 连接地址
mongodb://admin:123456@192.168.0.1:27017/?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&ssl=false

```

### CentOS7 安装&配置
参考文档：  
<https://docs.mongodb.com/v3.6/tutorial/install-mongodb-on-red-hat/>  

```shell script
# 1.设置安装源
vim /etc/yum.repos.d/mongodb-org-3.6.repo
    [mongodb-org-3.6]
    name=MongoDB Repository
    baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.6/x86_64/
    gpgcheck=1
    enabled=1
    gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc

# 2.安装
sudo yum install -y mongodb-org

# 3.启动
sudo systemctl start mongod

# 4.开机启动
sudo systemctl enable mongod

# 5.关闭|重启
sudo systemctl stop mongod
sudo systemctl restart mongod

# 连接
mongo --host 127.0.0.1:27017
```
    
#### 配置 Disable Transparent Huge Pages (THP)  
参考文档：<https://docs.mongodb.com/v3.6/tutorial/transparent-huge-pages/>

#### 配置文件[mongod.conf](mongod.conf)  
参考文档： <https://docs.mongodb.com/v3.6/administration/configuration/>   
&emsp;&emsp;外网访问和密码验证，文件路径`/etc/mongod.cnf`,添加修改如下内容：
```shell script
# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0  # Listen to local interface only, comment to listen on all interfaces.
#security:
security:
  authorization: enabled
``` 
#### 连接数设置  
官方推荐设置:<https://docs.mongodb.com/v3.6/reference/ulimit/#recommended-ulimit-settings>  
```shell script
-f (file size): unlimited
-t (cpu time): unlimited
-v (virtual memory): unlimited [1]
-l (locked-in-memory size): unlimited
-n (open files): 64000
-m (memory size): unlimited [1] [2]
-u (processes/threads): 64000
```


#### [每日备份](backup.sh)  
参考文档：<https://www.jb51.net/article/135847.htm>
```shell script
# 1.创建存储目录
cd /data
mkdir mongo
mkdir backup
mkdir backup/now
mkdir backup/list

# 2.编辑脚本
vim backup.sh
    #!/bin/sh
    OUT_DIR=/data/mongo/backup/now #临时备份目录
    TAR_DIR=/data/mongo/backup/list #备份存放路径
    DATE=`date +%Y_%m_%d` #获取当前系统时间
    DB_USER=root #数据库账号
    DB_PASS=123456 #数据库密码
    DAYS=7 #DAYS=7代表删除7天前的备份，即只保留最近7天的备份
    TAR_BAK="mongo_backup_$DATE.tar.gz" #最终保存的数据库备份文件名
    cd $OUT_DIR
    rm -rf $OUT_DIR/*
    mkdir -p $OUT_DIR/$DATE
    mongodump -u $DB_USER -p $DB_PASS -o $OUT_DIR/$DATE #备份全部数据库
    tar -zcvf $TAR_DIR/$TAR_BAK $OUT_DIR/$DATE #压缩为.tar.gz格式
    find $TAR_DIR/ -mtime +$DAYS -delete #删除7天前的备份文件

# 3.添加脚本执行权限
chmod +x backup.sh

# 4.添加定时任务,每天凌晨2点30进行备份
crontab -e
  30 2 * * * sh /data/mongo/backup.sh
crontab -l
```  
  
#### 将备份数据复制到另外一台主机
参考文档：<https://blog.csdn.net/gjwgjw1111/article/details/103515031> （有坑，不要在配置文件中加注释）   
数据库所在服务器1 每日定时将数据推送到服务器2

##### 备份主机2 
```shell script
# 1.查询rsync是否安装
rpm -qa rsync

# 2.创建备份目录
mkdir /data/mongo/backup
chown -R nobody:nobody /data/mongo/backup

# 3.编辑服务器配置文件，输入如下内容
vim /etc/rsyncd.conf
    #以下是全局配置
    log file = /var/log/rsyncd.log
    pid file = /var/run/rsyncd.pid
    lock file = /var/lock/rsyncd
    use chroot = yes
    read only = no
    [mongobackup]
       comment = sync rsync/data/mongo/backup
       path = /data/mongo/backup
       gid = root
       max connections = 10
       auth users = root
       secrets file = /etc/rsyncd.pass
       hosts allow = 172.31.49.33,127.0.0.1
       timeout = 600

# 4.创建认证文件，输入如下内容
vi /etc/rsyncd.pass
    root:123456
chmod 600 /etc/rsyncd.pass
vim /etc/xinetd.d/rsync
    service rsync
    {
            disable = no
            socket_type = stream
            wait = no
            user = root
            server = /usr/bin/rsync
            server_args = --daemon
            log_on_failure += USERID
    }

# 5.启动服务器 重启时记得删除rsyncd.pid：‘rm -rf /var/run/rsyncd.pid’
rsync --daemon --config=/etc/rsyncd.conf

# 6.开启端口，防火墙设置
sudo firewall-cmd --zone=public --add-port=873/tcp --permanent
```   


 
##### mongodb安装端
```shell script
# 1.创建账号密码
vi /etc/rsync_client.pwd
    123456
chmod 600 /etc/rsync_client.pwd

# 2.同步目录测试
rsync -auvrtzopgP --progress --password-file=/etc/rsync_client.pwd /data/mongo/backup/list root@172.31.55.20::mongobackup

# 3.回到 每日备份 在backup.sh中添加如下代码
rsync -auvrtzopgP --progress --password-file=/etc/rsync_client.pwd $TAR_DIR/$TAR_BAK root@172.31.55.20::mongobackup

```

#### 自动删除备份数据
```shell script
# 1.创建备份文件 redis、mongodb一样，只是路径不同
touch delete_backup.sh
chmod 754 delete_backup.sh
vim delete_backup.sh
    #!/bin/sh
    find /data/mongo/backup/ -mtime +30 -delete

# 2.删除30天前的备份文件pw
crontab -e
   30 2 * * * sh /data/mongo/delete_backup.sh
   35 2 * * * sh /data/redis/delete_backup.sh
crontab -l
```
## 命令操作
### 账号密码  
参考文档：  
<https://www.jianshu.com/p/d21cdf929a2e>    
<https://docs.mongodb.com/v3.6/tutorial/enable-authentication/>   

```shell script
# 1.创建管理员账号
use admin
db.createUser(
  {
    user: "root",
    pwd: "123456",
    roles: [
       { role: "userAdminAnyDatabase", db: "admin" }
    ]
  }
)

# 2.登录
db.auth('root','123456')
mongo -u root -p 123456


# 3.授权
 db.grantRolesToUser(
    "root",
    [
        { role: "root", db: "admin" },
    ]
)
db.grantRolesToUser("root",[{role:"readWrite",db:"common"}])

# 4.读写权限账号
db.createUser(
  {
    user: "admin",
    pwd: "123456",
    roles: [
       { role: "readWriteAnyDatabase", db: "admin" }
    ]
  }
)
db.auth('admin','123456')

# 5.查看权限账号
db.createUser(
  {
    user: "read",
    pwd: "123456",
    roles: [
       { role: "readAnyDatabase", db: "admin" }
    ]
  }
)

# 6.数据库权限账号
db.createUser({user:"hall",pwd:"123456",roles:[{role:"readWrite",db:"game-hall"}]})

# 7.删除用户
db.dropUser("slots")
```


###  性能统计设置 
参考文档：<https://docs.mongodb.com/v3.6/tutorial/manage-the-database-profiler/#database-profiling-view-status>
```shell script
db.setProfilingLevel(1)
# 最近10条慢操作
db.system.profile.find().limit(10).sort( { ts : -1 } ).pretty()
```

### 数据备份还原
参考文档：  
<https://docs.mongodb.com/v3.6/tutorial/backup-and-restore-tools/>  
<https://www.cnblogs.com/clsn/p/8244206.html>  

```shell script
# 1.备份
cd /data/mongo/backup
mkdir 2020****
cd 2020****
mongodump --username root --password 123456
#显示备份目录大小
du -h --max-depth=1 /data/mongo/backup/    

# 2.数据还原
mongorestore --host mongodb1.example.net --port 3017 --username user --password 'pass' /opt/backup/mongodump-2013-10-24
mongorestore -h 172.31.49.33:27017 -uroot -p123456 --authenticationDatabase admin -d game-hall -c club /data/mongo/backup/now/2022_01_07/game-hall/club.bson
```

### 常用命令  
```shell script
# 1.查询 昵称包含指定字符串，显示指定字段
db.role.find({"nick":{$regex:"Helen"}},{nick:1,rid:1,gold:1})
db.player.find({"level":{"$gte":50}},{_id:1,nick:1,level:1})

# 2.查询所有注册人数
db.getCollection('role').find({"roleType":0}).count({})

# 3.查询平台充值总和
db.billing_order.aggregate([
   { $match: { status: 200 } },
   { $group: { _id: "$platform", total: { $sum: "$price" } } }
])

# 4.查询总注册人数
db.role.aggregate([
   { $group: { _id: "$roleType", count: { $sum: 1 } } }
])

# 5.查询最近时间段登录人数
db.role.aggregate([
   { $match: { lastLoginTime: {"$gt":ISODate("2021-01-01T00:00:01.303Z")} } },
   { $group: { _id: "$roleType", count: { $sum: 1 } } }
])
db.role.aggregate([
   { $match: { registerTime: {"$lt":ISODate("2021-01-08T00:00:01.303Z"),"$gt":ISODate("2021-01-07T00:00:01.303Z")} } },
   { $group: { _id: "$roleType", count: { $sum: 1 } } }
])

# 6.查询人数大于10的公会
db.club.aggregate([
    {$project:{memberCount:{$size:"$memberIds"}}},
    {$match:{memberCount: {$gte:10}}}
 ]).itcount()

# 7.模糊查询
{"nick":{$regex:/^.*emp.*$/i}}

# 8.删除
db.config_board.deleteMany({"type":2})

# 9.数组大小查询
{"firstEnter":true,"refreshTime":{"$gt":1646024300450},"pushCoin.levelEntries":{"$exists":true},"$where": "this.pushCoin.levelEntries.length>1" }

# 10.查看可用连接
db.serverStatus().connections

# 11.查询性能分析
db.account.find({"rid":1000037}).explain("executionStats")

# 12.创建索引
db.account.createIndex( { "accountName" : 1 } )
```
