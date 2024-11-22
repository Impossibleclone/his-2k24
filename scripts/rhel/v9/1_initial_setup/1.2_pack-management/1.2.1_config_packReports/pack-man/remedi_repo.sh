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

# Remediate global gpgcheck and repo_gpgcheck in dnf.conf
echo "Remediating global configuration in $GLOBAL_CONF..."

grep -q "^gpgcheck=1" "$GLOBAL_CONF" || {
  echo "Global gpgcheck is NOT set to 1. Remediating..."
  sed -i 's/^gpgcheck=.*/gpgcheck=1/' "$GLOBAL_CONF"
  echo "Global gpgcheck set to 1."
}

grep -q "^repo_gpgcheck=1" "$GLOBAL_CONF" || {
  echo "Global repo_gpgcheck is NOT set to 1. Remediating..."
  sed -i 's/^repo_gpgcheck=.*/repo_gpgcheck=1/' "$GLOBAL_CONF"
  echo "Global repo_gpgcheck set to 1."
}

# Iterate through each repository configuration file and remediate gpgcheck
echo "Remediating per-repository configurations in $REPO_DIR..."

for repo in "${REPOS[@]}"; do
  echo "Remediating $repo..."

  # Check if gpgcheck is set to 1
  grep -q "^gpgcheck=1" "$repo" || {
    echo "$repo does NOT have gpgcheck enabled. Remediating..."
    sed -i 's/^gpgcheck=.*/gpgcheck=1/' "$repo"
    echo "gpgcheck set to 1 in $repo."
  }

  # Check if repo_gpgcheck is set to 1
  grep -q "^repo_gpgcheck=1" "$repo" || {
    echo "$repo does NOT have repo_gpgcheck enabled. Remediating..."
    sed -i 's/^repo_gpgcheck=.*/repo_gpgcheck=1/' "$repo"
    echo "repo_gpgcheck set to 1 in $repo."
  }
done

# Verify repositories
echo "Listing active repositories after remediation..."
dnf repolist

echo "Repository configuration remediation complete."

