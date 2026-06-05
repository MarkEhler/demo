#!/bin/bash
set -euo pipefail

DD_API_KEY="$1"
DD_SITE="$2"
DD_TAGS="$3" 

echo "[DATADOG] Starting installation"

# Install only if not already present (config is managed below, not by the installer)
if ! command -v datadog-agent >/dev/null 2>&1; then
  DD_API_KEY="$DD_API_KEY" DD_SITE="$DD_SITE" DD_AGENT_MAJOR_VERSION=7 \
    bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"
fi

# Declarative "values" config — always rewritten so site/tags/key can't drift
cat > /etc/datadog-agent/datadog.yaml <<EOF
api_key: ${DD_API_KEY}
site: ${DD_SITE}
tags:
$(for t in ${DD_TAGS}; do echo "  - ${t}"; done)
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