#!/bin/bash
# Deploy customized web UI to PiKVM
#
# First time:
#   ssh root@pikvm
#   rw
#   cd /root
#   git clone https://github.com/vewe-richard/pi-kvm-customize.git
#   cd pi-kvm-customize
#   ./deploy.sh
#
# After that, pikvm-update will auto-restore custom UI via pacman hook.

set -euo pipefail

REPO_DIR="/root/pi-kvm-customize"
KVMD_WEB="/usr/share/kvmd/web"
HOOK_DIR="/etc/pacman.d/hooks"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== PiKVM Web UI Custom Deploy ==="

# Make filesystem read-write
if command -v rw &>/dev/null; then
    rw
fi

# Backup original web dir if first time
if [ -d "${KVMD_WEB}" ] && [ ! -d "${KVMD_WEB}-bak" ]; then
    echo "-> Backing up original web dir..."
    mv "${KVMD_WEB}" "${KVMD_WEB}-bak"
fi

# Copy repo files to kvmd web dir
echo "-> Copying custom UI to ${KVMD_WEB}..."
rm -rf "${KVMD_WEB}"
cp -a "${SCRIPT_DIR}" "${KVMD_WEB}"

# Install pacman hook if not already present
if [ ! -f "${HOOK_DIR}/99-kvmd-web-custom.hook" ]; then
    echo "-> Installing pacman hook..."
    mkdir -p "${HOOK_DIR}"
    cp "${SCRIPT_DIR}/99-kvmd-web-custom.hook" "${HOOK_DIR}/"
    echo "   Installed to ${HOOK_DIR}/99-kvmd-web-custom.hook"
else
    echo "-> Pacman hook already installed."
fi

# Make filesystem read-only (may fail if fs is busy, that's ok)
if command -v ro &>/dev/null; then
    ro || true
fi

echo "=== Deploy complete. Reload browser to see changes. ==="
