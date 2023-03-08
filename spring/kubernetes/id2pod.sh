#!/bin/sh

case $1 in
purchase)	name='spring-nci-wf-app-ns-purchase-\w*-\w*' ;;
order)		name='spring-nci-wf-app-ns-order-\w*-\w*' ;;
*)		name="[\w-]*$1[\w-]*" ;;
esac
if [ `oc get pod | perl -nle "print \\$1 if (/^($name) /)" | wc -l` -eq 1 ]; then
	echo `oc get pod | perl -nle "print \\$1 if (/^($name) /)"`
	exit 0
fi
echo "[Error] Duplicate target:" 1>&2
oc get pod | perl -nle "print '  '.\$1 if (/^($name) /)" 1>&2
echo
exit 1
