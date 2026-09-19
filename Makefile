BINDIR := $(HOME)/bin
XDG_STATE_HOME ?= $(HOME)/.local/state
STATE_DIR := $(XDG_STATE_HOME)/cron-config
CRONTAB_SNAPSHOT := $(STATE_DIR)/crontab

.PHONY: all clean install uninstall FORCE
all: crontab

crontab: mail $(sort $(wildcard crontab.d/*)) $(sort $(wildcard ~/.crontab.d/*))
	cat $+ > $@

mail: FORCE
	echo MAILFROM=$(USER) > $@

clean:
	rm -f crontab
	rm -f mail

install: crontab $(BINDIR) $(STATE_DIR)
	cp -a checkcmd.sh $(BINDIR)/
	cp -a checkdiff.sh $(BINDIR)/
	cp -a filter_lines.sh $(BINDIR)/
	cp -a crontab $(CRONTAB_SNAPSHOT)
	crontab crontab

uninstall:
	@tmp="$$(mktemp)"; \
	trap 'rm -f "$$tmp"' EXIT; \
	if [ ! -f "$(CRONTAB_SNAPSHOT)" ]; then \
		echo "Not uninstalling: $(CRONTAB_SNAPSHOT) is missing." >&2; \
		exit 1; \
	fi; \
	if ! crontab -l > "$$tmp" 2>/dev/null; then \
		echo "Not uninstalling: current crontab could not be read." >&2; \
		exit 1; \
	fi; \
	if ! cmp -s "$$tmp" "$(CRONTAB_SNAPSHOT)"; then \
		echo "Not uninstalling: current crontab differs from the installed snapshot." >&2; \
		exit 1; \
	fi; \
	crontab -r; \
	rm -f $(BINDIR)/checkcmd.sh; \
	rm -f $(BINDIR)/checkdiff.sh; \
	rm -f $(BINDIR)/filter_lines.sh; \
	rm -f "$(CRONTAB_SNAPSHOT)"; \
	rmdir "$(STATE_DIR)" 2>/dev/null || true

$(BINDIR):
	mkdir -p $@

$(STATE_DIR):
	mkdir -p $@

FORCE:
