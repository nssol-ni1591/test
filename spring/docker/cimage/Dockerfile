#FROM docker-registry.default.svc:5000/prj-nsspring/spring-base-ubi:0.0.3-20220628064629
FROM docker-registry-default.router.default.tetra-c.sdc.ns-sol.co.jp/prj-nsspring/spring-base-ubi:0.0.3-20220628064629
#FROM centos:7

# 外部からの受付
ARG VERSION
LABEL spring.redis.version=${VERSION}

# AP定義
ENV REDIS_USER=redis \
    REDIS_HOME=/opt/redis \
    REDIS_VERSION=6.2.7 \
    HTTP_PROXY=http://proxy.ns-sol.co.jp:8000 \
    HTTPS_PROXY=http://proxy.ns-sol.co.jp:8000 \
    http_proxy=http://proxy.ns-sol.co.jp:8000 \
    https_proxy=http://proxy.ns-sol.co.jp:8000

# User
RUN useradd $REDIS_USER -m -u 10000 \
    && echo "$REDIS_USER:$REDIS_USER" | chpasswd

# Setup
RUN mkdir $REDIS_HOME \
    && mkdir $REDIS_HOME/etc
COPY sh $REDIS_HOME/sh

# Redis install
RUN yum -y install wget gcc make hostname bind-utils \
    && cd /usr/local/src \
    && wget http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz \
    && tar xzf redis-$REDIS_VERSION.tar.gz \
    && cd redis-$REDIS_VERSION \
    && make PREFIX=$REDIS_HOME install

# Remove direcory for compile
RUN rm -r /usr/local/src/redis-$REDIS_VERSION

# Setting
RUN chown -R $REDIS_USER:$REDIS_USER $REDIS_HOME && chmod 755 $REDIS_HOME/sh/* \
    && mkdir /data && chown -R $REDIS_USER:$REDIS_USER /data && chmod 777 /data

# user
# USER 10000

ENV PATH=$REDIS_HOME/bin:$PATH
EXPOSE 6379

ENTRYPOINT ["/opt/redis/sh/start.sh"]
