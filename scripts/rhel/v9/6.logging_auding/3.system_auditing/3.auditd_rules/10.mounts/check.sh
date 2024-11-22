#!/bin/bash

# Check for UID_MIN in /etc/login.defs
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# Check for audit rule for file permission modifications
if [ -n "${UID_MIN}" ]; then
  echo "Checking file permission modification rules..."
  # Check if the audit rule for permission modification is present
  if ! awk "/^ *-a *always,exit/ && /chmod|fchmod|chown|setxattr/ && /key=perm_mod/" /etc/audit/rules.d/*.rules > /dev/null; then
    echo "ERROR: File permission modification audit rules are missing or incorrect."
  else
    echo "File permission modification audit rules are properly configured."
  fi
else
  echo "ERROR: UID_MIN is unset. Unable to check for audit rules."
fi

# Check for audit rule for mount system call
if [ -n "${UID_MIN}" ]; then
  echo "Checking mount system call audit rules..."
  # Check if the audit rule for mount system call is present
  if ! awk "/^ *-a *always,exit/ && /mount/ && /key=mounts/" /etc/audit/rules.d/*.rules > /dev/null; then
    echo "ERROR: File system mount audit rules are missing or incorrect."
  else
    echo "File system mount audit rules are properly configured."
  fi
else
  echo "ERROR: UID_MIN is unset. Unable to check for mount rules."
fi

