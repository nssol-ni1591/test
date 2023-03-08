[ "$1" = "" ] && set redis
[ "$2" = "" ] && set $1 bash
container_id=`docker ps -a | grep $1 | awk '{print $1}'`
docker exec -it $container_id $2
