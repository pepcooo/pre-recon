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
            if [[ "$scan_type" == "c" ]]; then
                custom_args="${!OPTIND}"
                if [[ -z "$custom_args" || "$custom_args" != nmap* ]]; then
                    printf "Error in parsing custom nmap query."
                    exit 1
                fi
                OPTIND=$((OPTIND+1))
            elif [[ ! "$scan_type" =~ ^(s|m|f|c)$ ]]; then
                printf "${YELLOW}Unknown port scan type.\n" 
                printf "Viable options are: ${RESET}s, m, f, c (custom).\n"
                printf "If you need further help, please check ./pre-recon.sh -h"
                exit 1
            fi
            ;;
        \?) 
            printf "Unknown option.\n"
            printf "Check ./pre-recon.sh -h if you need any help."
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
        c)
            nmap_scan=$($custom_args "$input")
            ;;
    esac

    printf "$nmap_scan\n"
fi

if [[ "$headers" == true ]]; then
    tool_used="None"
    headers_response="Unknown"
    if is_installed curl; then
        headers_response=$(curl -I -s -L -k -m 5 http://$input)
        tool_used="cURL"
    fi

    if is_installed wget && [[ -z "$headers_response" ]]; then
        headers_response=$(wget -S -q --spider --no-check-certificate --timeout=5 "http://$input" 2>&1)
        tool_used="Wget"
    fi

    if [[ -z "$headers_response" ]]; then
        if exec 3<>/dev/tcp/"$input"/80 2>/dev/null; then
            echo -e "HEAD / HTTP/1.1\r\nHost: $input\r\nConnection: close\r\n\r\n" >&3
            headers_response=$(cat <&3)
            exec 3<&-
        else
            headers_response="Port 80 is closed or host is unresponsive."
        fi
        tool_used="Bash built-in web utilities" 
    fi
    printf "$headers_response\n"
fi