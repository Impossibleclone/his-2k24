#!/bin/bash

# Check for audit rules related to modifications to the sudo log file
echo "Checking audit rules for modifications to the sudo log file..."

# Get the sudo log file from the sudoers configuration
SUDO_LOG_FILE=$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,?.*//' -e 's/"//g' -e 's|/|\\/|g')

# Check if the sudo log file is configured and then check the audit rule
if [ -n "${SUDO_LOG_FILE}" ]; then
  echo "Checking on disk rules for ${SUDO_LOG_FILE}..."
  awk "/^ *-w/ && /${SUDO_LOG_FILE}/ && / -p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/" /etc/audit/rules.d/*.rules

  # Check the loaded rules using auditctl
  echo "Checking running configuration..."
  auditctl -l | awk "/^ *-w/ && /${SUDO_LOG_FILE}/ && / -p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)"
else
  echo "ERROR: Variable 'SUDO_LOG_FILE' is unset. Please check your sudoers configuration."
fi

echo "Audit rule checks complete."

