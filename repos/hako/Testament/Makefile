# SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
#
# SPDX-License-Identifier: CC0-1.0

ARGS  := --verbosity=1

# Required from host environment.
EMACS := emacs
GUIX  := guix

# Available in guix shell environment, set up direnv to load.
FIND  := find
GIT   := git
GUILD := guild

%.scm: %.org
	@$(EMACS) -Q --batch \
	--eval "(require 'ob-tangle)" \
	--eval "(org-babel-tangle-file \"$<\")"

%.go: %.scm
	$(GUILD) compile --output=$@ $<

load_dirs = \
	external/nonguix \
	external/rosenthal \
	external/sops-guix/modules \
	modules

objects = $(subst .scm,.go,$(shell $(FIND) $(load_dirs) -name '*.scm'))

.PHONY: compile compile-guix
compile: compile-guix $(objects)
compile-guix:
	@[ -x external/guix/scripts/guix ] || \
		(cd external/guix && ./bootstrap && ./configure)
	$(MAKE) -C external/guix --no-print-directory make-go

.PHONY: build
build: build-dorphine build-gokuraku
build-%: config/%.scm compile
	$(GUIX) system build $< $(ARGS)

.PHONY: reconfigure
reconfigure: config/dorphine.scm compile
	$(GUIX) system reconfigure $< $(ARGS)

.PHONY: deploy
deploy: config/gokuraku.scm compile
	$(GUIX) deploy files/blobs/deploy $(ARGS)

.PHONY: ares
# Load reader extensions before starting nREPL server.
ares: compile
	@$(GUIX) shell guile-next guile-ares-rs -- guile -c \
	"(begin \
	   (use-modules (guix gexp) \
	                (gnu home services emacs)) \
	   ((@ (ares server) run-nrepl-server)))"

.PHONY: authenticate
authenticate:
	@$(GUIX) git authenticate c5d46fdfdfbc84fe413f1d930049d1f703f9a0ff \
		"F4C2 D1DF 3FDE EA63 D1D3  0776 ACC6 6D09 CA52 8292"

.PHONY: clean
clean:
	-$(RM) --recursive config/*.scm $(objects)
	$(MAKE) -C external/guix clean
