BINDIR=~/bin

.PHONY: all clean install uninstall
all:

clean:

install:
	cp checkcmd.sh $(BINDIR)/
	cp checkdiff.sh $(BINDIR)/

uninstall:
	cp $(BINDIR)/checkcmd.sh
	cp $(BINDIR)/checkdiff.sh
