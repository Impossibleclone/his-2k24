#!/usr/bin/env bash

echo "Remediating the /etc/issue.net file..."

# Define the warning message for remote login
WARNING_MESSAGE="Authorized users only. All activity may be monitored and reported."

# Update the /etc/issue.net file with the new content
echo "$WARNING_MESSAGE" > /etc/issue.net

echo -e "\n- The /etc/issue.net file has been updated with the following warning message:"
cat /etc/issue.net

