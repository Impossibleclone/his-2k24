#!/usr/bin/env bash

echo "Checking the password inactivity lock configuration..."

# Check the default inactivity period for user accounts
inactive_period=$(useradd -D | grep INACTIVE | awk -F= '{print $2}')

if [ "$inactive_period" -le 45 ] && [ "$inactive_period" -ge 0 ]; then
    echo "- Default inactivity period is set to $inactive_period days, which is within policy."
else
    echo "- Default inactivity period is not set correctly. It should be 45 days or less, and non-negative."
fi

# Check all users' inactivity periods in /etc/shadow
awk -F: '($2~/^\$.+\$/) {if($7 > 45 || $7 < 0)print "User: " $1 " INACTIVE: " $7}' /etc/shadow

if [ $? -eq 0 ]; then
    echo "- All user inactivity periods are within the policy."
else
    echo "- Some user inactivity periods exceed the policy (greater than 45 days or negative)."
fi

