#!/bin/bash
# Ensure rsyslog log file creation mode is configured securely

# Edit rsyslog configuration to set FileCreateMode to 0640 or more restrictive
if ! grep -Psq '^\h*\$FileCreateMode\h+0[0,2,4,6][0,2,4]0\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf; then
    # Add the $FileCreateMode line if it doesn't exist
    echo "$FileCreateMode 0640" >> /etc/rsyslog.conf
fi

# Restart the rsyslog service to apply the changes
systemctl restart rsyslog

echo "rsyslog log file creation mode is now configured to 0640 or more restrictive."

