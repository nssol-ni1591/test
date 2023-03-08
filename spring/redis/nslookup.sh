#!/bin/sh

MASTER0=`kubectl get pods | grep redis | grep '1/1' | awk '{print $1}' | head -1`
for svc in `kubectl get service | grep redis | awk '{ print $1 }'`; do
	echo service=[$svc]
	kubectl exec -i ${MASTER0} -- nslookup $svc | egrep -v '^$|Server:|Address:.*#53'
	echo
done
