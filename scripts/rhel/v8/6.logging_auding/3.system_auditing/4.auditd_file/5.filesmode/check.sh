#!/usr/bin/env bash
{
l_output="" l_output2="" l_perm_mask="0137"   # Permissions mask for 0640
l_maxperm="$( printf '%o' $(( 0777 & ~$l_perm_mask )) )"  # Expected max permission for 0640
# Iterate through all .conf and .rules files in /etc/audit/
while IFS= read -r -d $'\0' l_fname; do
    l_mode=$(stat -Lc '%#a' "$l_fname")  # Get the file mode in octal format
    if [ $(( "$l_mode" & "$l_perm_mask" )) -gt 0 ]; then
        l_output2="$l_output2\n - file: \"$l_fname\" is mode: \"$l_mode\"\n (should be mode: \"$l_maxperm\" or more restrictive)"
    fi
done < <(find /etc/audit/ -type f \( -name "*.conf" -o -name '*.rules' \) -print0)

# Output the result of the check
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n - All audit configuration files are mode: \"$l_maxperm\" or more restrictive"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n$l_output2"
fi
}

