#!/bin/bash

source ./utils.sh

verbose=false

headers=false
domain_check=false
port_scan=false


while getopts "hvHDN:" opt; do
    case "$opt" in
        h) 
            help
            exit 0
            ;;
        v) 
            verbose=true
            ;;
        H)
            headers=true
            ;;
        D)
            domain_check=true
            ;;
        N) 
            port_scan=true
            scan_type="$OPTARG"
            ;;
        \?) 
            echo "Unknown option"
            ;;
    esac
done

shift $((OPTIND-1))

input=$1
echo "Scanning $input:"


if [[ "$domain_check" == true ]]; then
    domain=""
    IP=""  
    if [[ "$input" =~ $IPv4_REG ]]; then
        IP="$input"
        domain=$(dig -x "$input" +short)
    else
        domain="$input"
        IP=$(dig "$domain" +short)
    fi

    if [[ -z "$domain" ]]; then
        echo -e "${RED}Couldn't find the domain.${RESET}"

    elif [[ -z "$ip" ]]; then
        echo -e "${RED}Couldn't find th IP address.${RESET}"
    else
        echo -e "${GREEN}domain name:${RESET} $domain"
        echo -e "${GREEN}IP:${RESET} $IP"
    fi
fi 


NMAP_SCAN1=$(nmap -sS -A -Pn $1)


echo "$NMAP_SCAN1"