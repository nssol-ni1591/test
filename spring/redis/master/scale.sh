#!/bin/sh
NUM=$1
[ "$NUM" = "" ] && NUM=1
kubectl scale statefulset.v1.apps/spring-redis-master0 --replicas=${NUM}
kubectl scale statefulset.v1.apps/spring-redis-master1 --replicas=${NUM}
kubectl scale statefulset.v1.apps/spring-redis-master2 --replicas=${NUM}
kubectl scale statefulset.v1.apps/spring-redis-slave0 --replicas=${NUM}
kubectl scale statefulset.v1.apps/spring-redis-slave1 --replicas=${NUM}
kubectl scale statefulset.v1.apps/spring-redis-slave2 --replicas=${NUM}
