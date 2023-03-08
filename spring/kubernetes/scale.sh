#!/bin/sh

pod=`sh /root/gohdo/id2pod.sh $1 | sed 's/\-[0-9a-z]*\-[0-9a-z]*$//g`
[ -z "$pod" ] && exit 1
num=$2
[ -z "$num" ] && num=1
kubectl scale deployment.v1.apps/${name} --replicas=${num}
