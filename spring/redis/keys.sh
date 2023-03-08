#!/bin/sh

for pod in `kubectl get pods | egrep redis | awk '{print $1}'`; do
	echo "pod=[$pod]"
	kubectl exec --stdin --tty ${pod} -- redis-cli -c keys '*'
done

