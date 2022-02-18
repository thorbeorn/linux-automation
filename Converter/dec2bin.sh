#!/bin/bash -ex
function dec2bin() {
    str=""
    dec=$(($1))
    while [ $dec -ge 1 ]; 
    do
        str="$str$(($dec%2))"
        r=$(($dec%2))
        dec=$(($dec/2))
    done
    for (( i=${#str}-1; i>=0; i-- ));
    do
        revstr=$revstr${str:$i:1}
    done
    echo "$revstr"
}

function main() {
    read -p "Choose number to convert : " deconvert 
    echo "$(dec2bin $deconvert)"
}

main