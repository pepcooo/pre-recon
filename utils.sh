IPv4_REG="^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])"

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"

BOLD="\e[1m"
RESET="\e[0m"


function help() {
    printf "This is a help page for this pre-reconnaissance tool.\n"
    printf "Usage:\n"
    printf "    ./pre-recon.sh [options] <IP address/domain name>\n"
    printf "Available options:\n"
    printf "    -A - enables active reconnaissance (site response headers, port scan, ) \n"
    printf "    -P - enables passive reconnaissance (DNS/reverse DNS lookup, whois info)\n"
    printf "    -N d - enables a port scan, checking for open ports. The default scan may take some time, for up to 5 minutes. It is following:\n"
    printf "        nmap -sX -D RND,RND,RND,RND,ME -T2 -Pn --top-ports 200 <INPUT>\n"
    printf "        If you wish to write your own Nmap command, please use the c option. The usage is following:\n"
    printf "            ./pre-recon.sh -N c 'nmap <chosen flags>' <IP/domain>\n" 
    printf "        ${BOLD}It should be noted that the default scan is quite weak and will most likely lead to detection.${RESET}\n"
}

function is_installed() {
    command -v "$1" $> /dev/null
}