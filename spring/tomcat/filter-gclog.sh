LOG=`date '+%Y%m%d'`
find /export2/containers/ -name *_gc.log -ls -exec grep Full {} \; | perl filter-gclog.pl >logs/${LOG}.txt