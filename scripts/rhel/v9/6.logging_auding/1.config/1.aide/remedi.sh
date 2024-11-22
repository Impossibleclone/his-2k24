#!/usr/bin/env bash

echo "Remediating password expiration configuration..."

# Set PASS_MAX_DAYS in /etc/login.defs to 365
if grep -Pi -- '^\h*PASS_MAX_DAYS\h+' /etc/login.defs; then
    sed -ri 's/^\h*PASS_MAX_DAYS\h+\d+/PASS_MAX_DAYS 365/' /etc/login.defs
else
    echo "PASS_MAX_DAYS 365" >> /etc/login.defs
fi

# Update all users' password expiration to 365 days
awk -F: '($2~/^\$.+\$/) {if($5 > 365 || $5 < 1)system ("chage --maxdays 365 " $1)}' /etc/shadow

echo "Password expiration has been remediated to 365 days."

