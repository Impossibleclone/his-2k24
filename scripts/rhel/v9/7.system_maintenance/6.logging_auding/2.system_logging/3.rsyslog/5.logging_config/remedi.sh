#!/bin/bash
# Ensure rsyslog logging is configured correctly

# Backup the rsyslog.conf before making changes
cp /etc/rsyslog.conf /etc/rsyslog.conf.bak

# Append the appropriate logging configuration to /etc/rsyslog.conf or files in /etc/rsyslog.d/
echo "Configuring rsyslog for proper logging..."
cat <<EOL >> /etc/rsyslog.conf

# Log emergency messages to all users
*.emerg :omusrmsg:*

# Authentication logs
auth,authpriv.* /var/log/secure

# Mail logs
mail.* -/var/log/mail
mail.info -/var/log/mail.info
mail.warning -/var/log/mail.warn
mail.err /var/log/mail.err

# Cron logs
cron.* /var/log/cron

# Warning and error logs to a single file
*.=warning;*.=err -/var/log/warn
*.crit /var/log/warn

# General system logs
*.*;mail.none;news.none -/var/log/messages

# Local system logs for various facilities
local0,local1.* -/var/log/localmessages
local2,local3.* -/var/log/localmessages
local4,local5.* -/var/log/localmessages
local6,local7.* -/var/log/localmessages

EOL

# Restart rsyslog to apply changes
systemctl restart rsyslog

echo "rsyslog logging has been configured and the service has been restarted."

