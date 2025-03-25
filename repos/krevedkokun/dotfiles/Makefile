channels-lock.scm: channels.scm
	guix time-machine -C channels.scm \
	-- describe -f channels > channels-lock.scm

target/env:
	mkdir -p target/env

target/env/guix: target/env channels-lock.scm
	guix pull -C channels-lock.scm \
	-p $@

target/guix-time-marker: channels-lock.scm
	$(MAKE) target/env/guix
	touch $@

guix: target/guix-time-marker

GUIX=target/env/guix/bin/guix

clean:
	rm -rf target

target/env/guile: target/env guix
	rm -f target/env/tmp-env
	$(GUIX) shell guile-next guile-ares-rs \
	-r target/env/tmp-env --search-paths > /dev/null
	mv -fT target/env/tmp-env $@
	echo 'source $@/etc/profile && exec "$$@"' > target/$(@F)-env
	chmod +x target/$(@F)-env

GUILE=target/guile-env guile

repl: guix target/env/guile
	$(GUILE) \
	-L target/env/guix/share/guile/site/3.0/ \
	-L src/guile \
	-c "((@ (nrepl server) run-nrepl-server) #:port 7888)"

yggdrasil/configurations/%.scm: TARGET := home
yggdrasil/configurations/%.scm: guix
	$(GUIX) $(TARGET) reconfigure \
	--substitute-urls='https://substitutes.nonguix.org https://ci.guix.gnu.org' \
	-L src/guile \
	-e "((@ (yggdrasil configurations $(basename $(@F))) make-config) '$(TARGET))"
