#!/bin/bash
#平均数

if [ "$#" -lt 1 ]; then 
    echo "No number given!"
else
    sum=0
    for i in $@; do
        sum=$((sum+i))
    done
    avg=$((sum/$#))
    echo "average=$avg"
fi
