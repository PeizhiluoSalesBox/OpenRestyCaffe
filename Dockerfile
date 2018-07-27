FROM caffe:gpu
#FROM daocloud.io/geyijun/caffe:v0.01
#MAINTAINER peizhiluo007<25159673@qq.com>
MAINTAINER geyijun<geyijun@xiongmaitech.com>

#安装supervisor
RUN apt-get update && apt-get install -y --no-install-recommends \
    supervisor  \
    automake    \
    curl        \
    unzip       \
    perl        \
    libpcre3    \
    libpcre3-dev \
    zlib1g      \
    zlib1g.dev  \
    openssl     \
    libssl-dev   \
    libtool && \
    rm -rf /var/lib/apt/lists/*

#安装openresty
COPY resty/ /root/resty/
COPY geoip-api-c-master.zip /root/
COPY ngx_openresty-1.9.3.1.tar.gz /root/
RUN set -x \
 && cd /root \
 && echo "==> Install geoip..." \ 
 && unzip geoip-api-c-master.zip	\
 && cd geoip-api-c-master	\
 && chmod 777 ./bootstrap	&& ./bootstrap	&& ./configure && make && make install	\
 && echo '/usr/local/lib' > /etc/ld.so.conf.d/geoip.conf && ldconfig  \
 && cd /root \
 && echo "==> Downloading OpenResty..." \
#&& wget http://openresty.org/download/ngx_openresty-1.9.3.1.tar.gz \
 && tar -zxvf ngx_openresty-1.9.3.1.tar.gz	\
 && cd ngx_openresty-1.9.3.1 	\
 && echo "==> Configuring OpenResty..." \
 && ./configure \
    --with-luajit \
    --with-pcre-jit \
    --with-http_geoip_module \
    --without-http_ssi_module \
    --without-http_userid_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module  \
 && echo "==> Building OpenResty..." \
 && make \
 && echo "==> Installing OpenResty..." \
 && make install \
 && echo "==> Finishing..." \
 && cd .. && pwd && ls -l \
 && cp -rfp /root/resty/*  /usr/local/openresty/lualib/resty/	\
 && rm -rf /root/ngx_openresty*	\
 && rm -rf -R /root/geoip-api-c-master \  
 && rm -rf /root/geoip-api-c-master.zip	\ 
 && ln -s /usr/local/openresty/nginx/sbin/nginx /usr/bin/nginx

#安装一些基本工具
COPY common_lua/ /xm_workspace/xmcloud3.0/common_lua/
COPY config_lua/ /xm_workspace/xmcloud3.0/config_lua/

#安装时区，设置容器为北京时间
#RUN apk add tzdata 
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 
RUN echo "Asia/Shanghai" > /etc/timezone

