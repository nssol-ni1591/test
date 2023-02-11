#!/bin/sh
#cp -p /export2/containers/spring-redis-single-0/it-1/data/memdump-*.dat redis/it-1
#cp -p /export2/containers/spring-redis-single-0/it-2/data/memdump-*.dat redis/it-2
#cp -p /export2/containers/spring-redis-single-0/it-3/data/memdump-*.dat redis/it-3
#find /export2/containers/ -name *_gc.log -mtime -1 -size +100M -exec cp -p {} gc/ \;

copy() {
	src=$1
	des=$2

	if [ ! -d ${des} ]; then
		echo
		echo "Error: ${des} not found"
		exit 1
	fi

	name=`basename ${src}`
	if [ ! -f ${des}/${name} ] ; then
		cp -p ${src} ${des}
		echo copy [${src}] to [${des}]
		return
	fi

	src_size=`ls -l ${src} | awk '{ print $5 }'`
	des_size=`ls -l ${des}/${name} | awk '{ print $5 }'`
	if [ ${src_size} -ne ${des_size} ]; then
		cp -p ${src} ${des}
		echo overwrite [${src}] to [${des}]
	else
		echo skip [${src}]
	fi
}

for file in `find /export2/containers/spring-redis-single-0 -name memdump-*.dat`; do
	it=`echo ${file} | sed -e 's/^.*\/\(it\-.\)\/.*$/\1/g'`
	copy ${file} redis/${it}/
done
for file in `find /export2/containers/ -name *_gc.log -size +100M`; do
	copy ${file} gc/
done
exit 0
