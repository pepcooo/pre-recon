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
DOMAIN_CHECK=false

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
            DOMAIN_CHECK=true
            ;;
        \?) 
            echo "Unknown option"
            ;;
    esac
done

shift $((OPTIND-1))

INPUT=$1
echo "Scanning $INPUT:"


if [[ "$DOMAIN_CHECK" == true ]]; then
    DOMAIN=""
    IP=""
    if [[ "$INPUT" =~ $IPv4_REG ]]; then
        IP="$INPUT"
        DOMAIN=$(dig -x "$INPUT" +short)
    else
        DOMAIN="$INPUT"
        IP=$(dig "$DOMAIN" +short)
    fi

    if [[ -z "$DOMAIN" ]]; then
        echo "Couldn't find the domain."
    else
        echo "Domain name: $DOMAIN"
        echo "IP: $ADDRESS"
    fi
fi


NMAP_SCAN1=$(nmap -sS -A -Pn $1)


echo "$NMAP_SCAN1"