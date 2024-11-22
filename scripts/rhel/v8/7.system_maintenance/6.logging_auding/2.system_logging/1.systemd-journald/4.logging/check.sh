#!/usr/bin/env bash

# Check if rsyslog and journald are active
echo "Checking logging systems..."

l_output=""
l_output2=""

if systemctl is-active --quiet rsyslog; then
    l_output="$l_output\n - rsyslog is in use"
elif systemctl is-active --quiet systemd-journald; then
    l_output="$l_output\n - journald is in use"
else
    echo "Unable to determine system logging"
    l_output2="$l_output2\n - Unable to determine system logging\n - Configure only ONE logging system: rsyslog OR journald"
fi

# Display audit results
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2"
fi

