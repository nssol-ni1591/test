#!/bin/sh

[ "$1" = "" ] && set redis

for id in `docker ps | grep $1 | awk '{ print $1 }'`; do
	docker exec -it $id redis-cli shutdown
done

for id in `docker ps | grep $1 | awk '{ print $1 }'`; do
	docker stop $id
done
