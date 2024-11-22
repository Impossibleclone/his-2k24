##!/usr/bin/env bash

# Create the remediation script in /etc/profile.d/ to set TMOUT to 900 seconds
printf '%s\n' "# Set TMOUT to 900 seconds" "typeset -xr TMOUT=900" > /etc/profile.d/50-tmout.sh

# Apply the changes
echo "Remediation complete. TMOUT has been set to 900 seconds."
!/usr/bin/env bash

# Remove any line with nologin from /etc/shells
sed -i '/nologin/d' /etc/shells

echo "Remediation complete. nologin has been removed from /etc/shells."

