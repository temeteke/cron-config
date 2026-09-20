BINDIR := $(HOME)/bin

.PHONY: all clean install install-config install-bin uninstall uninstall-config uninstall-bin FORCE
all: crontab

crontab: mail $(sort $(wildcard crontab.d/*)) $(sort $(wildcard ~/.crontab.d/*))
	cat $+ > $@

mail: FORCE
	echo MAILFROM=$(USER) > $@

clean:
	rm -f crontab
	rm -f mail

install:
	$(MAKE) install-bin
	$(MAKE) install-config

install-config: crontab
	crontab crontab

install-bin: $(BINDIR)
	cp -a checkcmd.sh $(BINDIR)/
	cp -a checkdiff.sh $(BINDIR)/
	cp -a filter_lines.sh $(BINDIR)/

uninstall:
	$(MAKE) uninstall-config
	$(MAKE) uninstall-bin

uninstall-config: crontab
	@tmp="$$(mktemp)"; \
	trap 'rm -f "$$tmp"' EXIT; \
	if ! crontab -l > "$$tmp" 2>/dev/null; then \
		echo "Not uninstalling: current crontab could not be read." >&2; \
		exit 1; \
	fi; \
	if ! cmp -s "$$tmp" crontab; then \
		echo "Not uninstalling: current crontab differs from repository crontab." >&2; \
		exit 1; \
	fi; \
	crontab -r

uninstall-bin:
	rm -f $(BINDIR)/checkcmd.sh
	rm -f $(BINDIR)/checkdiff.sh
	rm -f $(BINDIR)/filter_lines.sh

$(BINDIR):
	mkdir -p $@

FORCE:
