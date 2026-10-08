# About
---
This pre-recon tool performs reconnaissance, both passive and active on a given domain or IP address. 

The user chooses which type of reconnaissance to perform. There is also an ability to perform a port scan using ```nmap```. 

## Usage and installation
---
The usage is straight-forward. You simply clone the repository and run the script with desired options and specified IP address/domain name.
```
git clone https://github.com/pepcooo/pre-recon.git
cd pre-recon
./pre-recon [OPTIONS] <DOMAIN/IP ADDRESS>
```

## Options
---
As of now the supported options are:
- -A - performs active reconnaissance, which now consists only of getting headers and using ```traceroute```
- -P - performs passive reconnaissance, which does a (reverse for IP addresses) DNS lookup, filters ```whois``` response for useful information and uses ```curl``` for checking crt.sh for any subdomains (whenever crt.sh is up, that is)
- -N - performs a port scan using ```nmap```. If you wish to, you can specify your own scan using the c value followed by a command string (e.g.: ./pre-recon -N c 'nmap -sX' google.com). 

## Prerequisites
---
These commands should be installed on Linux based systems by defualt, but in some cases they may be absent:
- ```dig```
- ```curl``` 
- ```whois```
- ```wget``` (optional)
- ```traceroute```