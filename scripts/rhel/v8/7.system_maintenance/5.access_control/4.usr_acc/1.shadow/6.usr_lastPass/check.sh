#!/usr/bin/env bash

echo "Checking for users with last password change date in the future..."

# Check each user with a password in /etc/shadow
while IFS= read -r user; do
    last_change=$(date -d "$(chage --list "$user" | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s 2>/dev/null)
    if [[ "$last_change" -gt "$(date +%s)" ]]; then
        echo "User: \"$user\" has a last password change in the future: $(chage --list "$user" | grep '^Last password change' | cut -d: -f2)"
    fi
done < <(awk -F: '$2~/^\$.+\$/{print $1}' /etc/shadow)

echo "Check complete."

