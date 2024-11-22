#!/bin/bash

{
    pkg_output=""
    # Determine package query tool based on system (dpkg-query or rpm)
    if command -v dpkg-query > /dev/null 2>&1; then
        pq="dpkg-query -W"
    elif command -v rpm > /dev/null 2>&1; then
        pq="rpm -q"
    fi

    # Check if GDM or GDM3 is installed
    pcl="gdm gdm3"
    for pn in $pcl; do
        $pq "$pn" > /dev/null 2>&1 && pkg_output="$pkg_output\n - Package: \"$pn\" exists on the system\n - Checking configuration"
    done

    if [ -n "$pkg_output" ]; then
        echo -e "$pkg_output"
        output=""
        output2=""

        # Look for banner message configuration
        gdmfile="$(grep -Prils '^\h*banner-message-enable\b' /etc/dconf/db/*.d)"
        if [ -n "$gdmfile" ]; then
            # Extract profile name from dconf db directory
            gdmprofile="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$gdmfile")"

            # Check if banner message is enabled
            if grep -Pisq '^\h*banner-message-enable=true\b' "$gdmfile"; then
                output="$output\n - The \"banner-message-enable\" option is enabled in \"$gdmfile\""
            else
                output2="$output2\n - The \"banner-message-enable\" option is not enabled"
            fi

            # Check banner message text
            lsbt="$(grep -Pios '^\h*banner-message-text=.*$' "$gdmfile")"
            if [ -n "$lsbt" ]; then
                output="$output\n - The \"banner-message-text\" option is set in \"$gdmfile\"\n - banner-message-text is set to:\n - \"$lsbt\""
            else
                output2="$output2\n - The \"banner-message-text\" option is not set"
            fi

            # Check if profile exists in dconf
            if grep -Pq "^\h*system-db:$gdmprofile" /etc/dconf/profile/"$gdmprofile"; then
                output="$output\n - The \"$gdmprofile\" profile exists"
            else
                output2="$output2\n - The \"$gdmprofile\" profile doesn't exist"
            fi
        else
            output2="$output2\n - The \"banner-message-enable\" option isn't configured"
        fi
    else
        echo -e "\n\n - GNOME Desktop Manager isn't installed\n - Recommendation is Not Applicable\n- Audit result:\n *** PASS ***\n"
    fi

    # Report results
    if [ -z "$output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$output\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$output2\n"
        [ -n "$output" ] && echo -e "\n- Correctly set:\n$output\n"
    fi
}

