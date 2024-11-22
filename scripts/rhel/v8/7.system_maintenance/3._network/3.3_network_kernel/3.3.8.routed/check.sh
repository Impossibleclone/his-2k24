#!/usr/bin/env bash

# Initialize output variables
l_output=""
l_output2=""
l_ipv6_disabled=""

# List of kernel parameters to check
a_parlist=("net.ipv4.conf.all.rp_filter=1" "net.ipv4.conf.default.rp_filter=1")

# Function to check if IPv6 is disabled
f_ipv6_chk() {
  l_ipv6_disabled=""
  ! grep -Pqs -- '^\h*0\b' /sys/module/ipv6/parameters/disable && l_ipv6_disabled="yes"
  if sysctl net.ipv6.conf.all.disable_ipv6 | grep -Pqs -- "^\h*net\.ipv6\.conf\.all\.disable_ipv6\h*=\h*1\b" && \
     sysctl net.ipv6.conf.default.disable_ipv6 | grep -Pqs -- "^\h*net\.ipv6\.conf\.default\.disable_ipv6\h*=\h*1\b"; then
    l_ipv6_disabled="yes"
  fi
  [ -z "$l_ipv6_disabled" ] && l_ipv6_disabled="no"
}

# Function to check kernel parameters
f_kernel_parameter_chk() {
  l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)"
  if [ "$l_krp" = "$l_kpvalue" ]; then
    l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
  else
    l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_krp\" and should have a value of: \"$l_kpvalue\""
  fi
}

# Check and process the kernel parameters
while IFS="=" read -r l_kpname l_kpvalue; do
  l_kpname="${l_kpname// /}"
  l_kpvalue="${l_kpvalue// /}"

  if grep -q '^net.ipv6.' <<< "$l_kpname"; then
    [ -z "$l_ipv6_disabled" ] && f_ipv6_chk
    if [ "$l_ipv6_disabled" = "yes" ]; then
      l_output="$l_output\n - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
    else
      f_kernel_parameter_chk
    fi
  else
    f_kernel_parameter_chk
  fi
done < <(printf '%s\n' "${a_parlist[@]}")

# Output the result
if [ -z "$l_output2" ]; then
  echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
else
  echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
  [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
fi

