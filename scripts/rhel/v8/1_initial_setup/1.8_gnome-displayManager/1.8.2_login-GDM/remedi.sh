#!/bin/bash

{
    pkg_output=""
    # Determine package query tool based on system (dpkg-query or rpm)
    if command -v dpkg-query > /dev/null 2>&1; then
        pq="dpkg-query -W"
    elif command -v rpm > /dev/null 2>&1; then
        pq="rpm -q"
    fi

    # Check if GDM or GDM3 is installed
    pcl="gdm gdm3"
    for pn in $pcl; do
        $pq "$pn" > /dev/null 2>&1 && pkg_output="$pkg_output\n - Package: \"$pn\" exists on the system\n - Checking configuration"
    done

    if [ -n "$pkg_output" ]; then
        gdmprofile="gdm"
        bmessage="'Authorized uses only. All activity may be monitored and reported'"

        # Create profile if not exists
        if [ ! -f "/etc/dconf/profile/$gdmprofile" ]; then
            echo "Creating profile \"$gdmprofile\""
            echo -e "user-db:user\nsystem-db:$gdmprofile\nfile-db:/usr/share/$gdmprofile/greeter-dconf-defaults" > /etc/dconf/profile/$gdmprofile
        fi

        # Create dconf database directory if not exists
        if [ ! -d "/etc/dconf/db/$gdmprofile.d/" ]; then
            echo "Creating dconf database directory \"/etc/dconf/db/$gdmprofile.d/\""
            mkdir /etc/dconf/db/$gdmprofile.d/
        fi

        # Configure banner-message-enable
        if ! grep -Piq '^\h*banner-message-enable\h*=\h*true\b' /etc/dconf/db/$gdmprofile.d/*; then
            echo "Creating GDM keyfile for machine-wide settings"
            kfile="/etc/dconf/db/$gdmprofile.d/01-banner-message"
            echo -e "[org/gnome/login-screen]\nbanner-message-enable=true" >> "$kfile"
        fi

        # Configure banner-message-text
        if ! grep -Piq "^\h*banner-message-text=[\'\"]+\S+" "$kfile"; then
            sed -ri "/^\s*banner-message-enable/ a\banner-message-text=$bmessage" "$kfile"
        fi

        # Update dconf database
        dconf update
    else
        echo -e "\n\n - GNOME Desktop Manager isn't installed\n - Recommendation is Not Applicable\n - No remediation required\n"
    fi
}

