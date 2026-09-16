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
                printf "${YELLOW}Unknown port scan type.\n" 
                printf "Viable options are: ${RESET}s, m, f.\n"
                exit 1
            fi
            ;;
        \?) 
            printf "Unknown option.\n"
            ;;
    esac
done

shift $((OPTIND-1))

input=$1


if [[ -z "$input" ]]; then
    printf "${RED}Empty input.${RESET}"
    exit 1 
fi


printf "Scanning $input:\n"


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
        printf "${RED}Couldn't find the domain.${RESET}\n"

    elif [[ -z "$ip" ]]; then
        printf "${RED}Couldn't find the IP address.${RESET}\n"

    else
        printf "${GREEN}Domain name:${RESET} $domain\n"
        printf "${GREEN}IP:${RESET} $ip\n"
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

    printf "$nmap_scan\n"
fi

if [[ "$headers" == true ]]; then
    headers_response="Unknown"
    if is_installed curl; then
        echo "test"
        headers_response=$(curl -I -s https://$input)
    fi
    
    printf "$headers_response\n"
fi