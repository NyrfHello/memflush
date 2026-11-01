Name:           memflush
Version:        1.1.0
Release:        1%{?dist}
Summary:        Advanced Linux memory compaction, cgroup reclaim into ZRAM, and cache flush utility

License:        MIT
URL:            https://github.com/NyrfHello/memflush
Source0:        https://github.com/NyrfHello/memflush/archive/refs/tags/v%{version}.tar.gz

BuildArch:      noarch
Requires:       bash
Requires:       systemd
Requires:       procps-ng
Recommends:     libnotify

%description
memflush proactively defragments memory zones, compresses dormant cold process
pages into ZRAM swap via cgroups v2 memory.reclaim, and safely flushes unused
file page caches, dentries, and inodes.

%prep
%autosetup

%build
# No compilation required

%install
make DESTDIR=%{buildroot} PREFIX=%{_prefix} install
install -Dm644 LICENSE %{buildroot}%{_datadir}/licenses/%{name}/LICENSE

%post
%systemd_post memflush.service

%preun
%systemd_preun memflush.service

%postun
%systemd_postun_with_restart memflush.service

%files
%license LICENSE
%doc README.md CHANGELOG.md SECURITY.md CONTRIBUTING.md
%{_bindir}/memflush
%{_unitdir}/memflush.service
%{_mandir}/man1/memflush.1*
%{_datadir}/bash-completion/completions/memflush
%{_datadir}/zsh/site-functions/_memflush
%{_datadir}/fish/vendor_completions.d/memflush.fish
%config(noreplace) %{_sysconfdir}/polkit-1/rules.d/99-memflush.rules
%config(noreplace) %{_sysconfdir}/sudoers.d/memflush

%changelog
* Sun Nov 01 2026 NyrfHello <https://github.com/NyrfHello> - 1.1.0-1
- Initial release with ZRAM reclaim, memory compaction, and CLI flags
