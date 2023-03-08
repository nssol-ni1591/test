#!/bin/sh

MASTER0=`kubectl get pods | grep redis-master | awk '{print $1}' | head -1`

echo "--- master ---"

MASTER_IP=""
for ip in `kubectl get pods -o wide | egrep 'redis-master' | awk '{print $6}'`; do
	MASTER_IP="${MASTER_IP} ${ip}:6379"
	kubectl exec ${MASTER0} -- redis-cli -h ${ip} -c FLUSHDB
	kubectl exec ${MASTER0} -- redis-cli -h ${ip} -c CLUSTER RESET
done

echo "MASTER0=[${MASTER0}] MASTER_IP=[${MASTER_IP}]"
kubectl exec --stdin --tty ${MASTER0} -- redis-cli --cluster create ${MASTER_IP} <<EOF
yes
EOF

echo
echo "--- slave ---"

ix=0
while `true`; do
	slave_ip=`kubectl get pods -o wide | egrep "redis-slave${ix}" | awk '{print $6}'`
	[ "${slave_ip}" = "" ] && break
	kubectl exec ${MASTER0} -- redis-cli -h ${slave_ip} -c FLUSHDB
	kubectl exec ${MASTER0} -- redis-cli -h ${slave_ip} -c CLUSTER RESET
	master_ip=`kubectl get pods -o wide | egrep "redis-master${ix}" | awk '{print $6}'`
	master_id=`kubectl exec ${MASTER0} -- redis-cli cluster nodes | egrep ${master_ip} | awk '{print $1}'`
	kubectl exec --stdin --tty ${MASTER0} -- redis-cli --cluster add-node ${slave_ip}:6379 ${master_ip}:6379 --cluster-slave --cluster-master-id ${master_id}
	ix=`expr $ix + 1`
done

echo

