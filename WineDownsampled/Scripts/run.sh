#!/bin/bash

## MaxLearn, UIUP PLP-trees, WineDownsampled, 1 user, each with 10322 examples over 177 outcomes.

number_of_users=1
root_dir=/home/xudong/Codes/PrefLearnExperiments_Train_Test/WineDownsampled
origin_dir=${root_dir}/Original
transformed_dir=${root_dir}/Transformed
ASP_dir=${root_dir}/ASP
Scripts_dir=${root_dir}/Scripts
pair_prefs=preferences1.csv
examples_ASP=examples.gringo
number_of_strict_ex_ASP=number_of_strict_examples.gringo
rules_ASP=rules.gringo

#clingo=$1
gringo=$1
clasp=$2
training_sample_size=$3
number_of_all_examples=$4
data=${ASP_dir}/data.gringo
outcomes=${ASP_dir}/outcomes.gringo
#rules=${ASP_dir}/rules.gringo
pars="-c tn=10 -c mn=10"

results_dir=${root_dir}/Results
parser_hr=${root_dir}/C++Src/parser

## preprocess the original Car dataset 1 and create examples in ASP
function preRun {
	${Scripts_dir}/create_datasets.sh $root_dir $origin_dir $training_sample_size
	${Scripts_dir}/preprocess_data.sh $number_of_users $origin_dir $transformed_dir $pair_prefs $parser_hr $ASP_dir
	${Scripts_dir}/make_ASP.sh $number_of_users $transformed_dir $ASP_dir $pair_prefs $examples_ASP $number_of_strict_ex_ASP
}

## run the experiments
function run {
	for (( i=0; i<$number_of_users; i+=1 )); do
		if [ ! -d ${results_dir}/User${i} ]; then
      mkdir ${results_dir}/User${i}
    fi
		mkdir ${results_dir}/User${i}/${training_sample_size}sample
		mkdir ${results_dir}/User${i}/${training_sample_size}sample/Training
		mkdir ${results_dir}/User${i}/${training_sample_size}sample/Testing
		for (( j=0; j<2; j+=1 )); do
			for (( k=0; k<10; k+=1 )); do
				# Training (1000 examples)
				$gringo ${ASP_dir}/User${i}/Training/examples${j}${k}.gringo $data \
					${ASP_dir}/User${i}/Training/number_of_strict_examples${j}${k}.gringo \
					$outcomes ${ASP_dir}/User${i}/Training/$rules_ASP $pars | $clasp > ${results_dir}/User${i}/${training_sample_size}sample/Training/res${j}${k}.txt 2>&1

				# Testing (1000 examples)
				cp ${ASP_dir}/User${i}/Testing/rules.gringo ${ASP_dir}/User${i}/Testing/rules${j}${k}.gringo # making the rules
				TREE_LEARNED="$(grep -B 2 OPTIMUM ${results_dir}/User${i}/${training_sample_size}sample/Training/res${j}${k}.txt | sed -n 1p)"
				foo=${TREE_LEARNED//)/).}
				TREE_LEARNED=$foo
				echo $TREE_LEARNED >> ${ASP_dir}/User${i}/Testing/rules${j}${k}.gringo
				$gringo $data ${ASP_dir}/User${i}/Testing/examples${j}${k}.gringo \
					${ASP_dir}/User${i}/Testing/number_of_strict_examples${j}${k}.gringo \
					$outcomes ${ASP_dir}/User${i}/Testing/rules${j}${k}.gringo | $clasp > ${results_dir}/User${i}/${training_sample_size}sample/Testing/res${j}${k}.txt 2>&1

				# Testing (all examples except the 1000 training examples)
				$gringo $data ${ASP_dir}/User${i}/Testing/examples_extra${j}${k}.gringo \
					${ASP_dir}/User${i}/Testing/number_of_strict_examples_extra${j}${k}.gringo \
					$outcomes ${ASP_dir}/User${i}/Testing/rules${j}${k}.gringo | $clasp> ${results_dir}/User${i}/${training_sample_size}sample/Testing/res_extra${j}${k}.txt 2>&1
			done
		done
	done
}

## get the learned UIUP trees
function postRun {
	cat /dev/null > ${results_dir}/results${training_sample_size}.txt
	for (( i=0; i<$number_of_users; i+=1 )); do
		echo "MaxLearn UIUP PLP-trees for user $i:" >> ${results_dir}/results${training_sample_size}.txt
		echo "" >> ${results_dir}/results${training_sample_size}.txt
		echo "" >> ${results_dir}/results${training_sample_size}.txt
		# for training, get the tree
		for (( j=0; j<2; j+=1 )); do
			for (( k=0; k<10; k+=1 )); do
				echo "Using training data number $j$k:" >> ${results_dir}/results${training_sample_size}.txt
				$parser_hr post ${origin_dir}/domain_description.txt ${results_dir}/User${i}/${training_sample_size}sample/Training/res${j}${k}.txt $i $training_sample_size\
					$ASP_dir >> ${results_dir}/results${training_sample_size}.txt
				echo "" >> ${results_dir}/results${training_sample_size}.txt

				# for testing, get the numbers
				echo "Using testing data number $j$k:" >> ${results_dir}/results${training_sample_size}.txt
				NUM_OF_SAT_PREDICATE="$(grep -B 1 SATISFIABLE ${results_dir}/User${i}/${training_sample_size}sample/Testing/res${j}${k}.txt | sed -n 1p)"
				NUM_OF_SAT="$(echo $NUM_OF_SAT_PREDICATE | cut -d "(" -f2 | cut -d ")" -f1)"
				RESULT=$(awk "BEGIN {printf \"%.4f\",${NUM_OF_SAT}/${training_sample_size}}")
				echo "Satisfy ${NUM_OF_SAT} out of ${training_sample_size} (${RESULT}) examples." >> ${results_dir}/results${training_sample_size}.txt
				echo "" >> ${results_dir}/results${training_sample_size}.txt

				# for extra testing, get the numbers
				echo "Using extra testing data number $j$k:" >> ${results_dir}/results${training_sample_size}.txt
				NUM_OF_SAT_PREDICATE="$(grep -B 1 SATISFIABLE ${results_dir}/User${i}/${training_sample_size}sample/Testing/res_extra${j}${k}.txt | sed -n 1p)"
				NUM_OF_SAT="$(echo $NUM_OF_SAT_PREDICATE | cut -d "(" -f2 | cut -d ")" -f1)"
				NUM_OF_EXTRA=$((number_of_all_examples-training_sample_size))
				RESULT=$(awk "BEGIN {printf \"%.4f\",${NUM_OF_SAT}/${NUM_OF_EXTRA}}")
				echo "Satisfy ${NUM_OF_SAT} out of ${NUM_OF_EXTRA} (${RESULT}) examples." >> ${results_dir}/results${training_sample_size}.txt
				echo "" >> ${results_dir}/results${training_sample_size}.txt
				echo "" >> ${results_dir}/results${training_sample_size}.txt
			done
		done
	done

	

	# compute average accuracy
	#echo "Avarage accuracy: " >> ${results_dir}/results${training_sample_size}.txt
	#grep -Eo '\([0-9]+\.?[0-9]*\)' ${results_dir}/results${training_sample_size}.txt | sed 's/.$//; s/^.//' | awk '{a+=$1} END{print a/NR}' \
	#	>> ${results_dir}/results${training_sample_size}.txt
}

## clean up the intermedia data, that is, all the directory for the Users
function cleanup {
	for (( i=0; i<$number_of_users; i+=1 )); do
		rm -rf ${ASP_dir}/User${i} ${results_dir}/User${i} ${transformed_dir}/User${i}
	done
	rm -rf ${transformed_dir}
}

## main function
function main {
	preRun
	run
	postRun
	#cleanup
}

########## main
main
