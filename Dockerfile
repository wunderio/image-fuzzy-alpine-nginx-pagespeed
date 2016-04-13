FROM alpine:3.3

ENV NGINX_VERSION 1.9.14
ENV PAGESPEED_VERSION 1.11.33.0-beta

RUN build_pkgs="build-base linux-headers openssl-dev pcre-dev wget zlib-dev subversion git patch bash gperf python" && \
    runtime_pkgs="ca-certificates openssl pcre zlib" && \
    apk --no-cache --update add ${build_pkgs} ${runtime_pkgs} && \
    mkdir -p /tmp/src/mod_pagespeed/src && \
    cd /tmp/src && \
    wget https://sourceforge.net/projects/libpng/files/libpng12/1.2.56/libpng-1.2.56.tar.xz/download\?use_mirror\=tenet\&r\=https%3A%2F%2Fsourceforge.net%2Fprojects%2Flibpng%2Ffiles%2Flibpng12%2F1.2.56%2F\&use_mirror\=tenet\# -O libpng-1.2.56.tar.xz && \
    tar -Jxf libpng-1.2.56.tar.xz && \
    wget https://github.com/pagespeed/ngx_pagespeed/archive/v${PAGESPEED_VERSION}.tar.gz && \
    tar -zxvf v${PAGESPEED_VERSION}.tar.gz && \
    svn co https://src.chromium.org/svn/trunk/tools/depot_tools && \
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -zxvf nginx-${NGINX_VERSION}.tar.gz && \
    cd /tmp/src/mod_pagespeed && \
    git clone https://github.com/pagespeed/mod_pagespeed.git src
RUN cd /tmp/src/libpng-1.2.56 && \
    ./configure --prefix=/usr --disable-static && make && make install
RUN export PATH=$PATH:/tmp/src/depot_tools && \
    cd /tmp/src/mod_pagespeed && \
    export GYP_DEFINES="use_system_libs=1 _GLIBCXX_USE_CXX11_ABI=0 use_system_icu=1" && \
    gclient config https://github.com/pagespeed/mod_pagespeed.git --unmanaged --name=src && \
    cd src/ && \
    git checkout 1.11.33.0 && \
    gclient sync --force --jobs=1 && \
    wget https://github.com/pagespeed/ngx_pagespeed/files/195988/psol-chromium.stacktrace.patch.txt && \
    patch third_party/chromium/src/base/debug/stack_trace_posix.cc < psol-chromium.stacktrace.patch.txt && \
    make BUILDTYPE=Release CXXFLAGS=" -I/usr/include/apr-1 -I/tmp/src/libpng-1.2.56 \
    -fPIC -D_GLIBCXX_USE_CXX11_ABI=0" CFLAGS=" -I/usr/include/apr-1 \
    -I/tmp/src/libpng-1.2.56 -fPIC -D_GLIBCXX_USE_CXX11_ABI=0"
RUN cd /tmp/src/mod_pagespeed/src/pagespeed/automatic && \
    sed -i '/apr\/libapr.a/d' Makefile && \
    sed -i '/aprutil\/libaprutil.a/d' Makefile && \
    sed -i '/libjpeg_turbo/d' Makefile && \
    sed -i '/libpng\/libpng.a/d' Makefile && \
    sed -i '/icu\/libi/d' Makefile && \
    sed -i '/libpng\/libpng.a/d' Makefile && \
    sed -i '/serf\/libopenssl.a/d' Makefile && \
    sed -i '/zlib\/libzlib.a/d' Makefile && \
    make all BUILDTYPE=Release CXXFLAGS=" -I/usr/include/apr-1 -I/tmp/src/libpng-1.2.56 \
    -fPIC -D_GLIBCXX_USE_CXX11_ABI=0" CFLAGS=" -I/usr/include/apr-1 \
    -I/tmp/src/libpng-1.2.56 -fPIC -D_GLIBCXX_USE_CXX11_ABI=0"
RUN cd /tmp/src/nginx-${NGINX_VERSION} && \
    MOD_PAGESPEED_DIR="/tmp/src/mod_pagespeed/src" ./configure \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --with-file-aio \
        --with-http_v2_module \
        --without-http_autoindex_module \
        --without-http_browser_module \
        --without-http_geo_module \
        --without-http_map_module \
        --without-http_memcached_module \
        --without-http_userid_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module \
        --without-http_split_clients_module \
        --without-http_uwsgi_module \
        --without-http_scgi_module \
        --without-http_referer_module \
        --without-http_upstream_ip_hash_module \
        --prefix=/etc/nginx \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --sbin-path=/usr/local/sbin/nginx \
        --add-module=/tmp/src/ngx_pagespeed-${NGINX_VERSION}/ && \
    make && \
    make install && \
    apk del ${build_pkgs} && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

VOLUME ["/var/log/nginx"]

WORKDIR /etc/nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]