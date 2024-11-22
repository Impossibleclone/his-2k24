#!/usr/bin/env bash

{
    # Check if GDM is installed
    if command -v gdm > /dev/null 2>&1 || command -v gdm3 > /dev/null 2>&1; then
        echo " - GDM is installed. Proceeding with audit."

        # Check if XDMCP is enabled
        if grep -Eis '^\s*Enable\s*=\s*true' /etc/gdm/custom.conf > /dev/null; then
            echo -e "\n- Audit Result:\n ** FAIL **\n - XDMCP is enabled (Enable=true found in /etc/gdm/custom.conf)."
        else
            echo -e "\n- Audit Result:\n ** PASS **\n - XDMCP is not enabled."
        fi
    else
        echo -e "\n- Audit Result:\n ** NOT APPLICABLE **\n - GDM is not installed on the system."
    fi
}

