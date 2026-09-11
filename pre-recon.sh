#!/bin/bash

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

while getopts "hvSH" opt; do
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
        \?) 
            echo "Unknown option"
            ;;
    esac
done

shift $((OPTIND-1))

echo "Scanning domain: $1"

NMAP_SCAN1=$(nmap -sS -A -Pn $1)

echo "$NMAP_SCAN1"