for id in `docker ps -a | grep redis | awk '{ print $1 }'`; do docker inspect $id | grep \"IPAddress\"; done
