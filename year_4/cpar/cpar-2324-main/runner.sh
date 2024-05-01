#!/bin/sh

METRICS=instructions,cycles,L1-dcache-load-misses
REPS=3

for i in {1..40}
do
    export OMP_NUM_THREADS=$i
    echo Threads: $i
    perf stat -r $REPS -e $METRICS sh -c "./MDpar.exe < inputdata.txt > /dev/null"
done