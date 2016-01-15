#!/bin/bash

usr_dir=""
if [ "$(hostname)" == 'kestrel' ]; then
  usr_dir=/homes/liu
else
  usr_dir=/home/xudong
fi

number_of_users=1
number_of_iterations=20
root_dir=${usr_dir}/Codes/PrefLearnExperiments/GermanCreditDownsampledFurther
results_dir=${root_dir}/Results
training_sample_size=$1
sum=0
avg=0

for (( i=0; i<$number_of_users; i+=1 )); do
  for (( j=0; j<$number_of_iterations; j+=1 )); do
    TIME_LINE="$(grep -B 1 CPU ${results_dir}/User${i}/${training_sample_size}sample/Training/res${j}.txt | sed -n 1p)"
    TIME="$(echo $TIME_LINE | cut -d ":" -f2 | cut -d "(" -f1 | cut -d "s" -f1)"
    #echo $TIME
		sum=$(echo "scale=4;$sum+$TIME" | bc)
  done
done
avg=$(echo "scale=4;$sum/$number_of_iterations" | bc)
echo $avg
