#!/bin/bash

# Output start log
echo `date "+%Y/%m/%d-%H:%M:%S"` Start start.sh of redis.

# Setting environment valiables
HOSTNAME=`hostname`
TODAY=`date +%Y%m%d`
[ "${REDIS_PORT}" = "" ] && REDIS_PORT=6379
[ "${REDIS_SINGLE}" = "" ] && REDIS_SINGLE=no
[ "${REDIS_SENTINEL}" = "" ] && REDIS_SENTINEL=no
echo "HOSTNAME=[${HOSTNAME}] TODAY=[${TODAY}] PORT=[${REDIS_PORT}] SINGLE=[${REDIS_SINGLE}] REDIS_SENTINEL=[${REDIS_SENTINEL}]"

# Get ip address of master
#MASTER_IP=""
[ "${MASTER_IP}" = "" ] || MASTER_IP=`eval ${MASTER_IP}`
RETRY=0
while [ ! ${MASTER_IP} ]; do
	MASTER_IP=`nslookup spring-redis-single-0.redis-single-svc | grep Address: | grep -v \#53 | awk '{ print $2 }'`
	if [ ${RETRY} -ge 600 ]; then
		echo `date "+%Y/%m/%d-%H:%M:%S"` Exceeded maximum waiting time.
		exit 1
	fi
	RETRY=`expr $RETRY + 1`
	sleep 1
done

# Gemerate conf file
if [ "${REDIS_SENTINEL}" = "yes" ]; then

	cat <<EOF >/opt/redis/etc/sentinel.conf
#### NETWORK
bind 0.0.0.0
port ${REDIS_PORT}
timeout 0

#### GENERAL
daemonize yes
pidfile redis-server.pid
loglevel notice
logfile redis-server.log

#### SNAPSHOTTING
dir /data

#### REDIS SENTINEL
sentinel monitor mymaster ${MASTER_IP} 6379 2
sentinel parallel-syncs mymaster 1
sentinel down-after-milliseconds mymaster 10000
sentinel failover-timeout mymaster 20000
sentinel notification-script mymaster /opt/redis/sh/notify.sh

EOF

elif [ "${REDIS_SINGLE}" = "yes" ]; then

	cat <<EOF >/opt/redis/etc/redis.conf
#### NETWORK
bind 0.0.0.0
port ${REDIS_PORT}
timeout 0

#### GENERAL
daemonize yes
pidfile redis-server.pid
loglevel notice
logfile redis-server.log

#### SNAPSHOTTING
rdbcompression yes
dbfilename dump.rdb
dir /data

#### CLIENTS
maxclients 1000

#### MEMORY MANAGEMENT
maxmemory 1gb
maxmemory-policy volatile-ttl

#### APPEND ONLY MODE
appendonly no
appendfilename "appendonly.aof"
appendfsync everysec

EOF

	REDIS_SINGLE="master"
	if [ "`hostname -i`" != "${MASTER_IP}" ]; then
		cat <<EOF >>/opt/redis/etc/redis.conf
#### REDIS SLAVE
slaveof ${MASTER_IP} ${REDIS_PORT}

EOF
		REDIS_SINGLE="slave"
	fi
fi

# Start redis
umask 002
cd /data
if [ "${REDIS_SENTINEL}" = "yes" ]; then
	echo "SENTINEL: REDIS_SENTINEL=[$REDIS_SENTINEL] MASTER_IP=[$MASTER_IP]"
	/opt/redis/bin/redis-sentinel /opt/redis/etc/sentinel.conf

else
	echo "SINGLE: REDIS_SINGLE=[$REDIS_SINGLE] MASTER_IP=[$MASTER_IP]"
	/opt/redis/bin/redis-server /opt/redis/etc/redis.conf
fi
echo

if [ "${REDIS_DEBUG}" ]; then
	echo `date "+%Y/%m/%d-%H:%M:%S"` Exit for debug mode ...
	echo
	exit 0
elif [ -f /data/redis-server.log ]; then
	echo `date "+%Y/%m/%d-%H:%M:%S"` Start logging ...
	tail -f /data/redis-server.log
else
	echo `date "+%Y/%m/%d-%H:%M:%S"` Wait for redis to finish ...
	sleep infinity
fi

# Output stop log
echo `date "+%Y/%m/%d-%H:%M:%S"` Shutdown start.sh of redis.
echo
exit 0

