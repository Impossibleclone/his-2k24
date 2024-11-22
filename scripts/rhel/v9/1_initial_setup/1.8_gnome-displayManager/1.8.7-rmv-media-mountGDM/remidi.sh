#!/usr/bin/env bash
{
  l_pkgoutput=""
  if command -v dpkg-query > /dev/null 2>&1; then
    l_pq="dpkg-query -W"
  elif command -v rpm > /dev/null 2>&1; then
    l_pq="rpm -q"
  fi
  
  l_pcl="gdm gdm3"
  for l_pn in $l_pcl; do
    $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="y" && echo -e "\n - Package: \"$l_pn\" exists on the system\n - remediating configuration if needed"
  done
  
  if [ -n "$l_pkgoutput" ]; then
    l_kfd="/etc/dconf/db/$(grep -Psril '^\h*automount\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"
    l_kfd2="/etc/dconf/db/$(grep -Psril '^\h*automount-open\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"

    if [ -d "$l_kfd" ]; then
      if grep -Priq '^\h*/org/gnome/desktop/media-handling/automount\b' "$l_kfd"; then
        echo " - \"automount\" is locked"
      else
        mkdir -p "$l_kfd"/locks
        {
          echo '# Lock automount setting'
          echo '/org/gnome/desktop/media-handling/automount'
        } >> "$l_kfd"/locks/00-media-automount
      fi
    else
      echo -e " - \"automount\" is not set"
    fi

    if [ -d "$l_kfd2" ]; then
      if grep -Priq '^\h*/org/gnome/desktop/media-handling/automount-open\b' "$l_kfd2"; then
        echo " - \"automount-open\" is locked"
      else
        mkdir -p "$l_kfd2"/locks
        {
          echo '# Lock automount-open setting'
          echo '/org/gnome/desktop/media-handling/automount-open'
        } >> "$l_kfd2"/locks/00-media-automount
      fi
    else
      echo -e " - \"automount-open\" is not set"
    fi

    dconf update
  else
    echo -e " - GNOME Desktop Manager is not installed\n - Recommendation is not applicable"
  fi
}

