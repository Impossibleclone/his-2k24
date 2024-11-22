#!/usr/bin/env bash
{
l_fwd_status="" l_nft_status="" l_fwutil_status=""

# Check FirewallD status
rpm -q firewalld > /dev/null 2>&1 && l_fwd_status="$(systemctl is-enabled firewalld.service):$(systemctl is-active firewalld.service)"

# Check NFTables status
rpm -q nftables > /dev/null 2>&1 && l_nft_status="$(systemctl is-enabled nftables.service):$(systemctl is-active nftables.service)"

l_fwutil_status="$l_fwd_status:$l_nft_status"

# Remediation steps
case $l_fwutil_status in
    enabled:active:masked:inactive|enabled:active:disabled:inactive)
        echo -e "\n - FirewallD utility is in use, enabled and active\n - NFTables utility is correctly disabled or masked and inactive\n - No remediation required" ;;
    masked:inactive:enabled:active|disabled:inactive:enabled:active)
        echo -e "\n - NFTables utility is in use, enabled and active\n - FirewallD utility is correctly disabled or masked and inactive\n - No remediation required" ;;
    enabled:active:enabled:active)
        echo -e "\n - Both FirewallD and NFTables utilities are enabled and active\n - Stopping and masking NFTables utility"
        systemctl stop nftables && systemctl --now mask nftables ;;
    enabled:*:enabled:*)
        echo -e "\n - Both FirewallD and NFTables utilities are enabled\n - Remediating"
        if [ "$(awk -F: '{print $2}' <<< "$l_fwutil_status")" = "active" ] && [ "$(awk -F: '{print $4}' <<< "$l_fwutil_status")" = "inactive" ]; then
            echo " - Masking NFTables utility"
            systemctl stop nftables && systemctl --now mask nftables
        elif [ "$(awk -F: '{print $4}' <<< "$l_fwutil_status")" = "active" ] && [ "$(awk -F: '{print $2}' <<< "$l_fwutil_status")" = "inactive" ]; then
            echo " - Masking FirewallD utility"
            systemctl stop firewalld && systemctl --now mask firewalld
        fi ;;
    *:active:*:active)
        echo -e "\n - Both FirewallD and NFTables utilities are active\n - Remediating"
        if [ "$(awk -F: '{print $1}' <<< "$l_fwutil_status")" = "enabled" ] && [ "$(awk -F: '{print $3}' <<< "$l_fwutil_status")" != "enabled" ]; then
            echo " - Stopping and masking NFTables utility"
            systemctl stop nftables && systemctl --now mask nftables
        elif [ "$(awk -F: '{print $3}' <<< "$l_fwutil_status")" = "enabled" ] && [ "$(awk -F: '{print $1}' <<< "$l_fwutil_status")" != "enabled" ]; then
            echo " - Stopping and masking FirewallD utility"
            systemctl stop firewalld && systemctl --now mask firewalld
        fi ;;
    :enabled:active)
        echo -e "\n - NFTables utility is in use, enabled, and active\n - FirewallD package is not installed\n - No remediation required" ;;
    :)
        echo -e "\n - Neither FirewallD nor NFTables is installed.\n - Remediating\n - Installing NFTables"
        dnf -q install nftables ;;
    *:*:)
        echo -e "\n - NFTables package is not installed on the system\n - Remediating\n - Installing NFTables"
        dnf -q install nftables ;;
    *)
        echo -e "\n - Unable to determine firewall state\n - MANUAL REMEDIATION REQUIRED: Configure only ONE firewall: either NFTables OR Firewalld" ;;
esac
}

