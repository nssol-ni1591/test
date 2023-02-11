#!/bin/sh
#cp -p /export2/containers/spring-redis-single-0/it-1/data/memdump-*.dat redis/it-1
#cp -p /export2/containers/spring-redis-single-0/it-2/data/memdump-*.dat redis/it-2
#cp -p /export2/containers/spring-redis-single-0/it-3/data/memdump-*.dat redis/it-3
#find /export2/containers/ -name *_gc.log -mtime -1 -size +100M -exec cp -p {} gc/ \;

copy_redis() {
	path=$1
	name=`basename $path`
	it=`echo $path | sed -e 's/^.*\/\(it\-.\)\/.*$/\1/g'`
	if [ ! -f redis/${it}/${name} ] ; then
		cp -p $path redis/${it}/
		echo copy [$path] to [${it}]
		return
	fi

	src_size=`ls -l $path | awk '{ print $5 }'`
	des_size=`ls -l redis/${it}/${name} | awk '{ print $5 }'`
	if [ $src_size -ne $des_size ]; then
		cp -p $path redis/${it}/
		echo overwrite [$path] to [${it}]
	else
		echo skip [$path]
	fi
}
copy_gc() {
	path=$1
	name=`basename $path`
	if [ ! -f gc/${name} ] ; then
		cp -p $path gc
		echo copy [$path] to [gc]
		return
	fi

	src_size=`ls -l $path | awk '{ print $5 }'`
	des_size=`ls -l gc/${name} | awk '{ print $5 }'`
	if [ $src_size -ne $des_size ]; then
		cp -p $path gc
		echo overwrite [$path] to [gc]
	else
		echo skip [$path]
	fi
}

for file in `find /export2/containers/spring-redis-single-0 -name memdump-*.dat`; do
	copy_redis ${file}
done
for file in `find /export2/containers/ -name *_gc.log -size +100M`; do
	copy_gc ${file}
done
