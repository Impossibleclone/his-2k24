#!/usr/bin/env bash
{
# Check if auditd.conf file exists
if [ -e "/etc/audit/auditd.conf" ]; then
    # Get the audit log directory path from auditd.conf
    l_audit_log_directory="$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' /etc/audit/auditd.conf | xargs)")"

    # Check if the directory exists
    if [ -d "$l_audit_log_directory" ]; then
        # Set directory permissions to 0750
        chmod g-w,o-rwx "$l_audit_log_directory"
        echo "Audit log directory permissions have been set to 0750 for: $l_audit_log_directory"
    else
        echo "Error: Log file directory not found at $l_audit_log_directory"
        exit 1
    fi
else
    echo "Error: File /etc/audit/auditd.conf not found. Please verify auditd is installed."
    exit 1
fi
}

