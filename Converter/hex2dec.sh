#!/bin/bash -ex
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
    echo "$(hex2dec $deconvert)"
}

main