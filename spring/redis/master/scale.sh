#!/bin/sh

# 課題：
# kubectl get pods に対象のpodが存在しない場合
# そのpodが定義されていないのか、それとも、単に起動していないのか区別が難しい

function exists() {
#	kubectl get pods | grep $1 >/dev/null ; return $?
	return `kubectl get pods | grep $1 | wc -l`
}

NUM=$1
[ "$NUM" = "" ] && NUM=1
for name in master0 master1 master2 slave0 slave1 slave2; do
	pod="spring-redis-${name}"
#	exists $pod && kubectl scale statefulset.v1.apps/${pod} --replicas=${NUM}
	[ `exists $pod` -ne $NUM ] && kubectl scale statefulset.v1.apps/${pod} --replicas=${NUM}
done
