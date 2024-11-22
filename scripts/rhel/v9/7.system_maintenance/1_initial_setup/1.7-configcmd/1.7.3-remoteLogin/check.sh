#!/usr/bin/env bash

echo "Auditing the /etc/issue.net file for system information..."

if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/\"//g'))" /etc/issue.net; then
    echo -e "\n- **FAIL**: The /etc/issue.net file contains system information. It should be remediated to remove this."
else
    echo -e "\n- **PASS**: The /etc/issue.net file does not contain system information."
fi

