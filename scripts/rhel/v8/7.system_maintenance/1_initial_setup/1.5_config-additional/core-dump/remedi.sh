#!/usr/bin/env bash

echo "Remediation: Disabling core dump backtraces by setting ProcessSizeMax to 0"

# Create directory if not exists
[ ! -d /etc/systemd/coredump.conf.d/ ] && mkdir -p /etc/systemd/coredump.conf.d/

# Check if [Coredump] section exists, if not add it with ProcessSizeMax=0
if grep -Psq -- '^\h*\[Coredump\]' /etc/systemd/coredump.conf.d/60-coredump.conf; then
    printf '%s\n' "ProcessSizeMax=0" >> /etc/systemd/coredump.conf.d/60-coredump.conf
else
    printf '%s\n' "[Coredump]" "ProcessSizeMax=0" >> /etc/systemd/coredump.conf.d/60-coredump.conf
fi

# Reload systemd settings
echo "Reloading systemd configuration..."
systemctl daemon-reload

echo "Remediation complete. Core dumps restricted."

