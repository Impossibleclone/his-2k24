#!/bin/bash
# Check if rsyslog is configured to send logs to a remote log host

# Check for the basic format of remote logging in rsyslog configuration
echo "Checking rsyslog configuration for remote log host..."
grep -E "^*.*@@[^#]*" /etc/rsyslog.conf /etc/rsyslog.d/*.conf

# Check for the advanced format of remote logging in rsyslog configuration
echo "Checking for advanced format remote logging configuration..."
grep -Psi -- '^\s*([^#]+\s+)?action\(([^#]+\s+)?\btarget=\"?[^#"]+\"?\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf

# Check if the remote log host is reachable
REMOTE_HOST="loghost.example.com"
ping -c 1 "$REMOTE_HOST" &>/dev/null
if [ $? -eq 0 ]; then
  echo "Remote log host $REMOTE_HOST is reachable."
else
  echo "Remote log host $REMOTE_HOST is not reachable. Please check network connectivity."
  exit 1
fi

echo "Remote rsyslog configuration is properly set."

