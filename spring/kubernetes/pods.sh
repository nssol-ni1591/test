PWD=`pwd`
NAME=`basename $PWD`
if [ $# -ne 0 ]; then
	kubectl get pods -o wide | egrep $*
elif [ "$NAME" != "tmp" ]; then
	kubectl get pods -o wide | grep $NAME
else
	kubectl get pods -o wide
fi

