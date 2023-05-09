# Desc: Check SSL certificate expiration date
# Usage: ./certcheck.sh <domain>
# Author: Elias Ericsson-Rydberg
# Date: 2023-05-09
# Version: 1.0.0
# Dependecies: curl, openssl
# License: MIT
#
# Example:
# $ ./certcheck.sh www.google.com
#
# Output:
# 89 days until expiration: www.google.com
#
# Example:
# $ ./certcheck.sh www.google.com www.facebook.com
# 89 days until expiration: www.google.com
# 89 days until expiration: www.facebook.com

# Check if domain is provided
# If not, exit with error

# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'

if [ -z "$1" ]; then
  echo "${YELLOW}No domain provided${NC}"
  echo "Usage: ./certcheck.sh <domain>"
  exit 1
fi

for i in "$@"
do
    # Get expiration date from domain
    # If domain is not valid, exit with error
    expirationdate=$(echo | openssl s_client -servername "$i" -connect $i:443 2>/dev/null | openssl x509 -noout -dates | grep notAfter | cut -d "=" -f 2)

    if [ -z "$expirationdate" ]; then
        echo "${RED}Could not find certificate for $i${NC}"
    fi

    # Convert expiration date and current date to seconds
    expirationdateinseconds=$(date -d "$expirationdate" +%s)
    currentdateinseconds=$(date +%s)

    # Calculate difference between expiration date and current date convert it to days
    datedifference=$(expr $expirationdateinseconds - $currentdateinseconds)
    datedifferenceindays=$(expr $datedifference / 86400)

    # Output result
    if [ "$datedifferenceindays" -lt 30 ]; then
        echo "${RED}$datedifferenceindays days${NC} until expiration: $i" 
    elif [ "$datedifferenceindays" -lt 60 ]; then
        echo "${YELLOW}$datedifferenceindays days${NC} until expiration: $i" 
    else
        echo "${GREEN}$datedifferenceindays days${NC} until expiration: $i" 
    fi
done
