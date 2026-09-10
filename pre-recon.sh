#!/bin/bash

function help() {
    echo "This is a help page for this pre-reconnaissance tool."
    echo "Usage:"
    echo "./pre-recon.sh [options] <IP>"
    echo "Example:"
    echo "./pre-recon.sh -v 192.168.0.1"
    echo "This enables verbose output for a pre-recon of the 192.168.0.1 IP."
    echo "For more examples consolt the examples.md"
}

while getopts "hv" opt; do
    case "$opt" in
        h) 
            help
            exit 0
            ;;
        v) 
            echo "Verbose mode active"
            ;;
        \?) 
            echo "Unknown option"
            ;;
    esac
done

echo "nothing done yet"