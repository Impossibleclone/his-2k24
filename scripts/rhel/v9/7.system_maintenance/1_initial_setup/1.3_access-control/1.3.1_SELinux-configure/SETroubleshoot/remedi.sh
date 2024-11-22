#!/bin/bash

# Function to check if setroubleshoot is installed
check_setroubleshoot_installed() {
    if rpm -q setroubleshoot &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to remove setroubleshoot
remove_setroubleshoot() {
    echo "Removing setroubleshoot..."
    dnf remove -y setroubleshoot
    if [[ $? -eq 0 ]]; then
        echo "setroubleshoot has been successfully removed."
    else
        echo "Failed to remove setroubleshoot."
    fi
}

# Main script execution
if check_setroubleshoot_installed; then
    # If setroubleshoot is installed, attempt to remove it
    remove_setroubleshoot
else
    echo "No action needed. setroubleshoot is not installed."
fi

