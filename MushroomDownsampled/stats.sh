#!/bin/bash

usr_dir=""
if [ "$(hostname)" == 'kestrel' ]; then
  usr_dir=/homes/liu
else
  usr_dir=/home/xudong
fi

root_dir=${usr_dir}/Codes/PrefLearnExperiments/MushroomDownsampled

echo "SampleSize,X-UIUP-Training%,X-UIUP-Testing%" > Results/sum.txt
for (( i=1; i<10; i+=1 )); do
	./stats Results/results${i}.txt $i >> Results/sum.txt
done
for (( i=10; i<50; i+=10 )); do
	./stats Results/results${i}.txt $i >> Results/sum.txt
done
./stats Results/results250.txt 250 >> Results/sum.txt

#echo ""
#
#echo "Time:"
#for (( i=1; i<10; i+=1 )); do
#	${root_dir}/Scripts/get_run_time.sh $i
#done
#for (( i=10; i<260; i+=10 )); do
#	${root_dir}/Scripts/get_run_time.sh $i
#done
