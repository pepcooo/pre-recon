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
            if [[ ! "$scan_type" =~ ^(s|m|f)$ ]]; then
                echo -e "${YELLOW}Unknown port scan type." 
                echo -e "Viable options are: ${RESET}s, m, f."
                exit 1
            fi
            ;;
        \?) 
            echo "Unknown option"
            ;;
    esac
done

shift $((OPTIND-1))

input=$1


if [[ -z "$input" ]]; then
    echo -e "${RED}Empty input.${RESET}"
    exit 1 
fi


echo "Scanning $input:"


if [[ "$domain_check" == true ]]; then
    domain=""
    ip=""  
    if [[ "$input" =~ $IPv4_REG ]]; then
        ip="$input"
        domain=$(dig -x "$input" +short)
    else
        domain="$input"
        ip=$(dig "$domain" +short)
    fi

    if [[ -z "$domain" ]]; then
        echo -e "${RED}Couldn't find the domain.${RESET}"

    elif [[ -z "$ip" ]]; then
        echo -e "${RED}Couldn't find the IP address.${RESET}"

    else
        echo -e "${GREEN}Domain name:${RESET} $domain"
        echo -e "${GREEN}IP:${RESET} $ip"
    fi
fi 

if [[ "$port_scan" == true ]]; then

    case "$scan_type" in
        s)
            nmap_scan=$(nmap -sS -D RND,RND,RND,RND,RND,RND,RND,ME,RND,RND -Pn -T2 $input)
            ;;
        m)
            nmap_scan=$(nmap -sS -Pn $input)
            ;;
        f)  
            nmap_scan=$(nmap -sS -Pn -F $input)
            ;;
    esac

    echo "$nmap_scan"
fi