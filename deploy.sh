#!/bin/bash
# Deploy customized web UI to PiKVM
#
# First time:
#   ssh root@pikvm
#   rw
#   cd /usr/share/kvmd/
#   mv web web-bak
#   git clone https://github.com/vewe-richard/pi-kvm-customize.git web
#   cd web
#   git checkout main
#   ro
#
# After kvmd update (web dir gets overwritten):
#   ssh root@pikvm
#   rw
#   cd /usr/share/kvmd/
#   rm -rf web
#   git clone https://github.com/vewe-richard/pi-kvm-customize.git web
#   cd web
#   git checkout main
#   ro
#
# Or run this script on the PiKVM device:
#   /usr/share/kvmd/web/deploy.sh

set -euo pipefail

KVMD_DIR="/usr/share/kvmd"
REPO="https://github.com/vewe-richard/pi-kvm-customize.git"
BRANCH="main"

echo "=== PiKVM Web UI Custom Deploy ==="

# Make filesystem read-write
if command -v rw &>/dev/null; then
    rw
fi

cd "${KVMD_DIR}"

# Backup original if first time
if [ -d web ] && [ ! -d web-bak ]; then
    echo "-> Backing up original web dir..."
    mv web web-bak
elif [ -d web ]; then
    echo "-> Removing overwritten web dir..."
    rm -rf web
fi

echo "-> Cloning custom UI..."
git clone "${REPO}" web
cd web
git checkout "${BRANCH}"

# Make filesystem read-only
if command -v ro &>/dev/null; then
    ro
fi

echo "=== Deploy complete. Reload browser to see changes. ==="
