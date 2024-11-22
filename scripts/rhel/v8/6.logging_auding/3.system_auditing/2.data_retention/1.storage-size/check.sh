#!/bin/bash

# Check if the max_log_file parameter is set correctly
log_size=$(grep -Po -- '^\h*max_log_file\h*=\h*\d+\b' /etc/audit/auditd.conf)

if [[ "$log_size" =~ ^max_log_file\h*=\h*[0-9]+$ ]]; then
  echo "Audit log file size is set to: $log_size"
else
  echo "Audit log file size is NOT configured correctly."
fi

