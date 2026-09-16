IPv4_REG="^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])"

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"

BOLD="\e[1m"
RESET="\e[0m"


function help() {
    printf "This is a help page for this pre-reconnaissance tool.\n"
    printf "Usage:\n"
    printf "    ./pre-recon.sh [options] <IP address/domain name>\n"
    printf "Available options:\n"
    printf "    -H - enables header reading using curl, wget or bash built-in utilities. ${BOLD}It is recommended to install curl.${RESET}\n"
    printf "    -D - enables DNS lookup (or reverse DNS lookup if an IP address is given).\n"
    printf "    -N <option> - enables a port scan, checking for open ports. Available scan modes are:\n"
    printf "        -s - 'silent' mode, quite slow\n"
    printf "        -m - 'moderate' mode, should be fast but quite easily detectable\n"
    printf "        -f - 'fast' mode, only scans 100 ports (1000 is the default number).\n"
    printf "        -c - 'custom' mode, it allows the user to write their own nmap query. The syntax is following:\n"
    printf "            ./pre-recon.sh -N c 'nmap <chosen flags>' <IP/domain>\n" 
    printf "        ${BOLD}It should be noted that s, m and f port scans are quite weak and will most likely lead to detection.${RESET}\n"
}

function is_installed() {
    command -v "$1" $> /dev/null
}