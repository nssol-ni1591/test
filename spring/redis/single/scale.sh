#!/bin/sh
NUM=$1
if [ "$NUM" = "" ]; then
	kubectl scale statefulset.v1.apps/spring-redis-single   --replicas=1
else
	kubectl scale statefulset.v1.apps/spring-redis-single   --replicas=$NUM
fi

