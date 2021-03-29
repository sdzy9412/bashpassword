#!/bin/bash
#最大数

if [ $# -lt 1 ]; then
    echo "no number given!"
elif [ $# -eq 1 ]; then
    echo "$1"
else
    a=$1
    for i in $@; do
        if [[ $a -le $1 ]]; then
            a=$1
        fi
        shift
    done
    echo "$a"
fi