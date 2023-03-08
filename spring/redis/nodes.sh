#!/bin/sh

MASTER0=`kubectl get pods | egrep 'redis-master|redis-single|redis-cluster' | grep '1/1' | awk '{print $1}' | head -1`
kubectl exec --stdin --tty ${MASTER0} -- redis-cli cluster nodes
