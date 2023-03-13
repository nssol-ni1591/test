#!/bin/sh

CMD="$*"
MASTER_IP=""
for pod in `kubectl get pods | grep redis-sentinel | awk '{print $1}'`; do
	echo "pod=[$pod]"
	kubectl exec --stdin --tty ${pod} -- redis-cli -c ${CMD}
done

