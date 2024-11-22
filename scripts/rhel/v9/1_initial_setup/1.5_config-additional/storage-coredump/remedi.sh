#!/usr/bin/env bash
{
    # Ensure the directory exists
    [ ! -d /etc/systemd/coredump.conf.d/ ] && mkdir /etc/systemd/coredump.conf.d/
    
    # Check if [Coredump] section exists and add the Storage=none setting
    if grep -Psq -- '^\h*\[Coredump\]' /etc/systemd/coredump.conf.d/60-coredump.conf; then
        printf '%s\n' "Storage=none" >> /etc/systemd/coredump.conf.d/60-coredump.conf
    else
        printf '%s\n' "[Coredump]" "Storage=none" >> /etc/systemd/coredump.conf.d/60-coredump.conf
    fi
}

