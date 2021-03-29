#!/bin/bash
#打招呼

while true; do
    echo "Give a name:"
    read name
    for i in $@; do
        if [ $i == $name ]; then
            echo "Welcome back $name!"
        fi
    done
done