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

function hex2dec() {
    str=""
    bv=$1
    while [ ${#bv} -ge 1 ]; 
    do
        case "${bv:0:1}" in
        A | a)
            ch=10
            ;;
        B | b)
            ch=11
            ;;
        C | c)
            ch=12
            ;;
        D | d)
            ch=13
            ;;
        E | e)
            ch=14
            ;;
        F | f)
            ch=15
            ;;
        *)
            ch=${bv:0:1}
            ;;
        esac
        result=$(($result+(($ch)*(16**(${#bv}-1)))))
        bv=${bv:1:$((${#bv}-1))}
        str="$result"
        pos=$(($pos+1))
    done
    echo "$str"
}

function main() {
    read -p "Choose number to convert : " deconvert 
    echo "$(dec2bin $(hex2dec $deconvert))"
}

main