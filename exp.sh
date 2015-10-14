#!/bin/bash

root_dir=/home/xudong/Codes/PrefLearnExperiments_Train_Test

CarEvaluation=${root_dir}/CarEvaluation/Scripts/run.sh
number_of_all_examples_CarEvaluation=682721
TicTacToe=${root_dir}/TicTacToe/Scripts/run.sh
number_of_all_examples_TicTacToe=207832
Nursery=${root_dir}/Nursery/Scripts/run.sh
number_of_all_examples_Nursery=573194 # 1% of all 57319460 examples
MammographicMass=${root_dir}/MammographicMass/Scripts/run.sh
Wine=${root_dir}/Wine/Scripts/run.sh
number_of_all_examples_Wine=10429
Cars1=${root_dir}/Cars1/Scripts/run.sh
Cars2=${root_dir}/Cars2/Scripts/run.sh
clingo3=/home/xudong/.MyBinaries/clingo-3.0.5-amd64-linux/clingo-3.0.5
gringo3=/home/xudong/.MyBinaries/gringo-3.0.5-amd64-linux/gringo-3.0.5
clasp=/home/xudong/.MyBinaries/clasp-3.1.1/clasp-3.1.1-x86_64-linux

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
for (( i=10; i<100; i+=10 )); do
	time $TicTacToe $gringo3 $clasp $i $number_of_all_examples_TicTacToe
	sleep 2
done
for (( i=100; i<1000; i+=100 )); do
	time $TicTacToe $gringo3 $clasp $i $number_of_all_examples_TicTacToe
	sleep 2
done
for (( i=2000; i<4000; i+=1000 )); do
	time $TicTacToe $gringo3 $clasp $i $number_of_all_examples_TicTacToe
	sleep 2
done
echo "PrefLearn experiment is done on the TicTacToe dataset." | mail -s "TicTacToe Done" xudong.liu23@gmail.com
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
#
#time $MammographicMass $gringo3 $clasp
#echo "PrefLearn experiment is done on the MammographicMass dataset." | mail -s "MammographicMass Done" xudong.liu23@gmail.com
#sleep 2
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
