#!/bin/bash
set -euo pipefail

echo "Hello world from the Azure VM!"
cat <<'EOF' >/tmp/hello-world.txt
Hello World from the Azure VM!
EOF
chmod 644 /tmp/hello-world.txt

echo "Created /tmp/hello-world.txt with the following content:"
cat /tmp/hello-world.txt
