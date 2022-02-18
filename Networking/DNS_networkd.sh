#!/bin/bash

function DNS_config() {
    rm /etc/resolv.conf
    ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
    systemctl enable systemd-resolved.service
    systemctl restart systemd-resolved.service
}

DNS_config