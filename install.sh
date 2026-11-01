#!/usr/bin/env bash
# ==============================================================================
# Installer for memflush
# Installs binary to /usr/local/bin, registers systemd unit, polkit rules,
# man page, and shell completions.
# ==============================================================================

set -euo pipefail

# Ensure running with root privileges
if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "This installer requires root privileges."
    echo "Relaunching with sudo..."
    exec sudo bash "$0" "$@"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing memflush v1.1.0..."

# 1. Install executable
install -Dm755 "${SCRIPT_DIR}/memflush" /usr/local/bin/memflush
echo "  [✓] Installed /usr/local/bin/memflush"

# 2. Install systemd service unit
install -Dm644 "${SCRIPT_DIR}/memflush.service" /etc/systemd/system/memflush.service
if command -v systemctl >/dev/null 2>&1; then
    systemctl daemon-reload
fi
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

# 4. Install man page if present
if [ -f "${SCRIPT_DIR}/doc/memflush.1" ]; then
    install -Dm644 "${SCRIPT_DIR}/doc/memflush.1" /usr/local/share/man/man1/memflush.1
    echo "  [✓] Installed /usr/local/share/man/man1/memflush.1"
fi

# 5. Install shell completions if present
if [ -d "${SCRIPT_DIR}/completions" ]; then
    [ -f "${SCRIPT_DIR}/completions/memflush.bash" ] && install -Dm644 "${SCRIPT_DIR}/completions/memflush.bash" /usr/local/share/bash-completion/completions/memflush
    [ -f "${SCRIPT_DIR}/completions/_memflush" ] && install -Dm644 "${SCRIPT_DIR}/completions/_memflush" /usr/local/share/zsh/site-functions/_memflush
    [ -f "${SCRIPT_DIR}/completions/memflush.fish" ] && install -Dm644 "${SCRIPT_DIR}/completions/memflush.fish" /usr/local/share/fish/vendor_completions.d/memflush.fish
    echo "  [✓] Installed shell completions (Bash, Zsh, Fish)"
fi

echo ""
echo "=========================================================="
echo "  memflush installed successfully!"
echo "=========================================================="
echo ""
echo "Quick Test:"
echo "  Open any terminal and simply type: memflush"
echo ""
echo "Desktop Shortcut Setup:"
echo "  • Hyprland (hyprland.conf):"
echo "      bind = SUPER SHIFT, Backspace, exec, memflush"
echo ""
echo "  • Hyprland (CachyOS Lua binds.lua):"
echo "      hl.bind(mainMod .. \" + SHIFT + Backspace\", hl.dsp.exec_cmd(\"memflush\"))"
echo ""
echo "  • Sway / i3 (config):"
echo "      bindsym \$mod+Shift+BackSpace exec memflush"
echo ""
echo "  • KDE Plasma:"
echo "      System Settings -> Shortcuts -> Custom Shortcuts -> Add Command 'memflush'"
echo ""
echo "  • GNOME:"
echo "      Settings -> Keyboard -> Shortcuts -> Custom Shortcut -> Command 'memflush'"
echo ""
echo "Pro-tip (Automatic 8-second Boot Trim):"
echo "  Add this to your desktop autostart so your PC boots at minimum RAM:"
echo "  sh -c 'sleep 8 && memflush --silent'"
echo "=========================================================="
echo ""
