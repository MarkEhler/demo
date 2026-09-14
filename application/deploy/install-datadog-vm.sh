#!/bin/bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <datadog_api_key> <datadog_site> <space-delimited-tags>" >&2
  exit 1
fi

DD_API_KEY="${1}"
DD_SITE="${2}"
DD_TAGS="${3}"

if [ -z "$DD_API_KEY" ] || [ -z "$DD_SITE" ] || [ -z "$DD_TAGS" ]; then
  echo "Missing required Datadog installation values." >&2
  exit 1
fi

echo "[DATADOG] Starting installation"

# Install only if not already present.
if ! command -v datadog-agent >/dev/null 2>&1; then
  DD_API_KEY="$DD_API_KEY" DD_SITE="$DD_SITE" DD_AGENT_MAJOR_VERSION=7 \
    bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"
fi

# Declarative config — avoid drift between releases and environments.
cat > /etc/datadog-agent/datadog.yaml <<EOF
api_key: ${DD_API_KEY}
site: ${DD_SITE}
tags:
$(for tag in ${DD_TAGS}; do echo "  - ${tag}"; done)
apm_config:
  enabled: true
logs_enabled: true
EOF

chown dd-agent:dd-agent /etc/datadog-agent/datadog.yaml
chmod 640 /etc/datadog-agent/datadog.yaml

systemctl restart datadog-agent
sleep 5
datadog-agent status | grep -A6 Forwarder || true
echo "[DATADOG] Installation complete"