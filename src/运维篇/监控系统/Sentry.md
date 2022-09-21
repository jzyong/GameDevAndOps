# Sentry
&emsp;&emsp;提供错误日志查询，预警，文档参考：<https://docs.sentry.io/product/>

## 安装
&emsp;&emsp;官网只看见linux docker-compose安装教程，而且对docker和docker-compose有要求，sentry服务太多，较耗内存。安装脚本[下载](https://github.com/getsentry/self-hosted/releases) ,参考文档：  
<https://github.com/getsentry/self-hosted/releases>  
<https://develop.sentry.dev/self-hosted/>
```shell script
# 1.解押及安装
mkdir /data/sentry
unzip self-hosted-22.8.0.zip
cd self-hosted-22.8.0
./install.sh

# 2.启动 访问地址：<http://127.0.0.1:9000/>
docker-compose up -d

# 3.停止
docker-compose down
```


