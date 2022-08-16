# Gitlab
&emsp;&emsp; Gitlab是开源的仓库管理系统，在Git基础上添加了Web服务，类似Github，使用非常方便，因此公司内部自行搭建了Gitlab。

### gitlab命令
参考文档：<https://docs.gitlab.com/ee/administration/raketasks/maintenance.html#check-gitlab-configuration>  
```shell script
# 1.查看系统信息和gitlab信息
sudo gitlab-rake gitlab:env:info

# 2.检查配置
sudo gitlab-rake gitlab:check

# 3.数据迁移检测
sudo gitlab-rake db:migrate:status
```

### gitlab升级
参考文档：  
<https://docs.gitlab.com/ee/update/plan_your_upgrade.html>
<https://docs.gitlab.com/ee/update/package/>  
<https://docs.gitlab.com/ee/update/index.html#upgrade-paths>  
```shell script
# 1.查看可用版本包
yum --showduplicates list gitlab-ee

# 2.更新到指定版本，gitlab必须一步一步的更新到最新版本，中间版本不能跳过
yum install gitlab-ee-13.8.8-ee.0.el7
yum install gitlab-ee-13.12.15-ee.0.el7
yum install gitlab-ee-14.0.12-ee.0.el7
yum install gitlab-ee-14.6.2-ee.0.el7
```    

    
升级错误问题：  
安装官方路径 yum install gitlab-ee-14.0.12-ee.0.el7 升级到 yum install gitlab-ee-14.6.2-ee.0.el7 报错  
参考文档：<https://docs.gitlab.com/ee/user/admin_area/monitoring/background_migrations.html#database-migrations-failing-because-of-batched-background-migration-not-finished>

```shell script
# 1.重新加载配置
sudo gitlab-ctl reconfigure

# 2.重新迁移数据库
sudo gitlab-rake db:migrate
```





