#!/bin/bash

# Create or update the audit rule file for monitoring modifications to the sudo log file
echo "Setting up audit rules for modifications to the sudo log file..."

# Get the sudo log file from the sudoers configuration
SUDO_LOG_FILE=$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,?.*//' -e 's/"//g')

# Check if the sudo log file is configured
if [ -n "${SUDO_LOG_FILE}" ]; then
  # Add the audit rule to monitor write access (wa) to the sudo log file
  echo "-w ${SUDO_LOG_FILE} -p wa -k sudo_log_file" > /etc/audit/rules.d/50-sudo.rules

  # Load the updated audit rules into the active configuration
  echo "Loading new audit rules..."
  augenrules --load

  # Check if a reboot is required to apply the rules
  if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    echo "Reboot required to load rules."
  else
    echo "Audit rules loaded successfully."
  fi
else
  echo "ERROR: Variable 'SUDO_LOG_FILE' is unset. Please check your sudoers configuration."
fi

