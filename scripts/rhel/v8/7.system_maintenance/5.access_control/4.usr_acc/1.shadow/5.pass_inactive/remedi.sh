#!/usr/bin/env bash

echo "Remediating the password inactivity lock configuration..."

# Set the default inactivity period to 45 days
useradd -D -f 45

echo "The default inactivity period has been set to 45 days."

# Ensure all users' inactivity period is set to 45 days or less
awk -F: '($2~/^\$.+\$/) {if($7 > 45 || $7 < 0)system ("chage --inactive 45 " $1)}' /etc/shadow

echo "All user inactivity periods have been set to 45 days or less."

