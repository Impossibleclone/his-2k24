#!/bin/bash

# Check if the space_left_action parameter is set to email, exec, single, or halt
space_left_action=$(grep -P -- '^\h*space_left_action\h*=\h*(email|exec|single|halt)\b' /etc/audit/auditd.conf)

if [[ -z "$space_left_action" ]]; then
  echo "space_left_action is not configured to email, exec, single, or halt. Current setting: $space_left_action"
else
  echo "space_left_action is set to $space_left_action."
fi

# Check if the admin_space_left_action parameter is set to single or halt
admin_space_left_action=$(grep -P -- '^\h*admin_space_left_action\h*=\h*(single|halt)\b' /etc/audit/auditd.conf)

if [[ -z "$admin_space_left_action" ]]; then
  echo "admin_space_left_action is not configured to single or halt. Current setting: $admin_space_left_action"
else
  echo "admin_space_left_action is set to $admin_space_left_action."
fi

