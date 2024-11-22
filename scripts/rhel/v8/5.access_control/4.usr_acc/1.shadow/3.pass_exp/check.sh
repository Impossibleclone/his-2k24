#!/usr/bin/env bash

echo "Checking password expiration warning days configuration..."

# Check if PASS_WARN_AGE is set to a value of 7 or more in /etc/login.defs
if grep -Pi -- '^\h*PASS_WARN_AGE\h+\d+\b' /etc/login.defs | grep -Pq 'PASS_WARN_AGE\s*(\d+)\b'; then
    warn_days=$(grep -Pi -- '^\h*PASS_WARN_AGE\h+\d+\b' /etc/login.defs | awk '{print $2}')
    if [ "$warn_days" -ge 7 ]; then
        echo "- PASS_WARN_AGE is set to a valid value ($warn_days) in /etc/login.defs"
    else
        echo "- PASS_WARN_AGE is NOT set to a valid value (less than 7) in /etc/login.defs"
    fi
else
    echo "- PASS_WARN_AGE is NOT set in /etc/login.defs"
fi

# Check user password settings in /etc/shadow for PASS_WARN_AGE
awk -F: '($2~/^\$.+\$/) {if($6 < 7)print "User: " $1 " PASS_WARN_AGE: " $6}' /etc/shadow

