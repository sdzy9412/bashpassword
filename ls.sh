#ls.sh
#!/bin/bash
./P.sh "$1"
if [ "$#" -eq 2 ]; then
    if [ ! -x "$1" ]; then
        echo "Error: user does not exist"
        ./V.sh "$1"
        exit 1
    else
        if [ -x "$1"/"$2" ]; then
            echo "OK:"
            tree "$1"/"$2"
            ./V.sh "$1"
            exit 0
        else
            echo "Error: folder does not exist"
            ./V.sh "$1"
            exit 2
        fi
    fi
elif [ "$#" -eq 1 ]; then 
    if [ ! -x "$1" ]; then
        echo "Error: user does not exist"
        ./V.sh "$1"
        exit 1
    else
        echo "OK:"
        tree "$1"
        ./V.sh "$1"
        exit 0
    fi
else 
    echo "Error: parameters problem"
    ./V.sh "$1"
    exit 3
fi