# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Standard `Makefile` with DESTDIR and PREFIX packaging support.
- Arch Linux / CachyOS `PKGBUILD` in `contrib/arch/`.
- RPM spec file in `contrib/rpm/`.
- Manual page (`doc/memflush.1`) for terminal man documentation.
- Tab completion scripts for Bash, Zsh, and Fish shells.
- GitHub Actions CI workflow for automated ShellCheck validation.
- Automated release packaging workflow with SHA256 checksum generation.
- Security hardening directives for `memflush.service`.
- Structured GitHub issue and pull request templates.

---

## [1.1.0] - 2026-11-01

### Added
- Proactive memory offloading into ZRAM via `/sys/fs/cgroup/memory.reclaim`.
- Zone memory defragmentation and compaction via `/proc/sys/vm/compact_memory`.
- CLI options:
  - `-n, --no-notify` for CLI-only execution (skipping notifications in scripts/SSH).
  - `-s, --silent` and `-q, --quiet` for completely silent background/autostart operation.
  - `-v, --version` and `-h, --help`.
- Polkit rules (`99-memflush.rules`) allowing passwordless execution for wheel and sudo group members.
- Fallback sudoers permission configuration for non-interactive execution.
- Human-readable memory unit conversion (MB / GB) for terminal and notification outputs.

### Changed
- Improved memory differential calculations to accurately report reclaimed capacity.
- Switched desktop notification daemon calls to run safely without blocking.

---

## [1.0.0] - 2026-10-31

### Added
- Initial release of `memflush`.
- Linux page cache, dentry, and inode flushing (`drop_caches`).
- `systemd` service unit integration (`memflush.service`).
- Standalone installer (`install.sh`) and uninstaller (`uninstall.sh`).
- Basic desktop notification with `notify-send`.
