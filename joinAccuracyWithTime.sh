#!/bin/bash

usr_dir=""
if [ "$(hostname)" == 'kestrel' ]; then
  usr_dir=/homes/liu
else
  usr_dir=/home/xudong
fi

root_dir=${usr_dir}/Codes/PrefLearnExperiments

BreastCancerWisconsinDownsampledScriptDir=${root_dir}/BreastCancerWisconsinDownsampled/Scripts
CarEvaluationScriptDir=${root_dir}/CarEvaluation/Scripts
CreditApprovalDownsampledFurtherScriptDir=${root_dir}/CreditApprovalDownsampledFurther/Scripts
GermanCreditDownsampledFurtherScriptDir=${root_dir}/GermanCreditDownsampledFurther/Scripts
IonosphereDownsampledFurtherScriptDir=${root_dir}/IonosphereDownsampledFurther/Scripts
MammographicMassDownsampledScriptDir=${root_dir}/MammographicMassDownsampled/Scripts
MushroomDownsampledScriptDir=${root_dir}/MushroomDownsampled/Scripts
NurseryDownsampledFurtherScriptDir=${root_dir}/NurseryDownsampledFurther/Scripts
SpectHeartDownsampledFurtherScriptDir=${root_dir}/SpectHeartDownsampledFurther/Scripts
TicTacToeScriptDir=${root_dir}/TicTacToe/Scripts
VehicleDownsampledFurtherScriptDir=${root_dir}/VehicleDownsampledFurther/Scripts
WineDownsampledScriptDir=${root_dir}/WineDownsampled/Scripts

BreastCancerWisconsinDownsampledResultDir=${root_dir}/BreastCancerWisconsinDownsampled/Results
CarEvaluationResultDir=${root_dir}/CarEvaluation/Results
CreditApprovalDownsampledFurtherResultDir=${root_dir}/CreditApprovalDownsampledFurther/Results
GermanCreditDownsampledFurtherResultDir=${root_dir}/GermanCreditDownsampledFurther/Results
IonosphereDownsampledFurtherResultDir=${root_dir}/IonosphereDownsampledFurther/Results
MammographicMassDownsampledResultDir=${root_dir}/MammographicMassDownsampled/Results
MushroomDownsampledResultDir=${root_dir}/MushroomDownsampled/Results
NurseryDownsampledFurtherResultDir=${root_dir}/NurseryDownsampledFurther/Results
SpectHeartDownsampledFurtherResultDir=${root_dir}/SpectHeartDownsampledFurther/Results
TicTacToeResultDir=${root_dir}/TicTacToe/Results
VehicleDownsampledFurtherResultDir=${root_dir}/VehicleDownsampledFurther/Results
WineDownsampledResultDir=${root_dir}/WineDownsampled/Results

declare -a DatasetsNames=(
	'BreastCancerWisconsin'
	'CarEvaluation'
	'CreditApproval'
	'GermanCredit'
	'Ionosphere'
	'MammographicMass'
	'Mushroom'
	'Nursery'
	'SpectHeart'
	'TicTacToe'
	'Vehicle'
	'Wine'
)

declare -a Script_Dirs=(
	$BreastCancerWisconsinDownsampledScriptDir
	$CarEvaluationScriptDir
	$CreditApprovalDownsampledFurtherScriptDir
	$GermanCreditDownsampledFurtherScriptDir
	$IonosphereDownsampledFurtherScriptDir
	$MammographicMassDownsampledScriptDir
	$MushroomDownsampledScriptDir
	$NurseryDownsampledFurtherScriptDir
	$SpectHeartDownsampledFurtherScriptDir
	$TicTacToeScriptDir
	$VehicleDownsampledFurtherScriptDir
	$WineDownsampledScriptDir)

declare -a Result_Dirs=(
	$BreastCancerWisconsinDownsampledResultDir
	$CarEvaluationResultDir
	$CreditApprovalDownsampledFurtherResultDir
	$GermanCreditDownsampledFurtherResultDir
	$IonosphereDownsampledFurtherResultDir
	$MammographicMassDownsampledResultDir
	$MushroomDownsampledResultDir
	$NurseryDownsampledFurtherResultDir
	$SpectHeartDownsampledFurtherResultDir
	$TicTacToeResultDir
	$VehicleDownsampledFurtherResultDir
	$WineDownsampledResultDir)

for i in "${!DatasetsNames[@]}"
do
	#echo "SampleSize,X-UIUP-Training%,X-UIUP-Testing%,X-UIUP-TrainingTime(s)" > ${Result_Dirs[$i]}/sumWithTime.txt
	echo "X-UIUP-TrainingTime(s)" > ${root_dir}/tmp
	for (( j=1; j<10; j+=1 )); do
	  ${Script_Dirs[$i]}/get_run_time.sh $j >> ${root_dir}/tmp
	done
	for (( j=10; j<260; j+=10 )); do
	  ${Script_Dirs[$i]}/get_run_time.sh $j >> ${root_dir}/tmp
	done
	paste -d, ${Result_Dirs[$i]}/sum.txt ${root_dir}/tmp > ${Result_Dirs[$i]}/sumWithTime.txt
	echo "Done for ${DatasetsNames[$i]}"
done
rm ${root_dir}/tmp
