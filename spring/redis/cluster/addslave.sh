#!/bin/sh

if [ "$1" = "" -o "$2" = "" ]; then
	echo "usage addslave.sh <slave container> <master container>"
	exit 1
fi

MASTER0=`kubectl get pods | grep redis-cluster | grep '1/1' | awk '{print \$1}' | head -1`
slave_ip =`kubectl get pods -o wide | grep $1 | awk '{ print $6 }'`
master_ip=`kubectl get pods -o wide | grep $2 | awk '{ print $6 }'`
master_id=`oc exec ${MASTER0}} -- redis-cli cluster nodes | grep ${master_ip} | awk '{ print $1 }'`

cmd="kubectl exec --stdin --tty ${MASTER0} -- redis-cli --cluster add-node ${slave_ip}:6379 ${master_ip}:6379 --cluster-slave --cluster-master-id ${master_id}"
echo "$cmd"
eval $cmd

