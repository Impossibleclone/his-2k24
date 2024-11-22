#!/usr/bin/env bash
{
# Check if auditd.conf file exists
if [ -e "/etc/audit/auditd.conf" ]; then
    # Get the audit log directory path from auditd.conf
    l_audit_log_directory="$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' /etc/audit/auditd.conf | xargs)")"
    
    # Check if the directory exists
    if [ -d "$l_audit_log_directory" ]; then
        # Set permissions of audit log files to 0640
        find "$l_audit_log_directory" -type f -perm /0137 -exec chmod u-x,g-wx,o-rwx {} +
        echo "Audit log files permissions have been set to 0640 or more restrictive in: $l_audit_log_directory"
    else
        echo "Error: Log file directory not found at $l_audit_log_directory"
        exit 1
    fi
else
    echo "Error: File /etc/audit/auditd.conf not found. Please verify auditd is installed."
    exit 1
fi
}

