#!/bin/sh

dir=`dirname $0`
pod=`sh ${dir}/id2pod.sh $1`
[ -z "$pod" ] && exit 1
if [ -z "$2" ]; then
	kubectl exec --stdin --tty ${pod} -- /bin/bash
else
	shift
	kubectl exec ${pod} -- $*
fi
