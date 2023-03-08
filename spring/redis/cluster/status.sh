#!/bin/bash

# 起動しているかどうかにかかわらず、全てのRedisの情報を出力したい
# つまり、起動していないRedisはエラーとなり、起動していないので取得できないことがわかればよい

for container in 0-0 0-1 1-0 1-1 2-0 2-1; do
	echo -e "spring-redis-cluster${container} => \c"
	kubectl exec -i spring-redis-cluster${container} -- redis-cli cluster info | grep cluster_state
done
