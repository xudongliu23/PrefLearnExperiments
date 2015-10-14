#!/bin/bash

for (( i=1; i<10; i+=1 )); do
	./stats Results/results${i}.txt
done
for (( i=10; i<260; i+=10 )); do
	./stats Results/results${i}.txt
done
