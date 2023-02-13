#!/bin/sh

copy() {
	src=$1
	des=$2
	cmd=$3

	if [ ! -d ${des} ]; then
		echo
		echo "Error: ${des} not found"
		exit 1
	fi

	name=`basename ${src}`
	csv=`echo ${name} | sed -r 's/\.log$|\.dat$/.csv/g'`
	if [ ! -f ${des}/${csv} ] ; then
		eval "${cmd}" >${des}/${csv}
		echo create [${src}] to [${des}]
		return
	fi

	src_time=`ls -l --time-style='+%Y%m%d%H%M%S' ${src} | awk '{ print $6 }'`
	des_time=`ls -l --time-style='+%Y%m%d%H%M%S' ${des}/${csv} | awk '{ print $6 }'`
	if [ ${src_time} -gt ${des_time} ]; then
		eval "${cmd}" >${des}/${csv}
		echo update [${src}] to [${des}]
	else
		echo skiped [${src}]
	fi
}

[ ! -d csv ] && echo "Error: csv not found" && exit 1
for file in `find /export2/containers/spring-redis-single-0 -name 'memdump-*.dat'`; do
	it=`echo ${file} | sed -e 's/^.*\/\(it\-.\)\/.*$/\1/g'`
	copy ${file} csv/${it} "cat ${file} | perl memdump.pl"
done
for file in `find /export2/containers/ -name '*_gc.log' -size +10M`; do
	copy ${file} csv/gc "echo ${file} | perl gclog.pl"
done
exit 0
