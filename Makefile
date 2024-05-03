BINDIR=~/bin

.PHONY: all clean install uninstall FORCE
all: crontab

crontab: mail $(sort $(wildcard crontab.d/*)) $(sort $(wildcard ~/.crontab.d/*))
	cat $+ > $@

mail: FORCE
	echo MAILFROM=$(USER) > $@

clean:
	rm -f crontab
	rm -f mail

install: crontab
	cp -a checkcmd.sh $(BINDIR)/
	cp -a checkdiff.sh $(BINDIR)/
	cp -a filter_lines.sh $(BINDIR)/
	crontab crontab

uninstall:
	rm $(BINDIR)/checkcmd.sh
	rm $(BINDIR)/checkdiff.sh
	rm $(BINDIR)/filter_lines.sh
	crontab -r

FORCE:
