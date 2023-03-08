[ "$1" = "" ] && set redis
docker run --rm -u 10000:10000 -p 6379:6379 -e "REDIS_PORT=6379" -e "REDIS_SINGLE=yes" -e "MASTER_IP=hostname -i" -it $1
