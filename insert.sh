#insert.sh
#!/bin/bash

dir_name=` dirname "$1"/"$2" `

./P.sh "$1"
if [ "$#" -eq 4 ]; then
    if [ ! -x "$1" ]; then
        echo "Error: user does not exist"
        ./V.sh "$1"
        exit 1
    else
        if [ -f "$1"/"$2" ]; then
            if [ -z "$3" ]; then
                echo "Error: service already exists"
                ./V.sh "$1"
                exit 2
            #update a service
            elif [ "$3" = "f" ]; then
                echo -e "$4" > "$1"/"$2"
                echo "OK:service updated"
                ./V.sh "$1"
                exit 0
            fi
        #create a service
        else 
            if [ ! -x "$dir_name" ]; then
                mkdir "$dir_name"
            fi 
                touch "$1"/"$2"
                echo -e "$4" > "$1"/"$2"
            echo "OK:service created"
            ./V.sh "$1"
            exit 0
        fi
    fi
else
    echo "Error: parameters problem"
    ./V.sh "$1"
    exit 3
fi