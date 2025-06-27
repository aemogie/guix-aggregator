# SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
#
# SPDX-License-Identifier: CC0-1.0

ARGS  :=
OPTS  := --keep-going --verbosity=1 $(ARGS)
GUIX  := guix time-machine --channels=channels.lock --
EMACS := $(GUIX) shell emacs-minimal -- emacs

%.scm: %.org
	@$(EMACS) -Q --batch \
	--eval "(require 'ob-tangle)" \
	--eval "(setopt org-babel-load-languages '((shell . t)))" \
	--eval "(setopt org-confirm-babel-evaluate nil)" \
	--eval "(org-babel-tangle-file \"$<\")"

.PHONY: update-channels
update-channels:
	guix time-machine --channels=channels.scm -- \
		describe --format=channels > channels.tmp && \
	mv channels.tmp channels.lock

.PHONY: pull
pull:
	guix pull --channels=channels.lock $(OPTS)

.PHONY: build
build: build-dorphine build-gokuraku
build-%: config/%.scm
	$(GUIX) system build $< $(OPTS)

.PHONY: deploy
deploy: deploy-dorphine deploy-gokuraku
deploy-%: config/%.scm
	$(GUIX) deploy files/deploy/$(notdir $<) $(OPTS)

.PHONY: live
live: live-console live-desktop
live-%: config/live-%.scm
	@mkdir --parents dist
	@cp "$(shell $(GUIX) system image --image-type=iso9660 $< $(OPTS))" \
	"dist/guix-system-$(shell date +%Y%m%d)-$(notdir $(basename $<)).iso"

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
	-$(RM) config/*.scm channels.lock
