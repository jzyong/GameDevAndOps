#! /bin/bash
PATH=/usr/local/redis/bin:$PATH
redis-cli -p 6379 bgsave
date=$(date +"%Y%m%d")
cp /data/redis/dump.rdb /data/redis/backup/dump$date.rdb
echo " 备份完成!"

DAYS=7
find /data/redis/backup/ -mtime +$DAYS -delete #删除7天前的备份文件
echo "删除7天前数据备份完成！"

rsync -auvrtzopgP --progress --password-file=/etc/rsync_client.pwd /data/redis/backup/dump$date.rdb root@172.31.55.20::redisbackup
echo "同步备份到主机2"


