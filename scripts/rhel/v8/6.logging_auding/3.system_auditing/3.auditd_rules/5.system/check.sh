#!/bin/bash

# Check for audit rules related to modifications of system date/time
echo "Checking audit rules for date and time changes..."

# Verify rules for adjtimex, settimeofday, and clock_settime system calls
auditctl -l | awk '/^ *-a *always,exit/ \
&&/ -F *arch=b(32|64)/ \
&&/ -S/ \
&&/adjtimex/ \
||/settimeofday/ \
||/clock_settime/ \
&&/ key= *[!-~]* *$/'

# Verify rules for watching /etc/localtime file (used for time zone changes)
auditctl -l | awk '/^ *-w/ \
&&/\/etc\/localtime/ \
&&/ +-p *wa/ \
&&/ key= *[!-~]* *$/'

echo "Audit rule checks complete."

