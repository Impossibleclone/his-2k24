#!/bin/bash

# Check the audit rules for kernel module operations (on disk)
echo "Checking audit rules on disk..."

# Ensure that UID_MIN is set
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
if [ -z "$UID_MIN" ]; then
    echo "ERROR: UID_MIN is unset."
    exit 1
fi

# Check if kernel module audit rules are present
grep -E "init_module|finit_module|delete_module|create_module|query_module" /etc/audit/rules.d/*.rules | grep -E "auid>=${UID_MIN}.*perm=x.*path=/usr/bin/kmod.*key=kernel_modules" > /dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: Missing or incorrect audit rule for kernel module operations."
    exit 1
else
    echo "Kernel module audit rules are correctly configured."
fi

# Check the current running configuration of audit rules
echo "Checking running audit configuration..."

auditctl -l | grep -E "init_module|finit_module|delete_module|create_module|query_module" | grep -E "auid>=${UID_MIN}.*perm=x.*path=/usr/bin/kmod.*key=kernel_modules" > /dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: Kernel module audit rule not active in running configuration."
    exit 1
else
    echo "Kernel module audit rule is active in the running configuration."
fi

# Check symlink integrity
echo "Checking symlink integrity for kernel module tools..."

a_files=("/usr/sbin/lsmod" "/usr/sbin/rmmod" "/usr/sbin/insmod" "/usr/sbin/modinfo" "/usr/sbin/modprobe" "/usr/sbin/depmod")
for l_file in "${a_files[@]}"; do
    if [ "$(readlink -f "$l_file")" != "$(readlink -f /bin/kmod)" ]; then
        echo "Issue with symlink for file: \"$l_file\""
    else
        echo "OK: \"$l_file\""
    fi
done

echo "Audit check completed."

