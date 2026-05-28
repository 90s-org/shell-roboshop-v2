#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MESSAGE=""
IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

log(){
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $1"
}

RAM_THRESHOLD=80

TOTAL=$(free | awk '/Mem:/ {print $2}')
USED=$(free | awk '/Mem:/ {print $3}')
USAGE=$(awk "BEGIN {printf \"%.0f\", ($USED/$TOTAL)*100}")

log "RAM Usage: ${USAGE}%"

if [ "$USAGE" -ge "$RAM_THRESHOLD" ]; then
    MESSAGE="High RAM usage: ${USAGE}% (Used: $(free -h | awk '/Mem:/ {print $3}') / Total: $(free -h | awk '/Mem:/ {print $2}')) <br>"
    echo -e "$MESSAGE"
    sh mail.sh "info@joindevops.com" "High RAM Usage Alert on $IP_ADDRESS" "$MESSAGE" "HIGH_RAM_USAGE" "$IP_ADDRESS" "DevOps Team"
else
    log "${G}RAM usage is normal: ${USAGE}%${N}"
fi
