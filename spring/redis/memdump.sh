
log() {
	date '+DATE: %Y-%m-%d_%H:%M:%S'
	redis-cli --memkeys
	echo "INFO: start"
	redis-cli info
	echo "INFO: end"
}

while true; do
	LOG="/data/memdump-`date '+%Y%m%d'`.dat"
	log >> ${LOG}
	sleep 60
done
