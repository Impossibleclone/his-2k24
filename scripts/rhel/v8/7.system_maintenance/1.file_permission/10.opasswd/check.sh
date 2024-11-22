#!/usr/bin/env bash
{
l_output=""
# Check if /etc/security/opasswd exists and verify its permissions and ownership
if [ -e "/etc/security/opasswd" ]; then
    l_stat_output=$(stat -Lc '%n Access: (%#a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/security/opasswd)
    if [[ ! "$l_stat_output" =~ "Access: (0600/-rw-------)" ]]; then
        l_output2="$l_output2\n - /etc/security/opasswd permissions are incorrect: $l_stat_output"
    else
        l_output="$l_output\n - /etc/security/opasswd permissions are correct"
    fi
    if [[ ! "$l_stat_output" =~ "Uid: ( 0/ root)" || ! "$l_stat_output" =~ "Gid: ( 0/ root)" ]]; then
        l_output2="$l_output2\n - /etc/security/opasswd owner or group is incorrect: $l_stat_output"
    else
        l_output="$l_output\n - /etc/security/opasswd owner and group are correct"
    fi
fi

# Check if /etc/security/opasswd.old exists and verify its permissions and ownership
if [ -e "/etc/security/opasswd.old" ]; then
    l_stat_output=$(stat -Lc '%n Access: (%#a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/security/opasswd.old)
    if [[ ! "$l_stat_output" =~ "Access: (0600/-rw-------)" ]]; then
        l_output2="$l_output2\n - /etc/security/opasswd.old permissions are incorrect: $l_stat_output"
    else
        l_output="$l_output\n - /etc/security/opasswd.old permissions are correct"
    fi
    if [[ ! "$l_stat_output" =~ "Uid: ( 0/ root)" || ! "$l_stat_output" =~ "Gid: ( 0/ root)" ]]; then
        l_output2="$l_output2\n - /etc/security/opasswd.old owner or group is incorrect: $l_stat_output"
    else
        l_output="$l_output\n - /etc/security/opasswd.old owner and group are correct"
    fi
fi

# Output the results
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n - Correctly configured: $l_output"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reasons for audit failure: $l_output2\n"
    [ -n "$l_output" ] && echo -e "\n - Correctly configured: $l_output\n"
fi

# Clean up
unset l_output l_output2 l_stat_output
}

