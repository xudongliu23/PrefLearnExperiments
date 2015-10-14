#!/bin/bash

number_of_users=1
root_dir=/home/xudong/Codes/PrefLearnExperiments_Train_Test/TicTacToe
results_dir=${root_dir}/Results
training_sample_size=$1

cat /dev/null > tmp.txt
for (( i=0; i<$number_of_users; i+=1 )); do
  for (( j=0; j<2; j+=1 )); do
    for (( k=0; k<10; k+=1 )); do
			TIME_LINE="$(grep -B 1 CPU ${results_dir}/User${i}/${training_sample_size}sample/Training/res${j}${k}.txt | sed -n 1p)"
			TIME="$(echo $TIME_LINE | cut -d ":" -f2 | cut -d "(" -f1 | cut -d "s" -f1)"
			echo $TIME >> tmp.txt
		done
	done
done
cat tmp.txt | awk  '{sum+=$1; ++n} END { print sum/n }'
rm tmp.txt
