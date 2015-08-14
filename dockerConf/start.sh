#!/bin/bash

# 设置时区
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 启动php-fpm
php5-fpm

# 启动nginx
nginx -g "daemon off;"
