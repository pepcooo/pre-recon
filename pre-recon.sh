#!/bin/bash

source ./utils.sh

passive=false
active=false
port_scan=false
scan_type=1

while getopts "hPAN:" opt; do
    case "$opt" in
        h) 
            help
            exit 0
            ;;
        P)
            passive=true
            ;;
        A)
            active=true
            ;;
        N) 
            port_scan=true
            scan_type="$OPTARG"

            if [[ ! "$scan_type" =~ ^[dc]$ ]]; then
                printf "Unknown nmap scan option.\n"
                exit 1
            fi    

            if [[ "$scan_type" == "c" ]]; then
                scan="custom"
                custom_args="${!OPTIND}"
                if [[ -z "$custom_args" || "$custom_args" != nmap* ]]; then
                    printf "Error in parsing custom nmap query."
                    exit 1
                fi
                OPTIND=$((OPTIND+1))

            else
                scan="default"
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
    printf "${RED}Empty input.${RESET}\n"
    exit 1 
fi


printf "Scanning $input:\n"

domain=""
ip=""  


if [[ "$input" =~ $IPv4_REG ]]; then
    ip="$input"
    domain=""
else
    domain="$input"
    ip=""
fi

if [[ "$passive" == true ]]; then
    printf "${BLUE}Performing passive scan...${RESET}\n"


    if is_installed dig; then
        if [[ -z "$domain" ]]; then
            domain=$(dig -x "$ip" +short)
            
            if [[ -z "$domain" ]]; then
                printf "${RED}Couldn't look up the domain.${RESET}\n"
            fi

        elif [[ -z "$ip" ]]; then
            ip=$(dig "$domain" +short)
            
            if [[ -z "$ip" ]]; then
                printf "${RED}Couldn't find the IP address.${RESET}\n"
            fi

        fi
    fi

    if [[ ! -z "$domain" && ! -z "$ip" ]]; then
        printf "${GREEN}IP${RESET}:\n$ip\n\n\n"
        printf "${GREEN}Domain name${RESET}:\n$domain\n\n\n"
    fi

    
    
    if is_installed whois; then
        whois_response=$(whois -H "$input" | grep -iE "^(Name Server|Domain Name|Postal Code|Registrant Email|Creation Date|Updated Date)|(Organization|Country|Street|City|State|Provinence)+")
        printf "whois ${GREEN}response${RESET}:\n$whois_response\n\n\n"
    else
        printf "whois ${RED}is not installed on this system.\n"
        printf "Consider installing it to get more information about the domain.${RESET}\n\n\n" 
    fi


    if is_installed curl; then
        subdomains=$(curl -s "https://crt.sh/?q=%25.$input&output=json" | jq -r ".[].name_value" | sed "s/\*\.//" | sort -u)
    fi

    if [[ -z "$subdomains" ]]; then
        printf "${RED}No subdomains found or ${RESET}crt.sh${RED} is down.\n"
        printf "Check https://downforeveryoneorjustme.com/crt.sh to see if crt.sh is down.\n"
        printf "If so, either wait until it is back again or use another tool to enumerate subdomains, like DNSDumpster (online) or sublist3r.${RESET}\n\n\n"
    else
        printf "${GREEN}Subdomains:${RESET}\n$subdomains\n"
    fi  
fi

if [[ "$active" == true ]]; then
    printf "${BLUE}Performing active scan...${RESET}\n"

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
  
  
    printf "${GREEN}Headers response${RESET}:\n$headers_response\n\n\n"
fi

if [[ "$port_scan" == true ]]; then
    nmap_scan=""
    if [[ "$scan" == "default" ]]; then
        nmap_scan=$(nmap -sX -D RND,RND,RND,RND,ME -T2 -Pn --top-ports 200 "$input")
    elif [[ "$scan" == "custom" ]]; then
        nmap_scan=$($custom_args $input)
    fi

    printf "Nmap scan:\n$nmap_scan"
fi