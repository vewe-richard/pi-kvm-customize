#!/bin/bash
# Deploy customized web UI to PiKVM
#
# First time:
#   ssh root@pikvm
#   rw
#   cd /usr/share/kvmd/
#   mv web web-bak
#   git clone https://github.com/vewe-richard/pi-kvm-customize.git web
#   cd web/
#   ./deploy.sh
#
# After that, pikvm-update will auto-restore custom UI via pacman hook.

set -euo pipefail

KVMD_DIR="/usr/share/kvmd"
HOOK_DIR="/etc/pacman.d/hooks"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== PiKVM Web UI Custom Deploy ==="

# Make filesystem read-write
if command -v rw &>/dev/null; then
    rw
fi

# Install pacman hook if not already present
if [ ! -f "${HOOK_DIR}/99-kvmd-web-custom.hook" ]; then
    echo "-> Installing pacman hook..."
    mkdir -p "${HOOK_DIR}"
    cp "${SCRIPT_DIR}/99-kvmd-web-custom.hook" "${HOOK_DIR}/"
    echo "   Installed to ${HOOK_DIR}/99-kvmd-web-custom.hook"
else
    echo "-> Pacman hook already installed."
fi

# Make filesystem read-only
if command -v ro &>/dev/null; then
    ro
fi

echo "=== Deploy complete. Reload browser to see changes. ==="
