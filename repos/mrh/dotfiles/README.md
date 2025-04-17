![screenshot](screenshot.png)

# Dotfiles

These are the configuration files for my personal guix + emacs setup.
Feel free to take anything you find helpful and tell me your thoughts!

## Free Software

The most important part of my system is that it uses as much [free
software](https://writefreesoftware.org) as possible, and I encourage
all others to shoot for the same. I also have a fondness for lisp and
hackable systems, hence why I control as much of my computing as
possible through GNU Guix and Emacs. These are (mostly) distinct
computing goals.

My system is not completely free however, as some of my hardware is
completely non-functional without proprietary kernel blobs. I hope that
hardware manufacturers see the cons of this approach, and those that
change would surely have the business of myself and many others.

## Guix

[GNU Guix](https://guix.gnu.org) is a purely functional package manager
and distribution of the GNU sytsem. It is committed to dependability
(unbreakable), hackability, and software freedom. I run Guix System, but
it can also be installed as a standalone package manager on any
GNU/Linux distribution.

My system configurations are split up into a base configuration for all
machines, and multiple machine-specific configs which inherit that base
config. They can be found at `mrh-guix/system`.

My home configurations are similarly machine specific and can be found
at `mrh-guix/home`. Here is where I setup [guix
home](https://guix.gnu.org/manual/en/html_node/Home-Configuration.html)
to manage all of my user level packages, as well as environment
variables and other miscellaneous aspects of my home environment.

Finally, my custom packages which are not (as of writing) available in
the standard guix repo are available as a [guix
channel](https://guix.gnu.org/manual/devel/en/html_node/Channels.html)
at [git.sr.ht/\~mrh/guix-channel](https://git.sr.ht/~mrh/guix-channel).
These include:

- [rivercarro](https://sr.ht/~novakane/rivercarro/): A layout generator
  for river which adds monocle mode and smart gaps

These are available under the `(mrh packages ...)` namespace. To include
my channel in your guix config, add it to your
`~/.config/guix/channels.scm` like so:

``` scheme
(cons* (channel
        (name 'mrh-channel)
        (url "https://git.sr.ht/~mrh/guix-channel")
        (branch "trunk"))
       %default-channels)
```

Remember to run `guix pull` afterwards to refresh your local package
definitions.

## Emacs

[GNU Emacs](https://www.gnu.org/software/emacs) is a text editor and
lisp interpreter designed to maximize hackability and software freedom,
in addition to serving as the primary text editor for the GNU system.

I use emacs for just about everything on my computer other than browsing
the web and consuming audio/visual media. This of course includes
editing source code, but also:

- [AUCTeX](https://www.gnu.org/software/auctex) for writing LaTeX
  documents
- [Dired](https://www.gnu.org/software/emacs/manual/html_node/emacs/Dired.html)
  for browsing files
- [Eshell](https://www.gnu.org/software/emacs/manual/html_mono/eshell.html) +
  [Eat](https://codeberg.org/akib/emacs-eat) + `M-&` for shell/terminal
- [Elfeed](https://github.com/skeeto/elfeed) for RSS
- [ERC](https://www.gnu.org/software/emacs/erc.html) for IRC
- [Geiser](https://www.nongnu.org/geiser/) for Guile Scheme hacking
- [Magit](https://magit.vc/) for git
- [Org Mode](https://orgmode.org/) for so much (including this readme!)
- `M-x proced` to manage system processes
- [Mu4e](https://www.djcbsoftware.nl/code/mu/) for email
- [Sly](https://joaotavora.github.io/sly) for Common Lisp hacking
- [Tramp](https://www.gnu.org/software/tramp/) for remote access

All of my emacs packages are installed and managed via guix home (see
<span class="spurious-link" target="Guix">*Guix*</span> section).

My configuration can be found at `home/dot-config/emacs/init.org`. Note
that my `init.el` is simply the tangled elisp codeblocks from
`init.org`.
