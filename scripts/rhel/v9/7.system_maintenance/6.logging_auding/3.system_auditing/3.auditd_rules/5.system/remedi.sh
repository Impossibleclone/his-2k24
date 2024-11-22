#!/bin/bash

# Setting up audit rules for monitoring date and time changes
echo "Setting up audit rules for date and time changes..."

# Add the relevant audit rules to track modifications of the system clock
echo "-a always,exit -F arch=b64 -S adjtimex,settimeofday -k time-change" >> /etc/audit/rules.d/50-time-change.rules
echo "-a always,exit -F arch=b32 -S adjtimex,settimeofday -k time-change" >> /etc/audit/rules.d/50-time-change.rules
echo "-a always,exit -F arch=b64 -S clock_settime -F a0=0x0 -k time-change" >> /etc/audit/rules.d/50-time-change.rules
echo "-a always,exit -F arch=b32 -S clock_settime -F a0=0x0 -k time-change" >> /etc/audit/rules.d/50-time-change.rules

# Watch the /etc/localtime file for any modifications (e.g., changing the timezone)
echo "-w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/50-time-change.rules

# Load the new audit rules
echo "Loading new audit rules..."
augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
  echo "Reboot required to load rules."
else
  echo "Audit rules loaded successfully."
fi

echo "Audit rule setup complete."

