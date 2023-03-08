#!/bin/sh
NUM=$1
[ "$NUM" = "" ] && NUM=1
kubectl scale statefulset.v1.apps/spring-redis-cluster0 --replicas=${NUM}
kubectl scale statefulset.v1.apps/spring-redis-cluster1 --replicas=${NUM}
kubectl scale statefulset.v1.apps/spring-redis-cluster2 --replicas=${NUM}
