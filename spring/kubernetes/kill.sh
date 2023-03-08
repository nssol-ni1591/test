#!/bin/sh

pod=`sh /root/gohdo/id2pod.sh $1 | sed 's/\-[0-9a-z]*\-[0-9a-z]*$//g`
[ -z "$pod" ] && exit 1
kubectl delete pods $1 --grace-period=0 --force
