#!/bin/bash

for (( i=1; i<10; i+=1 )); do
	./stats Results/results${i}.txt
done
for (( i=10; i<100; i+=10 )); do
	./stats Results/results${i}.txt
done
for (( i=100; i<1000; i+=100 )); do
	./stats Results/results${i}.txt
done
for (( i=1000; i<5000; i+=1000 )); do 
	./stats Results/results${i}.txt
done
