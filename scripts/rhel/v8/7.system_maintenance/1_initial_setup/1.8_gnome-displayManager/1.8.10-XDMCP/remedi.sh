#!/usr/bin/env bash

{
    # Check if GDM is installed
    if command -v gdm > /dev/null 2>&1 || command -v gdm3 > /dev/null 2>&1; then
        echo " - GDM is installed. Proceeding with remediation."

        # Edit the configuration file
        if grep -Eis '^\s*Enable\s*=\s*true' /etc/gdm/custom.conf > /dev/null; then
            echo " - Found 'Enable=true'. Removing this line..."
            sed -i '/^\s*Enable\s*=\s*true/d' /etc/gdm/custom.conf
            echo " - Remediation completed: XDMCP is now disabled."
        else
            echo " - 'Enable=true' is not found. No action needed."
        fi
    else
        echo " - GDM is not installed on the system. Recommendation is not applicable."
    fi
}

