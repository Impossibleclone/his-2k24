#!/usr/bin/env bash

echo "Remediating password expiration warning days configuration..."

# Set PASS_WARN_AGE in /etc/login.defs to a value of 7 or more
if grep -Pi -- '^\h*PASS_WARN_AGE\h+' /etc/login.defs; then
    sed -ri 's/^\h*PASS_WARN_AGE\h+\d+/PASS_WARN_AGE 7/' /etc/login.defs
else
    echo "PASS_WARN_AGE 7" >> /etc/login.defs
fi

# Update all users' password expiration warning days in /etc/shadow to be 7 or more
awk -F: '($2~/^\$.+\$/) {if($6 < 7)system ("chage --warndays 7 " $1)}' /etc/shadow

echo "Password expiration warning days has been set to 7 days."

