#!/bin/bash

# Define the log file path
ACCESS_LOG="/var/log/nginx/access.log"

# Ensure the script has permissions to write to the log file
if [ ! -w "$ACCESS_LOG" ]; then
    echo "Error: Permission denied for writing to $ACCESS_LOG"
    exit 1
fi

# Simulate HTTP logs
while true; do
    for x in {1..1800}; do
        echo "$[(RANDOM%222)+1].$[RANDOM%254].$[RANDOM%254].$[RANDOM%254] - - [$(date '+%d/%b/%Y:%H:%M:%S %z')] \"GET / HTTP/1.1\" 200 735" >> "$ACCESS_LOG"
        sleep 2
    done &

    # Simulate SSH logs
    for x in {1..1800}; do
        usrNo=$[RANDOM%100]
        echo "$[(RANDOM%222)+1].$[RANDOM%254].$[RANDOM%254].$[RANDOM%254] - - [$(date '+%d/%b/%Y:%H:%M:%S %z')] \"Accepted password for user${usrNo}\" 0" >> "$ACCESS_LOG"
        echo "$[(RANDOM%222)+1].$[RANDOM%254].$[RANDOM%254].$[RANDOM%254] - - [$(date '+%d/%b/%Y:%H:%M:%S %z')] \"pam_unix(sshd:session): session opened for user user${usrNo} by (uid=0)\" 0" >> "$ACCESS_LOG"
        sleep 3
    done &

    wait
done

