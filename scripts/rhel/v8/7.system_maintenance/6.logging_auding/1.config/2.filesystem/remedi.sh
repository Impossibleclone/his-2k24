#!/bin/bash

echo "Setting up AIDE filesystem integrity checks..."

# Prompt for setup choice: cron or systemd
read -p "Choose method to schedule AIDE checks (1 for cron, 2 for systemd): " choice

if [[ "$choice" == "1" ]]; then
    # Set up cron job to run AIDE check at 5 AM daily
    echo "Configuring cron job for AIDE check at 5 AM daily..."
    (crontab -u root -l; echo "0 5 * * * /usr/sbin/aide --check") | crontab -u root -
    echo "Cron job configured."

elif [[ "$choice" == "2" ]]; then
    # Configure systemd service and timer
    echo "Creating systemd service and timer for AIDE check..."

    # Create aidecheck.service
    cat <<EOF > /etc/systemd/system/aidecheck.service
[Unit]
Description=Aide Check

[Service]
Type=simple
ExecStart=/usr/sbin/aide --check

[Install]
WantedBy=multi-user.target
EOF

    # Create aidecheck.timer
    cat <<EOF > /etc/systemd/system/aidecheck.timer
[Unit]
Description=Aide check every day at 5AM

[Timer]
OnCalendar=*-*-* 05:00:00
Unit=aidecheck.service

[Install]
WantedBy=multi-user.target
EOF

    # Set permissions and enable timer
    chown root:root /etc/systemd/system/aidecheck.*
    chmod 0644 /etc/systemd/system/aidecheck.*
    systemctl daemon-reload
    systemctl enable aidecheck.service
    systemctl --now enable aidecheck.timer

    echo "Systemd service and timer configured for daily AIDE check."
else
    echo "Invalid choice. Please run the script again and select 1 or 2."
    exit 1
fi

echo "AIDE filesystem integrity check scheduling setup is complete."

