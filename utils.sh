IPv4_REG="^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])"

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"


function help() {
    echo "This is a help page for this pre-reconnaissance tool."
    echo "Usage:"
    echo "./pre-recon.sh [options] <IP address>"
    echo "Example:"
    echo "./pre-recon.sh -v 192.168.0.1"
    echo "This enables verbose output for a pre-recon of the 192.168.0.1 IP address."
    echo "For more examples consolt the examples.md"
}