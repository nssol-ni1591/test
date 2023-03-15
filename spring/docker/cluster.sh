 docker exec -it `docker ps | grep redis | awk '{ print $1 }' | tail -1` redis-cli --cluster create 172.17.0.3:6379 172.17.0.4:6379 172.17.0.5:6379
#docker exec -it `docker ps | grep redis | awk '{ print $1 }' | tail -1` redis-cli --cluster create 172.30.143.98:6379 172.30.143.98:6380 172.30.143.98:6381
