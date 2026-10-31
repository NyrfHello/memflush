#!/usr/bin/env bash
# ==============================================================================
# Uninstaller for memflush
# Cleanly removes binary, systemd service unit, and permissions rules.
# ==============================================================================

set -euo pipefail

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "This uninstaller requires root privileges."
    echo "Relaunching with sudo..."
    exec sudo bash "$0" "$@"
fi

echo "==> Uninstalling memflush..."

rm -f /usr/local/bin/memflush
echo "  [✓] Removed /usr/local/bin/memflush"

rm -f /etc/systemd/system/memflush.service
systemctl daemon-reload
echo "  [✓] Removed /etc/systemd/system/memflush.service"

rm -f /etc/polkit-1/rules.d/99-memflush.rules
rm -f /etc/sudoers.d/memflush
echo "  [✓] Removed permission rules"

echo ""
echo "memflush has been cleanly removed from your system."
