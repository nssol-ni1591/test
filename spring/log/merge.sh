
merge() {
	dir=$1

	# output header
	head -1 `ls -1 ${dir}/* | head -1` >${dir}.csv

	for file in ${dir}/*; do
		tail -n +2 ${file} >>${dir}.csv
	done
}
join() {
	head -1 it-1.csv | sed "s/^/it,/g" >redis.csv
	for dir in it-?; do
		csv=${dir}.csv
		tail -n +2 ${csv} | sed "s/^/${dir},/g" >>redis.csv
	done
}

for dir in gc it-?; do
	merge $dir
done
join
