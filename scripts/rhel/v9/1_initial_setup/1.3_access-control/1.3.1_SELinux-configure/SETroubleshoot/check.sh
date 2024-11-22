#!/bin/bash

# Function to check if setroubleshoot is installed
check_setroubleshoot_installed() {
    echo "Checking if setroubleshoot is installed..."
    if rpm -q setroubleshoot &>/dev/null; then
        echo "setroubleshoot is installed."
        return 0
    else
        echo "setroubleshoot is not installed."
        return 1
    fi
}

# Main script execution
check_setroubleshoot_installed

