#!/bin/bash -ex
function bin2dec() {
    bv="$1"
    pos=0
    result=0
    strr=""
    while [ ${#bv} -ge 1 ]; 
    do
        result=$(($result+((${bv:0:1})*(2**(${#bv}-1)))))
        bv=${bv:1:$((${#bv}-1))}
        strr="$result"
        pos=$(($pos+1))
    done
    echo "$strr"
}

function main() {
    read -p "Choose number to convert : " deconvert 
    echo "$(bin2dec $deconvert)"
}

main