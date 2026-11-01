# Contributing to memflush

Thank you for your interest in improving `memflush`! We welcome bug reports, feature suggestions, documentation enhancements, and pull requests.

---

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

---

## Development & Testing Guidelines

1. **Shell Standards:**
   - All shell scripts (`memflush`, `install.sh`, `uninstall.sh`, completions) must pass `shellcheck` without warnings.
   - Maintain POSIX compliance where portable and avoid bash-specific extensions unless specified with `#!/usr/bin/env bash`.
   - Maintain clear error handling (`set -euo pipefail` where applicable).

2. **Idempotency:**
   - Any modifications to `install.sh`, `uninstall.sh`, or `Makefile` must be safe to run multiple times without corrupting system configuration or permissions.

3. **Systemd Hardening:**
   - Changes to `memflush.service` must maintain minimal required privileges and avoid touching network stacks or user home files.
   - You can evaluate security posture with:
     ```bash
     systemd-analyze security memflush.service
     ```

4. **Desktop & ZRAM Compatibility:**
   - Ensure changes do not break desktop notification integration (`notify-send` under Wayland/X11) or silent modes (`-s`, `-q`).
   - Test that proactive memory reclaim properly offloads into ZRAM when available.

---

## Submitting a Pull Request

1. **Fork & Branch:**
   ```bash
   git checkout -b feat/your-feature-name
   ```

2. **Conventional Commits:**
   Please format your commit messages using [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat(zram): offload non-essential pages into zram swap`
   - `fix(systemd): ensure service waits for local-fs.target`
   - `docs(readme): update shortcut examples for Hyprland`
   - `ci(shellcheck): add linting workflow for bash scripts`

3. **Verify Locally:**
   - Test the CLI with:
     ```bash
     ./memflush --help
     ./memflush --version
     ./memflush --no-notify
     ```
   - Test packaging and installation:
     ```bash
     make
     ```

4. **Open a Pull Request:**
   - Fill out the provided Pull Request template.
   - Include before/after output or terminal logs.
   - Reference any relevant issues.
