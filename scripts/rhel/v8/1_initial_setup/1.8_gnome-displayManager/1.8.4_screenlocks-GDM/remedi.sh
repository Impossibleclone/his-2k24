#!/usr/bin/env bash

# Set the maximum values for idle and lock delay
idle_delay=900 # Max idle delay in seconds (between 1 and 900)
lock_delay=5   # Max lock delay in seconds (between 0 and 5)

# Set the dconf profile and path
dconf_profile="/etc/dconf/profile/user"
dconf_db_dir="/etc/dconf/db/local.d"
dconf_key_file="$dconf_db_dir/00-screensaver"

# Ensure the dconf profile includes the system and user database
echo -e '\nuser-db:user\nsystem-db:local' >> "$dconf_profile"

# Create the dconf database directory if it doesn't exist
mkdir -p "$dconf_db_dir"

# Write the dconf settings to the key file
{
    echo '# Specify the dconf path'
    echo '[org/gnome/desktop/session]'
    echo ''
    echo '# Number of seconds of inactivity before the screen goes blank'
    echo '# Set to 0 seconds if you want to deactivate the screensaver.'
    echo "idle-delay=uint32 $idle_delay"
    echo ''
    echo '# Specify the dconf path'
    echo '[org/gnome/desktop/screensaver]'
    echo ''
    echo '# Number of seconds after the screen is blank before locking the screen'
    echo "lock-delay=uint32 $lock_delay"
} > "$dconf_key_file"

# Update the dconf system databases
dconf update

# Notify the user to log out and back in for the changes to take effect
echo "Remediation complete. Please log out and log back in for the settings to take effect."

