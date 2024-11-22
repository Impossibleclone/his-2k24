#!/usr/bin/env bash
{
# Check if auditd.conf file exists
if [ -e "/etc/audit/auditd.conf" ]; then
    # Extract the audit log directory from auditd.conf
    l_audit_log_directory="$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' /etc/audit/auditd.conf | xargs)")"
    
    # Ensure that the log_group is set to "adm"
    sed -ri 's/^\s*#?\s*log_group\s*=\s*\S+(\s*#.*)?.*$/log_group = adm\1/' /etc/audit/auditd.conf
    
    # Check if the directory exists
    if [ -d "$l_audit_log_directory" ]; then
        # Change the group ownership of audit log files to "adm"
        find "$l_audit_log_directory" -type f \( ! -group adm -a ! -group root \) -exec chgrp adm {} +
        echo "Audit log files group ownership has been set to adm in: $l_audit_log_directory"
    else
        echo "Error: Log file directory not found at $l_audit_log_directory"
        exit 1
    fi
    
    # Restart the audit daemon to apply the new configuration
    systemctl restart auditd
    echo "Audit daemon has been restarted to apply the new configuration."
else
    echo "Error: File /etc/audit/auditd.conf not found. Please verify auditd is installed."
    exit 1
fi
}

