#!/usr/bin/env bash

# Remove any line with nologin from /etc/shells
sed -i '/nologin/d' /etc/shells

echo "Remediation complete. nologin has been removed from /etc/shells."

