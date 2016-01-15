#!/bin/bash

## Transform the original datasets to new ones to be processed by my learning algorithm.
## After the following is done, I will have all pairwise preferences for all 60 users.
## These pairwise preferences are in ../Transformed/UserX/.

number_of_users=$1
number_of_iterations=$2
origin_dir=$3
transformed_dir=$4
pair_prefs=$5
parser_hr=$6
ASP_dir=$7

## main function
function main {
	if [ ! -d ${transformed_dir} ]; then
		mkdir ${transformed_dir}
		for (( i=0; i<$number_of_users; i+=1 )); do
			mkdir ${transformed_dir}/User${i}
			mkdir ${transformed_dir}/User${i}/Training
			mkdir ${transformed_dir}/User${i}/Testing
		done
	fi

	# get the number of columns
	OUTPUT="$(head -1 ${origin_dir}/strict_examples_cp.csv | sed 's/[^,]//g' | wc -c)"

	# if there are 4 columns, modify prefs1.csv; otherwise, do next.
	if [ "$OUTPUT" -eq "4" ]; then
		sed -i "/,1$/d" ${origin_dir}/prefs1.csv # remove the control examples
		cut --complement -f 4 -d, ${origin_dir}/prefs1.csv > ${origin_dir}/tmp.csv; \
			cp ${origin_dir}/tmp.csv ${origin_dir}/prefs1.csv; \
			rm ${origin_dir}/tmp.csv  # remove the last column for the Is Control
	fi

	for (( i=0; i<$number_of_users; i+=1 )); do
#		if [ ! -d ${transformed_dir}/User${i} ]; then
#			cp -r ${origin_dir} ${transformed_dir}/User${i}
#		fi
	
		X=$((i+1))
		
		for (( j=0; j<$number_of_iterations; j+=1 )); do
			# Parse the training set
			$parser_hr pre ${origin_dir}/domain_description.txt ${origin_dir}/outcomes.csv \
			${origin_dir}/StrictExamples/User${i}/Training/train${j} \
				${ASP_dir}/outcomes.gringo > ${transformed_dir}/User${i}/Training/strict_examples_new${j}.csv
			sed -n "/^${X},/p" ${transformed_dir}/User${i}/Training/strict_examples_new${j}.csv \
				> ${transformed_dir}/User${i}/Training/prefs${j}.csv
			sed -i "s/^${X},/${i},/g" ${transformed_dir}/User${i}/Training/prefs${j}.csv
			sed -i "s/[^,]*,//" ${transformed_dir}/User${i}/Training/prefs${j}.csv  # remove the first column for the User ID
	
			# Parse the testing set
			$parser_hr pre ${origin_dir}/domain_description.txt ${origin_dir}/outcomes.csv \
			${origin_dir}/StrictExamples/User${i}/Testing/test${j} \
				${ASP_dir}/outcomes.gringo > ${transformed_dir}/User${i}/Testing/strict_examples_new${j}.csv
			sed -n "/^${X},/p" ${transformed_dir}/User${i}/Testing/strict_examples_new${j}.csv \
				> ${transformed_dir}/User${i}/Testing/prefs${j}.csv
			sed -i "s/^${X},/${i},/g" ${transformed_dir}/User${i}/Testing/prefs${j}.csv
			sed -i "s/[^,]*,//" ${transformed_dir}/User${i}/Testing/prefs${j}.csv  # remove the first column for the User ID
		done
	done
}

##### main
main
