#init.sh
#!/bin/bash
./P.sh "$1"
if [ "$#" -eq 1 ]; then   
    if [ ! -x "$1" ]; then
        mkdir "$1"
        echo "OK: user created"
        ./V.sh "$1"
        exit 0
    else
        echo "Error: user already exists"
        ./V.sh "$1"
        exit 1
    fi
else
    echo "Error: parameters problem"
    ./V.sh "$1"
    exit 2
fi