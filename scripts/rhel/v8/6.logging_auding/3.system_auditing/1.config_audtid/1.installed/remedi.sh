#!/bin/bash

# Install audit and audit-libs packages
echo "Installing audit and audit-libs packages..."
dnf install -y audit audit-libs

# Verify installation
if rpm -q audit audit-libs; then
  echo "audit and audit-libs packages successfully installed."
else
  echo "Failed to install audit and/or audit-libs packages."
fi

