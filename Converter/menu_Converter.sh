#!/bin/bash -ex
function dec2bin() {
    clear
    read -p "Choose number to convert : " deconvert 
    str=""
    dec=$(($deconvert))
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
    echo "$deconvert in binary is $revstr"
}
function dec2hex() {
    clear
    read -p "Choose number to convert : " deconvert 
    str=""
    dec=$(($deconvert))
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
    echo "$deconvert in hexadecimal is $revstr"
}
function bin2dec() {
    clear
    read -p "Choose number to convert : " deconvert 
    bv="$deconvert"
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
    echo "$deconvert in decimal is $strr"
}
function bin2hex() {
    clear
    read -p "Choose number to convert : " deconvert
    bv="$deconvert"
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
    str=""
    dec=$(($strr))
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
    echo "$deconvert in hexadecimal is $revstr"
}
function hex2dec() {
    clear
    read -p "Choose number to convert : " deconvert
    str=""
    bv=$deconvert
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
    echo "$deconvert in decimal is $str"
}
function hex2bin() {
    clear
    read -p "Choose number to convert : " deconvert
    str=""
    bv=$deconvert
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
    str2=""
    dec=$(($str))
    while [ $dec -ge 1 ]; 
    do
        str2="$str2$(($dec%2))"
        r=$(($dec%2))
        dec=$(($dec/2))
    done
    for (( i=${#str2}-1; i>=0; i-- ));
    do
        revstr=$revstr${str2:$i:1}
    done
    echo "$deconvert in binary is $revstr"
}

function afficher_choix_Converter() {
    clear
    echo "1) Convert Decimal number to binary"
    echo "2) Convert Decimal number to Hexadecimal"
    echo "3) Convert Hexadecimal number to binary"
    echo "4) Convert Hexadecimal number to decimal"
    echo "5) Convert Binary number to decimal"
    echo "6) Convert Binary number to Hexadecimal"
    echo "7) Quit"
    choisir_fonction_Converter
}
function choisir_fonction_Converter() {
    read -n1 -p "Choose action (1-7) : " Action_Converter
    if [ "$Action_Converter" == "1" ]; then
        dec2bin
    elif [ "$Action_Converter" == "2" ]; then
        dec2hex
    elif [ "$Action_Converter" == "3" ]; then
        hex2bin
    elif [ "$Action_Converter" == "4" ]; then
        hex2dec
    elif [ "$Action_Converter" == "5" ]; then
        bin2dec
    elif [ "$Action_Converter" == "6" ]; then
        bin2hex
    elif [ "$Action_Converter" == "7" ]; then
        clear
        exit
    else
        echo "incorrect entry, please retry !"
        choisir_fonction_Converter
    fi
}

afficher_choix_Converter