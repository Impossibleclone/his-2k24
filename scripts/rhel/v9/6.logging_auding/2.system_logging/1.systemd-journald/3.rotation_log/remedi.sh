#!/usr/bin/env bash

# Define configuration file
config_file="/etc/systemd/journald.conf"
backup_file="${config_file}.bak"

# Parameters for log rotation
system_max_use="1G"
system_keep_free="500M"
runtime_max_use="200M"
runtime_keep_free="50M"
max_file_sec="1month"

# Backup existing configuration file
if [ -f "$config_file" ]; then
    echo "Backing up current configuration to $backup_file..."
    cp "$config_file" "$backup_file"
fi

# Apply log rotation settings to journald configuration
echo "Applying recommended log rotation settings to $config_file..."

cat << EOF > "$config_file"
[Journal]
SystemMaxUse=$system_max_use
SystemKeepFree=$system_keep_free
RuntimeMaxUse=$runtime_max_use
RuntimeKeepFree=$runtime_keep_free
MaxFileSec=$max_file_sec
EOF

echo "Configuration applied. Restarting systemd-journald to apply changes..."
systemctl restart systemd-journald

# Confirm settings
echo "Log rotation settings have been applied as follows:"
systemd-analyze cat-config systemd/journald.conf | grep -E '(SystemMaxUse|SystemKeepFree|RuntimeMaxUse|RuntimeKeepFree|MaxFileSec)'

