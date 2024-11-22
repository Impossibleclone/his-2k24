#!/usr/bin/env bash
{
    # Check if SHA1 hash or signature support is present in CURRENT.pol
    awk_output=$(awk -F= '($1~/(hash|sign)/ && $2~/SHA1/ && $2!~/^\s*\-\s*([^#\n\r]+)?SHA1/){print}' /etc/crypto-policies/state/CURRENT.pol)

    # Check if sha1_in_certs is disabled (set to 0)
    sha1_in_certs=$(grep -Psi -- '^\h*sha1_in_certs\h*=\h*' /etc/crypto-policies/state/CURRENT.pol | grep -Pi '\h*=\h*0')

    # Report based on audit results
    if [[ -z "$awk_output" && -n "$sha1_in_certs" ]]; then
        echo "PASS: SHA1 hash and signature support is disabled."
        exit 0
    else
        echo "FAIL: SHA1 hash and/or signature support is enabled."
        exit 1
    fi
}

