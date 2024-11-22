#!/usr/bin/env bash
{
# Check if GNOME Desktop Manager is installed
l_pkgoutput=""
if command -v dpkg-query > /dev/null 2>&1; then
    l_pq="dpkg-query -W"
elif command -v rpm > /dev/null 2>&1; then
    l_pq="rpm -q"
fi

# Check if GDM is installed
l_pcl="gdm gdm3"
for l_pn in $l_pcl; do
    $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="y" && echo -e "\n - Package: \"$l_pn\" exists on the system\n - remediating configuration if needed"
done

# Check configuration (If applicable)
if [ -n "$l_pkgoutput" ]; then
    l_kfd="/etc/dconf/db/$(grep -Psril '^\h*autorun-never\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"
    
    if [ -d "$l_kfd" ]; then
        if grep -Priq '^\h*\/org/gnome\/desktop\/media-handling\/autorun-never\b' "$l_kfd"; then
            echo " - \"autorun-never\" is locked in \"$(grep -Pril '^\h*\/org/gnome\/desktop\/media-handling\/autorun-never\b' "$l_kfd")\""
        else
            echo " - creating entry to lock \"autorun-never\""
            [ ! -d "$l_kfd/locks" ] && echo "creating directory $l_kfd/locks" && mkdir "$l_kfd/locks"
            {
                echo -e '\n# Lock desktop media-handling autorun-never setting'
                echo '/org/gnome/desktop/media-handling/autorun-never'
            } >> "$l_kfd/locks/00-media-autorun
        fi
    else
        echo -e " - \"autorun-never\" is not set so it cannot be locked\n - Please follow Recommendation \"Ensure GDM autorun-never is enabled\" and follow this Recommendation again"
    fi
    
    # Update dconf database
    dconf update
else
    echo -e " - GNOME Desktop Manager package is not installed on the system\n - Recommendation is not applicable"
fi
}

