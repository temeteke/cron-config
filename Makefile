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
	crontab crontab

uninstall:
	cp $(BINDIR)/checkcmd.sh
	cp $(BINDIR)/checkdiff.sh
	crontab -r
