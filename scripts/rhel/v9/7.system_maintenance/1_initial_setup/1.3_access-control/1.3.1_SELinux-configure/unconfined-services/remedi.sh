#!/bin/bash

# Function to create a custom SELinux policy
create_selinux_policy() {
    local service_name="$1"
    local policy_file="service_allowlist_policy.te"
    
    echo "Creating SELinux policy for service: $service_name"

    # Create SELinux policy
    cat <<EOL > "$policy_file"
module my_service 1.0;

require {
    type my_service_t;
    type system_resource_t;
    class file { read write execute };
    class dir { read write add_name };
    class tcp_socket name_connect;
}

# Allow the service to read, write, and execute files in the system_resource_t domain
allow my_service_t system_resource_t:file { read write execute };

# Allow the service to read and write to directories in the system_resource_t domain
allow my_service_t system_resource_t:dir { read write add_name };

# Allow the service to establish TCP connections
allow my_service_t system_resource_t:tcp_socket name_connect;
EOL

    echo "Policy file created: $policy_file"

    # Compile and install the policy
    compile_and_install_policy "$policy_file"
}

# Function to compile and install the SELinux policy
compile_and_install_policy() {
    local policy_file="$1"

    echo "Compiling the SELinux policy..."
    checkmodule -M -m -o service_allowlist_policy.mod "$policy_file"

    echo "Packaging the SELinux policy..."
    semodule_package -o service_allowlist_policy.pp -m service_allowlist_policy.mod

    echo "Installing the SELinux policy..."
    semodule -i service_allowlist_policy.pp

    echo "Policy installed successfully."
}

# Function to label the service binary
label_service_binary() {
    local service_binary_path="$1"
    echo "Labeling the service binary..."
    chcon -t my_service_t "$service_binary_path"
    echo "Service binary labeled successfully."
}

# Remediation steps
echo "Remediation steps:"
echo "1. Identify the service and functionality needed."
echo "2. Create SELinux policy (automated)."
echo "3. Label the service binary (manually)."

# Prompt user for service details
read -p "Enter the name of the unconfined service: " service_name
read -p "Enter the path to the service binary: " service_binary_path

# Create SELinux policy
create_selinux_policy "$service_name"

# Label the service binary
label_service_binary "$service_binary_path"

# Final check
echo "Re-checking for unconfined services..."
./check.sh

