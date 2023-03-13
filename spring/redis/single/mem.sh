#!/bin/sh

MASTER_IP=""
for pod in `kubectl get pods | egrep spring-redis-single | awk '{print $1}'`; do
	echo "pod=[$pod]"
	kubectl exec --stdin --tty ${pod} -- redis-cli --memkeys
done

