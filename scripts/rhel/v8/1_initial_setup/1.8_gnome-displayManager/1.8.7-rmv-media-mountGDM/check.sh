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
    $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
  done
  
  if [ -n "$l_pkgoutput" ]; then
    l_kfd="/etc/dconf/db/$(grep -Psril '^\h*automount\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"
    l_kfd2="/etc/dconf/db/$(grep -Psril '^\h*automount-open\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"
    
    if [ -d "$l_kfd" ]; then
      if grep -Priq '^\h*/org/gnome/desktop/media-handling/automount\b' "$l_kfd"; then
        l_output="$l_output\n - \"automount\" is locked"
      else
        l_output2="$l_output2\n - \"automount\" is not locked"
      fi
    else
      l_output2="$l_output2\n - \"automount\" is not set"
    fi
    
    if [ -d "$l_kfd2" ]; then
      if grep -Priq '^\h*/org/gnome/desktop/media-handling/automount-open\b' "$l_kfd2"; then
        l_output="$l_output\n - \"automount-open\" is locked"
      else
        l_output2="$l_output2\n - \"automount-open\" is not locked"
      fi
    else
      l_output2="$l_output2\n - \"automount-open\" is not set"
    fi
  else
    l_output="$l_output\n - GNOME Desktop Manager is not installed\n - Recommendation is not applicable"
  fi

  if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
  else
    echo -e "\n- Audit Result:\n ** FAIL **\n$l_output2\n"
    [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
  fi
}

