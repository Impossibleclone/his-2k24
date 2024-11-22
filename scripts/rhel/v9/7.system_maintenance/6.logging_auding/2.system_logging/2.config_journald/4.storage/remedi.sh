#!/bin/bash
# Ensure that journald Storage is set to 'persistent'

# Create the directory for additional journald configurations if it doesn't exist
if [ ! -d /etc/systemd/journald.conf.d/ ]; then
    mkdir /etc/systemd/journald.conf.d/
fi

# Check if the configuration file exists and if not, create it
if grep -Psq -- '^\h*\[Journal\]' /etc/systemd/journald.conf.d/60-journald.conf; then
    # Append the setting if [Journal] section is found
    echo "Storage=persistent" >> /etc/systemd/journald.conf.d/60-journald.conf
else
    # Create a new section and add the setting if [Journal] section is not found
    echo -e "[Journal]\nStorage=persistent" >> /etc/systemd/journald.conf.d/60-journald.conf
fi

# Reload or restart the journald service to apply the changes
systemctl reload-or-restart systemd-journald
echo "Storage has been set to 'persistent' and systemd-journald has been reloaded."

