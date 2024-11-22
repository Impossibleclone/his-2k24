#!/usr/bin/env bash

echo "Checking password expiration configuration..."

# Check if PASS_MAX_DAYS is set to 365 or less in /etc/login.defs
if grep -Pi -- '^\h*PASS_MAX_DAYS\h+\d+\b' /etc/login.defs | grep -Pq 'PASS_MAX_DAYS\s*(365|[1-9][0-9]{1,2})\b'; then
    echo "- PASS_MAX_DAYS is set correctly in /etc/login.defs"
else
    echo "- PASS_MAX_DAYS is NOT set to 365 or less in /etc/login.defs"
fi

# Check user password expiration settings in /etc/shadow
awk -F: '($2~/^\$.+\$/) {if($5 > 365 || $5 < 1)print "User: " $1 " PASS_MAX_DAYS: " $5}' /etc/shadow

