# SwooleDistributed-docker

基于https://github.com/yafei236/SwooleDistributed-docker 项目进行改进

## 基于 ubuntu:16.04

### 本项目适用于 sd 新手 用于开发环境
```
docker build -t sd:static .
```
注意上面代码的 . 符合不要漏掉 .

```
docker run -p 8081:8081 -v /usr/local/var/www/sd-static/app:/app/sd  -t -i sd:static /bin/bash 

```
进入之后执行
```
composer install
php vendor/tmtbe/swooledistributed/src/Install.php
```
第一次点Y 确认创建项目
第二次点N 不安装consul

修改 sd\src\config\redis.php
redis ip 和 密码

$config['redis']['local']['ip'] = 'localhost';
//$config['redis']['local']['password'] = '123456';

```
cd bin
service redis-server restart 
php start_swoole_server.php start

```
测试成功方法
http://localhost:8081/TestController/test
http://127.0.0.1:8081/
http://localhost:8081/

## Ubuntu 安装php7.1

更新本机内置程序
```
apt-get update

apt-get upgrade

```
安装 add-apt-repository 命令 （注意在docker环境中要加 -y）
```
apt-get install -y software-properties-common

```
更新php的源 查看php7源(自行选择7.1 & 7.2) 安装PHP
```
add-apt-repository ppa:ondrej/php

apt-get update

apt-cache search php7 

apt-get install  -y php7.1-cli php7.1-dev php7.1-mbstring php7.1-bcmath php7.1-zip php-redis php7.1-mysql

```