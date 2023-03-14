#!/bin/sh

for pod in `kubectl get pods | egrep 'redis-single' | awk '{ print $1 }'`; do
	echo "pod=[$pod]"
#	kubectl exec ${pod} -- redis-cli info replication
	kubectl exec ${pod} -- redis-cli info replication | egrep -v 'repl|slave_'
#	kubectl exec ${pod} -- redis-cli info replication | egrep 'role|conncted'
	echo
done
