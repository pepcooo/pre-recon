#!/bin/bash

IPv4_REG="^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])"


function help() {
    echo "This is a help page for this pre-reconnaissance tool."
    echo "Usage:"
    echo "./pre-recon.sh [options] <IP address>"
    echo "Example:"
    echo "./pre-recon.sh -v 192.168.0.1"
    echo "This enables verbose output for a pre-recon of the 192.168.0.1 IP address."
    echo "For more examples consolt the examples.md"
}

VERBOSE=false
HEADERS=false
SILENT=false
DOMAIN=false

while getopts "hvSHD" opt; do
    case "$opt" in
        h) 
            help
            exit 0
            ;;
        v) 
            VERBOSE=true
            ;;
        S)
            SILENT=true
            ;;
        H)
            HEADERS=true
            ;;
        D)
            DOMAIN=true
            ;;
        \?) 
            echo "Unknown option"
            ;;
    esac
done

shift $((OPTIND-1))

ADDRESS=$1
echo "Scanning $ADDRESS:"

if [[ $DOMAIN == true ]]; then
    if [[ $ADDRESS =~ $IPv4_REG ]]; then
        echo "This is an IPv4 address."
    else
        echo "This is NOT an IPv4 address."
    fi
fi


NMAP_SCAN1=$(nmap -sS -A -Pn $1)


echo "$NMAP_SCAN1"