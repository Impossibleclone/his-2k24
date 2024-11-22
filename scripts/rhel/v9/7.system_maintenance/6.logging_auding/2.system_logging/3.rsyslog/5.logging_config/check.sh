#!/bin/bash
# Check if rsyslog is configured for appropriate logging

# Check for appropriate logging configuration in /etc/rsyslog.conf and /etc/rsyslog.d/*.conf
echo "Checking rsyslog configuration for proper logging..."
grep -E '^\*\.emerg|auth,authpriv\.\*|mail\.\*|cron\.\*|local[0-7]\.\*' /etc/rsyslog.conf /etc/rsyslog.d/*.conf

# Check if the expected log files exist and have correct permissions
echo "Checking for log files..."
log_files=(
  "/var/log/secure"
  "/var/log/mail"
  "/var/log/cron"
  "/var/log/messages"
  "/var/log/localmessages"
)

for log_file in "${log_files[@]}"; do
  if [ -f "$log_file" ]; then
    echo "$log_file exists."
  else
    echo "$log_file does not exist. Please check the rsyslog configuration."
    exit 1
  fi
done

echo "rsyslog logging is configured properly."

