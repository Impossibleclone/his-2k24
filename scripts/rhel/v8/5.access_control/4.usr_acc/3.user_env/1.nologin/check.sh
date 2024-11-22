#!/usr/bin/env bash

# Check if nologin is listed in /etc/shells
if grep -Ps '^\h*([^#\n\r]+)?\/nologin\b' /etc/shells; then
    echo "Warning: nologin is listed in /etc/shells"
else
    echo "Pass: nologin is not listed in /etc/shells"
fi

