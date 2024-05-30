FROM nginx:latest

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpcre3 libpcre3-dev \
    libxml2 libxml2-dev \
    libyajl-dev \
    libgeoip-dev \
    zlib1g-dev \
    libssl-dev \
    git \
    curl \
    wget \
    automake \
    libtool \
    pkgconf \
    ca-certificates \
    tar \
    unzip

# Instalar ModSecurity
RUN git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity /modsecurity && \
    cd /modsecurity && \
    git submodule init && \
    git submodule update && \
    ./build.sh && \
    ./configure && \
    make && \
    make install

# Instalar módulo de Nginx para ModSecurity
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git /modsecurity-nginx

# Descargar y compilar Nginx con el módulo ModSecurity
RUN NGINX_VERSION=$(nginx -v 2>&1 | grep -o '[0-9.]*$') && \
    wget https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \
    tar zxvf nginx-$NGINX_VERSION.tar.gz && \
    cd nginx-$NGINX_VERSION && \
    ./configure --with-compat --add-dynamic-module=/modsecurity-nginx && \
    make modules && \
    cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules/

# Limpiar paquetes y archivos temporales
RUN apt-get remove -y build-essential git wget curl automake libtool pkgconf && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /modsecurity /modsecurity-nginx /nginx-$NGINX_VERSION*

# Copiar archivos de configuración
COPY nginx.conf /etc/nginx/nginx.conf
COPY modsecurity.conf /etc/nginx/modsecurity.conf
COPY rules /etc/nginx/rules

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
