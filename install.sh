#!/usr/bin/env bash
# ==============================================================================
# Installer for memflush
# Installs binary to /usr/local/bin, registers systemd unit, and polkit rules.
# ==============================================================================

set -euo pipefail

# Ensure running with root privileges
if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "This installer requires root privileges."
    echo "Relaunching with sudo..."
    exec sudo bash "$0" "$@"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing memflush..."

# 1. Install executable
install -Dm755 "${SCRIPT_DIR}/memflush" /usr/local/bin/memflush
echo "  [✓] Installed /usr/local/bin/memflush"

# 2. Install systemd service unit
install -Dm644 "${SCRIPT_DIR}/memflush.service" /etc/systemd/system/memflush.service
systemctl daemon-reload
echo "  [✓] Installed /etc/systemd/system/memflush.service"

# 3. Configure passwordless execution for wheel/sudo groups
POLKIT_DIR="/etc/polkit-1/rules.d"
if [ -d "$POLKIT_DIR" ]; then
    cat > "${POLKIT_DIR}/99-memflush.rules" << 'EOF'
/* Allow users in wheel or sudo group to run memflush.service without password prompt */
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.systemd1.manage-units") {
        if (action.lookup("unit") == "memflush.service") {
            if (subject.isInGroup("wheel") || subject.isInGroup("sudo")) {
                return polkit.Result.YES;
            }
        }
    }
});
EOF
    chmod 644 "${POLKIT_DIR}/99-memflush.rules"
    echo "  [✓] Installed Polkit rule for passwordless execution"
fi

# Also add sudoers.d rule as universal fallback
SUDOERS_DIR="/etc/sudoers.d"
if [ -d "$SUDOERS_DIR" ]; then
    echo "ALL ALL=(ALL) NOPASSWD: /usr/bin/systemctl start memflush.service" > "${SUDOERS_DIR}/memflush"
    chmod 440 "${SUDOERS_DIR}/memflush"
    echo "  [✓] Configured sudoers fallback"
fi

echo ""
echo "=========================================================="
echo "  memflush installed successfully!"
echo "=========================================================="
echo ""
echo "Quick Test:"
echo "  Open any terminal and type: memflush"
echo ""
echo "Optional - Set a keyboard shortcut:"
echo "  • Hyprland:  bind = SUPER SHIFT, Backspace, exec, memflush"
echo "  • Sway/i3:   bindsym \$mod+Shift+BackSpace exec memflush"
echo "  • KDE/GNOME: Add custom shortcut running 'memflush'"
echo ""
