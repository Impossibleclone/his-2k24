#!/usr/bin/env bash
{
l_output=""
# Check if any .conf or .rules file is not owned by root group
while IFS= read -r -d $'\0' l_fname; do
    l_group=$(stat -c '%G' "$l_fname")  # Get the file's group owner
    if [ "$l_group" != "root" ]; then
        l_output="$l_output\n - file: \"$l_fname\" is owned by group: \"$l_group\" (should be owned by root)"
    fi
done < <(find /etc/audit/ -type f \( -name "*.conf" -o -name "*.rules" \) -print0)

# Output the result of the check
if [ -z "$l_output" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n - All audit configuration files are group owned by root"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n$l_output"
fi
}

