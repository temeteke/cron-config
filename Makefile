BINDIR=~/bin

.PHONY: all clean install uninstall
all: crontab

crontab: $(sort $(wildcard crontab.d/*)) $(sort $(wildcard ~/.crontab.d/*))
	cat $+ > $@

clean:
	rm -f crontab

install: crontab
	cp checkcmd.sh $(BINDIR)/
	cp checkdiff.sh $(BINDIR)/
	cp filter_lines.sh $(BINDIR)/
	crontab crontab

uninstall:
	rm $(BINDIR)/checkcmd.sh
	rm $(BINDIR)/checkdiff.sh
	rm $(BINDIR)/filter_lines.sh
	crontab -r
