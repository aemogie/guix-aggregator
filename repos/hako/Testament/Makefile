# SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
#
# SPDX-License-Identifier: CC0-1.0

ARGS  :=
OPTS  := --verbosity=1 $(ARGS)
GUIX  := guix
EMACS := $(GUIX) shell emacs-next-minimal -- emacs

%.scm: %.org
	@$(EMACS) -Q --batch \
	--eval "(require 'ob-tangle)" \
	--eval "(org-babel-tangle-file \"$<\")"

.PHONY: pull
pull:
	$(GUIX) pull --channels=channels.scm $(OPTS)

.PHONY: build
build: build-dorphine build-gokuraku
build-%: config/%.scm
	$(GUIX) system build $< $(OPTS)

.PHONY: deploy
deploy: deploy-dorphine deploy-gokuraku
deploy-%: config/%.scm
	$(GUIX) deploy files/deploy/$(notdir $<) $(OPTS)

.PHONY: authenticate
# Authenticate commits.
authenticate:
	@$(GUIX) git authenticate c5d46fdfdfbc84fe413f1d930049d1f703f9a0ff \
		"F4C2 D1DF 3FDE EA63 D1D3  0776 ACC6 6D09 CA52 8292"

.PHONY: ares
# Start nREPL server for Guile.
# NOTE: Load reader extensions before starting nREPL server.
ares:
	@$(GUIX) shell guile-next guile-ares-rs -- guile -c \
	"(begin \
	   (use-modules (guix gexp) \
	                (gnu home services emacs)) \
	   ((@ (ares server) run-nrepl-server)))"

.PHONY: clean
clean:
	-$(RM) config/*.scm
