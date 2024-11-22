#!/bin/bash

echo "Checking password complexity settings..."

# Check if minclass and dcredit, ucredit, ocredit, lcredit settings exist and meet the criteria
complexity_check=$(grep -Psi -- '^\h*(minclass|[dulo]credit)\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

if echo "$complexity_check" | grep -q "minclass = 4" && \
   echo "$complexity_check" | grep -q "dcredit = -1" && \
   echo "$complexity_check" | grep -q "ucredit = -1" && \
   echo "$complexity_check" | grep -q "ocredit = -1" && \
   echo "$complexity_check" | grep -q "lcredit = -1"; then
    echo "Password complexity settings are correctly configured."
else
    echo "Password complexity settings are NOT correctly configured."
fi

