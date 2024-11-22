#!/usr/bin/env bash

echo "Remediating minimum password days configuration..."

# Set PASS_MIN_DAYS in /etc/login.defs to a value greater than 0
if grep -Pi -- '^\h*PASS_MIN_DAYS\h+' /etc/login.defs; then
    sed -ri 's/^\h*PASS_MIN_DAYS\h+\d+/PASS_MIN_DAYS 1/' /etc/login.defs
else
    echo "PASS_MIN_DAYS 1" >> /etc/login.defs
fi

# Update all users' minimum password days in /etc/shadow to be greater than 0
awk -F: '($2~/^\$.+\$/) {if($4 < 1)system ("chage --mindays 1 " $1)}' /etc/shadow

echo "Minimum password days has been set to 1 day."

