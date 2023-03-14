#!/bin/sh
if [ "$1" = "" -o "$2" = "" ]; then
	echo "usage addslave.sh <slave container> <master container>"
	exit 1
fi

slave_pod=$1
master_ip=`kubectl get pods -o wide| grep $2 | awk '{ print $6 }'`

cmd="kubectl exec ${slave_pod} -- redis-cli slaveof ${master_ip} 6379"
echo "$cmd"
eval $cmd

