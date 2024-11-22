#!/usr/bin/env bash
{
# Define permission mask for 0750
l_perm_mask="0027"

# Check if auditd.conf file exists
if [ -e "/etc/audit/auditd.conf" ]; then
    # Get the audit log directory path from auditd.conf
    l_audit_log_directory="$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' /etc/audit/auditd.conf | xargs)")"

    # Check if the directory exists
    if [ -d "$l_audit_log_directory" ]; then
        # Calculate the maximum permissible permissions
        l_maxperm="$(printf '%o' $(( 0777 & ~$l_perm_mask )) )"
        
        # Get the current directory permissions in octal format
        l_directory_mode="$(stat -Lc '%#a' "$l_audit_log_directory")"
        
        # Check if the current permissions are too permissive
        if [ $(( $l_directory_mode & $l_perm_mask )) -gt 0 ]; then
            echo -e "\n- Audit Result:\n ** FAIL **\n - Directory: \"$l_audit_log_directory\" is mode: \"$l_directory_mode\"\n (should be mode: \"$l_maxperm\" or more restrictive)\n"
        else
            echo -e "\n- Audit Result:\n ** PASS **\n - Directory: \"$l_audit_log_directory\" is mode: \"$l_directory_mode\"\n (should be mode: \"$l_maxperm\" or more restrictive)\n"
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Log file directory not set in \"/etc/audit/auditd.conf\". Please set log file directory."
    fi
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - File: \"/etc/audit/auditd.conf\" not found\n - ** Verify auditd is installed **"
fi
}

