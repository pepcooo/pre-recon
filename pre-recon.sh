#!/bin/bash

source ./utils.sh

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
        echo -e "${RED}Couldn't find the domain.${RESET}"
    else
        echo -e "${GREEN}Domain name:${RESET} $DOMAIN"
        echo -e "${GREEN}IP:${RESET} $IP"
    fi
fi


NMAP_SCAN1=$(nmap -sS -A -Pn $1)


echo "$NMAP_SCAN1"