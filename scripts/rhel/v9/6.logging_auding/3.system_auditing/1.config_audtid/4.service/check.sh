#!/bin/bash

# Check if the auditd service is enabled
if systemctl is-enabled auditd | grep -q '^enabled'; then
  echo "auditd service is enabled."
else
  echo "auditd service is NOT enabled."
fi

# Check if the auditd service is active
if systemctl is-active auditd | grep -q '^active'; then
  echo "auditd service is active."
else
  echo "auditd service is NOT active."
fi

