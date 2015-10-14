#!/bin/bash

## Transform the original datasets to new ones to be processed by my learning algorithm.
## After the following is done, I will have all pairwise preferences for all users.
## These pairwise preferences are in ../Transformed/UserX/.

number_of_users=$1
origin_dir=$2
transformed_dir=$3
pair_prefs=$4
parser_hr=$5
ASP_dir=$6

## main function
function main {
	if [ ! -d ${transformed_dir} ]; then
		mkdir ${transformed_dir}
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
		if [ ! -d ${transformed_dir}/User${i} ]; then
			cp -r ${origin_dir} ${transformed_dir}/User${i}
		fi
	
		X=$((i+1))
		
		for (( j=0; j<2; j+=1 )); do
			for (( k=0; k<10; k+=1 )); do
				# Parse the training set (1000 examples)
				$parser_hr pre ${origin_dir}/domain_description.txt ${origin_dir}/outcomes.csv \
				${origin_dir}/StrictExamples/User${i}/Training/train${j}${k} \
					${ASP_dir}/outcomes.gringo > ${transformed_dir}/User${i}/Training/strict_examples_new${j}${k}.csv
				sed -n "/^${X},/p" ${transformed_dir}/User${i}/Training/strict_examples_new${j}${k}.csv \
					> ${transformed_dir}/User${i}/Training/prefs${j}${k}.csv
				sed -i "s/^${X},/${i},/g" ${transformed_dir}/User${i}/Training/prefs${j}${k}.csv
				sed -i "s/[^,]*,//" ${transformed_dir}/User${i}/Training/prefs${j}${k}.csv  # remove the first column for the User ID

				# Parse the testing set (1000 examples)
				$parser_hr pre ${origin_dir}/domain_description.txt ${origin_dir}/outcomes.csv \
				${origin_dir}/StrictExamples/User${i}/Testing/test${j}${k} \
					${ASP_dir}/outcomes.gringo > ${transformed_dir}/User${i}/Testing/strict_examples_new${j}${k}.csv
				sed -n "/^${X},/p" ${transformed_dir}/User${i}/Testing/strict_examples_new${j}${k}.csv \
					> ${transformed_dir}/User${i}/Testing/prefs${j}${k}.csv
				sed -i "s/^${X},/${i},/g" ${transformed_dir}/User${i}/Testing/prefs${j}${k}.csv
				sed -i "s/[^,]*,//" ${transformed_dir}/User${i}/Testing/prefs${j}${k}.csv  # remove the first column for the User ID

				# Parse the testing set (all other examples except the 1000 training examples)
				$parser_hr pre ${origin_dir}/domain_description.txt ${origin_dir}/outcomes.csv \
				${origin_dir}/StrictExamples/User${i}/Testing/test_extra${j}${k} \
					${ASP_dir}/outcomes.gringo > ${transformed_dir}/User${i}/Testing/strict_examples_new_extra${j}${k}.csv
				sed -n "/^${X},/p" ${transformed_dir}/User${i}/Testing/strict_examples_new_extra${j}${k}.csv \
					> ${transformed_dir}/User${i}/Testing/prefs_extra${j}${k}.csv
				sed -i "s/^${X},/${i},/g" ${transformed_dir}/User${i}/Testing/prefs_extra${j}${k}.csv
				sed -i "s/[^,]*,//" ${transformed_dir}/User${i}/Testing/prefs_extra${j}${k}.csv  # remove the first column for the User ID
			done
		done
	done
}

##### main
main
