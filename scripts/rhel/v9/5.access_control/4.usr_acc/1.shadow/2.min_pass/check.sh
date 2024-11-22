#!/usr/bin/env bash

echo "Checking minimum password days configuration..."

# Check if PASS_MIN_DAYS is set to a value greater than 0 in /etc/login.defs
if grep -Pi -- '^\h*PASS_MIN_DAYS\h+\d+\b' /etc/login.defs | grep -Pq 'PASS_MIN_DAYS\s*(\d+)\b'; then
    min_days=$(grep -Pi -- '^\h*PASS_MIN_DAYS\h+\d+\b' /etc/login.defs | awk '{print $2}')
    if [ "$min_days" -gt 0 ]; then
        echo "- PASS_MIN_DAYS is set to a valid value ($min_days) in /etc/login.defs"
    else
        echo "- PASS_MIN_DAYS is NOT set to a valid value greater than 0 in /etc/login.defs"
    fi
else
    echo "- PASS_MIN_DAYS is NOT set in /etc/login.defs"
fi

# Check user password settings in /etc/shadow for PASS_MIN_DAYS
awk -F: '($2~/^\$.+\$/) {if($4 < 1)print "User: " $1 " PASS_MIN_DAYS: " $4}' /etc/shadow

