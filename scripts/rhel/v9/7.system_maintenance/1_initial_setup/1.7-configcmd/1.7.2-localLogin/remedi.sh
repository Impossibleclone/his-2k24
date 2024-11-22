#!/usr/bin/env bash

echo "Remediating the /etc/issue file..."

# Define the warning message for local login
WARNING_MESSAGE="Authorized users only. All activity may be monitored and reported."

# Update the /etc/issue file with the new content
echo "$WARNING_MESSAGE" > /etc/issue

echo -e "\n- The /etc/issue file has been updated with the following warning message:"
cat /etc/issue

