#!/usr/bin/env bash

# Set permissions and ownership for /etc/ssh/sshd_config
chmod u-x,og-rwx /etc/ssh/sshd_config
chown root:root /etc/ssh/sshd_config

# Set permissions and ownership for files in /etc/ssh/sshd_config.d
while IFS= read -r -d $'\0' l_file; do
    if [ -e "$l_file" ]; then
        chmod u-x,og-rwx "$l_file"
        chown root:root "$l_file"
    fi
done < <(find /etc/ssh/sshd_config.d -type f -print0 2>/dev/null)

