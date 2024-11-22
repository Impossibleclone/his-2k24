#!/usr/bin/env bash

# Initialize output variables
output=""

# Parameters to check
params=(
  "net.ipv4.conf.all.send_redirects=0"
  "net.ipv4.conf.default.send_redirects=0"
)

# Check each parameter
for param in "${params[@]}"; do
  key=$(echo "$param" | cut -d= -f1)
  expected_value=$(echo "$param" | cut -d= -f2)

  # Get the current value
  current_value=$(sysctl -n "$key" 2>/dev/null)

  # Check if current value matches expected value
  if [ "$current_value" = "$expected_value" ]; then
    output+="$key is correctly set to $expected_value\n"
  else
    output+="$key is incorrectly set to $current_value (should be $expected_value)\n"
  fi
done

# Display result
if [[ -z $(echo -e "$output" | grep "incorrectly") ]]; then
  echo -e "\nAudit Result: ** PASS **\n$output"
else
  echo -e "\nAudit Result: ** FAIL **\n$output"
fi

