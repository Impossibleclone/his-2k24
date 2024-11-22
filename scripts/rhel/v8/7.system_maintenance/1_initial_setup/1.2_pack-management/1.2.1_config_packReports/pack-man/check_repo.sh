#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Variables
REPO_DIR="/etc/yum.repos.d/"
GLOBAL_CONF="/etc/dnf/dnf.conf"
REPOS=($(find "$REPO_DIR" -name "*.repo"))

# Check global gpgcheck and repo_gpgcheck in dnf.conf
echo "Checking global configuration in $GLOBAL_CONF..."

grep -q "^gpgcheck=1" "$GLOBAL_CONF" && echo "Global gpgcheck is set to 1" || {
  echo "Global gpgcheck is NOT set to 1"
}

grep -q "^repo_gpgcheck=1" "$GLOBAL_CONF" && echo "Global repo_gpgcheck is set to 1" || {
  echo "Global repo_gpgcheck is NOT set to 1"
}

# Iterate through each repository configuration file and check for gpgcheck
echo "Checking per-repository configurations in $REPO_DIR..."

for repo in "${REPOS[@]}"; do
  echo "Checking $repo..."

  # Check if gpgcheck is set to 1
  grep -q "^gpgcheck=1" "$repo" && echo "$repo has gpgcheck enabled" || {
    echo "$repo does NOT have gpgcheck enabled"
  }

  # Check if repo_gpgcheck is set to 1
  grep -q "^repo_gpgcheck=1" "$repo" && echo "$repo has repo_gpgcheck enabled" || {
    echo "$repo does NOT have repo_gpgcheck enabled"
  }
done

# Verify repositories
echo "Listing active repositories..."
dnf repolist

echo "Repository configuration check complete."

