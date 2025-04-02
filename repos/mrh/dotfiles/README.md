![screenshot](screenshot.png)

# Dotfiles

These are the configuration files for my personal guix + emacs setup.
Feel free to take anything you find helpful and tell me your thoughts!

## Free Software

The most important part of my system is that it uses as much [free
software](https://writefreesoftware.org) as possible, and I encourage
all others to shoot for the same. I also have a fondness for lisp and
hackable systems. These are (mostly) distinct computing goals.

My system is not completely free however, as some of my hardware is
completely non-functional without proprietary blobs. I hope that
hardware manufacturers turn away from this habit. Those that
do would surely have the business and admiration of myself and many others.

## Guix

[GNU Guix](https://guix.gnu.org) is a purely functional package manager
and distribution of the GNU sytsem. It is committed to dependability, hackability, and
software freedom. I run Guix System, a fully fledged GNU/Linux distribution, but it can
also be installed as a standalone package manager on top of any GNU/Linux distribution.

My system configurations are split up into a base configuration for all
machines, and machine-specific configs which inherit that base config.
They can be found at `mrh-guix/system`.

My home configurations are similarly machine specific and can be found
at `mrh-guix/home`. Here is where I setup [guix
home](https://guix.gnu.org/manual/en/html_node/Home-Configuration.html)
to manage all of my user level packages, as well as environment
variables and other miscellaneous aspects of my home environment.

Finally, my custom packages which are not (as of writing) available in
the standard guix repo are available as a [guix
channel](https://guix.gnu.org/manual/devel/en/html_node/Channels.html)
at [git.sr.ht/\~mrh/guix-channel](https://git.sr.ht/~mrh/guix-channel).
There you will find instructions for including my channel in your guix config, and an
updated list of packages.

## Emacs

[GNU Emacs](https://www.gnu.org/software/emacs) is a text editor and
lisp environment designed to maximize hackability and software freedom.

I use emacs for just about everything on my computer other than browsing
the web and audio/visual media. This of course includes editing source code, but also:

- [AUCTeX](https://www.gnu.org/software/auctex) for writing LaTeX
  documents
- [Dired](https://www.gnu.org/software/emacs/manual/html_node/emacs/Dired.html)
  for browsing files
- [Eshell](https://www.gnu.org/software/emacs/manual/html_mono/eshell.html) +
  [Eat](https://codeberg.org/akib/emacs-eat) + `M-&` for shell/terminal
- [Elfeed](https://github.com/skeeto/elfeed) for RSS
- [ERC](https://www.gnu.org/software/emacs/erc.html) for IRC
- [Magit](https://magit.vc/) for git
- [Org Mode](https://orgmode.org/) for so much (including this readme!)
- `M-x proced` to manage system processes
- [Mu4e](https://www.djcbsoftware.nl/code/mu/) for email
- [Sly](https://joaotavora.github.io/sly) for Common Lisp hacking
- [Tramp](https://www.gnu.org/software/tramp/) for remote access

All of my emacs packages are installed and managed via guix home (see
<span class="spurious-link" target="Guix">*Guix*</span> section).

My configuration can be found at `dot-config/emacs/config.org`. Note
that my `init.el` merely evaluates all the source code blocks within
`config.org`.
