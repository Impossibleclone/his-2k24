#!/usr/bin/env bash

echo "Remediating users with last password change date in the future..."

# Correct users with a last password change date in the future
while IFS= read -r user; do
    last_change=$(date -d "$(chage --list "$user" | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s 2>/dev/null)
    if [[ "$last_change" -gt "$(date +%s)" ]]; then
        echo "Setting password expiration for user \"$user\" due to future last password change date."
        # Expire the password to force change on next login
        chage -d 0 "$user"
    fi
done < <(awk -F: '$2~/^\$.+\$/{print $1}' /etc/shadow)

echo "Remediation complete."

