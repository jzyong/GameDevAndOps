# Git

### 安装
```shell script
# 1.安装
yum install -y git

# 2.查看版本
git version
```

### 命令
```shell script

# 1.添加全部&目录
git add .
git add Assets/Scripts

# 2.提交 
git commit -m "初始化提交"

# 3.推送
git push -u origin develop 

# 4.取消提交
git reset @~
```

## 常见问题
### 1.Git Push remote: fatal: pack exceeds maximum allowed size
* 取消提交 `git reset @~`,提交少量文件，再推送
* 如果使用gitlab，可以到管理后台修改最大推送文件限制

