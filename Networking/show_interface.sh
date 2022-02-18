#!/bin/bash

function afficher_choix_interface_network_managor() {
    echo -e "\n1) Retry show interfaces"
    echo -e "2) Quit\n"
}

function choisir_fonction_interface_network_managor() {
    read -n1 -p "Choose action (1-2) : " Action_interface_network_managor
    if [ "$Action_interface_network_managor" == "1" ]; then
        show_interfaces_network_managor
    elif [ "$Action_interface_network_managor" == "2" ]; then
        echo ""
        exit
    else
        echo "incorrect entry, please retry !"
        choisir_fonction_interface_network_managor
    fi
}

function show_interfaces_network_managor() {
    clear
    echo "Number of interfaces connected : $(ls -A /sys/class/net | wc -l)"
    for interfacename in $(ip -4 -o a | awk '{print $2}')
    do 
        echo -e "\n============$interfacename============"
        echo "=> IPV4"
        echo "IP address -> $(ip -4 -o addr show $interfacename | awk '{print $4}')"
        echo "Broadcast IP -> $(ip -4 -o addr show $interfacename | awk '{print $6}')"
        echo -e "\n=> IPV6"
        testipv6="false"
        for interfacenameipv6 in $(ip -6 -o addr show $interfacename | awk '{print $4}')
        do 
            echo "IP address -> $interfacenameipv6"
            testipv6="true"
        done
        if [ $testipv6 == "false" ]; then
            echo "No IPV6 configured"
        fi
    done
    echo -e "\n==================================="
    afficher_choix_interface_network_managor
    choisir_fonction_interface_network_managor
}

show_interfaces_network_managor