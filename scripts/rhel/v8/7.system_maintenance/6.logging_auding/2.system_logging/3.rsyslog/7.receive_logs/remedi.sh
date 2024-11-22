#!/bin/bash
# Ensure rsyslog is configured to send logs to a remote log host

# Backup the rsyslog.conf before making changes
cp /etc/rsyslog.conf /etc/rsyslog.conf.bak

# Add the remote log host configuration to rsyslog.conf
echo "Configuring rsyslog to forward logs to remote host..."
cat <<EOL >> /etc/rsyslog.conf

# Forward all logs to a remote log host using TCP
*.* action(type="omfwd" target="loghost.example.com" port="514" protocol="tcp"
action.resumeRetryCount="100" queue.type="LinkedList" queue.size="1000")

EOL

# Restart rsyslog to apply changes
systemctl reload-or-restart rsyslog.service

echo "rsyslog has been configured to send logs to the remote log host."

