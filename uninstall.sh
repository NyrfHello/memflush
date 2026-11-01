#!/usr/bin/env bash
# ==============================================================================
# Uninstaller for memflush
# Cleanly removes binary, systemd service unit, permissions rules, man page,
# and shell completions.
# ==============================================================================

set -euo pipefail

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "This uninstaller requires root privileges."
    echo "Relaunching with sudo..."
    exec sudo bash "$0" "$@"
fi

echo "==> Uninstalling memflush..."

# 1. Remove binary
rm -f /usr/local/bin/memflush
echo "  [✓] Removed /usr/local/bin/memflush"

# 2. Stop and remove systemd service unit
if command -v systemctl >/dev/null 2>&1; then
    systemctl stop memflush.service 2>/dev/null || true
fi
rm -f /etc/systemd/system/memflush.service
if command -v systemctl >/dev/null 2>&1; then
    systemctl daemon-reload || true
fi
echo "  [✓] Removed /etc/systemd/system/memflush.service"

# 3. Remove permissions rules
rm -f /etc/polkit-1/rules.d/99-memflush.rules
rm -f /etc/sudoers.d/memflush
echo "  [✓] Removed permission rules"

# 4. Remove man page and shell completions
rm -f /usr/local/share/man/man1/memflush.1
rm -f /usr/local/share/bash-completion/completions/memflush
rm -f /usr/local/share/zsh/site-functions/_memflush
rm -f /usr/local/share/fish/vendor_completions.d/memflush.fish
echo "  [✓] Removed documentation and completions"

echo ""
echo "memflush has been cleanly removed from your system."
