# Makefile - installing and working with sss - Supreme Sexp System

# Copyright © Josep Bigorra <jjbigorra@gmail.com>

# sss is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# sss is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with sss.  If not, see <https://www.gnu.org/licenses/>.

# Commentary:

# Makefile for managing sss - Supreme Sexp System
#
# This Makefile provides commands for configuring and managing the sss system,
# including tasks like system reconfiguration, formatting files, and deploying manuals.

# Code:

.PHONY: update system-reconfigure joe-reconfigure manon-reconfigure \
        format jr fr sr mr fmt full-rebuild nix-profile-upgrade \
        test publish-manual gc store-gc full-gc shepherd-logs npu \
        clone-user-repos install-nix-packages npi deploy install-flatpak-packages

# Constants

DEPLOY_WWW=/srv/http/jointhefreeworld.org

# Logging and notification helper functions

# sss-log-complete: Logs when a target has finished executing.
define sss-log-complete
	@printf "\n\033[1m[INFO] $(shell date --rfc-3339=seconds) - completed work on target %s\033[0m\n" $(1)
endef

# sss-log-starting: Logs when a target starts execution.
define sss-log-starting
	@printf "\n\033[1m[INFO] $(shell date --rfc-3339=seconds) - begin working on target: %s...\033[0m\n" $(1)
endef

# sss-log-info: Logs informational messages in custom format with highlight.
define sss-log-info
	@printf "\n\033[1m[INFO] $(shell date --rfc-3339=seconds) - %s\033[0m\n" $(1)
endef

# sss-notify: Sends success desktop notifications (if available).
define sss-notify-success
	@-fyi -i /run/current-system/profile/share/icons/Yaru/32x32/actions/dialog-yes.png $(1) $(2) >/dev/null 2>&1
endef

# Targets

# update: Updates the Guix system with the latest packages.
update:
	@guix pull

# system-reconfigure: Reconfigures the system using the provided configuration file.
system-reconfigure: format test
	$(call sss-log-starting,"system-reconfigure")
	@sudo guix system reconfigure \
		-L ./per-host -L ./src ./system/config.scm --fallback
	$(call sss-log-complete,"system-reconfigure")
	$(call sss-notify-success,"SSS system-reconfigure complete","task was completed successfully!")
	@-sudo fc-cache -frv

# User reconfigure function
define sss-user-reconfigure
	$(call sss-log-starting,"$(1)-reconfigure")
	@guix home reconfigure -L ./per-host -L ./src ./home/$(1).scm --fallback
	$(call sss-log-complete,"$(1)-reconfigure")
	$(call sss-notify-success,"SSS $(1)-reconfigure complete","task was completed successfully!")
	@-fc-cache -frv &
endef


joe-reconfigure: format test
	$(call sss-user-reconfigure,"joe")
	-hyprctl reload

jr:
	make joe-reconfigure

manon-reconfigure: format test
	$(call sss-user-reconfigure,"manon")
mr:
	make manon-reconfigure


# full-rebuild: Rebuilds the entire system and home environment for Joe.
full-rebuild: format
	$(call sss-log-starting,"full-rebuild")
	@make system-reconfigure
	@make joe-reconfigure
	@make install-flatpak-packages
	@make install-nix-packages
	$(call sss-log-complete,"full-rebuild")

# nix-profile-upgrade: Upgrades Nix packages using a custom Guile script.
nix-profile-upgrade:
	guile --fresh-auto-compile -L ./per-host -L ./src system/scripts/update-nix-packages.scm

# format: Formats Scheme and Emacs Lisp files in the project.
format:
	$(call sss-log-starting,"format")
	@-find ~+ -maxdepth 8 -name "*.scm" -type f -exec guix style -f {} \;
	@-find ~+ -maxdepth 8 -name "*.el" -type f -exec emacs -Q --batch {} \
		-l $(shell realpath ./src/sss/emacs/batch-indent.el) -f indent-file \;
	$(call sss-log-complete,"format")


# Cleans up unused objects in the Guix store.
store-gc:  
	@sudo guix gc

# Performs a full garbage collection across Guix and Nix stores.
full-gc:
	-guix home delete-generations 1d
	-sudo guix system delete-generations 1d
	-sudo guix gc
	-nix-store --gc
	-nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc)"

# Displays the logs for the Shepherd service manager.
shepherd-logs:  
	cat $(HOME)/.local/state/log/shepherd.log

# clone-user-repos: Clones user repositories using a custom script.
clone-user-repos:
	$(call sss-log-info,"Cloning user Git repositories for SSS")
	guile --fresh-auto-compile -L ./per-host -L ./src system/scripts/clone-user-repos.scm

# install-nix-packages: Installs Nix packages using a custom script.
install-nix-packages:
	$(call sss-log-info,"Installing Nix packages for SSS")
	guile --fresh-auto-compile -L ./per-host -L ./src system/scripts/install-nix-packages.scm

# install-flatpak-packages: Installs Flatpak packages using a custom script.
install-flatpak-packages:
	$(call sss-log-info,"Installing Flatpak packages for SSS")
	guile --fresh-auto-compile -L ./per-host -L ./src system/scripts/install-flatpak-packages.scm

# update-flatpak-packages: Updates the system's Flatpak packages
update-flatpak-packages:
	$(call sss-log-info,"Updating Flatpak packages for SSS")
	flatpak update --user -y

# Aliases for common tasks


sr:  # Alias for system-reconfigure
	@make system-reconfigure

fr:  # Alias for full-rebuild
	@make full-rebuild

gc:  # Deletes old generations (1 day or older).
	@sudo guix system delete-generations 1d

npu:  # Alias for nix-profile-upgrade
	@make nix-profile-upgrade

fmt:  # Alias for format
	@make format

npi:  # Installs Nix packages 
	@make install-nix-packages

fpi:  # Installs Flatpak packages
	@make install-flatpak-packages
fpu:  # Updates Flatpak packages
	@make update-flatpak-packages

# deploy: Deploys the manual HTML to a web server directory.
deploy:
	guix shell -m manifest.scm -- emacs -Q --batch \
		--eval '(progn (find-file "$(shell realpath ./docs/manual/en-GB.org)")(org-html-export-to-html)(message "finished publishing SSS manual"))'
	mkdir -pv $(DEPLOY_WWW)/manuals/sss
	rm -rfv $(DEPLOY_WWW)/manuals/sss/index.html
	mv -v docs/manual/en-GB.html $(DEPLOY_WWW)/manuals/sss/index.html

# repl: Start a Guile Scheme development REPL
repl:
	guix shell -m manifest.scm -- guile --fresh-auto-compile \
		-L ./per-host \
		-L ./src \
		-c '((@ (ares server) run-nrepl-server))'

# Unit tests
test:
	$(call sss-log-starting,"test")
	guix shell -m manifest.scm -- guile  --fresh-auto-compile \
		-L ./per-host \
		-L ./src \
		-L ./test \
		-c "((@ (sss test-runners) run-project-tests))"
	$(call sss-log-complete,"test")


full-reset-emacs:
	-pkill emacs
	-pkill emacsclient
	-rm -rf ~/.emacs.d/auto-save-list
	-rm -rf ~/.emacs.d/elpa
	-rm -rf ~/.emacs.d/elpaca
	-rm -rf ~/.emacs.d/history
	-rm -rf ~/.emacs.d/org-roam.db
	-rm -rf ~/.emacs.d/tramp
	-rm -rf ~/.emacs.d/recentf
	-emacs --daemon
