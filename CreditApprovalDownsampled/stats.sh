#!/bin/bash

usr_dir=""
if [ "$(hostname)" == 'kestrel' ]; then
  usr_dir=/homes/liu
else
  usr_dir=/home/xudong
fi

root_dir=${usr_dir}/Codes/PrefLearnExperiments/CreditApprovalDownsampled

echo "Accuracy:"
for (( i=1; i<10; i+=1 )); do
	./stats Results/results${i}.txt
done
for (( i=10; i<260; i+=10 )); do
	./stats Results/results${i}.txt
done

echo ""

echo "Time:"
for (( i=1; i<10; i+=1 )); do
	${root_dir}/Scripts/get_run_time.sh $i
done
for (( i=10; i<260; i+=10 )); do
	${root_dir}/Scripts/get_run_time.sh $i
done
