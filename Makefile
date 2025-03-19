.SHELLFLAGS   += -u -o pipefail
MAKEFLAGS     := --no-builtin-rules         \
                 --warn-undefined-variables \
                 --no-print-directory

prefix      ?=  /usr/local
BIN          =  makewash


bindir      ?= $(prefix)/bin
destdir     ?=
INSTALL     ?= install -m 0755

.PHONY:\
all
all: $(BIN)

.PHONY:\
install
install: $(BIN)
	mkdir -p $(destdir)$(bindir)
	$(INSTALL) $(BIN) $(destdir)$(bindir)/$(BIN)

uninstall:
	rm -f $(destdir)$(bindir)/$(BIN)

clean:
	@echo '(Nothing to clean)'

.PHONY: unintall clean


# -------------------------- homebrew ------------------------- #

.PHONY:\
install_brew_localformula
install_brew_localformula: $(brewformula)
	brew install -v -d --formula ./$<

.PHONY:\
gen_brewformula
gen_brewformula: $(brewformula)

$(brewformula): repo/gen_brewformula
	mkdir -p $(@D)
	repo/gen_brewformula > $@



# ------------------------- misc; old ------------------------- #

# @brew install --build-from-source --force-bottle --verbose --debug $(brewformula)

# with DESTDIR:
# https://github.com/Distrotech/txt2man/blob/0e09055e925f81c9333ee0a4697970e68a85249a/Makefile
# prefix ?= /usr
# BIN = src2man bookman txt2man
# MAN1 = src2man.1 txt2man.1 bookman.1
#
# all: $(MAN1)
#
# install: $(MAN1)
# 	mkdir -p $(DESTDIR)$(prefix)/bin $(DESTDIR)$(prefix)/share/man/man1
# 	cp $(BIN) $(DESTDIR)$(prefix)/bin/
# 	cp $(MAN1) $(DESTDIR)$(prefix)/share/man/man1

