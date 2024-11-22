#!/usr/bin/env bash
{
l_output="" l_output2="" l_fwd_status="" l_nft_status=""
l_fwutil_status=""

# Check FirewallD status
rpm -q firewalld > /dev/null 2>&1 && l_fwd_status="$(systemctl is-enabled firewalld.service):$(systemctl is-active firewalld.service)"

# Check NFTables status
rpm -q nftables > /dev/null 2>&1 && l_nft_status="$(systemctl is-enabled nftables.service):$(systemctl is-active nftables.service)"

l_fwutil_status="$l_fwd_status:$l_nft_status"

# Determine the firewall status
case $l_fwutil_status in
    enabled:active:masked:inactive|enabled:active:disabled:inactive)
        l_output="\n - FirewallD utility is in use, enabled and active\n - NFTables utility is correctly disabled or masked and inactive\n - Only configure the recommendations found in the Configure Firewalld subsection" ;;
    masked:inactive:enabled:active|disabled:inactive:enabled:active)
        l_output="\n - NFTables utility is in use, enabled and active\n - FirewallD utility is correctly disabled or masked and inactive\n - Only configure the recommendations found in the Configure NFTables subsection" ;;
    enabled:active:enabled:active)
        l_output2="\n - Both FirewallD and NFTables utilities are enabled and active. Configure only ONE firewall either NFTables OR Firewalld" ;;
    enabled:*:enabled:*)
        l_output2="\n - Both FirewallD and NFTables utilities are enabled\n - Configure only ONE firewall: either NFTables OR Firewalld" ;;
    *:active:*:active)
        l_output2="\n - Both FirewallD and NFTables utilities are enabled\n - Configure only ONE firewall: either NFTables OR Firewalld" ;;
    :enabled:active)
        l_output="\n - NFTables utility is in use, enabled, and active\n - FirewallD package is not installed\n - Only configure the recommendations found in the Configure NFTables subsection" ;;
    :)
        l_output2="\n - Neither FirewallD nor NFTables is installed.\n Configure only ONE firewall: either NFTables OR Firewalld" ;;
    *:*:)
        l_output2="\n - NFTables package is not installed on the system.\n Install NFTables and configure only ONE firewall: either NFTables OR Firewalld" ;;
    *)
        l_output2="\n - Unable to determine firewall state.\n Configure only ONE firewall: either NFTables OR Firewalld" ;;
esac

if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Results:\n ** Pass **\n$l_output\n"
else
    echo -e "\n- Audit Results:\n ** Fail **\n$l_output2\n"
fi
}

