#!/bin/bash
# Check if rsyslog is configured with the correct FileCreateMode

# Check for $FileCreateMode in rsyslog.conf and any files in /etc/rsyslog.d/
if grep -Ps '^\h*\$FileCreateMode\h+0[0,2,4,6][0,2,4]0\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf > /dev/null; then
    echo "rsyslog is configured with a secure $FileCreateMode."
else
    echo "rsyslog is NOT configured with a secure $FileCreateMode."
    exit 1
fi

