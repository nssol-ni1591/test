[ "$1" = "" ] && set redis
docker run --rm -u 10000:10000 -p 6379:6379 -e "REDIS_PORT=6379" -e "REDIS_SINGLE=yes" -e "MASTER_IP=hostname -i" -it $1

#docker run -d --rm -v /root/gohdo/conf/cluster_0.conf:/etc/redis.conf -v /root/gohdo/data/0:/data -p 6379:6379 -it redis redis-server /etc/redis.conf
#docker run -d --rm -v /root/gohdo/conf/cluster_1.conf:/etc/redis.conf -v /root/gohdo/data/1:/data -p 6380:6379 -it redis redis-server /etc/redis.conf
#docker run -d --rm -v /root/gohdo/conf/cluster_2.conf:/etc/redis.conf -v /root/gohdo/data/2:/data -p 6381:6379 -it redis redis-server /etc/redis.conf
