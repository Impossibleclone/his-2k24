#!/bin/bash

check_gpg_keys() {
    echo -e "\n\n -- INFO -- Checking if GPG keys are configured for repositories"

    # Search for gpgkey configuration in repo files
    gpg_key_files=$(grep -r gpgkey /etc/yum.repos.d/* /etc/dnf/dnf.conf 2>/dev/null)

    if [[ -n "$gpg_key_files" ]]; then
        echo " - GPG keys are configured in the following files:"
        echo "$gpg_key_files"
    else
        echo " - No GPG keys found in repository configuration files."
    fi
}

# Function to list installed GPG keys
list_installed_gpg_keys() {
    echo -e "\n\n -- INFO -- Listing installed GPG keys"

    # List the installed GPG keys
    for RPM_PACKAGE in $(rpm -q gpg-pubkey); do
        echo "RPM: ${RPM_PACKAGE}"
        RPM_SUMMARY=$(rpm -q --queryformat "%{SUMMARY}" "${RPM_PACKAGE}")
        RPM_PACKAGER=$(rpm -q --queryformat "%{PACKAGER}" "${RPM_PACKAGE}")
        RPM_DATE=$(date +%Y-%m-%d -d "1970-1-1+$((0x$(rpm -q --queryformat '%{RELEASE}' "${RPM_PACKAGE}") ))sec")
        RPM_KEY_ID=$(rpm -q --queryformat "%{VERSION}" "${RPM_PACKAGE}")
        echo "Packager: ${RPM_PACKAGER}
Summary: ${RPM_SUMMARY}
Creation date: ${RPM_DATE}
Key ID: ${RPM_KEY_ID}
"
    done
}

# Function to list GPG keys stored on disk
list_disk_gpg_keys() {
    echo -e "\n\n -- INFO -- Listing GPG keys stored on disk"

    for PACKAGE in $(find /etc/pki/rpm-gpg/ -type f -exec rpm -qf {} \; | sort -u); do
        rpm -q --queryformat "%{NAME}-%{VERSION} %{PACKAGER} %{SUMMARY}\\n" "${PACKAGE}"
    done
}

# Run functions
check_gpg_keys
list_installed_gpg_keys
list_disk_gpg_keys

