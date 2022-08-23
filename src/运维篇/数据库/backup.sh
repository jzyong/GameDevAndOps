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
rsync -auvrtzopgP --progress --password-file=/etc/rsync_client.pwd $TAR_DIR/$TAR_BAK root@172.31.55.20::mongobackup #推送最新备份到主机2

