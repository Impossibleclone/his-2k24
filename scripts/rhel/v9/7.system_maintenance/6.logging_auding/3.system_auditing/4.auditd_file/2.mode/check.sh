#!/usr/bin/env bash
{
l_output="" l_output2=""
l_perm_mask="0177"  # Permission mask for files that are too permissive

# Check if auditd.conf file exists
if [ -e "/etc/audit/auditd.conf" ]; then
    # Get the audit log directory from the auditd.conf file
    l_audit_log_directory="$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' /etc/audit/auditd.conf | xargs)")"
    
    # Check if the directory exists
    if [ -d "$l_audit_log_directory" ]; then
        # Calculate the maximum permissible file permissions (0640)
        l_maxperm="$(printf '%o' $(( 0777 & ~$l_perm_mask )) )"
        
        # Loop through audit log files and check permissions
        while IFS= read -r -d $'\0' l_file; do
            while IFS=: read -r l_file_mode l_hr_file_mode; do
                l_output2="$l_output2\n - File: \"$l_file\" is mode: \"$l_file_mode\"\n (should be mode: \"$l_maxperm\" or more restrictive)\n"
            done <<< "$(stat -Lc '%#a:%A' "$l_file")"
        done < <(find "$l_audit_log_directory" -maxdepth 1 -type f -perm /"$l_perm_mask" -print0)
    else
        l_output2="$l_output2\n - Log file directory not set in \"/etc/audit/auditd.conf\". Please set the log file directory."
    fi
else
    l_output2="$l_output2\n - File: \"/etc/audit/auditd.conf\" not found.\n - ** Verify auditd is installed **"
fi

# Check the results and print the output
if [ -z "$l_output2" ]; then
    l_output="$l_output\n - All files in \"$l_audit_log_directory\" are mode: \"$l_maxperm\" or more restrictive"
    echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :$l_output"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_output2\n"
fi
}

