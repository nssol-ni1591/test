LOG=`date '+%Y%m%d'`
find /export2/containers/ -name '*_gc.log' -ls -exec cat {} \; | perl filter-gclog.pl >gc/${LOG}.txt
