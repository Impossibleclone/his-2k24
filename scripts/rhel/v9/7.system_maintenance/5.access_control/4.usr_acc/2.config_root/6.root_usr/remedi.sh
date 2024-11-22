#!/usr/bin/env bash

# Define the desired umask
desired_umask="0027"
files=("/root/.bash_profile" "/root/.bashrc")

for file in "${files[@]}"; do
  # Check if umask is already set and if it matches the desired umask
  if grep -q "umask" "$file"; then
    sed -i "s/^umask.*/umask $desired_umask/" "$file"
  else
    # Add umask if not present
    echo "umask $desired_umask" >> "$file"
  fi
done

echo -e "Remediation complete. The root user's umask is now set to $desired_umask in both .bash_profile and .bashrc files."

