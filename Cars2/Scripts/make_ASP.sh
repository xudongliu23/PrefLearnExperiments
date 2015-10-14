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
			mkdir ${ASP_dir}/User${i}/Training
			mkdir ${ASP_dir}/User${i}/Testing
		fi

		# Strict examples ASP encoding for training
		if [ -f ${transformed_dir}/User${i}/Training/prefs.csv ]; then
			cp ${transformed_dir}/User${i}/Training/prefs.csv ${ASP_dir}/User${i}/Training/examples.gringo
		fi
		sed -i "s/^/strictExample(/g" ${ASP_dir}/User${i}/Training/examples.gringo
		sed -i "s/$/)./g" ${ASP_dir}/User${i}/Training/examples.gringo

		# Strict examples ASP encoding for testing
		if [ -f ${transformed_dir}/User${i}/Testing/prefs.csv ]; then
			cp ${transformed_dir}/User${i}/Testing/prefs.csv ${ASP_dir}/User${i}/Testing/examples.gringo
		fi
		sed -i "s/^/strictExample(/g" ${ASP_dir}/User${i}/Testing/examples.gringo
		sed -i "s/$/)./g" ${ASP_dir}/User${i}/Testing/examples.gringo
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

		# Number of strict examples ASP encoding for training
		NUMBER="$(wc -l ${ASP_dir}/User${i}/Training/examples.gringo | awk '{print($1)}')"
		echo "numberOfStrict(${NUMBER})." > ${ASP_dir}/User${i}/Training/number_of_strict_examples.gringo

		# Number of strict examples ASP encoding for testing
		NUMBER="$(wc -l ${ASP_dir}/User${i}/Testing/examples.gringo | awk '{print($1)}')"
		echo "numberOfStrict(${NUMBER})." > ${ASP_dir}/User${i}/Testing/number_of_strict_examples.gringo
	done
}

## main function
function main {
	strictExamples
	numberOfStrictEx
}


##### main
main
