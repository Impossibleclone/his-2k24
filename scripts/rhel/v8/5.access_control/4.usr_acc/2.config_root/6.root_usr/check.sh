#!/usr/bin/env bash

# Define the target umask for root
expected_umask="0027"
output=""

# Check the root's umask in /root/.bash_profile and /root/.bashrc
for file in /root/.bash_profile /root/.bashrc; do
  if grep -Psi -- '^\h*umask\h+(([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b)|([0-7][01][0-7]\b|[0-7][0-7][0-6]\b)|(u=[rwx]{1,3},)?(((g=[rx]?[rx]?w[rx]?[rx]?\b)(,o=[rwx]{1,3})?)|((g=[wrx]{1,3},)?o=[wrx]{1,3}\b)))' "$file"; then
    output="$output\n- Warning: umask is set in $file, but may not meet the expected restrictive permissions."
  fi
done

# Print result
if [ -z "$output" ]; then
  echo -e "\n- Audit Result:\n *** PASS ***\n - The root user's umask is correctly configured to restrict file permissions."
else
  echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$output\n"
fi

