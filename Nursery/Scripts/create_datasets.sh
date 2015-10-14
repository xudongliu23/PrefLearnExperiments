#!/bin/bash

root_dir=$1
origin_dir=$2
training_sample_size=$3
number_of_all_examples=$4
strictEx_dir=${origin_dir}/StrictExamples
user0_dir=${strictEx_dir}/User0
train_dir=${user0_dir}/Training
test_dir=${user0_dir}/Testing

if [ ! -d ${strictEx_dir} ]; then
  mkdir ${strictEx_dir}
  mkdir ${user0_dir}
  mkdir ${train_dir}
  mkdir ${test_dir}
fi

# Pick random examples from strict_examples_cp.csv for training and testing (semi-2-fold)
title="$(head -1 ${origin_dir}/strict_examples_cp.csv)"
sed -i '1d' ${origin_dir}/strict_examples_cp.csv
used_data_size=$(($training_sample_size*40))
shuf -n $used_data_size ${origin_dir}/strict_examples_cp.csv > ${origin_dir}/tmp.csv
training_size=$(($training_sample_size*20))
split -l $training_size -d ${origin_dir}/tmp.csv ${origin_dir}/tmp
split -l $training_sample_size -d ${origin_dir}/tmp00 ${train_dir}/train
split -l $training_sample_size -d ${origin_dir}/tmp01 ${test_dir}/test
rm ${origin_dir}/tmp*

# Add title to the training and testing datasets
for (( i=0; i<2; i+=1 )); do
	for (( j=0; j<10; j+=1 )); do
		sed -i "1s/^/$title\n/" ${train_dir}/train${i}${j}
		sed -i "1s/^/$title\n/" ${test_dir}/test${i}${j}
	done
done

# Create the extra testing datasets
#for (( i=0; i<2; i+=1 )); do
#  for (( j=0; j<10; j+=1 )); do
#    cp ${origin_dir}/strict_examples_cp.csv ${test_dir}/test_extra${i}${j}
#    grep -v -x -f ${test_dir}/test${i}${j} ${test_dir}/test_extra${i}${j} \
#      > ${test_dir}/tmp && mv ${test_dir}/tmp ${test_dir}/test_extra${i}${j}
#
#    # Due to too large extra testing datasets, pick at random 1% of the rest examples.
#		NUMBER=$(((number_of_all_examples-training_sample_size)/100))
#    shuf -n $NUMBER ${test_dir}/test_extra${i}${j} > ${test_dir}/tmp${i}${j}
#    sed -i "1s/^/$title\n/" ${test_dir}/tmp${i}${j}
#    rm ${test_dir}/test_extra${i}${j}
#    mv ${test_dir}/tmp${i}${j} ${test_dir}/test_extra${i}${j}
#  done
#done
############## Note that strict_examples_cp.csv is already one percent!
for (( i=0; i<2; i+=1 )); do
	for (( j=0; j<10; j+=1 )); do
		cp ${origin_dir}/strict_examples_cp.csv ${test_dir}/test_extra${i}${j}
		grep -v -x -f ${test_dir}/test${i}${j} ${test_dir}/test_extra${i}${j} \
			> ${test_dir}/tmp && mv ${test_dir}/tmp ${test_dir}/test_extra${i}${j}
		sed -i "1s/^/$title\n/" ${test_dir}/test_extra${i}${j}
	done
done
sed -i "1s/^/$title\n/" ${origin_dir}/strict_examples_cp.csv
