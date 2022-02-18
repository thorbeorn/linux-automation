#!/bin/bash

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
}

function choisir_fonction_configure_interface_network_managor() {
    arr_inter_string=""
    for interfacename in $(ip -4 -o a | awk '{print $2}')
    do 
        arr_inter_string="$interfacename-$arr_inter_string"
    done
    echo ""
    read -p "Choose interface to configure (${arr_inter_string::-1}) : " Action_IPV6_network_managor
    contain="false"
    for valinterface in $(ip -4 -o a | awk '{print $2}')
    do 
        if [ "$valinterface" == "$Action_IPV6_network_managor" ]; then
            contain="true"
        fi
    done
    if [ $contain == "true" ]; then
        configure_configure_interface_network_managor "$Action_IPV6_network_managor"
    else 
        echo "Interface name are not recognized!"
        choisir_fonction_configure_interface_network_managor 
    fi
}

function configure_configure_interface_network_managor() {
    clear
    echo "Configure interface : $1"
    echo "================================================="
    read -n1 -p "DHCP(y/n) : " DHCP
    if [ "$DHCP" == y ]; then
        filename="$1.network"
        echo -e "[Match]\nName=$1\n[Network]\nDHCP=yes" > /etc/systemd/network/$filename
    else
        read -p "IP(x.x.x.x/yy where x.x.x.x=IP and yy=mask) : " IP
        read -p "Gateway(x.x.x.x) : " GT
        read -p "DNS(x.x.x.x) : " DNS
        if [ "$IP" == "" ]; then
            a=""
        else
            a="Address=$IP"
        fi
        if [ "$GT" == "" ]; then
            g=""
        else
            g="Gateway=$GT"
        fi
        if [ "$DNS" == "" ]; then
            d=""
        else
            d="DNS=$GT"
        fi
        filename="$1.network"
        echo -e "[Match]\nName=$1\n[Network]\n$a\n$g\n$d" > /etc/systemd/network/$filename
    fi
    systemctl restart systemd-networkd
    show_interfaces_network_managor
    afficher_choix_next_configure_interface_network_managor
}

function afficher_choix_next_configure_interface_network_managor() {
    echo -e "\n1) Refresh config"
    echo "2) Configure interface"
    echo -e "3) Quit\n"
    choisir_fonction_next_configure_interface_network_managor
}

function choisir_fonction_next_configure_interface_network_managor() {
    read -n1 -p "Choose action (1-3) : " Action_IPV6_network_managor
    if [ "$Action_IPV6_network_managor" == "1" ]; then
        show_interfaces_network_managor
        afficher_choix_next_configure_interface_network_managor
    elif [ "$Action_IPV6_network_managor" == "2" ]; then
        configure_interface_network_managor
    elif [ "$Action_IPV6_network_managor" == "3" ]; then
        clear
        exit
    else
        echo "incorrect entry, please retry !"
        choisir_fonction_interface_network_managor
    fi
}

function configure_interface_network_managor() {
    show_interfaces_network_managor
    choisir_fonction_configure_interface_network_managor
}

configure_interface_network_managor