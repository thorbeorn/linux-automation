#!/bin/bash -ex
######################Show interface####################################
function afficher_choix_interface_Networking() {
    echo "1) Retry show interfaces"
    echo "2) Return to Networking menu"
    echo "3) Quit"
    choisir_fonction_interface_Networking
}
function choisir_fonction_interface_Networking() {
    read -n1 -p "Choose action (1-3) : " Action_interface_Networking
    if [ "$Action_interface_Networking" == "1" ]; then
        show_interfaces_Networking
        afficher_choix_interface_Networking
    elif [ "$Action_interface_Networking" == "2" ]; then
        clear
        afficher_choix_Networking
    elif [ "$Action_interface_Networking" == "3" ]; then
        clear
        exit
    else
        echo "incorrect entry, please retry !"
        choisir_fonction_interface_Networking
    fi
}
function show_interfaces_Networking() {
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
    echo -e "\n===================================\n"
}
function main_show_interfaces_Networking() {
    show_interfaces_Networking
    afficher_choix_interface_Networking
}
######################Configure interface####################################
function choisir_fonction_configure_interface_Networking() {
    arr_inter_string=""
    for interfacename in $(ip -4 -o a | awk '{print $2}')
    do 
        arr_inter_string="$interfacename-$arr_inter_string"
    done
    echo ""
    read -p "Choose interface to configure (${arr_inter_string::-1}) : " Action_IPV6_Networking
    contain="false"
    for valinterface in $(ip -4 -o a | awk '{print $2}')
    do 
        if [ "$valinterface" == "$Action_IPV6_Networking" ]; then
            contain="true"
        fi
    done
    if [ $contain == "true" ]; then
        configure_configure_interface_Networking "$Action_IPV6_Networking"
    else 
        echo "Interface name are not recognized!"
        choisir_fonction_configure_interface_Networking 
    fi
}
function configure_configure_interface_Networking() {
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
    show_interfaces_Networking
    afficher_choix_next_configure_interface_Networking
}
function afficher_choix_next_configure_interface_Networking() {
    echo -e "\n1) Refresh config"
    echo "2) Configure interface"
    echo "3) Return to Networking menu"
    echo -e "4) Quit\n"
    choisir_fonction_next_configure_interface_Networking
}
function choisir_fonction_next_configure_interface_Networking() {
    read -n1 -p "Choose action (1-3) : " Action_configure_interface_Networking
    if [ "$Action_configure_interface_Networking" == "1" ]; then
        show_interfaces_Networking
        afficher_choix_next_configure_interface_Networking
    elif [ "$Action_configure_interface_Networking" == "2" ]; then
        choisir_fonction_configure_interface_Networking
    elif [ "$Action_configure_interface_Networking" == "3" ]; then
        clear
        afficher_choix_Networking
    elif [ "$Action_configure_interface_Networking" == "4" ]; then
        clear
        exit
    else
        echo "incorrect entry, please retry !"
        choisir_fonction_interface_network_managor
    fi
}
function main_configure_interface_Networking() {
    show_interfaces_Networking
    choisir_fonction_configure_interface_Networking
}
######################Configure IPV6####################################
function afficher_choix_IPV6_Networking() {
    echo -e "\n1) Retry check IPV6"
    if [ "$(sysctl -p | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}')" = "1" ] && [ "$(sysctl -p | grep net.ipv6.conf.all.autoconf | awk '{print $3}')" = "0" ] && [ "$(sysctl -p | grep net.ipv6.conf.default.disable_ipv6 | awk '{print $3}')" = "1" ] && [ "$(sysctl -p | grep net.ipv6.conf.default.autoconf | awk '{print $3}')" = "0" ]; then 
        echo "2) Enable IPV6"
    else
        echo "2) Disable IPV6"
    fi
    echo "3) Return to Networking menu"
    echo -e "4) Quit\n"
    choisir_fonction_IPV6_Networking
}
function choisir_fonction_IPV6_Networking() {
    read -n1 -p "Choose action (1-4) : " Action_IPV6_Networking
    if [ "$Action_IPV6_Networking" == "1" ]; then
        main_IPV6_Networking
    elif [ "$Action_IPV6_Networking" == "2" ]; then
        IPV6_chage_state
    elif [ "$Action_IPV6_Networking" == "3" ]; then
        clear
        afficher_choix_Networking
    elif [ "$Action_IPV6_Networking" == "4" ]; then
        clear
        exit
    else
        echo "incorrect entry, please retry !"
        choisir_fonction_IPV6_network_managor
    fi
}
function IPV6_chage_state() {
    if [ "$(sysctl -p | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}')" = "1" ] && [ "$(sysctl -p | grep net.ipv6.conf.all.autoconf | awk '{print $3}')" = "0" ] && [ "$(sysctl -p | grep net.ipv6.conf.default.disable_ipv6 | awk '{print $3}')" = "1" ] && [ "$(sysctl -p | grep net.ipv6.conf.default.autoconf | awk '{print $3}')" = "0" ]; then 
        sed -i "s/net.ipv6.conf.all.disable_ipv6 = 1//" /etc/sysctl.conf
        sed -i "s/net.ipv6.conf.all.autoconf = 0//" /etc/sysctl.conf
        sed -i "s/net.ipv6.conf.default.disable_ipv6 = 1//" /etc/sysctl.conf
        sed -i "s/net.ipv6.conf.default.autoconf = 0//" /etc/sysctl.conf
        systemctl restart systemd-networkd
        main_IPV6_Networking
    else
        echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
        echo "net.ipv6.conf.all.autoconf = 0" >> /etc/sysctl.conf
        echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
        echo "net.ipv6.conf.default.autoconf = 0" >> /etc/sysctl.conf
        systemctl restart systemd-networkd
        main_IPV6_Networking
    fi
}
function main_IPV6_Networking() {
    clear
    if [ "$(sysctl -p | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}')" = "1" ] && [ "$(sysctl -p | grep net.ipv6.conf.all.autoconf | awk '{print $3}')" = "0" ] && [ "$(sysctl -p | grep net.ipv6.conf.default.disable_ipv6 | awk '{print $3}')" = "1" ] && [ "$(sysctl -p | grep net.ipv6.conf.default.autoconf | awk '{print $3}')" = "0" ]; then 
        echo "IPV6 is actually disabled"
    else
        echo "IPV6 is actually enable"
    fi
    afficher_choix_IPV6_Networking
}
######################DNS####################################
function DNS_config() {
    rm /etc/resolv.conf
    ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
    systemctl enable systemd-resolved.service
    systemctl restart systemd-resolved.service
    systemctl restart systemd-networkd
    echo "DNS updates"
}

function afficher_choix_Networking() {
    clear
    echo "1) Show interfaces"
    echo "2) Config interfaces"
    echo "3) Config IPV6"
    echo "4) DNS from networkd(execute 1 time)"
    echo "5) Quit"
    choisir_fonction_Networking
}
function choisir_fonction_Networking() {
    read -n1 -p "Choose action (1-5) : " Action_Converter
    if [ "$Action_Converter" == "1" ]; then
        main_show_interfaces_Networking
    elif [ "$Action_Converter" == "2" ]; then
        main_configure_interface_Networking
    elif [ "$Action_Converter" == "3" ]; then
        main_IPV6_Networking
    elif [ "$Action_Converter" == "4" ]; then
        DNS_config
    elif [ "$Action_Converter" == "5" ]; then
        clear
        exit
    else
        echo "incorrect entry, please retry !"
        choisir_fonction_Networking
    fi
}

afficher_choix_Networking