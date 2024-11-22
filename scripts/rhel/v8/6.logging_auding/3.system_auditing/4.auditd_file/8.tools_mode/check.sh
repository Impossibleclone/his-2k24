#!/usr/bin/env bash
{
l_output=""
l_output2=""
l_perm_mask="0022"  # Mask to check if write permissions for group/others exist
l_maxperm="$( printf '%o' $(( 0777 & ~$l_perm_mask )) )"  # 0755 permission

# List of audit tools to check
a_audit_tools=("/sbin/auditctl" "/sbin/aureport" "/sbin/ausearch" "/sbin/autrace" "/sbin/auditd" "/sbin/augenrules")

for l_audit_tool in "${a_audit_tools[@]}"; do
    # Check the permissions of each audit tool
    l_mode="$(stat -Lc '%#a' "$l_audit_tool")"
    
    if [ $(( "$l_mode" & "$l_perm_mask" )) -gt 0 ]; then
        # If the permissions are too permissive, report failure
        l_output2="$l_output2\n - Audit tool \"$l_audit_tool\" is mode: \"$l_mode\" (should be mode: \"$l_maxperm\" or more restrictive)"
    else
        # If permissions are correctly configured, report success
        l_output="$l_output\n - Audit tool \"$l_audit_tool\" is correctly configured to mode: \"$l_mode\""
    fi
done

# Output the results
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n - Correctly configured: $l_output"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reasons for audit failure: $l_output2\n"
    [ -n "$l_output" ] && echo -e "\n - Correctly configured: $l_output\n"
fi

# Clean up
unset a_audit_tools
}

