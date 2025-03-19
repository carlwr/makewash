.SHELLFLAGS   += -u -o pipefail
MAKEFLAGS     := --no-builtin-rules         \
                 --warn-undefined-variables \
                 --no-print-directory

prefix      ?=  /usr/local
bindir      ?= $(prefix)/bin
destdir     ?=
BIN          =  makewash
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

.PHONY:\
  all        \
  install    \
  uninstall  \
  clean


# -------------------------- homebrew ------------------------- #

gen_formula   := repo/gen_brewformula
tap_repourl   := git@github.com:carlwr/homebrew-tap.git
tap_worktree  := .aux/homebrew-tap
brewformula   := $(tap_worktree)/Formula/makewash.rb


brew-update-tap       :  brew-tap-tree-fetched $(brewformula)
brew-tap-tree-fetched :  brew-tap-tree-exists
brew-tap-tree-exists  :| $(tap_worktree)
$(brewformula)        :  brew-tap-tree-fetched $(gen_formula)


brew-update-tap: msg = '(makewash.rb): update'
brew-update-tap:
	# $@:
	git -C $(tap_worktree) add ./Formula/makewash.rb
	git -C $(tap_worktree) commit -m $(msg)
	# NOTE: pushing with --dry-run:
	git -C $(tap_worktree) push --dry-run
	@echo

brew-tap-tree-fetched:
	# $@:
	git -C $(tap_worktree) fetch
	@echo

$(tap_worktree):
	# $@:
	git clone $(tap_repourl) $@
	@echo

$(brewformula): name  = Makewash
$(brewformula): desc != ./makewash -_h | grep -om1 "\- .*" | sed 's/- //'
$(brewformula): page  = https://github.com/carlwr/makewash
$(brewformula): vers  = 1.001
$(brewformula): repo  = https://github.com/carlwr/makewash.git
$(brewformula): brch  = main
$(brewformula):
	# $@:
	[ -d $(@D) ]
	name='$(name)' \
	desc='$(desc)' \
	page='$(page)' \
	vers='$(vers)' \
	repo='$(repo)' \
	brch='$(brch)' \
	  $(gen_formula) > $@
	@echo

brew-clean:
	rm -rf .aux/

.PHONY:\
  brew-update-tap        \
  brew-tap-tree-fetched  \
  brew-tap-tree-exists   \
  brew-clean
