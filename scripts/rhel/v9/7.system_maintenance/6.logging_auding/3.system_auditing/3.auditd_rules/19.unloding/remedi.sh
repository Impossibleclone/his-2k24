#!/bin/bash

# Ensure UID_MIN is set
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
if [ -z "$UID_MIN" ]; then
    echo "ERROR: UID_MIN is unset."
    exit 1
fi

# Remediate audit rules
echo "Creating or updating audit rules for kernel module operations..."

echo "
-a always,exit -F arch=b64 -S init_module,finit_module,delete_module,create_module,query_module -F auid>=${UID_MIN} -F auid!=unset -k kernel_modules
-a always,exit -F path=/usr/bin/kmod -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k kernel_modules
" > /etc/audit/rules.d/50-kernel_modules.rules

# Reload the audit rules
echo "Loading audit rules..."
augenrules --load

# Check if reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    echo "Reboot required to load rules."
fi

# Verify symlinks for kernel module tools
echo "Verifying symlink integrity..."
a_files=("/usr/sbin/lsmod" "/usr/sbin/rmmod" "/usr/sbin/insmod" "/usr/sbin/modinfo" "/usr/sbin/modprobe" "/usr/sbin/depmod")
for l_file in "${a_files[@]}"; do
    if [ "$(readlink -f "$l_file")" != "$(readlink -f /bin/kmod)" ]; then
        echo "Issue with symlink for file: \"$l_file\". Fixing..."
        ln -sf /bin/kmod "$l_file"
    else
        echo "OK: \"$l_file\""
    fi
done

echo "Remediation completed."

