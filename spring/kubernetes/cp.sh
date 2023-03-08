#!/bin/sh

dir=`dirnme $0`

function sub() {
	p=`echo $1 | cut -f 1 -d :`
	c=`sh ${dir}/id2pod.sh $p`
	[ -z "$c" ] && return
	echo $1 | sed "s#$p#$c#g"
}

SRC=$1
TGT=$2
if [ -z "$SRC" ] || [ -z "$TGT" ]; then
	echo "[Error] Parameters"
	echo "Usage: cp.sh SRC TGT"
	exit 1
fi

echo $SRC | grep ':' >/dev/null
if [ $? -ne 0 ]; then
	echo $TGT | grep ':' >/dev/null
	if [ $? -ne 0 ]; then
		echo "[Error] Container name not found"
		exit 1
	fi
	src=$SRC
	des=`sub $TGT`
else
	src=`sub $SRC`
	des=$TGT
fi

if [ -z "$src" ] || [ -z "$des" ]; then
	echo "Error: A matched pod not found"
	p=`echo $1 | cut -f 1 -d :`
	kubectl get pods | grep $p
	exit 1
fi
cmd="oc cp $src $des"
echo $cmd
$cmd
