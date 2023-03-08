[ "$1" = "" ] && set redis
container_id=`docker ps -a | grep $1 | awk '{print $1}'`
docker stop $container_id
