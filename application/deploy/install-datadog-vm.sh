#!/bin/bash

set -euo pipefail

echo "[DATADOG] Starting installation"

export DD_API_KEY="${DD_API_KEY}"
export DD_SITE="${DD_SITE}"
export DD_AGENT_MAJOR_VERSION="${DD_AGENT_MAJOR_VERSION}"
export DD_TAGS="${DD_TAGS}"

bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"

echo "[DATADOG] Installation complete"