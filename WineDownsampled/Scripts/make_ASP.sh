#!/bin/bash

## This script creates strict_examples.gringo and outcomes.gringo for ASP experiments.

number_of_users=$1
transformed_dir=$2
ASP_dir=$3
pair_prefs=$4
examples_ASP=$5
number_of_strict_ex=$6

## for strict_examples.gringo
function strictExamples {
	for (( i=0; i<$number_of_users; i+=1 )); do
		if [ ! -d ${ASP_dir}/User${i} ]; then
			mkdir ${ASP_dir}/User${i}
		fi

    for (( j=0; j<2; j+=1 )); do
      for (( k=0; k<10; k+=1 )); do
				# Strict examples ASP encoding for training (1000 examples)
				if [ -f ${transformed_dir}/User${i}/Training/prefs${j}${k}.csv ]; then
					cp ${transformed_dir}/User${i}/Training/prefs${j}${k}.csv ${ASP_dir}/User${i}/Training/examples${j}${k}.gringo
				fi
				sed -i "s/^/strictExample(/g" ${ASP_dir}/User${i}/Training/examples${j}${k}.gringo
				sed -i "s/$/)./g" ${ASP_dir}/User${i}/Training/examples${j}${k}.gringo

				# Strict examples ASP encoding for testing (1000 examples)
				if [ -f ${transformed_dir}/User${i}/Testing/prefs${j}${k}.csv ]; then
					cp ${transformed_dir}/User${i}/Testing/prefs${j}${k}.csv ${ASP_dir}/User${i}/Testing/examples${j}${k}.gringo
				fi
				sed -i "s/^/strictExample(/g" ${ASP_dir}/User${i}/Testing/examples${j}${k}.gringo
				sed -i "s/$/)./g" ${ASP_dir}/User${i}/Testing/examples${j}${k}.gringo

				# Strict examples ASP encoding for testing (all examples except the 1000 training examples)
				if [ -f ${transformed_dir}/User${i}/Testing/prefs_extra${j}${k}.csv ]; then
					cp ${transformed_dir}/User${i}/Testing/prefs_extra${j}${k}.csv ${ASP_dir}/User${i}/Testing/examples_extra${j}${k}.gringo
				fi
				sed -i "s/^/strictExample(/g" ${ASP_dir}/User${i}/Testing/examples_extra${j}${k}.gringo
				sed -i "s/$/)./g" ${ASP_dir}/User${i}/Testing/examples_extra${j}${k}.gringo
			done
		done
	done
}

## for number_of_strict_examples.gringo
function numberOfStrictEx {
	for (( i=0; i<$number_of_users; i+=1 )); do
		if [ ! -d ${ASP_dir}/User${i} ]; then
			mkdir ${ASP_dir}/User${i}
		fi

    for (( j=0; j<2; j+=1 )); do
      for (( k=0; k<10; k+=1 )); do
				# Number of strict examples ASP encoding for training
				NUMBER="$(wc -l ${ASP_dir}/User${i}/Training/examples${j}${k}.gringo | awk '{print($1)}')"
				echo "numberOfStrict(${NUMBER})." > ${ASP_dir}/User${i}/Training/number_of_strict_examples${j}${k}.gringo

				# Number of strict examples ASP encoding for testing (1000 examples)
				NUMBER="$(wc -l ${ASP_dir}/User${i}/Testing/examples${j}${k}.gringo | awk '{print($1)}')"
				echo "numberOfStrict(${NUMBER})." > ${ASP_dir}/User${i}/Testing/number_of_strict_examples${j}${k}.gringo

				# Number of strict examples ASP encoding for testing (all examples except the 1000 training examples)
				NUMBER="$(wc -l ${ASP_dir}/User${i}/Testing/examples_extra${j}${k}.gringo | awk '{print($1)}')"
				echo "numberOfStrict(${NUMBER})." > ${ASP_dir}/User${i}/Testing/number_of_strict_examples_extra${j}${k}.gringo
			done
		done
	done
}

## main function
function main {
	strictExamples
	numberOfStrictEx
}


##### main
main
