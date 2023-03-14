#!/bin/sh
NUM=$1
if [ "$NUM" = "" ]; then
	kubectl scale statefulset.v1.apps/spring-redis-single   --replicas=1
	kubectl scale statefulset.v1.apps/spring-redis-sentinel --replicas=3
else
	kubectl scale statefulset.v1.apps/spring-redis-single   --replicas=$NUM
	kubectl scale statefulset.v1.apps/spring-redis-sentinel --replicas=$NUM
fi
