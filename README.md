# ⚡ memflush

> **Lightweight Linux Memory & Cache Flush Utility**  
> Safely reclaim cached RAM, dentries, and inodes with a single command or hotkey.

---

## 🚀 Features

- **Instant Cache Reclaim:** Flushes unused page cache, directory entries (dentries), and inodes without killing running applications.
- **Dual Interface:**
  - **Terminal Mode:** Clean, colored statistics showing memory before/after and exact amount reclaimed.
  - **Desktop Notification:** Native desktop notification via `notify-send` for Wayland and X11 sessions.
- **Zero Daemon Overhead:** No permanent background service or memory polling. Consumes 0 MB of RAM while idle.
- **Passwordless Hotkey Support:** Includes automated Polkit and sudoers rules so you can trigger cache flushes via a desktop hotkey without password interruptions.

---

## 📦 Installation

Clone this repository and run the installer:

```bash
git clone https://github.com/NyrfHello/memflush
cd memflush
chmod +x install.sh
sudo ./install.sh
```

---

## 💻 Usage

### 1. In Any Terminal
Simply type:
```bash
memflush
```

Example Output:
```text
[memflush] Measuring system memory...
           Cached: 1840 MB / Total: 7600 MB
[memflush] Flushing page cache, dentries, and inodes...
[memflush] Success! Reclaimed: 1.2 GB | Available: 5.6 GB (Total: 7600 MB)
```

### 2. Command-Line Options

| Option | Description |
| :--- | :--- |
| `memflush` | Standard run: prints terminal stats and sends desktop notification |
| `memflush -n`, `--no-notify` | Terminal output only (skips notification; great for SSH/servers) |
| `memflush -s`, `--silent` | Completely silent (no terminal text, no notification; great for cron) |
| `memflush -v`, `--version` | Displays version information |
| `memflush -h`, `--help` | Displays help manual |

---

## ⌨️ Desktop Keyboard Shortcut Guide

You can easily bind `memflush` to a keyboard shortcut for instant RAM cleaning while gaming or multitasking:

### Hyprland (`hyprland.conf` or `binds.lua`)
```ini
bind = SUPER SHIFT, Backspace, exec, memflush
```

### Sway / i3 (`config`)
```ini
bindsym $mod+Shift+BackSpace exec memflush
```

### KDE Plasma
1. Go to **System Settings** → **Shortcuts** → **Custom Shortcuts**.
2. Click **Add New** → **Global Shortcut** → **Command/URL**.
3. Set the trigger to your preferred shortcut (e.g. `Super + Shift + Backspace`).
4. Set the action to `memflush`.

### GNOME
1. Go to **Settings** → **Keyboard** → **View and Customize Shortcuts** → **Custom Shortcuts**.
2. Name: `Flush Memory`
3. Command: `memflush`
4. Shortcut: Set your key combination.

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
