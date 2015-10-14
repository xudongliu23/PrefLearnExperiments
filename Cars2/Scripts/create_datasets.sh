#!/bin/bash

number_of_users=$1
root_dir=$2
origin_dir=$3
strictEx_dir=${origin_dir}/StrictExamples

if [ ! -d ${strictEx_dir} ]; then
  mkdir ${strictEx_dir}
	for (( i=0; i<$number_of_users; i+=1 )); do
		mkdir ${strictEx_dir}/User${i}
		mkdir ${strictEx_dir}/User${i}/Training
		mkdir ${strictEx_dir}/User${i}/Testing
	done
fi

# Pick random examples from strict_examples_cp.csv for training and testing
title="$(head -1 ${origin_dir}/strict_examples_cp.csv)"
sed -i '1d' ${origin_dir}/strict_examples_cp.csv
awk -F "," '{print $0 >> ("'$origin_dir'/strict_examples"$1-1".csv")}' ${origin_dir}/strict_examples_cp.csv
for (( i=0; i<$number_of_users; i+=1 )); do
	mv ${origin_dir}/strict_examples${i}.csv ${strictEx_dir}/User${i}
	count="$(wc -l ${strictEx_dir}/User${i}/strict_examples${i}.csv | awk '{print($1)}')"
	half=$(($count/2))
	shuf -n $half ${strictEx_dir}/User${i}/strict_examples${i}.csv > ${strictEx_dir}/User${i}/Training/train
	cp ${strictEx_dir}/User${i}/strict_examples${i}.csv ${strictEx_dir}/User${i}/Testing/test
	grep -v -x -f ${strictEx_dir}/User${i}/Training/train ${strictEx_dir}/User${i}/Testing/test \
		> ${strictEx_dir}/User${i}/Testing/tmp && mv ${strictEx_dir}/User${i}/Testing/tmp ${strictEx_dir}/User${i}/Testing/test
done

# Add title to the training and testing datasets, and other files
sed -i "1s/^/$title\n/" ${origin_dir}/strict_examples_cp.csv
for (( i=0; i<$number_of_users; i+=1 )); do
	sed -i "1s/^/$title\n/" ${strictEx_dir}/User${i}/Training/train
	sed -i "1s/^/$title\n/" ${strictEx_dir}/User${i}/Testing/test
	sed -i "1s/^/$title\n/" ${strictEx_dir}/User${i}/strict_examples${i}.csv
done
