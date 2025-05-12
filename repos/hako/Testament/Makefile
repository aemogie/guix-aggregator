# SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
#
# SPDX-License-Identifier: CC0-1.0

ARGS  :=
OPTS  := $(ARGS) --verbosity=1
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

.PHONY: reconfigure
reconfigure: reconfigure-dorphine
reconfigure-%: config/%.scm
	$(GUIX) system reconfigure $< $(OPTS)

.PHONY: home-build
home-build: home-build-dorphine
home-build-%: config/%.scm
	$(GUIX) home build $< $(OPTS)

.PHONY: home-reconfigure
home-reconfigure: home-reconfigure-dorphine
home-reconfigure-%: config/%.scm
	$(GUIX) home reconfigure $< $(OPTS)

.PHONY: deploy
deploy: config/gokuraku.scm
	$(GUIX) deploy files/blobs/deploy $(OPTS)

.PHONY: ares
# Load reader extensions before starting nREPL server.
ares:
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
	-$(RM) config/*.scm
