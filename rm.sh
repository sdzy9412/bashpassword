#rm.sh
#!/bin/bash
./P.sh "$1"
if [ "$#" -eq 2 ]; then
    if [ ! -x "$1" ]; then
        echo "Error:user does not exist"
        ./V.sh "$1"
        exit 1
    else
        if [ -f "$1"/"$2" ]; then
            rm "$1"/"$2"
            echo "OK: service removed"
            ./V.sh "$1"
            exit 0
        else
            echo "Error: service does not exist"
            ./V.sh "$1"
            exit 2
        fi
    fi
else
    echo "Error: parameters problem"
    ./V.sh "$1"
    exit 3
fi