#!/usr/bin/env bash
{
l_output=""
# List of audit tools to check
a_audit_tools=("/sbin/auditctl" "/sbin/aureport" "/sbin/ausearch" "/sbin/autrace" "/sbin/auditd" "/sbin/augenrules")

# Check the ownership of each audit tool
for l_audit_tool in "${a_audit_tools[@]}"; do
    # Check the ownership of each audit tool
    l_owner=$(stat -Lc "%n %U" "$l_audit_tool" | awk '{print $2}')
    
    if [ "$l_owner" != "root" ]; then
        # If the owner is not root, report a failure
        l_output2="$l_output2\n - Audit tool \"$l_audit_tool\" is owned by \"$l_owner\" (should be owned by root)"
    else
        # If the owner is root, report success
        l_output="$l_output\n - Audit tool \"$l_audit_tool\" is correctly owned by root"
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

