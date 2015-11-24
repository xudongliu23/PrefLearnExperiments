#!/bin/bash

usr_dir=""
if [ "$(hostname)" == 'kestrel' ]; then
  usr_dir=/homes/liu
else
  usr_dir=/home/xudong
fi

root_dir=${usr_dir}/Codes/PrefLearnExperiments

CarEvaluation=${root_dir}/CarEvaluation/Scripts/run.sh
number_of_all_examples_CarEvaluation=682721
TicTacToe=${root_dir}/TicTacToe/Scripts/run.sh
number_of_all_examples_TicTacToe=207832
Nursery=${root_dir}/Nursery/Scripts/run.sh
number_of_all_examples_Nursery=573194 # 1% of all 57319460 examples
MammographicMass=${root_dir}/MammographicMass/Scripts/run.sh
number_of_all_examples_MammographicMass=165889
Wine=${root_dir}/Wine/Scripts/run.sh
number_of_all_examples_Wine=10429
Cars1=${root_dir}/Cars1/Scripts/run.sh
Cars2=${root_dir}/Cars2/Scripts/run.sh
BreastCancerWisconsin=${root_dir}/BreastCancerWisconsin/Scripts/run.sh
Ionosphere=${root_dir}/Ionosphere/Scripts/run.sh
BreastCancerWisconsinDownsampled=${root_dir}/BreastCancerWisconsinDownsampled/Scripts/run.sh
number_of_all_examples_BreastCancerWisconsinDownsampled=9009
IonosphereDownsampled=${root_dir}/IonosphereDownsampled/Scripts/run.sh
number_of_all_examples_IonosphereDownsampled=11856
SpectHeartDownsampled=${root_dir}/SpectHeartDownsampled/Scripts/run.sh
number_of_all_examples_SpectHeartDownsampled=8178
CreditApprovalDownsampled=${root_dir}/CreditApprovalDownsampled/Scripts/run.sh
number_of_all_examples_CreditApprovalDownsampled=101850
CreditApprovalDownsampledFurther=${root_dir}/CreditApprovalDownsampledFurther/Scripts/run.sh
number_of_all_examples_CreditApprovalDownsampledFurther=66079
VehicleDownsampledFurther=${root_dir}/VehicleDownsampledFurther/Scripts/run.sh
number_of_all_examples_VehicleDownsampledFurther=76713
clingo3=${usr_dir}/.tools/clingo-3.0.5/clingo-3.0.5
gringo3=${usr_dir}/.tools/gringo-3.0.5/gringo-3.0.5
clasp=${usr_dir}/.tools/clasp-3.1.3/clasp-3.1.3

#for (( i=1; i<10; i+=1 )); do
#	time $CarEvaluation $gringo3 $clasp $i $number_of_all_examples_CarEvaluation
#	sleep 2
#done
#for (( i=10; i<100; i+=10 )); do
#	time $CarEvaluation $gringo3 $clasp $i $number_of_all_examples_CarEvaluation
#	sleep 2
#done
#for (( i=100; i<1000; i+=100 )); do
#	time $CarEvaluation $gringo3 $clasp $i $number_of_all_examples_CarEvaluation
#	sleep 2
#done
#for (( i=1000; i<5000; i+=1000 )); do
#	time $CarEvaluation $gringo3 $clasp $i $number_of_all_examples_CarEvaluation
#	sleep 2
#done
#echo "PrefLearn experiment is done on the CarEvaluation dataset." | mail -s "CarEvaluation Done" xudong.liu23@gmail.com
#
#for (( i=10; i<100; i+=10 )); do
#	time $TicTacToe $gringo3 $clasp $i $number_of_all_examples_TicTacToe
#	sleep 2
#done
#for (( i=100; i<1000; i+=100 )); do
#	time $TicTacToe $gringo3 $clasp $i $number_of_all_examples_TicTacToe
#	sleep 2
#done
#for (( i=2000; i<4000; i+=1000 )); do
#	time $TicTacToe $gringo3 $clasp $i $number_of_all_examples_TicTacToe
#	sleep 2
#done
#echo "PrefLearn experiment is done on the TicTacToe dataset." | mail -s "TicTacToe Done" xudong.liu23@gmail.com
#
# For Nursery, the extra testing part was on 1% of the whole extra which is too many.
# But I have generated test_extra's in Original/StrictExamples/User0/Testing/.
#for (( i=10; i<100; i+=10 )); do
#	time $Nursery $gringo3 $clasp $i $number_of_all_examples_Nursery
#	sleep 2
#done
#for (( i=100; i<1000; i+=100 )); do
#	time $Nursery $gringo3 $clasp $i $number_of_all_examples_Nursery
#	sleep 2
#done
#for (( i=2000; i<4000; i+=1000 )); do
#	time $Nursery $gringo3 $clasp $i $number_of_all_examples_Nursery
#	sleep 2
#done
#echo "PrefLearn experiment is done on the Nursery dataset." | mail -s "Nursery Done" xudong.liu23@gmail.com

for (( i=1; i<10; i+=1 )); do
	time $MammographicMass $gringo3 $clasp $usr_dir $i $number_of_all_examples_MammographicMass
	sleep 2
done
for (( i=10; i<260; i+=10 )); do
	time $MammographicMass $gringo3 $clasp $usr_dir $i $number_of_all_examples_MammographicMass
	sleep 2
done
sleep 2
echo "PrefLearn experiment is done on the MammographicMass dataset." | mail -s "MammographicMass Done" xudong.liu23@gmail.com
#
#for (( i=1; i<10; i+=1 )); do
#	time $Wine $gringo3 $clasp $i $number_of_all_examples_Wine
#	sleep 2
#done
#for (( i=10; i<260; i+=10 )); do
#	time $Wine $gringo3 $clasp $i $number_of_all_examples_Wine
#	sleep 2
#done
#echo "PrefLearn experiment is done on the Wine dataset." | mail -s "Wine Done" xudong.liu23@gmail.com
#
#time $Cars1 $gringo3 $clasp
#echo "PrefLearn experiment is done on the Cars1 dataset." | mail -s "Cars1 Done" xudong.liu23@gmail.com
#sleep 2
#
#time $Cars2 $gringo3 $clasp
#echo "PrefLearn experiment is done on the Cars2 dataset." | mail -s "Cars2 Done" xudong.liu23@gmail.com
#sleep 2
#
#time $BreastCancerWisconsin $gringo3 $clasp $usr_dir
#echo "PrefLearn experiment is done on the BreastCancerWisconsin dataset." | mail -s "BreastCancerWisconsin Done" xudong.liu23@gmail.com
#sleep 2
#
#time $Ionosphere $gringo3 $clasp $usr_dir
#echo "PrefLearn experiment is done on the Ionosphere dataset." | mail -s "Ionosphere Done" xudong.liu23@gmail.com
#sleep 2
#
#time $BreastCancerWisconsinDownsampled $gringo3 $clasp $usr_dir 200
#echo "PrefLearn experiment is done on the BreastCancerWisconsinDownsampled dataset." | mail -s "BreastCancerWisconsinDownsampled Done" xudong.liu23@gmail.com
#sleep 2
#
#time $IonosphereDownsampled $gringo3 $clasp $usr_dir 200
#echo "PrefLearn experiment is done on the IonosphereDownsampled dataset." | mail -s "IonosphereDownsampled Done" xudong.liu23@gmail.com
#sleep 2
#
#time $SpectHeartDownsampled $gringo3 $clasp $usr_dir 200
#echo "PrefLearn experiment is done on the SpectHeartDownsampled dataset." | mail -s "SpectHeartDownsampled Done" xudong.liu23@gmail.com
#sleep 2
#
#for (( i=1; i<10; i+=1 )); do
#	time $BreastCancerWisconsinDownsampled $gringo3 $clasp $usr_dir $i $number_of_all_examples_BreastCancerWisconsinDownsampled
#	sleep 2
#done
#for (( i=10; i<260; i+=10 )); do
#	time $BreastCancerWisconsinDownsampled $gringo3 $clasp $usr_dir $i $number_of_all_examples_BreastCancerWisconsinDownsampled
#	sleep 2
#done
#echo "PrefLearn experiment is done on the BreastCancerWisconsinDownsampled dataset." | mail -s "BreastCancerWisconsinDownsampled Done" xudong.liu23@gmail.com
#
#for (( i=1; i<10; i+=1 )); do
#	time $IonosphereDownsampled $gringo3 $clasp $usr_dir $i $number_of_all_examples_IonosphereDownsampled
#	sleep 2
#done
#for (( i=10; i<260; i+=10 )); do
#	time $IonosphereDownsampled $gringo3 $clasp $usr_dir $i $number_of_all_examples_IonosphereDownsampled
#	sleep 2
#done
#echo "PrefLearn experiment is done on the IonosphereDownsampled dataset." | mail -s "IonosphereDownsampled Done" xudong.liu23@gmail.com
#
#for (( i=1; i<10; i+=1 )); do
#	time $SpectHeartDownsampled $gringo3 $clasp $usr_dir $i $number_of_all_examples_SpectHeartDownsampled
#	sleep 2
#done
#for (( i=10; i<260; i+=10 )); do
#	time $SpectHeartDownsampled $gringo3 $clasp $usr_dir $i $number_of_all_examples_SpectHeartDownsampled
#	sleep 2
#done
#echo "PrefLearn experiment is done on the SpectHeartDownsampled dataset." | mail -s "SpectHeartDownsampled Done" xudong.liu23@gmail.com
#
#time $CreditApprovalDownsampled $gringo3 $clasp $usr_dir 20 $number_of_all_examples_CreditApprovalDownsampled
#echo "PrefLearn experiment is done on the CreditApprovalDownsampled dataset." | mail -s "CreditApprovalDownsampled Done" xudong.liu23@gmail.com
#
#for (( i=1; i<10; i+=1 )); do
#	time $CreditApprovalDownsampledFurther $gringo3 $clasp $usr_dir $i $number_of_all_examples_CreditApprovalDownsampledFurther
#	sleep 2
#done
#for (( i=10; i<260; i+=10 )); do
#	time $CreditApprovalDownsampledFurther $gringo3 $clasp $usr_dir $i $number_of_all_examples_CreditApprovalDownsampledFurther
#	sleep 2
#done
#sleep 2
#echo "PrefLearn experiment is done on the CreditApprovalDownsampledFurther dataset." | mail -s "CreditApprovalDownsampledFurther Done" xudong.liu23@gmail.com
#
#for (( i=1; i<10; i+=1 )); do
#	time $VehicleDownsampledFurther $gringo3 $clasp $usr_dir $i $number_of_all_examples_VehicleDownsampledFurther
#	sleep 2
#done
#for (( i=10; i<260; i+=10 )); do
#	time $VehicleDownsampledFurther $gringo3 $clasp $usr_dir $i $number_of_all_examples_VehicleDownsampledFurther
#	sleep 2
#done
#sleep 2
#echo "PrefLearn experiment is done on the VehicleDownsampledFurther dataset." | mail -s "VehicleDownsampledFurther Done" xudong.liu23@gmail.com
