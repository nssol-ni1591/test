#!/bin/sh

for pod in `kubectl get pods | egrep 'redis-single|redis-master' | awk '{ print $1 }'`; do
	echo "pod=[$pod]"
#	kubectl exec ${pod} -- redis-cli info replication
	kubectl exec ${pod} -- redis-cli info replication | egrep -v 'repl|slave_'
#	kubectl exec ${pod} -- redis-cli info replication | egrep 'role|conncted'
	echo
done
for pod in `kubectl get pods | grep redis-sentinel | awk '{ print $1 }'`; do
	echo "pod=[$pod]"
	kubectl exec ${pod} -- redis-cli -p 26379 info sentinel
	echo
done
