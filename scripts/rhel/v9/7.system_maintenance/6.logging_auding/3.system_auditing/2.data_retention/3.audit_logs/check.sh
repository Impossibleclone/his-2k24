#!/bin/bash

# Check if the disk_full_action parameter is set to halt or single
disk_full_action=$(grep -P -- '^\h*disk_full_action\h*=\h*(halt|single)\b' /etc/audit/auditd.conf)

if [[ -z "$disk_full_action" ]]; then
  echo "disk_full_action is not configured to halt or single. Current setting: $disk_full_action"
else
  echo "disk_full_action is set to $disk_full_action."
fi

# Check if the disk_error_action parameter is set to syslog, single, or halt
disk_error_action=$(grep -P -- '^\h*disk_error_action\h*=\h*(syslog|single|halt)\b' /etc/audit/auditd.conf)

if [[ -z "$disk_error_action" ]]; then
  echo "disk_error_action is not configured to syslog, single, or halt. Current setting: $disk_error_action"
else
  echo "disk_error_action is set to $disk_error_action."
fi

