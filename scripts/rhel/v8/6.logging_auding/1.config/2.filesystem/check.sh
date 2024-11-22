#!/bin/bash

echo "Checking for AIDE scheduled filesystem integrity checks..."

# Check for AIDE cron job
cron_check=$(grep -Ers '^([^#]+\s+)?(\/usr\/s?bin\/|^\s*)aide(\.wrapper)?\s(--?\S+\s)*(--check|--update|\$AIDEARGS)\b' /etc/cron.* /etc/crontab /var/spool/cron/)
if [[ -n "$cron_check" ]]; then
    echo "Cron job for AIDE check is scheduled."
else
    echo "No cron job found for AIDE check."
fi

# Check for aidecheck.service and aidecheck.timer
service_enabled=$(systemctl is-enabled aidecheck.service 2>/dev/null)
timer_enabled=$(systemctl is-enabled aidecheck.timer 2>/dev/null)
timer_running=$(systemctl is-active aidecheck.timer 2>/dev/null)

if [[ "$service_enabled" == "enabled" && "$timer_enabled" == "enabled" && "$timer_running" == "active" ]]; then
    echo "Systemd aidecheck.service and aidecheck.timer are enabled and running."
else
    echo "Systemd aidecheck.service and aidecheck.timer are NOT correctly set up."
fi

# Determine audit result
if [[ -n "$cron_check" || ( "$service_enabled" == "enabled" && "$timer_enabled" == "enabled" && "$timer_running" == "active" ) ]]; then
    echo "Filesystem integrity check scheduling is in compliance."
else
    echo "Filesystem integrity check scheduling is NOT in compliance. Run remedi.sh to set it up."
fi

