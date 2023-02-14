
merge() {
	dir=$1

	# output header
	head -1 `ls -1 ${dir}/* | head -1` >${dir}.csv

	for file in ${dir}/*; do
		tail -n +2 ${file} >>${dir}.csv
	done
}

for dir in gc it-?; do
	merge $dir
done
