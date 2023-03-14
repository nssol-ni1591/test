#!/bin/sh

NUM=$1
[ -z $NUM ] && NUM=1
kubectl scale statefulset.v1.apps/spring-redis-single   --replicas=$NUM
