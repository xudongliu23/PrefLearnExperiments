#!/bin/bash

for (( i=10; i<100; i+=10 )); do
	./get_run_time.sh $i
done
for (( i=100; i<1000; i+=100 )); do
	./get_run_time.sh $i
done
for (( i=1000; i<4000; i+=1000 )); do
	./get_run_time.sh $i
done
