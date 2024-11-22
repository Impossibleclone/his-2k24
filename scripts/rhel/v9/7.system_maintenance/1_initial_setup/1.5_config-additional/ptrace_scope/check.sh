#!/bin/bash

echo "Checking kernel.yama.ptrace_scope..."

# Checking the running kernel parameter
current_value=$(sysctl kernel.yama.ptrace_scope | awk '{print $3}')

if [ "$current_value" -eq 1 ]; then
  echo "PASS: kernel.yama.ptrace_scope is set to 1 in the running configuration."
else
  echo "FAIL: kernel.yama.ptrace_scope is set to $current_value in the running configuration."
  echo "Recommended value: 1"
fi

# Checking if it's correctly set in sysctl configuration files
config_files=$(grep -Rl 'kernel.yama.ptrace_scope' /etc/sysctl.conf /etc/sysctl.d/)

if [ -n "$config_files" ]; then
  echo "Checking configuration files for correct setting..."
  grep -q 'kernel.yama.ptrace_scope = 1' $config_files && echo "PASS: Correct value found in configuration files." || echo "FAIL: Incorrect or missing value in configuration files."
else
  echo "FAIL: kernel.yama.ptrace_scope is not found in configuration files."
fi

