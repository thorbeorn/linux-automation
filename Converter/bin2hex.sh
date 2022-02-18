#!/bin/bash -ex
function dec2hex() {
    str=""
    dec=$(($1))
    while [ $dec -ge 1 ]; 
    do
        case $(($dec%16)) in
        10)
            str="${str}A"
            ;;
        11)
            str="${str}B"
            ;;
        12)
            str="${str}C"
            ;;
        13)
            str="${str}D"
            ;;
        14)
            str="${str}E"
            ;;
        15)
            str="${str}F"
            ;;
        *)
            str="$str$(($dec%16))"
            ;;
        esac
        dec=$(($dec/16))
    done
    for (( i=${#str}-1; i>=0; i-- ));
    do
        revstr=$revstr${str:$i:1}
    done
    echo "$revstr"
}

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
    echo "$(dec2hex $(bin2dec $deconvert))"
}

main