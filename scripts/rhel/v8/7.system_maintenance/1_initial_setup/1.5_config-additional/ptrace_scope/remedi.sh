#!/bin/bash

# Fixing in running kernel
echo "Setting kernel.yama.ptrace_scope to 1 in the running configuration..."
sysctl -w kernel.yama.ptrace_scope=1

# Persisting in sysctl configuration files
config_file="/etc/sysctl.d/60-kernel_sysctl.conf"

echo "Persisting the setting in $config_file..."
echo "kernel.yama.ptrace_scope = 1" >> "$config_file"

# Reload sysctl settings
echo "Reloading sysctl settings..."
sysctl --system

echo "Remediation complete."

