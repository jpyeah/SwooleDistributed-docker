FROM  ubuntu:16.04
MAINTAINER yafei

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list 
RUN sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt-get update
WORKDIR /app
#COPY ./develop /app
RUN mkdir -p /app/src

#安装必备组件
RUN apt-get install -y unzip make gcc redis-server

RUN  apt-get install -y software-properties-common

RUN  LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && apt-get update && apt-cache search php7

RUN apt-get install -y php7.1-cli php7.1-dev php7.1-mbstring php7.1-bcmath php7.1-zip php-redis php7.1-mysql

#安装php
#RUN apt-get install -y php7.0-cli php7.0-dev php7.0-mbstring php7.0-bcmath php7.0-zip php-redis php7.0-mysql


#安装hiredis扩展
RUN cd /app/src/ \
    && curl -fsSL 'https://github.com/redis/hiredis/archive/v0.13.3.tar.gz' -o hiredis.tar.gz \
    && mkdir -p hiredis \
    && tar -xf hiredis.tar.gz -C hiredis --strip-components=1 \
    && cd hiredis && make && make install && ldconfig

#安装swoole扩展
RUN cd /app/src/ \
    && curl -fsSL 'https://github.com/swoole/swoole-src/archive/v1.9.18.tar.gz' -o swoole-src.tar.gz \
    && mkdir -p swoole-src \
    && tar -xf swoole-src.tar.gz -C swoole-src --strip-components=1 \
    &&  cd swoole-src && phpize \
    && ./configure --enable-async-redis  --enable-openssl \
    && make clean && make && make install && echo "extension=swoole.so" >> /etc/php/7.1/cli/php.ini

#安装inotify扩展
# RUN cd /app/src/  \
#     && curl -fsSL 'http://pecl.php.net/get/inotify-2.0.0.tgz' -o inotify.tgz \
#     && mkdir -p inotify \
#     && tar -xf inotify.tgz -C inotify --strip-components=1 \
#     &&  cd inotify && phpize \
#     && ./configure  \
#     && make clean && make && make install && echo "extension=inotify.so" >> /etc/php/7.0/cli/php.ini

RUN pecl install inotify \
	&& pecl install redis \
	&& cd /etc/php/7.1/cli/conf.d \
	#&& echo extension=redis.so>redis.ini \
	&& echo extension=inotify.so>inotify.ini


#安装 consul

# RUN cd /app/src/  \
#     && curl -fsSL 'https://releases.hashicorp.com/consul/0.9.0/consul_0.9.0_linux_amd64.zip' -o consul.zip \
#     && unzip consul.zip \
#     && mv consul /usr/local/bin/

#安装 composer
RUN curl -sS https://install.phpcomposer.com/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 安装redis
# RUN apt-get install -y redis-server && service redis-server start && update-rc.d redis-server defaults

#安装 为服务框架
#RUN  cd /app/code/ &&  unzip SwooleDistributed-2.1.4.zip &&  cd SwooleDistributed-2.1.4 \
#&& composer config repo.packagist composer https://packagist.phpcomposer.com && composer install  \
#&& cd /app/code/SwooleDistributed-2.1.4/src/bin

 #执行启动命令
 # php start_swoole_server.php start

#CMD [ "php", "/app/sd/bin/server.php start" ]

#打包后删除无用文件
RUN  apt-get autoremove && rm -rf /app/src &&  rm -rf /var/lib/apt/lists/*;
