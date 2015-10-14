#!/bin/bash

## MaxLearn, UIUP PLP-trees, Cars Dataset2, 60 user, each with a few examples over 20 outcomes.

number_of_users=60
root_dir=/home/xudong/Codes/PrefLearnExperiments_Train_Test/Cars2
origin_dir=${root_dir}/Original
transformed_dir=${root_dir}/Transformed
ASP_dir=${root_dir}/ASP
Scripts_dir=${root_dir}/Scripts
pair_prefs=preferences1.csv
examples_ASP=examples.gringo
number_of_strict_ex_ASP=number_of_strict_examples.gringo
rules_train_ASP=rules_train.gringo
rules_test_ASP_template=rules_test_template.gringo

#clingo=$1
gringo=$1
clasp=$2
data=${ASP_dir}/data.gringo
outcomes=${ASP_dir}/outcomes.gringo
#rules=${ASP_dir}/rules.gringo
pars="-c tn=5 -c mn=5"

results_dir=${root_dir}/Results
parser_hr=${root_dir}/C++Src/parser

## preprocess the original Car dataset 2 and create examples in ASP
function preRun {
	${Scripts_dir}/create_datasets.sh $number_of_users $root_dir $origin_dir
	${Scripts_dir}/preprocess_data.sh $number_of_users $origin_dir $transformed_dir $pair_prefs $parser_hr $ASP_dir
	${Scripts_dir}/make_ASP.sh $number_of_users $transformed_dir $ASP_dir $pair_prefs $examples_ASP $number_of_strict_ex_ASP
}

## run the experiments
function run {
	for (( i=0; i<$number_of_users; i+=1 )); do
		if [ ! -d ${results_dir}/User${i} ]; then
      mkdir ${results_dir}/User${i}
      mkdir ${results_dir}/User${i}/Training
      mkdir ${results_dir}/User${i}/Testing
    fi
		# Training
		$gringo ${ASP_dir}/User${i}/Training/examples.gringo $data \
			${ASP_dir}/User${i}/Training/number_of_strict_examples.gringo \
			$outcomes ${ASP_dir}/$rules_train_ASP $pars | $clasp > ${results_dir}/User${i}/Training/res.txt 2>&1

		# Testing
		TREE_LEARNED="$(grep -B 2 OPTIMUM ${results_dir}/User${i}/Training/res.txt | sed -n 1p)" # making the rules
		foo=${TREE_LEARNED//)/).}
		TREE_LEARNED=$foo
		cp ${ASP_dir}/rules_test_template.gringo ${ASP_dir}/User${i}/Testing
		echo $TREE_LEARNED >> ${ASP_dir}/User${i}/Testing/rules_test_template.gringo
		$gringo $data ${ASP_dir}/User${i}/Testing/examples.gringo \
			${ASP_dir}/User${i}/Testing/number_of_strict_examples.gringo \
			$outcomes ${ASP_dir}/User${i}/Testing/rules_test_template.gringo | $clasp > ${results_dir}/User${i}/Testing/res.txt 2>&1
	done
}

## get the learned UIUP trees
function postRun {
	cat /dev/null > ${results_dir}/results.txt
	for (( i=0; i<$number_of_users; i+=1 )); do
		echo "MaxLearn UIUP PLP-trees for user $i:" >> ${results_dir}/results.txt
		echo "" >> ${results_dir}/results.txt
		# for training, get the tree
		echo "Using training data:" >> ${results_dir}/results.txt
		$parser_hr post ${origin_dir}/domain_description.txt ${results_dir}/User${i}/Training/res.txt $i -1 -1\
			$ASP_dir >> ${results_dir}/results.txt
		echo "" >> ${results_dir}/results.txt

		# for testing, get the numbers
		echo "Using testing data:" >> ${results_dir}/results.txt
		NUM_OF_SAT_PREDICATE="$(grep -B 1 SATISFIABLE ${results_dir}/User${i}/Testing/res.txt | sed -n 1p)"
		NUM_OF_SAT="$(echo $NUM_OF_SAT_PREDICATE | cut -d "(" -f2 | cut -d ")" -f1)"
		NUM_OF_STRICT_EX="$(wc -l ${ASP_dir}/User${i}/Testing/examples.gringo | awk '{print($1)}')"
		RESULT=$(awk "BEGIN {printf \"%.4f\",${NUM_OF_SAT}/${NUM_OF_STRICT_EX}}")
		echo "Satisfy ${NUM_OF_SAT} out of ${NUM_OF_STRICT_EX} (${RESULT}) examples." >> ${results_dir}/results.txt
		echo "" >> ${results_dir}/results.txt
		echo "" >> ${results_dir}/results.txt
	done

	# compute average accuracy
	#echo "Avarage accuracy: " >> ${results_dir}/results.txt
	#grep -Eo '\([0-9]+\.?[0-9]*\)' ${results_dir}/results.txt | sed 's/.$//; s/^.//' | awk '{a+=$1} END{print a/NR}' \
	#	>> ${results_dir}/results.txt
}

## clean up the intermedia data, that is, all the directory for the Users
function cleanup {
	rm -rf ${origin_dir}/StrictExamples
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
