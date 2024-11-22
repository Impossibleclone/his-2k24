#!/bin/bash

# Check for accounts in /etc/passwd that do not have shadowed passwords
awk -F: '($2 != "x") { print "User: \"" $1 "\" does not have a shadowed password." }' /etc/passwd

# The expected output should list any users with passwords not shadowed in /etc/shadow

