# Nginx

## 安装
安装参考：<http://nginx.org/en/linux_packages.html>
    配置路径：`/etc/nginx/`

```shell script
# 1.安装前置软件
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

# 2.安装
sudo yum install nginx

# 3.退出
nginx -s quit
service nginx stop
# 4.启动
nginx
service nginx start
# 5.重载配置
nginx -s reload
sudo systemctl reload nginx
# 6.重启
nginx -c /etc/nginx/nginx.conf
```

## 配置
### 文件下载
```shell script
# 1.创建目录文件
mkdir /data/download
 
# 2.配置download.conf
vim download.conf
   server {
       listen       8012;
       listen  [::]:8012;
       auth_basic           "input password";
       auth_basic_user_file /etc/nginx/conf.d/password;
       location ^~ /download/ {
          #需要下载的文件存放的目录
           alias  /data/download/;
           sendfile on;
           autoindex on;  # 开启目录文件列表
           autoindex_exact_size on;  # 显示出文件的确切大小，单位是bytes
           autoindex_localtime on;  # 显示的文件时间为文件的服务器时间
           charset utf-8,gbk;  # 避免中文乱码
       }
   }
 
# 3.加载配置
nginx -s reload
```

## 常见问题

* **bind() to 0.0.0.0:XXXX failed (13: Permission denied)**  
```
# 1.查看http可访问端口
semanage port -l | grep http_port_t
# 2.设置http访问端口
semanage port -a -t http_port_t  -p tcp 8090
```    
参考：<https://blog.csdn.net/cbmljs/article/details/88574122>

代理和被代理端口都需要设置

* **recv() failed (104: Connection reset by peer) while reading response header from upstream, client:**
 game-manage 项目docker端口映射错误，导致不能访问
 
 * **502 no live upstreams while connecting to upstream**
 大厅报错，未正常返回数据，导致nginx连接耗尽  
 配置 `keepalive 256;` 共用长链接  
 参考：<https://blog.csdn.net/donkeyboy001/article/details/119548514>
