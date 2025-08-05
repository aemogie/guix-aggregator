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
        test gc store-gc full-gc shepherd-logs npu \
        clone-user-repos install-nix-packages npi deploy install-flatpak-packages

DEPLOY_WWW="/srv/http/jointhefreeworld.org"
COPYRIGHT_HOLDERS="Josep Bigorra"
I18N_LOCATION="resources/locale"

LOG_MSG_PREFIX = "\n\033[1m[INFO]["
LOG_MSG_SUFFIX_PRE_MSG = "]"
LOG_END="\033[0m\n"

# G_: translate messages using gettext (i18n)
define G_
	$(shell TEXTDOMAINDIR=./resources/locale TEXTDOMAIN=sss gettext $(1))
endef

define get-date-string
	$(shell date --rfc-3339=seconds)
endef

# sss-log-complete: Logs when a target has finished executing.
define sss-log-complete
	@-echo -e $(LOG_MSG_PREFIX)$(strip $(call get-date-string))$(LOG_MSG_SUFFIX_PRE_MSG) \
		$(strip $(call G_,"Completed work on Make target:")) "$(1)" \
		$(LOG_END)
endef

# sss-log-starting: Logs when a target starts execution.
define sss-log-starting
	@-echo -e $(LOG_MSG_PREFIX)$(strip $(call get-date-string))$(LOG_MSG_SUFFIX_PRE_MSG) \
		$(strip $(call G_,"Begin working on Make target:")) "$(1)" \
		$(LOG_END)
endef

# sss-log-info: Logs informational messages in custom format with highlight.
define sss-log-info
	@-echo -e $(LOG_MSG_PREFIX)$(strip $(call get-date-string))$(LOG_MSG_SUFFIX_PRE_MSG) \
		$(strip $(call G_,$(1))) \
		$(LOG_END)
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
		-L ./per-host -L ./system/packages -L ./src ./system/config.scm --fallback --on-error=backtrace
	$(call sss-log-complete,"system-reconfigure")
	$(call sss-notify-success,"SSS system-reconfigure",$(call G_,"Task was completed successfully!"))
	@-sudo fc-cache -frv >/dev/null 2>&1 &

# User reconfigure function
define sss-user-reconfigure
	$(call sss-log-starting,"$(1)-reconfigure")
	@guix home reconfigure -L ./per-host -L ./src ./home/$(1).scm --fallback
	$(call sss-log-complete,"$(1)-reconfigure")
	$(call sss-notify-success,"SSS $(1)-reconfigure",$(call G_,"Task was completed successfully!"))
	@-fc-cache -frv >/dev/null 2>&1 &
	@-sh $(HOME)/.local/bin/write-gtk-dconf-settings.sh
	@-sh $(HOME)/.local/bin/write-sss-dconf-settings.sh
	@-herd trigger set-random-wallpaper
	@-make document-keybindings-dconf
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
	@guile --fresh-auto-compile -L ./per-host -L ./src system/scripts/update-nix-packages.scm

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
	@guile --fresh-auto-compile -L ./per-host -L ./src system/scripts/clone-user-repos.scm

# install-nix-packages: Installs Nix packages using a custom script.
install-nix-packages:
	$(call sss-log-info,"Installing Nix packages for SSS")
	@guile --fresh-auto-compile -L ./per-host -L ./src system/scripts/install-nix-packages.scm

# install-flatpak-packages: Installs Flatpak packages using a custom script.
install-flatpak-packages:
	$(call sss-log-starting,"install-flatpak-packages")
	@guile --fresh-auto-compile -L ./per-host -L ./src system/scripts/install-flatpak-packages.scm
	$(call sss-log-complete,"install-flatpak-packages")

# update-flatpak-packages: Updates the system's Flatpak packages
update-flatpak-packages:
	$(call sss-log-info,"Updating Flatpak packages for SSS")
	@flatpak update --user -y

# document-keybindings-dconf: Write keybinding documentation to dconf for posterior retrieval.
document-keybindings-dconf:
	$(call sss-log-starting,"document-keybindings-dconf")
	@guile --fresh-auto-compile -L ./per-host -L ./src system/scripts/document-keybindings-dconf.scm
	$(call sss-log-complete,"document-keybindings-dconf")

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
		-L ./system/packages \
		-L ./src \
		-c '((@ (ares server) run-nrepl-server))'

# Unit tests
test: fmt
	$(call sss-log-starting,"test")
	guix shell -m manifest.scm -- \
		guile --fresh-auto-compile \
		-L ./per-host \
		-L ./src \
		-L ./test \
		-c '((@ (veritas runner) run-tests))'
	$(call sss-log-complete,"test")

update-submodules:
	git submodule update --remote --merge


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

# i18n helpers

# Define a function for compiling the translation file (.po) into a machine-readable (.mo) format
# Arguments: $(1) represents the language code (e.g., "en_US", "nl_NL", etc.)
# Use msgfmt to compile the .po file into a .mo file for the specified language
# The output .mo file will be placed in the LC_MESSAGES directory under the language's folder
define sss-msgfmt
	msgfmt -v -o $(I18N_LOCATION)/$(1)/LC_MESSAGES/sss.mo \
		$(I18N_LOCATION)/$(1)/LC_MESSAGES/sss.po
endef

# Define a function to initialize a new translation file from a template (.pot) for a specific language
# Arguments: $(1) represents the language code (e.g., "en_US", "nl_NL", etc.)
# Use msginit to generate a .po file from the .pot template for the specified language
# The -l option sets the language, and --no-translator means no translator is pre-filled in the .po file
# The generated .po file is placed in the LC_MESSAGES directory for the given language
define sss-msginit
	mkdir -p $(I18N_LOCATION)/$(1)/LC_MESSAGES
	msginit -l $(1).UTF8 -o $(I18N_LOCATION)/$(1)/LC_MESSAGES/sss.po \
		-i $(I18N_LOCATION)/sss.pot --no-translator
endef

# Define a function to merge translation updates from the template (.pot) into an existing .po file
# Arguments: $(1) represents the language code (e.g., "en_US", "nl_NL", etc.)
# Use msgmerge to update the specified language's .po file with new translations from the template (.pot)
# The -U flag updates the .po file in place
# This ensures the .po file stays up-to-date with the latest changes in the template
define sss-merge
	msgmerge -U $(I18N_LOCATION)/$(1)/LC_MESSAGES/sss.po \
		$(I18N_LOCATION)/sss.pot 
endef

# Define a function to extract translatable strings from Scheme source files using xgettext
# Arguments: $(1) should be either "--join-existing" for updating template
#   or "" to start from scratch.
# Run xgettext to extract strings marked for translation from Scheme source files
define sss-xgettext
	xgettext --default-domain=sss \
		--output=$(I18N_LOCATION)/sss.pot \
		--language=Scheme \
		--keyword=G_ \
		--sort-by-file $(1) \
		--copyright-holder=$(COPYRIGHT_HOLDERS) \
		--package-name="sss" \
		system/scripts/*.scm \
		system/*.scm \
		src/sss/*.scm \
		src/sss/hyprland/*.scm \
		src/sss/packages/*.scm \
		home/*.scm \
		--from-code UTF-8
endef

# Compile translation files to .mo files
compile-i18n:
	$(call sss-log-info,"Compiling translation files")
	$(call sss-msgfmt,"en_US")
	$(call sss-msgfmt,"nl_NL")
	$(call sss-log-complete,"compile-i18n")

# Create new i18n template from source code
new-i18n:
	$(call sss-log-info,"Creating new i18n template from source code")
	$(call sss-xgettext)

# Update i18n template from source code
join-i18n:
	$(call sss-log-info,"Updating i18n template from source code")
	$(call sss-xgettext,"--join-existing")

# en_US - English language targets
init-i18n-en:
	$(call sss-msginit,"en_US")
merge-i18n-en:
	$(call sss-merge,"en_US")

# nl_NL - Dutch language targets
init-i18n-nl:
	$(call sss-msginit,"nl_NL")
merge-i18n-nl:
	$(call sss-merge,"nl_NL")
