#!/usr/bin/env bash
{
l_output=""
# List of audit tools to check
a_audit_tools=("/sbin/auditctl" "/sbin/aureport" "/sbin/ausearch" "/sbin/autrace" "/sbin/auditd" "/sbin/augenrules")

# Check the group ownership of each audit tool
for l_audit_tool in "${a_audit_tools[@]}"; do
    # Check the group ownership of each audit tool
    l_group=$(stat -Lc "%n %G" "$l_audit_tool" | awk '{print $2}')
    
    if [ "$l_group" != "root" ]; then
        # If the group is not root, report a failure
        l_output2="$l_output2\n - Audit tool \"$l_audit_tool\" is owned by group \"$l_group\" (should be owned by root)"
    else
        # If the group is root, report success
        l_output="$l_output\n - Audit tool \"$l_audit_tool\" is correctly owned by group root"
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

