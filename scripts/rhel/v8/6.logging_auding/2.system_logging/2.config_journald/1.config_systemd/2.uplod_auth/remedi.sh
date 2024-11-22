#!/usr/bin/env bash

# Check if journald is in use
if systemctl is-active --quiet systemd-journald; then
    echo "Configuring systemd-journal-upload authentication..."

    # Ensure the configuration file exists
    config_file="/etc/systemd/journal-upload.conf"
    if [ ! -f "$config_file" ]; then
        echo "Configuration file $config_file does not exist. Creating it..."
        touch "$config_file"
    fi

    # Edit the /etc/systemd/journal-upload.conf file
    cat <<EOF > $config_file
[Upload]
URL=192.168.50.42
ServerKeyFile=/etc/ssl/private/journal-upload.pem
ServerCertificateFile=/etc/ssl/certs/journal-upload.pem
TrustedCertificateFile=/etc/ssl/ca/trusted.pem
EOF

    # Restart the systemd-journal-upload service to apply the changes
    systemctl restart systemd-journal-upload
    echo "systemd-journal-upload authentication configured successfully."
else
    echo "journald is not active. Skipping configuration of systemd-journal-upload."
fi

