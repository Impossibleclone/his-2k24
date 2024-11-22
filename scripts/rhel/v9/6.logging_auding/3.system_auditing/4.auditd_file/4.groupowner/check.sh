#!/usr/bin/env bash
{
l_output="" l_output2=""
if [ -e "/etc/audit/auditd.conf" ]; then
    # Extract the audit log directory path from auditd.conf
    l_audit_log_directory="$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' /etc/audit/auditd.conf | xargs)")"
    
    # Extract the log_group parameter value
    l_audit_log_group="$(awk -F= '/^\s*log_group\s*/{print $2}' /etc/audit/auditd.conf | xargs)"
    
    # Check if log_group is set to root or adm
    if grep -Pq -- '^\h*(root|adm)\h*$' <<< "$l_audit_log_group"; then
        l_output="$l_output\n - Log file group correctly set to: \"$l_audit_log_group\" in \"/etc/audit/auditd.conf\""
    else
        l_output2="$l_output2\n - Log file group is set to: \"$l_audit_log_group\" in \"/etc/audit/auditd.conf\"\n (should be set to group: \"root or adm\")\n"
    fi
    
    # Check if the audit log directory exists
    if [ -d "$l_audit_log_directory" ]; then
        # Check if audit log files are group-owned by root or adm
        while IFS= read -r -d $'\0' l_file; do
            l_file_group=$(stat -c '%G' "$l_file")
            if [[ "$l_file_group" != "root" && "$l_file_group" != "adm" ]]; then
                l_output2="$l_output2\n - File: \"$l_file\" is group owned by: \"$l_file_group\"\n (should be group owned by: \"root\" or \"adm\")\n"
            fi
        done < <(find "$l_audit_log_directory" -maxdepth 1 -type f \( ! -group root -a ! -group adm \) -print0)
    else
        l_output2="$l_output2\n - Log file directory not set in \"/etc/audit/auditd.conf\". Please set log file directory."
    fi
else
    l_output2="$l_output2\n - File: \"/etc/audit/auditd.conf\" not found.\n - ** Verify auditd is installed **"
fi

# Check the results and print the output
if [ -z "$l_output2" ]; then
    l_output="$l_output\n - All files in \"$l_audit_log_directory\" are group owned by root or adm."
    echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :$l_output"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_output2\n"
    [ -n "$l_output" ] && echo -e " - * Correctly configured * :\n$l_output\n"
fi
}

