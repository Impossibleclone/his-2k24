#!/usr/bin/env bash

# Check if journald is in use
if systemctl is-active --quiet systemd-journald; then
    echo "Checking systemd-journal-upload authentication configuration..."
    
    # Check if configuration parameters are set correctly
    if grep -P "^ *URL=|^ *ServerKeyFile=|^ *ServerCertificateFile=|^ *TrustedCertificateFile=" /etc/systemd/journal-upload.conf >/dev/null; then
        echo " ** PASS ** systemd-journal-upload authentication is configured."
    else
        echo " ** FAIL ** systemd-journal-upload authentication is NOT configured properly."
        echo "Run remedi.sh to configure authentication."
    fi
else
    echo " ** NOTE ** journald is not active. Skipping configuration check for systemd-journal-upload."
fi

