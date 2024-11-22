#!/bin/bash

# Check if the audit and audit-libs packages are installed
if rpm -q audit audit-libs; then
  echo "audit and audit-libs packages are installed."
else
  echo "audit and/or audit-libs packages are not installed."
fi

