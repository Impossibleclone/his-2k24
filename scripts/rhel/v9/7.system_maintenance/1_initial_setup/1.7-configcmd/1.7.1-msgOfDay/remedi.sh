#!/usr/bin/env bash

echo "Remediating MOTD files..."

a_files=()
for l_file in /etc/motd{,.d/*}; do
    if grep -Psqi -- "(\\\v|\\\r|\\\m|\\\s|\b$(grep ^ID= /etc/os-release | cut -d= -f2 | sed -e 's/\"//g')\b)" "$l_file"; then
        echo -e "\n - File: \"$l_file\" includes system information. Editing this file to remove system information."
        # Remove the system information entries
        sed -i '/\\\v\|\\\r\|\\\m\|\\\s/d' "$l_file"
        echo "System information removed from $l_file."
    else
        a_files+=("$l_file")
    fi
done

if [ "${#a_files[@]}" -eq 0 ]; then
    echo -e "\n- **All MOTD files have been remediated to conform with local site policy**\n"
else
    echo -e "\n- **Please manually review the following files for any additional adjustments**\n"
    printf '%s\n' "${a_files[@]}"
fi

# Optional: remove the MOTD file if not used
# Uncomment the following line if the motd file is not needed.
# rm /etc/motd

