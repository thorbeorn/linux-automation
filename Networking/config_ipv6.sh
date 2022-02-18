#!/bin/bash

function IPV6_chage_state() {
    if [ "$(sysctl -p | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}')" = "1" ] && [ "$(sysctl -p | grep net.ipv6.conf.all.autoconf | awk '{print $3}')" = "0" ] && [ "$(sysctl -p | grep net.ipv6.conf.default.disable_ipv6 | awk '{print $3}')" = "1" ] && [ "$(sysctl -p | grep net.ipv6.conf.default.autoconf | awk '{print $3}')" = "0" ]; then 
        sed -i "s/net.ipv6.conf.all.disable_ipv6 = 1//" /etc/sysctl.conf
        sed -i "s/net.ipv6.conf.all.autoconf = 0//" /etc/sysctl.conf
        sed -i "s/net.ipv6.conf.default.disable_ipv6 = 1//" /etc/sysctl.conf
        sed -i "s/net.ipv6.conf.default.autoconf = 0//" /etc/sysctl.conf
        show_IPV6_network_managor
    else
        echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
        echo "net.ipv6.conf.all.autoconf = 0" >> /etc/sysctl.conf
        echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
        echo "net.ipv6.conf.default.autoconf = 0" >> /etc/sysctl.conf
        show_IPV6_network_managor
    fi
    systemctl restart systemd-networkd
}

function afficher_choix_IPV6_network_managor() {
    echo -e "\n1) Retry check IPV6"
    if [ "$(sysctl -p | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}')" = "1" ] && [ "$(sysctl -p | grep net.ipv6.conf.all.autoconf | awk '{print $3}')" = "0" ] && [ "$(sysctl -p | grep net.ipv6.conf.default.disable_ipv6 | awk '{print $3}')" = "1" ] && [ "$(sysctl -p | grep net.ipv6.conf.default.autoconf | awk '{print $3}')" = "0" ]; then 
        echo "2) Enable IPV6"
    else
        echo "2) Disable IPV6"
    fi
    echo -e "3) Quit\n"
}

function choisir_fonction_IPV6_network_managor() {
    read -n1 -p "Choose action (1-3) : " Action_IPV6_network_managor
    if [ "$Action_IPV6_network_managor" == "1" ]; then
        show_IPV6_network_managor
    elif [ "$Action_IPV6_network_managor" == "2" ]; then
        IPV6_chage_state
    elif [ "$Action_IPV6_network_managor" == "3" ]; then
        clear
        exit
    else
        echo "incorrect entry, please retry !"
        choisir_fonction_IPV6_network_managor
    fi
}

function show_IPV6_network_managor() {
    clear
    if [ "$(sysctl -p | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}')" = "1" ] && [ "$(sysctl -p | grep net.ipv6.conf.all.autoconf | awk '{print $3}')" = "0" ] && [ "$(sysctl -p | grep net.ipv6.conf.default.disable_ipv6 | awk '{print $3}')" = "1" ] && [ "$(sysctl -p | grep net.ipv6.conf.default.autoconf | awk '{print $3}')" = "0" ]; then 
        echo "IPV6 is actually disabled"
    else
        echo "IPV6 is actually enable"
    fi
    afficher_choix_IPV6_network_managor
    choisir_fonction_IPV6_network_managor
}

show_IPV6_network_managor