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

CPU_THRESHOLD=80

IDLE=$(top -bn1 | grep "Cpu(s)" | grep -oP '[\d.]+ id' | awk '{print $1}')
USAGE=$(awk "BEGIN {printf \"%.0f\", 100 - $IDLE}")

log "CPU Usage: ${USAGE}%"

if [ "$USAGE" -ge "$CPU_THRESHOLD" ]; then
    MESSAGE="High CPU usage: ${USAGE}% on $IP_ADDRESS <br>"
    echo -e "$MESSAGE"
    sh mail.sh "info@joindevops.com" "High CPU Usage Alert on $IP_ADDRESS" "$MESSAGE" "HIGH_CPU_USAGE" "$IP_ADDRESS" "DevOps Team"
else
    log "${G}CPU usage is normal: ${USAGE}%${N}"
fi
