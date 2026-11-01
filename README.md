# ⚡ memflush

> **Advanced Linux Memory Compaction & Cache Flush Utility**  
> Proactively reclaim cold memory into ZRAM, defragment RAM zones, and flush lingering file caches with a single command or hotkey.

---

## 🚀 Features

- **Proactive Memory Compaction:** Unlike basic scripts that only drop disk caches, `memflush` uses Linux kernel cgroups (`memory.reclaim`) to proactively compress cold, dormant startup pages into **ZRAM**.
- **Instant Cache Reclaim:** Flushes unused page cache, directory entries (dentries), and inodes safely without killing running processes.
- **Dual Interface:**
  - **Terminal Mode:** Clean, colored statistics showing memory before/after, amount reclaimed, and available RAM.
  - **Desktop Notification:** Native desktop notification via `notify-send` for Wayland and X11 sessions.
- **Zero Daemon Overhead:** No permanent background processes or polling loops. Consumes **0 MB of RAM** while idle.
- **Passwordless Execution:** Includes automated Polkit and sudoers rules so you can trigger memory flushes via a desktop hotkey without password interruptions.

---

## 📦 Installation

Clone this repository and run the automated installer:

```bash
git clone https://github.com/NyrfHello/memflush.git
cd memflush
chmod +x install.sh
sudo ./install.sh
```

The installer automatically:
1. Links the executable to `/usr/local/bin/memflush` (so typing `memflush` works everywhere).
2. Registers `/etc/systemd/system/memflush.service`.
3. Configures Polkit and sudoers permissions so your desktop shortcuts can run without password prompts.

---

## 🔄 Updating

If you or your friends have already installed `memflush`, updating to the latest version takes just seconds and will never reset your desktop keybinds or shortcuts:

```bash
cd memflush
git pull
sudo ./install.sh
```

The installer cleanly overwrites the previous binary and systemd service with the latest version while keeping all permissions and custom shortcuts intact.

---

## 💻 CLI Usage

### 1. In Any Terminal
Simply open your terminal (Bash, Zsh, Fish) and type:

```bash
memflush
```

Example Output:
```text
[memflush] Measuring system memory...
           Cached: 2180 MB / Total RAM: 7628 MB
[memflush] Trimming cold memory, compacting zones, and dropping caches...
[memflush] Success! Reclaimed: 1.4 GB | Available: 5.8 GB (Total: 7628 MB)
```

### 2. Command-Line Options

| Option | Description |
| :--- | :--- |
| `memflush` | Standard run: prints terminal statistics and sends a desktop notification. |
| `memflush -n`, `--no-notify` | Terminal output only (skips notification; great for SSH, servers, and scripts). |
| `memflush -s`, `--silent` | Completely silent (no terminal text, no notification; great for hotkeys and autostart). |
| `memflush -q`, `--quiet` | Alias for `--silent`. |
| `memflush -v`, `--version` | Displays version information. |
| `memflush -h`, `--help` | Displays the help manual. |

---

## ⌨️ Keybind & Shortcut Management Guide

You can easily bind `memflush` to a keyboard shortcut for instant RAM cleaning while gaming, multitasking, or after closing heavy apps.

### 1. Hyprland

#### Traditional Hyprland (`hyprland.conf`):
Add this to your `~/.config/hypr/hyprland.conf`:
```ini
bind = SUPER SHIFT, Backspace, exec, memflush
```

#### Modern Lua Hyprland (`binds.lua` / CachyOS):
Add this to your `~/.config/hypr/config/binds.lua`:
```lua
hl.bind(mainMod .. " + SHIFT + Backspace", hl.dsp.exec_cmd("memflush"))
```

---

### 2. Sway / i3
Add this to your `~/.config/sway/config` or `~/.config/i3/config`:
```ini
bindsym $mod+Shift+BackSpace exec memflush
```

---

### 3. KDE Plasma (GUI)
1. Open **System Settings** $\rightarrow$ **Shortcuts** $\rightarrow$ **Custom Shortcuts**.
2. Click **Add New** $\rightarrow$ **Global Shortcut** $\rightarrow$ **Command/URL**.
3. Name it: `Flush Memory`.
4. Trigger tab: Press your preferred key combination (e.g. `Super + Shift + Backspace`).
5. Action tab: Type `memflush`.
6. Click **Apply**.

---

### 4. GNOME (GUI)
1. Open **Settings** $\rightarrow$ **Keyboard** $\rightarrow$ **View and Customize Shortcuts** $\rightarrow$ **Custom Shortcuts**.
2. Click the **+** (Add Shortcut) button.
3. **Name:** `Flush Memory`
4. **Command:** `memflush`
5. **Shortcut:** Press your key combination (e.g. `Super + Shift + Backspace`).
6. Click **Add**.

---

## ⚡ The "8-Second Boot Trim" Secret (Automated Low RAM on Boot)

When Linux boots up, it reads hundreds of initialization files, font tables, and setup scripts that stay in RAM even after the desktop is loaded.

You can make your desktop trim that startup garbage automatically by adding this command to your desktop autostart:

### In Hyprland (`autostart.lua` or `hyprland.conf`):
```lua
hl.exec_cmd("sh -c 'sleep 8 && memflush --silent >/dev/null 2>&1'")
```
*(Or in standard `hyprland.conf`: `exec-once = sh -c 'sleep 8 && memflush --silent'`)*

### In Sway (`config`):
```ini
exec sh -c 'sleep 8 && memflush --silent'
```

### In KDE / GNOME Autostart:
Create a `.desktop` file in `~/.config/autostart/memflush-boot.desktop`:
```ini
[Desktop Entry]
Type=Application
Name=Memflush Boot Trim
Exec=sh -c "sleep 8 && memflush --silent"
Hidden=false
NoDisplay=true
X-GNOME-Autostart-enabled=true
```

**What Happens:** 8 seconds after logging in, once your desktop reaches steady state, `memflush` silently compresses cold boot garbage into ZRAM and wipes disk caches, leaving your system at rock-bottom idle RAM!

---

## 🗑️ Uninstallation

If you ever wish to remove `memflush`:

```bash
cd memflush
sudo ./uninstall.sh
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
