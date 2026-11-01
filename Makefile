PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
SHAREDIR ?= $(PREFIX)/share
MANDIR ?= $(SHAREDIR)/man/man1
BASH_COMPDIR ?= $(SHAREDIR)/bash-completion/completions
ZSH_COMPDIR ?= $(SHAREDIR)/zsh/site-functions
FISH_COMPDIR ?= $(SHAREDIR)/fish/vendor_completions.d

# System paths (package managers may override with PREFIX=/usr)
ifeq ($(PREFIX),/usr)
    SYSTEMD_DIR ?= /usr/lib/systemd/system
else
    SYSTEMD_DIR ?= /etc/systemd/system
endif

POLKIT_DIR ?= /etc/polkit-1/rules.d
SUDOERS_DIR ?= /etc/sudoers.d

.PHONY: all install uninstall check help

all:
	@echo "memflush is ready to install."
	@echo "Run 'sudo make install' to install on your system."
	@echo "Run 'make check' to validate script syntax."

check:
	@echo "Checking bash scripts syntax..."
	@bash -n memflush
	@bash -n install.sh
	@bash -n uninstall.sh
	@bash -n completions/memflush.bash
	@echo "All bash scripts syntax OK."

install:
	install -Dm755 memflush $(DESTDIR)$(BINDIR)/memflush
	install -Dm644 memflush.service $(DESTDIR)$(SYSTEMD_DIR)/memflush.service
	install -Dm644 doc/memflush.1 $(DESTDIR)$(MANDIR)/memflush.1
	install -Dm644 completions/memflush.bash $(DESTDIR)$(BASH_COMPDIR)/memflush
	install -Dm644 completions/_memflush $(DESTDIR)$(ZSH_COMPDIR)/_memflush
	install -Dm644 completions/memflush.fish $(DESTDIR)$(FISH_COMPDIR)/memflush.fish
	@mkdir -p $(DESTDIR)$(POLKIT_DIR)
	@printf '%s\n' \
		'/* Allow users in wheel or sudo group to run memflush.service without password prompt */' \
		'polkit.addRule(function(action, subject) {' \
		'    if (action.id == "org.freedesktop.systemd1.manage-units") {' \
		'        if (action.lookup("unit") == "memflush.service") {' \
		'            if (subject.isInGroup("wheel") || subject.isInGroup("sudo")) {' \
		'                return polkit.Result.YES;' \
		'            }' \
		'        }' \
		'    }' \
		'});' > $(DESTDIR)$(POLKIT_DIR)/99-memflush.rules
	@chmod 644 $(DESTDIR)$(POLKIT_DIR)/99-memflush.rules
	@mkdir -p $(DESTDIR)$(SUDOERS_DIR)
	@echo "ALL ALL=(ALL) NOPASSWD: /usr/bin/systemctl start memflush.service" > $(DESTDIR)$(SUDOERS_DIR)/memflush
	@chmod 440 $(DESTDIR)$(SUDOERS_DIR)/memflush
	@if [ -z "$(DESTDIR)" ] && command -v systemctl >/dev/null 2>&1; then \
		systemctl daemon-reload || true; \
	fi
	@echo "==> memflush installed successfully."

uninstall:
	@if [ -z "$(DESTDIR)" ] && command -v systemctl >/dev/null 2>&1; then \
		systemctl stop memflush.service 2>/dev/null || true; \
	fi
	rm -f $(DESTDIR)$(BINDIR)/memflush
	rm -f $(DESTDIR)$(SYSTEMD_DIR)/memflush.service
	rm -f $(DESTDIR)$(MANDIR)/memflush.1
	rm -f $(DESTDIR)$(BASH_COMPDIR)/memflush
	rm -f $(DESTDIR)$(ZSH_COMPDIR)/_memflush
	rm -f $(DESTDIR)$(FISH_COMPDIR)/memflush.fish
	rm -f $(DESTDIR)$(POLKIT_DIR)/99-memflush.rules
	rm -f $(DESTDIR)$(SUDOERS_DIR)/memflush
	@if [ -z "$(DESTDIR)" ] && command -v systemctl >/dev/null 2>&1; then \
		systemctl daemon-reload || true; \
	fi
	@echo "==> memflush uninstalled successfully."

help:
	@echo "Available targets:"
	@echo "  make check      - Lint and check bash syntax"
	@echo "  sudo make install    - Install binary, systemd unit, man page, completions, polkit rules"
	@echo "  sudo make uninstall  - Cleanly remove all installed files"
