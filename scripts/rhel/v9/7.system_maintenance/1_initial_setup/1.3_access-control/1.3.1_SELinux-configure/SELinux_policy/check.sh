#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Check the SELinux policy in /etc/selinux/config
echo "Checking SELinux policy in /etc/selinux/config..."
config_policy=$(grep -E '^\s*SELINUXTYPE=(targeted|mls)\b' /etc/selinux/config)

if [ -z "$config_policy" ]; then
  echo "SELINUXTYPE in /etc/selinux/config is not set to 'targeted' or 'mls'."
else
  echo "SELINUXTYPE in /etc/selinux/config is set to: $config_policy"
fi

# Check the loaded SELinux policy
echo "Checking loaded SELinux policy..."
loaded_policy=$(sestatus | grep "Loaded policy name:")

if [[ "$loaded_policy" =~ (targeted|mls) ]]; then
  echo "Loaded SELinux policy is set to: $loaded_policy"
else
  echo "SELinux loaded policy is not set to 'targeted' or 'mls'."
fi

