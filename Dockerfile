FROM daocloud.io/library/ubuntu:latest

# 安装add-apt-repository工具
RUN apt-get update && apt-get -y install software-properties-common --fix-missing

# 安装apt-fast
RUN add-apt-repository ppa:saiarcot895/myppa && apt-get update && apt-get -y install apt-fast

RUN locale-gen en_US.UTF-8 && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php5-5.6 && apt-get update && apt-get -y upgrade
RUN apt-get -y install php5-dev php5-cli php5 php5-mongo php5-fpm php5-mysql php5-mcrypt php5-curl php5-imagick php5-common php5-redis gcc libpcre3-devo libmcrypt-dev libz-dev --fix-missing \
    && apt-get clean \
    && apt-get autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/list/* /tmp/* /var/tmp/* \
    && curl -sS https://getcomposer.org/installer \
            | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./dockerConf/php-fpm.conf /etc/php5/fpm/php-fpm.conf
COPY ./dockerConf/www.conf /etc/php5/fpm/pool.d/www.conf

COPY ./dockerConf/cphalcon /root/cphalcon
RUN cd  /root/cphalcon/build && ./install && rm -rf /root/cphalcon
COPY ./dockerConf/z-phalcon.ini /etc/php5/mods-available/z-phalcon.ini
RUN ln -s /etc/php5/mods-available/z-phalcon.ini /etc/php5/fpm/conf.d/z-phalcon.ini
RUN ln -s /etc/php5/mods-available/z-phalcon.ini /etc/php5/cli/conf.d/z-phalcon.ini

# 安装nginx
RUN apt-get -y nginx --fix-missing
COPY ./dockerConf/phalcon_nginx.conf /etc/nginx/conf.d/phalcon_nginx.conf
COPY ./dockerConf/nginx.conf /etc/nginx/nginx.conf

RUN sed -i "s/display_errors\ =\ Off/display_errors\ =\ On/g" /etc/php5/fpm/php.ini && sed -i "s/display_errors\ =\ Off/display_errors\ =\ On/g" /etc/php5/cli/php.ini

COPY ./dockerConf/start.sh /root

RUN mkdir /app
VOLUME /app

WORKDIR /root

EXPOSE 80

CMD ["/bin/sh", "/root/start.sh"]
