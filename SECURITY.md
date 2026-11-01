# Security Policy

## Supported Versions

| Version | Supported |
| ------- | ------------------ |
| 1.1.x   | :white_check_mark: |
| 1.0.x   | :white_check_mark: |

## Privilege & System Impact Notice

`memflush` interacts with Linux kernel memory tunables, systemd units, and cgroup interfaces (`/proc/sys/vm/*`, `/sys/fs/cgroup/memory.reclaim`, `/sys/block/zram*`).

Elevated privileges (`root` / `sudo` / `polkit`) are required to:
- Write to kernel memory reclaim interfaces
- Install and manage `memflush.service` via systemd
- Set up Polkit / sudoers execution rules

Always inspect `install.sh`, `Makefile`, and the `memflush` script before executing with elevated privileges.

## Hardening

The provided systemd unit (`memflush.service`) applies security hardening directives:
- `ProtectHome=true`: Prevents access to `/home`, `/root`, and `/run/user`.
- `PrivateTmp=true`: Isolates `/tmp` and `/var/tmp`.
- `RestrictAddressFamilies=AF_UNIX`: Blocks internet / network socket access.
- `NoNewPrivileges=false`: Permits required systemd execution parameters while restricting external escalations.

## Reporting a Vulnerability

If you discover a privilege escalation risk, unsafe shell expansion, permission bypass, or unintended system degradation:
1. **Do NOT open a public GitHub issue.**
2. Report it privately via [GitHub Private Vulnerability Reporting](https://github.com/NyrfHello/memflush/security/advisories/new).
3. Include your Linux distribution (`/etc/os-release`), kernel version (`uname -r`), desktop environment, and reproducible steps.

All legitimate vulnerability reports will be addressed promptly.
