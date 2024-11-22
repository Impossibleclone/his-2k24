#!/bin/bash

# Check if GDM is installed
if rpm -q gdm &> /dev/null; then
    echo "GDM is installed. Removing GDM..."
    dnf remove -y gdm
    echo "GDM has been removed."
else
    echo "GDM is not installed. No action required."
fi

