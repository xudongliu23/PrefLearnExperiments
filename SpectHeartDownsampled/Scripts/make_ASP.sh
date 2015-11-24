#!/bin/bash

## This script creates strict_examples.gringo and outcomes.gringo for ASP experiments.

number_of_users=$1
number_of_iterations=$2
transformed_dir=$3
ASP_dir=$4
pair_prefs=$5
examples_ASP=$6
number_of_strict_ex=$7

## for strict_examples.gringo
function strictExamples {
	for (( i=0; i<$number_of_users; i+=1 )); do
		if [ ! -d ${ASP_dir}/User${i} ]; then
			mkdir ${ASP_dir}/User${i}
			mkdir ${ASP_dir}/User${i}/Training
			mkdir ${ASP_dir}/User${i}/Testing
		fi

		for (( j=0; j<$number_of_iterations; j+=1 )); do
			# Strict examples ASP encoding for training
			if [ -f ${transformed_dir}/User${i}/Training/prefs${j}.csv ]; then
				cp ${transformed_dir}/User${i}/Training/prefs${j}.csv ${ASP_dir}/User${i}/Training/examples${j}.gringo
			fi
			sed -i "s/^/strictExample(/g" ${ASP_dir}/User${i}/Training/examples${j}.gringo
			sed -i "s/$/)./g" ${ASP_dir}/User${i}/Training/examples${j}.gringo
	
			# Strict examples ASP encoding for testing
			if [ -f ${transformed_dir}/User${i}/Testing/prefs${j}.csv ]; then
				cp ${transformed_dir}/User${i}/Testing/prefs${j}.csv ${ASP_dir}/User${i}/Testing/examples${j}.gringo
			fi
			sed -i "s/^/strictExample(/g" ${ASP_dir}/User${i}/Testing/examples${j}.gringo
			sed -i "s/$/)./g" ${ASP_dir}/User${i}/Testing/examples${j}.gringo
		done
	done
}

## for number_of_strict_examples.gringo
function numberOfStrictEx {
	for (( i=0; i<$number_of_users; i+=1 )); do
		if [ ! -d ${ASP_dir}/User${i} ]; then
			mkdir ${ASP_dir}/User${i}
			mkdir ${ASP_dir}/User${i}/Training
			mkdir ${ASP_dir}/User${i}/Testing
		fi

		for (( j=0; j<$number_of_iterations; j+=1 )); do
			# Number of strict examples ASP encoding for training
			NUMBER="$(wc -l ${ASP_dir}/User${i}/Training/examples${j}.gringo | awk '{print($1)}')"
			echo "numberOfStrict(${NUMBER})." > ${ASP_dir}/User${i}/Training/number_of_strict_examples${j}.gringo
	
			# Number of strict examples ASP encoding for testing
			NUMBER="$(wc -l ${ASP_dir}/User${i}/Testing/examples${j}.gringo | awk '{print($1)}')"
			echo "numberOfStrict(${NUMBER})." > ${ASP_dir}/User${i}/Testing/number_of_strict_examples${j}.gringo
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
