verbosity ?= 3
AETHERIA_HOST ?= $(shell hostname)
AETHERIA_USER ?= $(shell whoami)
export AETHERIA_HOST
export AETHERIA_USER

# do it twice because guile auto compiles the channel file
# so if the channel definition abi changed we have to compile it again
# it's cached so negligible on performances
guix := guix time-machine -C channels.lock.scm -c $$(nproc) --
sources := $(wildcard aetheria/**/*.scm)
guix_system_options := -v $(verbosity) -c $$(nproc) -L. -e '((@ (aetheria) system-config))'
guix_home_options := -v $(verbosity) -c $$(nproc) -L. -e '((@ (aetheria) home-config))'
export GUILE_AUTO_COMPILE=0

.PHONY: system home geiser-repl --build-dirs update-lockfile system-container home-container run-vm style! clean

system: $(sources) channels.lock.scm
	sudo $(guix) system reconfigure $(guix_system_options)

home: $(sources) channels.lock.scm
	 $(guix) home reconfigure $(guix_home_options)

geiser-repl: --build-dirs
	rm -f build/repl
	$(guix) repl --listen=unix:build/repl

--build-dirs:
	@mkdir -p build/tmp

# would be cool to some day replace this entire makefile with guile scripts
# i could also forego calling into the guix binary
# would have to figure out how to get guix on the load path tho
# but honestly most of these assume you have guix on your PATH,
# so assuming guile load path is pretty much the same i guess
define guile_helpers
(use-modules ((ice-9 pretty-print) #:select (pretty-print)))
(define (write-channel-lock-header)
  (call-with-output-file "build/tmp/channels.lock.scm"
    (lambda (lockfile)
      (display ";; DO NOT MODIFY!" lockfile) (newline lockfile)
      (display ";; instead, make your changes to channels.scm, then run `make update-lockfile`"
               lockfile) (newline lockfile)
      (newline lockfile))))
endef
$(guile $(guile_helpers))
build/tmp/channels.lock.scm: --build-dirs
	$(guile (write-channel-lock-header))
	guix time-machine -C channels.scm -c $$(nproc) -- \
	     describe -f channels >> build/tmp/channels.lock.scm || exit 1

# doesnt depend on channels.scm as you might need to update lockfile without updating channels
update-lockfile: build/tmp/channels.lock.scm
	rm -f channels.lock.scm
	mv build/tmp/channels.lock.scm channels.lock.scm

build/system: $(sources) channels.lock.scm --build-dirs
	$(guix) system build $(guix_system_options) -r"build/tmp/system" || exit 1
	rm -f build/system
	mv build/tmp/system build/system

build/system.img: $(sources) channels.lock.scm --build-dirs
	$(guix) system image -t efi-raw --image-size=8G $(guix_system_options) -r"build/tmp/system.img" || exit 1
	rm -f build/system.img
	mv build/tmp/system.img build/system.img

build/home: $(sources) channels.lock.scm --build-dirs
	$(guix) home build $(guix_home_options) # why no gcroot option?

build/run-container: $(sources) channels.lock.scm --build-dirs
	$(guix) system container $(guix_system_options) -r"build/tmp/run-container" || exit 1
	rm -f build/run-container
	mv build/tmp/run-container build/run-container

system-container: build/run-container
	sudo build/run-container --share="$(shell pwd)=/config"

home-container: $(sources) channels.lock.scm --build-dirs
	$(guix) home container $(guix_home_options)

build/run-vm: $(sources) channels.lock.scm --build-dirs
	$(guix) system vm $(guix_system_options) --full-boot -r"build/tmp/run-vm" || exit 1
	rm -f build/run-vm
	mv build/tmp/run-vm build/run-vm

run-vm: build/run-vm
	build/run-vm

# this makes (define-module #:use-module ((...) #:select (...)))
# ugly as it tries to be smart when it shouldnt
style!: $(sources)
	$(guix) style $(foreach src,$(sources), -f $(src))

define clean_file
@if [ -f $(1) ]; then \
  rm $(1) && echo "clean: removed $(1)" || echo "clean: couldn't remove '$(1)'"; \
elif [ -e $(1) ] && [ ! -f $(1) ]; then \
  echo "clean: warning: $(1) exists but is not a regular file"; \
fi
endef
define clean_link
@if [ -h $(1) ]; then \
  rm $(1) && echo "clean: removed $(1)" || echo "clean: couldn't remove '$(1)'"; \
elif [ -e $(1) ] && [ ! -h $(1) ]; then \
  echo "clean: warning: $(1) exists but is not a symlink"; \
fi
endef
define clean_dir
@if [ -d $(1) ]; then \
  rmdir $(1) && echo "clean: removed $(1)" || echo "clean: couldn't remove '$(1)'"; \
elif [ -e $(1) ] && [ ! -d $(1) ]; then \
  echo "clean: warning: $(1) exists but is not a directory"; \
fi
endef

clean:
	rm -f build/repl
	$(call clean_file,build/tmp/channels.lock.scm)
	$(call clean_link,build/tmp/system)
	$(call clean_link,build/tmp/system.img)
	$(call clean_link,build/tmp/run-vm)
	$(call clean_link,build/tmp/run-container)
	$(call clean_dir,build/tmp/)

	$(call clean_link,build/system)
	$(call clean_link,build/system.img)
	$(call clean_link,build/run-vm)
	$(call clean_link,build/run-container)
	$(call clean_dir,build/)
