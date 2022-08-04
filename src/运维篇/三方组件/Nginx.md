# Nginx

### 10. Nginx安装
安装参考：http://nginx.org/en/linux_packages.html
    配置路径：`/etc/nginx/`
    [正式服配置](nginx/aws/正式服nginx配置.md)

    //安装前置软件
    sudo yum install yum-utils

    vim /etc/yum.repos.d/nginx.repo

    [nginx-stable]
    name=nginx stable repo
    baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true

    [nginx-mainline]
    name=nginx mainline repo
    baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
    gpgcheck=1
    enabled=0
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true

    # 安装
    sudo yum install nginx

    # 退出
    nginx -s quit
    service nginx stop
    # 启动
    nginx
    service nginx start
    # 重载配置
    nginx -s reload
    sudo systemctl reload nginx
    # 重启
    nginx -c /etc/nginx/nginx.conf
