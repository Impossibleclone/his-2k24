#!/usr/bin/env bash
{
l_pkgoutput="" l_output="" l_output2=""
l_gpname="local"  # Default profile name

# Determine system's package manager
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
echo -e "$l_pkgoutput"

# Set autorun-never
if [ -n "$l_pkgoutput" ]; then
    l_kfile="$(grep -Prils -- '^\h*autorun-never\b' /etc/dconf/db/*.d)"
    if [ -f "$l_kfile" ]; then
        l_gpname="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile")"
        echo " - updating dconf profile name to \"$l_gpname\""
    fi

    [ ! -f "$l_kfile" ] && l_kfile="/etc/dconf/db/$l_gpname.d/00-media-autorun"

    if grep -Pqs -- '^\h*autorun-never\h*=\h*true\b' "$l_kfile"; then
        echo " - \"autorun-never\" is set to true in: \"$l_kfile\""
    else
        echo " - creating or updating \"autorun-never\" entry in \"$l_kfile\""
        ! grep -Psq -- '\^\h*\[org\/gnome\/desktop\/media-handling\]\b' "$l_kfile" && echo '[org/gnome/desktop/media-handling]' >> "$l_kfile"
        sed -ri '/^\s*\[org\/gnome\/desktop\/media-handling\]/a \\nautorun-never=true' "$l_kfile"
    fi
fi

# Update dconf database
dconf update
}

