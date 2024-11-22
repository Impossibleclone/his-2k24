#!/bin/bash

# Check for accounts in /etc/shadow that have empty password fields
awk -F: '($2 == "") { print $1 " does not have a password" }' /etc/shadow

# If no output is returned, it means all password fields are properly populated.

