BINDIR := $(HOME)/bin

.PHONY: all clean install uninstall FORCE
all: crontab

crontab: mail $(sort $(wildcard crontab.d/*)) $(sort $(wildcard ~/.crontab.d/*))
	cat $+ > $@

mail: FORCE
	echo MAILFROM=$(USER) > $@

clean:
	rm -f crontab
	rm -f mail

install: crontab $(BINDIR)
	cp -a checkcmd.sh $(BINDIR)/
	cp -a checkdiff.sh $(BINDIR)/
	cp -a filter_lines.sh $(BINDIR)/
	crontab crontab

uninstall: crontab
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
	crontab -r; \
	rm -f $(BINDIR)/checkcmd.sh; \
	rm -f $(BINDIR)/checkdiff.sh; \
	rm -f $(BINDIR)/filter_lines.sh

$(BINDIR):
	mkdir -p $@

FORCE:
