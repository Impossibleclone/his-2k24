#!/usr/bin/env bash
{
    l_pkgoutput=""
    l_gpname="local" # Set to desired dconf profile name (default is local)

    # Check if GNOME Desktop Manager is installed
    if command -v dpkg-query > /dev/null 2>&1; then
        l_pq="dpkg-query -W"
    elif command -v rpm > /dev/null 2>&1; then
        l_pq="rpm -q"
    fi

    # Check if GDM is installed
    l_pcl="gdm gdm3"
    for l_pn in $l_pcl; do
        $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
    done

    if [ -n "$l_pkgoutput" ]; then
        echo -e "$l_pkgoutput"

        # Look for existing settings
        l_kfile="$(grep -Prils -- '^\h*automount\b' /etc/dconf/db/*.d)"
        l_kfile2="$(grep -Prils -- '^\h*automount-open\b' /etc/dconf/db/*.d)"

        # Set profile name based on dconf db directory
        if [ -f "$l_kfile" ]; then
            l_gpname="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile")"
            echo " - updating dconf profile name to \"$l_gpname\""
        elif [ -f "$l_kfile2" ]; then
            l_gpname="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile2")"
            echo " - updating dconf profile name to \"$l_gpname\""
        fi

        # Check and configure automount and automount-open
        if ! grep -Pqs -- '^\h*automount\h*=\h*false\b' "$l_kfile"; then
            echo " - creating \"automount\" entry in \"$l_kfile\""
            ! grep -Psq -- '^\h*\[org/gnome/desktop/media-handling\]\b' "$l_kfile" && echo '[org/gnome/desktop/media-handling]' >> "$l_kfile"
            sed -ri '/^\s*\[org/gnome/desktop/media-handling\]/a \\nautomount=false' "$l_kfile"
        fi

        if ! grep -Pqs -- '^\h*automount-open\h*=\h*false\b' "$l_kfile2"; then
            echo " - creating \"automount-open\" entry in \"$l_kfile2\""
            ! grep -Psq -- '^\h*\[org/gnome/desktop/media-handling\]\b' "$l_kfile2" && echo '[org/gnome/desktop/media-handling]' >> "$l_kfile2"
            sed -ri '/^\s*\[org/gnome/desktop/media-handling\]/a \\nautomount-open=false' "$l_kfile2"
        fi

        # Update dconf database
        dconf update
    else
        echo -e "\n - GNOME Desktop Manager package is not installed on the system\n - Recommendation is not applicable"
    fi
}

