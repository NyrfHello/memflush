## Description
<!-- Provide a brief description of the problem solved or feature introduced. -->

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Documentation update
- [ ] Performance / CI enhancement
- [ ] Packaging / Distro configuration

## Motivation and Context
<!-- Why is this change required? What problem does it solve? -->
<!-- If it fixes an open issue, link to it here: Fixes # -->

## Testing Matrix
- [ ] Linux Distribution: <!-- e.g., CachyOS / Arch / Fedora -->
- [ ] Kernel Version (`uname -r`): <!-- e.g., 6.13.0 -->
- [ ] ZRAM active (`zramctl` or swap check):
- [ ] Tested CLI commands:
  - `memflush` (terminal output & notification verified)
  - `memflush --no-notify`
  - `memflush --silent`
- [ ] Tested `memflush.service`:
  - `systemctl start memflush.service`
  - `systemctl status memflush.service`
- [ ] Tested installation / uninstallation (`make install` / `install.sh`)

## Checklist
- [ ] My code follows the code style of this project.
- [ ] All shell scripts pass `shellcheck` with zero warnings.
- [ ] My commits follow [Conventional Commits](https://www.conventionalcommits.org/) format.
- [ ] `README.md`, manpage (`doc/memflush.1`), or completion files updated if CLI flags changed.
