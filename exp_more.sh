#!/bin/bash

usr_dir=""
if [ "$(hostname)" == 'kestrel' ]; then
  usr_dir=/homes/liu
else
  usr_dir=/home/xudong
fi

root_dir=${usr_dir}/Codes/PrefLearnExperiments

MammographicMassDownsampled=${root_dir}/MammographicMassDownsampled/Scripts/run.sh
number_of_all_examples_MammographicMassDownsampled=792
IonosphereDownsampledFurther=${root_dir}/IonosphereDownsampledFurther/Scripts/run.sh
number_of_all_examples_IonosphereDownsampledFurther=3472
MushroomDownsampled=${root_dir}/MushroomDownsampled/Scripts/run.sh
number_of_all_examples_MushroomDownsampled=8448
GermanCreditDownsampledFurther=${root_dir}/GermanCreditDownsampledFurther/Scripts/run.sh
number_of_all_examples_GermanCreditDownsampledFurther=172368
TicTacToe=${root_dir}/TicTacToe/Scripts/run.sh
number_of_all_examples_TicTacToe=207832
NurseryDownsampledFurther=${root_dir}/NurseryDownsampledFurther/Scripts/run.sh
number_of_all_examples_NurseryDownsampledFurther=548064
CarEvaluation=${root_dir}/CarEvaluation/Scripts/run.sh
number_of_all_examples_CarEvaluation=682721
clingo3=${usr_dir}/.tools/clingo-3.0.5/clingo-3.0.5
gringo3=${usr_dir}/.tools/gringo-3.0.5/gringo-3.0.5
clasp=${usr_dir}/.tools/clasp-3.1.3/clasp-3.1.3

#for (( i=1; i<10; i+=1 )); do
#	time $MammographicMassDownsampled $gringo3 $clasp $usr_dir $i $number_of_all_examples_MammographicMassDownsampled
#	sleep 2
#done
#for (( i=10; i<260; i+=10 )); do
#	time $MammographicMassDownsampled $gringo3 $clasp $usr_dir $i $number_of_all_examples_MammographicMassDownsampled
#	sleep 2
#done
#sleep 2
#echo "PrefLearn experiment is done on the MammographicMassDownsampled dataset." | mail -s "MammographicMassDownsampled Done" xudong.liu23@gmail.com
#
#for (( i=1; i<10; i+=1 )); do
#	time $IonosphereDownsampledFurther $gringo3 $clasp $usr_dir $i $number_of_all_examples_IonosphereDownsampledFurther
#	sleep 2
#done
#for (( i=10; i<260; i+=10 )); do
#	time $IonosphereDownsampledFurther $gringo3 $clasp $usr_dir $i $number_of_all_examples_IonosphereDownsampledFurther
#	sleep 2
#done
#echo "PrefLearn experiment is done on the IonosphereDownsampledFurther dataset." | mail -s "IonosphereDownsampledFurther Done" xudong.liu23@gmail.com
#
#for (( i=1; i<10; i+=1 )); do
#	time $MushroomDownsampled $gringo3 $clasp $usr_dir $i $number_of_all_examples_MushroomDownsampled
#	sleep 2
#done
#for (( i=10; i<50; i+=10 )); do
#	time $MushroomDownsampled $gringo3 $clasp $usr_dir $i $number_of_all_examples_MushroomDownsampled
#	sleep 2
#done
#sleep 2
#echo "PrefLearn experiment is done on the MushroomDownsampled dataset." | mail -s "MushroomDownsampled Done" xudong.liu23@gmail.com
#
#for (( i=1; i<10; i+=1 )); do
#	time $TicTacToe $gringo3 $clasp $usr_dir $i $number_of_all_examples_TicTacToe
#	sleep 2
#done
#for (( i=10; i<260; i+=10 )); do
#	time $TicTacToe $gringo3 $clasp $usr_dir $i $number_of_all_examples_TicTacToe
#	sleep 2
#done
#sleep 2
#echo "PrefLearn experiment is done on the TicTacToe dataset." | mail -s "TicTacToe Done" xudong.liu23@gmail.com
#
#for (( i=50; i<260; i+=10 )); do
#	time $GermanCreditDownsampledFurther $gringo3 $clasp $usr_dir $i $number_of_all_examples_GermanCreditDownsampledFurther
#	sleep 2
#done
#sleep 2
#echo "PrefLearn experiment is done on the GermanCreditDownsampledFurther dataset." | mail -s "GermanCreditDownsampledFurther Done" xudong.liu23@gmail.com

#for (( i=1; i<10; i+=1 )); do
#	time $CarEvaluation $gringo3 $clasp $usr_dir $i $number_of_all_examples_CarEvaluation
#	sleep 2
#done
for (( i=10; i<210; i+=10 )); do
	time $CarEvaluation $gringo3 $clasp $usr_dir $i $number_of_all_examples_CarEvaluation
	sleep 2
done
#for (( i=210; i<260; i+=10 )); do
#	time $CarEvaluation $gringo3 $clasp $usr_dir $i $number_of_all_examples_CarEvaluation
#	sleep 2
#done
sleep 2
echo "PrefLearn experiment is done on the CarEvaluation dataset." | mail -s "CarEvaluation Done" xudong.liu23@gmail.com

#time $NurseryDownsampledFurther $gringo3 $clasp $usr_dir 1 $number_of_all_examples_NurseryDownsampledFurther
#for (( i=1; i<10; i+=1 )); do
#	time $NurseryDownsampledFurther $gringo3 $clasp $usr_dir $i $number_of_all_examples_NurseryDownsampledFurther
#	sleep 2
#done
#for (( i=10; i<260; i+=10 )); do
#	time $NurseryDownsampledFurther $gringo3 $clasp $usr_dir $i $number_of_all_examples_NurseryDownsampledFurther
#	sleep 2
#done
#sleep 2
#echo "PrefLearn experiment is done on the NurseryDownsampledFurther dataset." | mail -s "NurseryDownsampledFurther Done" xudong.liu23@gmail.com

