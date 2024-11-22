#!/usr/bin/env bash

# Audit specific journald configuration parameters for log rotation
expected_system_max_use="1G"
expected_system_keep_free="500M"
expected_runtime_max_use="200M"
expected_runtime_keep_free="50M"
expected_max_file_sec="1month"

echo "Checking journald log rotation settings..."

# Check current settings with systemd-analyze
current_settings=$(systemd-analyze cat-config systemd/journald.conf | grep -E '(SystemMaxUse|SystemKeepFree|RuntimeMaxUse|RuntimeKeepFree|MaxFileSec)')

# Parse and display each setting to verify compliance
echo "$current_settings" | while read -r line; do
    key=$(echo "$line" | cut -d'=' -f1 | tr -d ' ')
    value=$(echo "$line" | cut -d'=' -f2)

    case "$key" in
        SystemMaxUse)
            if [[ "$value" != "$expected_system_max_use" ]]; then
                echo " - SystemMaxUse: Expected $expected_system_max_use, found $value"
            fi
            ;;
        SystemKeepFree)
            if [[ "$value" != "$expected_system_keep_free" ]]; then
                echo " - SystemKeepFree: Expected $expected_system_keep_free, found $value"
            fi
            ;;
        RuntimeMaxUse)
            if [[ "$value" != "$expected_runtime_max_use" ]]; then
                echo " - RuntimeMaxUse: Expected $expected_runtime_max_use, found $value"
            fi
            ;;
        RuntimeKeepFree)
            if [[ "$value" != "$expected_runtime_keep_free" ]]; then
                echo " - RuntimeKeepFree: Expected $expected_runtime_keep_free, found $value"
            fi
            ;;
        MaxFileSec)
            if [[ "$value" != "$expected_max_file_sec" ]]; then
                echo " - MaxFileSec: Expected $expected_max_file_sec, found $value"
            fi
            ;;
    esac
done

echo -e "\nAudit completed. Review any discrepancies above to ensure compliance with site policy."

