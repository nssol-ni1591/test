LOG="/data/memdump.log"

log() {
	date '+DATE: %Y-%m-%d_%H:%M:%S'
	redis-cli --memkeys
}

while true; do
	log >> ${LOG}
	sleep 60
done
