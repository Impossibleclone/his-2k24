#!/bin/bash

# Ensure proper logrotate configuration for rsyslog logs
# Backup the logrotate.conf before making changes
cp /etc/logrotate.conf /etc/logrotate.conf.bak

# Add logrotate configuration for rsyslog logs
echo "/var/log/rsyslog/*.log {" > /etc/logrotate.d/rsyslog
echo "    weekly" >> /etc/logrotate.d/rsyslog
echo "    rotate 4" >> /etc/logrotate.d/rsyslog
echo "    compress" >> /etc/logrotate.d/rsyslog
echo "    missingok" >> /etc/logrotate.d/rsyslog
echo "    notifempty" >> /etc/logrotate.d/rsyslog
echo "    postrotate" >> /etc/logrotate.d/rsyslog
echo "        /usr/bin/systemctl reload rsyslog.service >/dev/null || true" >> /etc/logrotate.d/rsyslog
echo "    endscript" >> /etc/logrotate.d/rsyslog
echo "}" >> /etc/logrotate.d/rsyslog

# Restart rsyslog service to apply changes
systemctl restart rsyslog

echo "rsyslog log rotation is now configured."

