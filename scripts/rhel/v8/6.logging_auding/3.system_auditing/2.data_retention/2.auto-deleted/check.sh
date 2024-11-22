#!/bin/bash

# Check if the max_log_file_action parameter is set to keep_logs
log_action=$(grep -i max_log_file_action /etc/audit/auditd.conf)

if [[ "$log_action" =~ ^max_log_file_action\h*=\h*keep_logs$ ]]; then
  echo "Audit logs are configured to be kept."
else
  echo "Audit logs are not configured to be kept (current setting: $log_action)."
fi

