
# Table of Contents

-   [What lies here?](#orga443a3b)
    -   [An operating system (OS) configured in Lisp (Guile Scheme)](#orgfefea07)
    -   [Joe's Emacs configuration](#orgf1fdf07)
    -   [Universal session](#orgc1fb820)
-   [Why ?](#org8d0fd8f)
-   [What is Guix](#org7a98d23)
-   [On Non-free software](#orgf3950ee)
-   [Keyboard Terminology](#orga7dfac3)
-   [How this manual works](#orgc05f348)
-   [Customizing SSS](#orgdf35d6d)
-   [Showcase](#orgd26ccff)
-   [Videos about SSS (Supreme Sexp System)](#orgdb4f788)
-   [Bootstrapping](#org48a57f4)
-   [Per host - per-host.scm](#org625ed0b)
    -   [User Management](#org5a88cd3)
    -   [Adding channels](#org08fec0c)
    -   [Installation of SSS](#org2c7a41a)
    -   [Keeping SSS updated](#org3e6b0ae)
    -   [Login managers, and login screen](#org770f1ab)
-   [Nix profile](#orgc8d0070)
-   [Flatpaks](#org41495aa)
-   [System audio](#orgaeddfbd)
-   [Wallpapers](#org2e847c6)
-   [Nyxt browser](#org5df0196)
-   [Git](#orgb88f472)
-   [Disk space](#orgf24a5b8)
-   [Bluetooth](#org93ba2c8)
-   [Virtualization](#orga5dccb5)
-   [Mime types](#org25bfe90)
-   [Troubleshooting FAQ](#orgc1063d4)
-   [WM keybindings](#org903dc37)
    -   [General keybindings](#orgfddb317)
    -   [Application keybindings](#orgcabfcbd)
    -   [More keybindings](#org881a046)
-   [Emacs keybindings](#org40f27e7)
    -   [General non-vanilla bindings](#org6c1a99c)
    -   [SSS specific keybindings](#orgf387b50)
    -   [More bindings](#org7bfc076)
-   [SSS project](#org5a8323e)
-   [Glossary](#orgf46b6b2)
-   [Acronyms](#orgf102177)
-   [Postume: Inheriting an SSS/GNU system](#orgff9e385)
-   [Software engineering](#org7f0fbed)
    -   [Development environments, manifests and flakes](#orgc69dd14)
        -   [Guix and manifests](#orgbe10a1a)
        -   [Nix and flakes](#org3c8dff6)

![img](https://jointhefreeworld.org/static-assets/badges/GNU-Guix-c48702.png) ![img](https://jointhefreeworld.org/static-assets/badges/Scheme-Guile-d0730f.png) ![img](https://jointhefreeworld.org/static-assets/badges/Wayland-Hyprland-6a6aff.png) ![img](https://jointhefreeworld.org/static-assets/badges/Emacs-30-a8516e.png)  ![img](https://jointhefreeworld.org/static-assets/badges/Shell-Fish-2fffb2.png) 

You are reading the manual for the Supreme Sexp System (SSS).

This manual documents the SSS/GNU system and its functionalities.

SSS is a Lisp machine adventure, where the hacking culture is celebrated. Let me help you achieve *GNUrvana*.

If you like my work, please support me by [buying me a cup of coffee](https://bmc.link/jjbigorra) so I can continue with a lot of motivation.

You can follow the project here on Codeberg, or on the fediverse at Mastodon: <https://mastodon.social/@sss_project>

This custom GNU + Linux setup lets you customize everything endlessly, inspires creativity and problem-solving, and gives you a great user experience. This is partly thanks to the REPL (Read Eval Print Loop) and Lisp programming languages.

SSS strives to have all things configured via Lisp dialects when possible and convenient, staying accessible to all kinds of users, and allowing for magical things to happen 🪄.

⚠️ Installing and managing SSS is not meant for people new to GNU/Linux systems. You should already have some experience with software development. Knowing Lisp dialects, or functional programming techniques is also a big help and is something you will learn further.

Refer to the project's code of conduct here: [jointhefreeworld code of conduct](https://jointhefreeworld.org/blog/articles/personal/jointhefreeworld-code-of-conduct/index.html)

![img](https://jointhefreeworld.org/static-assets/sss/dall-e-3-thumb.png)

I would appreciate if you write your findings when using SSS and if you can, fork the project, and contribute some improvements, or mail me at <jjbigorra@gmail.com>

It is recommended to use tagged releases of SSS, as those are considered as stable by the developers.


<a id="orga443a3b"></a>

# What lies here?


<a id="orgfefea07"></a>

## An operating system (OS) configured in Lisp (Guile Scheme)

-   GNU Guix system configuration
-   Hyprland configuration
-   🎨 Theme palettes that affect the entire system (ef-themes, solarized-light, everforest dark and light)
-   Labwc configuration (work-in progress)
-   Fish shell configuration
-   Conky configuration
-   Alacritty terminal emulator
-   Foot terminal emulator
-   Waybar configuration and style
-   Rofi application launcher
-   Mako configuration and style
-   multi-user Git configuration setup (work/personal)
-   Nyxt browser configuration
-   Qutebrowser configuration
-   Fastfetch configuration
-   Multi user configuration
    
    and more&#x2026;.


<a id="orgf1fdf07"></a>

## Joe's Emacs configuration

An operating system unto itself 🐂.

-   Advanced and modular Emacs configurations with Emacs Lisp + Elpaca
-   Dev setup for: Scheme, Scala, Haskell, Lisp, Rust, Python, Shell, Nix, Golang and more


<a id="orgc1fb820"></a>

## Universal session

I also include a (work in progress) Windows-like session for "non-geek" users, with "normal floating windows".
This session uses labwc compositor and waybar.

---


<a id="org8d0fd8f"></a>

# Why ?

Find the divine sayings, and the destined computer configurations, all my Guix, Scheme, Hyprland, and Emacs Lisp and more configurations here for learning you a fully Lisp machine with GNU/Linux for a great good.

⚠️ Warning: parts of the code and settings might default to the Dutch language ( `nl_NL.UTF-8` ).

I refer to SSS lovingly as the modern Lisp machine. With this one obtains a computing style and programming environment that can be referred to as Lisp user space. This is a modern iteration of the Lisp machines of yore.

You can be aware of all the code that is running on your machine, which puts free GNU systems among the most secure operating systems on Earth.

Learning Lisps is really going down a rabbit hole, but trust me, you will come out with a better understanding of programming as a whole out the other end.

Lisp user space provides an introspective, hackable, and transactionable operating system that can be modified live in a REPL.

⭐ The lines between data and code fade, allowing insane flexibility and power.

In some ways this is a laboratory of experimentation for my computing environment. What I do with any other program that forms part of SSS is only meant to work for me. As such, I will try to maintain backwards compatibility and consistency, but I may introduce breaking changes without prior notice.

This configuration is somewhat biased towards containing a `joe` user who also acts as administrator for most of the time. This is trivial to change and should be easy to adapt to your needs. Your mileage may vary (YMMV).

I have a bias towards Emacs-style behaviors and keyboard shortcuts, so most of my preferences in software settings get reflected on SSS, while I do try to make it all configurable.

Some commands in the `Makefile` are more geared towards `joe` since we assume a device is most frequently only tended to by one system administration most of the time. Some examples are `make fr` or `make jr`. Feel free to change this or contribute improvements to make this modular.

The system and home folders of users are managed independently of each other, in quite a loosely coupled manner.


<a id="org7a98d23"></a>

# What is Guix

GNU Guix is a package management tool for and distribution of the GNU system. Guix makes reproducibility easy and allows users to install, upgrade, or remove software packages, to roll back to a previous package set, to build packages from source, and generally assists with the creation and maintenance of software environments.

While you can install GNU Guix on top of an existing GNU/Linux system where it complements the available tools without interference, I encourage the use of Guix system, as standalone operating system distro, on top of which I have built the Supreme Sexp System (SSS).

I highly recommend refering to and studying the Guix reference manual, it's a super valuable source of knowledge: <https://guix.gnu.org/manual/en/html_node/>.


<a id="orgf3950ee"></a>

# On Non-free software

SSS attempts to stay as libre as possible, while also respecting your convenience.

This means, among other things that SSS:

-   includes the OG Linux kernel (with proprietary blobs) so as to be more compatible with modern hardware
-   includes non-guix software channel by default, so as to allow installation of convenient software to which few/no libre alternatives exist.


<a id="orga7dfac3"></a>

# Keyboard Terminology

When keybindings (shortcurts) are defined, the following legend applies (a la Emacs):

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">term</th>
<th scope="col" class="org-left">meaning</th>
</tr>
</thead>
<tbody>
<tr>
<td class="org-left"><code>s</code></td>
<td class="org-left">Super / Windows / CMD key</td>
</tr>

<tr>
<td class="org-left"><code>S</code></td>
<td class="org-left">Shift key</td>
</tr>

<tr>
<td class="org-left"><code>M</code></td>
<td class="org-left">Meta / Alt / Option key</td>
</tr>

<tr>
<td class="org-left"><code>C</code></td>
<td class="org-left">Control key</td>
</tr>

<tr>
<td class="org-left"><code>SPC</code></td>
<td class="org-left">Space key</td>
</tr>
</tbody>
</table>


<a id="orgc05f348"></a>

# How this manual works

This manual is written by hand with care and attention for detail.

I write my documents in Org format from Emacs and export them for your convenience to several other formats. A usual release of the manual happens as follows:

-   Edit the SSS manual
-   Run `C-c # m` from Emacs, which runs lib/sss-manual.el, exporting the Org document to several other formats (LaTEX, PDF, HTML, Markdown, etc.)


<a id="orgdf35d6d"></a>

# Customizing SSS

SSS supports several user customizations via the `per-host.scm` file and others.

I took inspiration from many sources, including several color palettes, inspired by the great \`ef-themes\` by Protesilaos Stavrou  (<https://github.com/protesilaos/ef-themes>).

There are more palettes though, see per-host section for more.

---


<a id="orgd26ccff"></a>

# Showcase

Note: Screenshots below might be outdated and no longer representative of the current, ever-changing state of SSS.

![img](https://jointhefreeworld.org/static-assets/sss/screenshots/2025-03-11.png)

![img](https://jointhefreeworld.org/static-assets/sss/screenshots/2025-03-05-2.png)

![img](https://jointhefreeworld.org/static-assets/sss/screenshots/2025-03-05-3.png)

![img](https://jointhefreeworld.org/static-assets/sss/screenshots/2025-03-05-4.png)

---


<a id="orgdb4f788"></a>

# Videos about SSS (Supreme Sexp System)

Some tutorials, conversations and videos have been made about SSS, some more up to date than others:

<span class="timestamp-wrapper"><span class="timestamp">&lt;2025-03-06 Thu&gt;</span></span>

SSS/GNU - Supreme Sexp System Installation Demo - How to install Joe's riced up Guix system @ virtual machine

<https://youtu.be/wZUes_10US8>

---


<a id="org48a57f4"></a>

# Bootstrapping

It's possible you need to some manual installations, and temporary workarounds, in order to install `sss` on a brand-new Guix installation.

Some aspects will be dependent on the manner of installation and hardware. Below follows a simple startup guide.

**On Hardware Requirements:**

While SSS is designed to be lightweight and efficient, certain hardware
configurations will provide a smoother experience. The following are
recommended minimums:

-   **CPU:** A modern x86-64 processor (Intel or AMD) is preferred. ARM64 is
    supported but may require additional configuration.
-   **RAM:** 4GB of RAM is the absolute minimum. 8GB or more is highly
    recommended for a comfortable experience, especially if you plan to
    run memory-intensive applications or virtual machines.
-   **Disk Space:** 30GB of disk space is a good starting point. Consider
    more if you plan to install a large number of packages, store many
    files, or use virtual machines extensively. SSDs are strongly
    recommended for optimal performance.
-   **Graphics:** SSS leverages Wayland and Hyprland. Most modern graphics cards
    should work well. If you encounter issues, consult the Hyprland
    documentation for compatibility information.

Download and the Guix GNU/Linux distribution from the official Guix page: <https://guix.gnu.org/download/> and make a bootable installation medium convenient for your use case.

If you are not familiar with the `dd` command which is present in all GNU/Linux distributions and in macOS, you can always feel free to use something like Rufus on Windows, or balenaEtcher, to flash this image into a USB, with which you can then boot your computer.

It is highly recommended to first become familiar with SSS and Guix via a *throw-away* virtual machine where you can experiment and do mistakes. After familiarity is acquired then a bare metal installation is the best.

SSS strives to be completely cross-architecture and should work well everywhere. That being said, as of the latest manual, x86-64 is the preferred architecture.

If your system doesn't boot due to lack of drivers, it can be useful to add the `nomodeset` option after `quiet` in the GRUB menu, by editing the boot "command" of the latest entry.

If you are on aarch64/arm64, or other more niche architectures, then you might need to put in some more work to get an installer image, and to get it working, likely having to generate an ISO image yourself to install Guix or a qcow2 virtual machine.

The following articles may be of help:
<https://jointhefreeworld.org/blog/articles/gnu-linux/gnu-guix-virtual-machine-image-aarch64/>

If things really aren't working with your hardware, you can build your own ISO with the right drivers, or use the one from nonguix: <https://gitlab.com/nonguix/nonguix/-/releases>

It is highly recommended to connect your device to Internet via an Ethernet cable or some other form of wired connection, specially since Guix by default will only come with free software drivers, and as such, might not immediately support your WiFi card. After installing SSS drivers will be there and you can use WiFi.

When installing Guix, make sure you take note of the Scheme code that gets generated by it, specially for the disk partitioning. You will see this at the last install step. This code can also be found after installing, at `/etc/config.scm` by default. Parts of this code will later need to be added to the `per-host.scm`.

After having installed things using the guided Guix installer, or via the command line for advanced users, boot into your new system.

I would recommend to then use a web browser and visit the web version of this manual: <https://codeberg.org/jjba23/sss/src/branch/trunk/docs/Manual>.

Once you have a working Guix base installation on your machine, you are ready to go about installing SSS.


<a id="org625ed0b"></a>

# Per host - per-host.scm

It is **REQUIRED** to include a `per-host.scm` in the root of this project, which is excluded from Git, and will determine certain settings for your own machine.
Find here a reference configuration with what is required.

    (use-modules (gnu)
                 (gnu packages))
    
    ;; system language
    (define sss-lang "en_US")
    
    ;; system timezone
    (define sss-timezone "Europe/Amsterdam")
    
    ;; system keyboard layout
    (define sss-keyboard-layout "us")
    
    ;; caps to control enabled
    (define sss-caps-to-ctrl
      #t)
    
    ;; system hostname
    (define sss-hostname "gnusystem")
    
    ;; disk partitioning
    
    ;; mapped devices for advanced configs, by default is empty '()
    ;; check /etc/config.scm after installing Guix and copy, or you know what to do if
    ;; you are a more advanced user
    (define sss-mapped-devices
      (list (mapped-device
             (source (uuid "e84af212-b13b-4163-9165-57bd6f1b787d"))
             (target "rootfs")
             (type luks-device-mapping))))
    
    ;; using mapped device of encrypted btrfs
    (define sss-filesystems
      (list (file-system
             (mount-point "/")
             (device "/dev/mapper/rootfs")
             (type "btrfs")
             (dependencies sss-mapped-devices))
            (file-system
             (device "/dev/nvme0n1p1")
             (mount-point "/boot/efi")
             (type "vfat"))))
    
    ;; alternatively for simple ext4 (legacy configurations)
    ;;  (define sss-filesystems
    ;;    (list (file-system
    ;;           (device "/dev/nvme0n1p3")
    ;;           (mount-point "/")
    ;;           (type "ext4"))
    ;;          (file-system
    ;;           (device "/dev/nvme0n1p1")
    ;;           (mount-point "/boot/efi")
    ;;           (type "vfat"))))
    
    ;; bootloader configuration
    (define sss-bootloader-configuration
      (bootloader-configuration
       (bootloader grub-efi-bootloader)
       (targets '("/boot/efi"))))
    
    ;; packages that should only be installed in the current host
    ;; or (define sss-per-host-packages '())
    (define sss-per-host-packages '(
                                    ;; AMD non-free drivers
                                    "amd-microcode" "amdgpu-firmware"
                                    ;; Games
                                    "prismlauncher" "steam")
      )
    
    ;; location where you cloned SSS Git repository
    (define sss-clone-dir
      "$HOME/hacking/sss")
    
    ;;
    ;; Define the active palette for all users accounts
    ;; You should reconfigure and ideally restart the system
    ;; for all changes to take effect
    ;;
    ;; Note: You could choose on a per-user basis to set a fixed palette
    ;; and not follow system wide, by just redefining this value
    ;;
    ;; Possible values are:
    ;;   - sss-palette-ef-bio
    ;;   - sss-palette-ef-cyprus
    ;;   - sss-palette-ef-dream
    ;;   - sss-palette-heavy-metal
    ;;   - sss-palette-solarized-light
    ;;   - sss-palette-ef-autumn
    ;;   - sss-palette-everforest-dark
    ;;   - sss-palette-everforest-light
    ;;
    (define-public sss-palette
      'sss-palette-ef-dream)
    
    ;; Nix packages to install
    (define-public sss-nixpkgs
      '("yaml-language-server" "bash-language-server"
        "monaspace"
        "jdt-language-server"
        "nil"
        "black"
        "pyright"
        "marksman"
        "_1password-gui"
        "_1password-cli"
        "stack"
        "sbt"
        "scala_2_13"
        "thunderbird"
        "postman"
        "vscode-langservers-extracted"
        "nwg-look"
        "krew"
        "mermaid-cli"
        "jetbrains.idea-community"))
    
    ;; Flatpak remotes to add to the user
    (define sss-flatpak-user-remotes '((flathub . "https://dl.flathub.org/repo/flathub.flatpakrepo")))
    
    ;; Flatpak packages to install
    (define sss-flatpak-pkgs '("app.drey.Warp" "com.usebottles.bottles"))
    
    ;; Additional Labwc startup commands on per-host basis, byt default '() , see example:
    (define sss-labwc-extra-startups
      '("wlr-randr --output eDP-1 --scale 1.5  >/dev/null 2>&1 &"))
    
    ;; Hyprland monitor configurations as a list of strings (lines)
    ;;
    ;; you can have a sensible default like "monitor = , preferred, auto, 1"
    ;; or more detailed config like "monitor=DP-1,1920x1080@144,0x0,1"
    ;; see https://wiki.hyprland.org/hyprland-wiki/pages/Configuring/Monitors/
    ;;
    (define sss-hyprland-monitors
      '("monitor = , preferred, auto, 1"))
    
    ;; Additional Hyprland startup commands on per-host basis, by default '() , see example:
    (define sss-hyprland-extra-startups
      '("sudo warp-svc" "sudo mkdir -p /usr/share/warp/images"
        "sleep 1 && warp-taskbar"))

---


<a id="org5a88cd3"></a>

## User Management

SSS works by programatically define users via code.

You should create users by tweaking the Scheme code (more specifically `system/users.scm` and `lib/sudoers.scm` ) and you should also create a Guix home file (`home/<user>.scm`) if you want to use the home services SSS provides.

When everything is in place, if it's a new user, you can add a password to the user with `sudo passwd <user>`. If this user was created by the Guix install then this will already be done for you.

⚠️ You shouldn't create users manually with `useradd` or the likes, and sudoers should also be managed from Scheme code, not by manually editing `/etc/sudoers`. If you do these things manually, Guix will reset them at next reboot or reconfigure.

---


<a id="org08fec0c"></a>

## Adding channels

Add `nonguix` in your channels file (`$HOME/.config/guix/channels.scm`). This will later be overwritten by SSS.

    (cons* (channel
          (name 'nonguix)
          (url "https://gitlab.com/nonguix/nonguix")
          (introduction
           (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
             "2A39 3FFF 68F4 EF7A 3D29 12AF 6F51 20A0 22FB B2D5"))))
         %default-channels)

After adding the channel, perform a `guix pull` from your user account (**no sudo or root**) and let all channels get updated.


<a id="org2c7a41a"></a>

## Installation of SSS

Once you have followed all those above steps, you can enter a temporary Guix shell, so as to bootstrap SSS.

You can do this with `guix shell make git icecat`. Icecat will be used for you to browse temporarily to Codeberg and download and install SSS.

Then proceed to clone SSS with `git clone https://codeberg.org/jjba23/sss.git` to your favourite location. This location will need to be added to `per-host.scm`.

You should have by now written an appropriate `per-host.scm` for your setup. See the above section on this topic.

Enter the directory of SSS: `cd sss`.

Make sure you place your `per-host.scm` in the root of this directory. Then you can do a `make sr`.

Note: `make sr` translates to `sudo guix system reconfigure config.scm --fallback`.

While unlikely, it's possible that some packages fail to install/build for your setup. I would encourage to temporarily comment those out of the configuration (likely at `system/packages.scm`) and try again. After a working SSS setup, you can uncomment them and try again.

For more commands take a look at the SSS Makefile: <../../Makefile>.

The `fallback` option is optional, and simply helps when upstream substitute (cache) servers are less available.

Once the system reconfigure is complete, you should also bootstrap your user's GNU home with something like: `guix home reconfigure ./home/joe.scm  --fallback`

You might at this point want to reset the font cache for the system and user.

    fc-cache -frv
    sudo fc-cache -frv

You can then reboot and you should be greeted by a simple TTY.

---


<a id="org3e6b0ae"></a>

## Keeping SSS updated

You should every now and then update the SSS repo with `git pull`. You also should regularly do a `guix pull` from your regular user, and then rebuild this system with the root user (`make sr`).

Guix is a rolling distribution and you don't need to be always on bleeding edge releases, but it's nice to stay updated.

---


<a id="org770f1ab"></a>

## Login managers, and login screen

SSS uses **no login managers** like GDM or SDDM. Simply login to the TTY and start your favorite GUI (or not).
That being said, feel free to use your own.

I like to alias my login command to `gui`, or sometimes I directly run `hyprland` or `labwc` from the TTY.

Sometimes for the fun I work in Emacs from the TTY for that 60's and 70's computer vibe.

If you run traditional X11 sessions, you *could* choose to do startx instead of a Wayland session, but SSS is more geared to Wayland.

---


<a id="orgc8d0070"></a>

# Nix profile

Nixpkgs contains a lot of software which we can leverage and manage from Guix.

SSS will automatically install and provide the Nix package manager for you.

SSS also provides some facilities to manage Nix from the comfort of your Guile Scheme.

You might need to activate and link the profile in order to be able to use, for the first time.

Assuming `joe` as user in question.

`/nix/var/nix/profiles/per-user/` should be:

    joe@guixvm ~ λ  ll /nix/var/nix/profiles/per-user/
    
    drwxr-xr-x 2 joe  users  16K 29 dec 23:09 joe/
    drwxr-xr-x 2 root root  4,0K 22 nov 13:23 root/

For this, make the directory an link it to your home.

    sudo mkdir -p /nix/var/nix/profiles/per-user/joe
    sudo chown -R joe:users /nix/var/nix/profiles/per-user/joe
    ln -sfv /nix/var/nix/profiles/per-user/joe/profile $HOME/.nix-profile

It's possible you might need to logout and log back in to re-activate the profile.

You can switch your install to use nixpkgs-unstable with:

    nix-channel --add https://nixos.org/channels/nixpkgs-unstable
    nix-channel --update

You can install Nix packages by running:

    nix -L profile install --impure nixpkgs#package-name

You can keep your Nix packages updated by running:

    NIXPGS_ALLOW_UNFREE=1 nix profile upgrade --impure '.*'

The installed software will be available, for example at: `$HOME/.nix-profile/bin/`

SSS provides some scripts that allow you to maintain your Nix configuration and installed packages programatically with Lisp.

You can find these scripts and the list file at `system/scripts` in this repo and in the Makefile.

Installing all wanted Nix packages can be done with `make npi` for example and updating them with `make npu`.

---


<a id="org41495aa"></a>

# Flatpaks

SSS takes care of flatpak origins and installing and maintaining your flatpaks up to date, all programatically and with Lisp.

You can find these scripts and the list file at `system/scripts` in this repo and in the Makefile.

Installing all wanted Flatpak packages can be done with `make fpi` for example and updating them with `make fpu`.

---


<a id="orgaeddfbd"></a>

# System audio

SSS favors modern technologies and thus makes use of Pipewire for all your GNU/Linux audio needs.

In practice this means that any user account in your system that wants to make use of audio, should have the  `(service home-dbus-service-type)` and `(service home-pipewire-service-type)` services enabled for their account (yes per-user basis).

You will also want to set the `RTC_USE_PIPEWIRE` variable to `true`. This is already the case by default in SSS.

---


<a id="org2e847c6"></a>

# Wallpapers

SSS automatically loads at startup a matching wallpaper for the currently enabled theme.

This is currently done with hyprpaper.

TODO: allow more dynamics and often changing of wallpapers, also random wallpaper script (but within theme)


<a id="org5df0196"></a>

# Nyxt browser

Nyxt is a fantastic web browser, infinitely extensible, and in Emacs-spirit. It is a great fit for SSS.

Find more about Nyxt here: <https://nyxt.atlas.engineer/>

Before you start Nyxt, you need to perform a one-time action so as to allow the SSS Nyxt config to work properly.

What we need is Quicklisp (refer to <https://quicklisp.org> for more details).

You only need to load `quicklisp.lisp` once to install Quicklisp.

Here's an example installation session on SBCL:

    curl -O https://beta.quicklisp.org/quicklisp.lisp
    sbcl --load quicklisp.lisp

You will then, if all went well, be inside a Common Lisp REPL.
Here, all you need to do is type the following commands, each followed by ENTER:

    (quicklisp-quickstart:install)
    (quit)

You are then ready to start the Nyxt browser, all configuration should work well from then on.

---


<a id="orgb88f472"></a>

# Git

Joe's account is automatically configured with a multi-user Git setup. See `lib/git.scm`.
Currently this works on a per-directory basis, and is configured by default to my preferred settings.
TODO: make this more configurable.

My settings are:

-   `$HOME/hacking` is where I keep my personal development projects. These are uploaded to Codeberg, and use their own gitconfig, email address, default git message, GPG key, and SSH keys.
-   `$HOME/work` is where I keep my work projects. These are uploaded to Github, and use their own gitconfig, email address, default git message, GPG key, and SSH keys.

---


<a id="orgf24a5b8"></a>

# Disk space

Reproducibility and isolation of builds naturally leads to a little more disk usage than other systems. This is not a problem nowadays, with cheap storage.

That being said, here follow some useful reminders, every now and then clean:

-   Guix generations
-   Guix store
-   Nix store
-   Unused Steam games

You could run something like this:

    sudo guix system delete-generations 1d
    sudo guix gc
    nix-store --gc

If you'd like to find the largest files in your disk, here’s an example command:  

    du -ah / | sort -rh | head -n 20

---


<a id="org93ba2c8"></a>

# Bluetooth

The real best way to manage your bluetooth is using the bluetoothctl shell. That being said SSS comes with a GUI graphical interface to manage Bluetooth. You can also go low-level, and programatically connect to your devices, setup shortcuts for "favourite" connections, and much more with `bluetoothctl`.

---


<a id="orga5dccb5"></a>

# Virtualization

SSS comes equipped with libvirt and libvirt-manager (the GUI).

I'd recommend for most cases to simply use the GUI to create a new NAT network, and have your VMs be able to connect to the Internet.

If you want two-way traffic, and your machine is connected wirelessly to the network, you won’t be able to use a true network bridge.

In this case, the next best option is to use a virtual bridge with static routing and to configure a libvirt-powered virtual machine to use it (via the virt-manager GUI for example).

---


<a id="org25bfe90"></a>

# Mime types

SSS supports specifying default applications to use for certain files, and also xdg-open, and customize allowed options, all in comfortable Scheme code.

Refer to the `sss mime` module at `lib/` and the `sss-mimeapps-list-file` function to understand more how it works.

    (define-public sss-mime-default-applications
    '((application/pdf org.gnome.Evince icecat)
      (text/html icecat emacsclient)))

The XDG MIME Applications specification builds upon the shared MIME database and desktop entries to provide default applications.

Added Associations indicates that the applications support opening that MIME type.
For example:
bar.desktop and baz.desktop can open JPEG images.
This might affect the application list you see when right-clicking a file in a file browser.

Removed Associations indicates that the applications do not support that MIME type.
For example, baz.desktop cannot open H.264 video.

Default Applications indicates that the applications should be the default choice for opening that MIME type.
For example, JPEG images should be opened with foo.desktop. This implicitly adds an association between the application and the MIME type.
If there are multiple applications, they are tried in order.

At `~/.config/mimeapps.list` you get this:

    [Default Applications]
    application/pdf=evince.desktop;icecat.desktop
    text/html=icecat.desktop;emacsclient.desktop

---


<a id="orgc1063d4"></a>

# Troubleshooting FAQ

Q: I ran out of disk space, and have too much garbage in the system!

A: Check the Makefile of SSS and run a `make full-gc` followed by a `make sr`

---

Q: Grub install fails due to missing disk space / input-output error!

A: It's recommended to delete some old generations of the system (perhaps also a `make full-gc`) and to clean the dump file at: `/sys/firmware/efi/efivars/dump*`

---

Q: I have a strange error, where `guix system reconfigure` or `guix home reconfigure` fails, and some error about ``expected string ~`Derive String(['``! This is also not consistently reproducible and happens in some machines, others not!

A: Sorry, your guix store is partially corrupted. There is some things you can do luckily. First of all backup your important data. Then try to identify the culprit, i.e. the file in the store which is being read and not successfully parsed.

You could first try to do a `sudo guix gc --verify=repair,contents`, but that may not help. If it does then great you are done!
Otherwise try to find a way to disable the dependency on this in your config if possible. Proceed to delete all Guix home generations (except current), after which you should delete all system generations (except current) and do an intensive garbage collection (`make full-gc`).

You can optionally do a `guix pull` now to see if maybe a new version of things comes along and helps. In any case try to `reconfigure` (`make jr` / `make sr`) again and it should work, after which you can turn the "offender" back on.

---

Q: I am unable to generate  a GPG key! I get errors about pin-item or pinentry!

A: Try with `gpg --pinentry-mode loopback --full-gen-key`. Otherwise try other options and check you have the right pinentry programs installed.

---


<a id="org903dc37"></a>

# WM keybindings

Find here the Hyprland keybindings. I usually use these bindings in other WMs too.
Labwc session has a a more windows-like style of bindings.


<a id="orgfddb317"></a>

## General keybindings

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">keybind</th>
<th scope="col" class="org-left">command</th>
</tr>
</thead>
<tbody>
<tr>
<td class="org-left"><code>s-k</code></td>
<td class="org-left">Kill/Close a window or application</td>
</tr>

<tr>
<td class="org-left"><code>s-l</code></td>
<td class="org-left">Lock screen</td>
</tr>

<tr>
<td class="org-left"><code>s-1..9</code></td>
<td class="org-left">Move focus to workspace 1..9</td>
</tr>

<tr>
<td class="org-left"><code>s-S-1..9</code></td>
<td class="org-left">Move window to workspace 1..9</td>
</tr>

<tr>
<td class="org-left"><code>s-v</code></td>
<td class="org-left">Vertical splits</td>
</tr>

<tr>
<td class="org-left"><code>s-h</code></td>
<td class="org-left">Horizontal splits</td>
</tr>

<tr>
<td class="org-left"><code>s-S-SPC</code></td>
<td class="org-left">Toggle floating/tiling mode for window</td>
</tr>

<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
</tr>
</tbody>
</table>


<a id="orgcabfcbd"></a>

## Application keybindings

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">keybind</th>
<th scope="col" class="org-left">command</th>
</tr>
</thead>
<tbody>
<tr>
<td class="org-left"><code>s-/</code></td>
<td class="org-left">Launch application fuzzy finder menu (Rofi)</td>
</tr>

<tr>
<td class="org-left"><code>s-i</code></td>
<td class="org-left">Open a Web Browser (Nyxt)</td>
</tr>

<tr>
<td class="org-left"><code>s-S-i</code></td>
<td class="org-left">Open a bloated Web Browser (Chrome)</td>
</tr>

<tr>
<td class="org-left"><code>s-t</code></td>
<td class="org-left">Open a terminal emulator (Foot)</td>
</tr>

<tr>
<td class="org-left"><code>s-e</code></td>
<td class="org-left">Open text editor (Emacs)</td>
</tr>

<tr>
<td class="org-left"><code>s--</code></td>
<td class="org-left">Open password manager (1password)</td>
</tr>

<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
</tr>
</tbody>
</table>


<a id="org881a046"></a>

## More keybindings

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">keybind</th>
<th scope="col" class="org-left">command</th>
</tr>
</thead>
<tbody>
<tr>
<td class="org-left"><code>s-S-.</code></td>
<td class="org-left"><b>Copy</b> screenshot of entire screen</td>
</tr>

<tr>
<td class="org-left"><code>s-.</code></td>
<td class="org-left"><b>Save</b> screenshot of entire screen</td>
</tr>

<tr>
<td class="org-left"><code>s-S-,</code></td>
<td class="org-left"><b>Copy</b> screenshot of selected area</td>
</tr>

<tr>
<td class="org-left"><code>s-,</code></td>
<td class="org-left"><b>Save</b> screenshot of selected area</td>
</tr>

<tr>
<td class="org-left"><code>s-S-b</code></td>
<td class="org-left">Set wallpaper to theme's default</td>
</tr>
</tbody>
</table>

---


<a id="org40f27e7"></a>

# Emacs keybindings


<a id="org6c1a99c"></a>

## General non-vanilla bindings

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">keybind</th>
<th scope="col" class="org-left">command</th>
</tr>
</thead>
<tbody>
<tr>
<td class="org-left"><code>M-s r</code></td>
<td class="org-left">consult-ripgrep</td>
</tr>

<tr>
<td class="org-left"><code>M-s o</code></td>
<td class="org-left">consult-occur</td>
</tr>

<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
</tr>
</tbody>
</table>


<a id="orgf387b50"></a>

## SSS specific keybindings

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">keybind</th>
<th scope="col" class="org-left">command</th>
</tr>
</thead>
<tbody>
<tr>
<td class="org-left"><code>C-c # s</code></td>
<td class="org-left">Perform a system rebuild</td>
</tr>

<tr>
<td class="org-left"><code>C-c # j</code></td>
<td class="org-left">Perform a user (joe) rebuild</td>
</tr>

<tr>
<td class="org-left"><code>C-c # f</code></td>
<td class="org-left">Perform a system + user (joe) rebuild</td>
</tr>

<tr>
<td class="org-left"><code>C-c # m</code></td>
<td class="org-left">Publish SSS manual locally</td>
</tr>
</tbody>
</table>


<a id="org7bfc076"></a>

## More bindings

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">keybind</th>
<th scope="col" class="org-left">command</th>
<th scope="col" class="org-left">description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="org-left">C-x C-f</td>
<td class="org-left">find-file</td>
<td class="org-left">Open a file.</td>
</tr>

<tr>
<td class="org-left">C-x C-s</td>
<td class="org-left">save-buffer</td>
<td class="org-left">Save the current buffer.</td>
</tr>

<tr>
<td class="org-left">C-x C-w</td>
<td class="org-left">write-file</td>
<td class="org-left">Save the current buffer to a different file.</td>
</tr>

<tr>
<td class="org-left">C-x C-b</td>
<td class="org-left">list-buffers</td>
<td class="org-left">List open buffers.</td>
</tr>

<tr>
<td class="org-left">C-g</td>
<td class="org-left">keyboard-quit</td>
<td class="org-left">Cancel the current command.</td>
</tr>

<tr>
<td class="org-left">C-x k</td>
<td class="org-left">kill-buffer</td>
<td class="org-left">Kill (close) the current buffer.</td>
</tr>

<tr>
<td class="org-left">C-x C-c</td>
<td class="org-left">save-buffers-kill-emacs</td>
<td class="org-left">Save all buffers and exit Emacs.</td>
</tr>

<tr>
<td class="org-left">C-y</td>
<td class="org-left">yank</td>
<td class="org-left">Paste the most recently killed (cut or copied) text.</td>
</tr>

<tr>
<td class="org-left">C-w</td>
<td class="org-left">kill-region</td>
<td class="org-left">Cut the selected region.</td>
</tr>

<tr>
<td class="org-left">M-w</td>
<td class="org-left">kill-ring-save</td>
<td class="org-left">Copy the selected region.</td>
</tr>

<tr>
<td class="org-left">C-k</td>
<td class="org-left">kill-line</td>
<td class="org-left">Cut the text from the cursor to the end of the line.</td>
</tr>

<tr>
<td class="org-left">C-d</td>
<td class="org-left">delete-char</td>
<td class="org-left">Delete the character under the cursor.</td>
</tr>

<tr>
<td class="org-left">C-a</td>
<td class="org-left">beginning-of-line</td>
<td class="org-left">Move the cursor to the beginning of the line.</td>
</tr>

<tr>
<td class="org-left">C-e</td>
<td class="org-left">end-of-line</td>
<td class="org-left">Move the cursor to the end of the line.</td>
</tr>

<tr>
<td class="org-left">C-p</td>
<td class="org-left">previous-line</td>
<td class="org-left">Move the cursor to the previous line.</td>
</tr>

<tr>
<td class="org-left">C-n</td>
<td class="org-left">next-line</td>
<td class="org-left">Move the cursor to the next line.</td>
</tr>

<tr>
<td class="org-left">C-f</td>
<td class="org-left">forward-char</td>
<td class="org-left">Move the cursor forward one character.</td>
</tr>

<tr>
<td class="org-left">C-b</td>
<td class="org-left">backward-char</td>
<td class="org-left">Move the cursor backward one character.</td>
</tr>

<tr>
<td class="org-left">M-f</td>
<td class="org-left">forward-word</td>
<td class="org-left">Move the cursor forward one word.</td>
</tr>

<tr>
<td class="org-left">M-b</td>
<td class="org-left">backward-word</td>
<td class="org-left">Move the cursor backward one word.</td>
</tr>

<tr>
<td class="org-left">C-v</td>
<td class="org-left">scroll-up-command</td>
<td class="org-left">Scroll the buffer up one screen.</td>
</tr>

<tr>
<td class="org-left">M-v</td>
<td class="org-left">scroll-down-command</td>
<td class="org-left">Scroll the buffer down one screen.</td>
</tr>

<tr>
<td class="org-left">C-s</td>
<td class="org-left">isearch-forward</td>
<td class="org-left">Incremental search forward.</td>
</tr>

<tr>
<td class="org-left">C-r</td>
<td class="org-left">isearch-backward</td>
<td class="org-left">Incremental search backward.</td>
</tr>

<tr>
<td class="org-left">M-x</td>
<td class="org-left">execute-extended-command</td>
<td class="org-left">Execute an extended command (by name).</td>
</tr>

<tr>
<td class="org-left">C-h k</td>
<td class="org-left">describe-key</td>
<td class="org-left">Describe a key binding.</td>
</tr>

<tr>
<td class="org-left">C-h f</td>
<td class="org-left">describe-function</td>
<td class="org-left">Describe a function.</td>
</tr>

<tr>
<td class="org-left">C-h v</td>
<td class="org-left">describe-variable</td>
<td class="org-left">Describe a variable.</td>
</tr>

<tr>
<td class="org-left">C-h m</td>
<td class="org-left">describe-mode</td>
<td class="org-left">Describe the current major mode.</td>
</tr>

<tr>
<td class="org-left">C-h i</td>
<td class="org-left">info</td>
<td class="org-left">Open the Emacs Info manual.</td>
</tr>

<tr>
<td class="org-left">C-x 2</td>
<td class="org-left">split-window-below</td>
<td class="org-left">Split the current window horizontally.</td>
</tr>

<tr>
<td class="org-left">C-x 3</td>
<td class="org-left">split-window-right</td>
<td class="org-left">Split the current window vertically.</td>
</tr>

<tr>
<td class="org-left">C-x 0</td>
<td class="org-left">delete-window</td>
<td class="org-left">Delete the current window.</td>
</tr>

<tr>
<td class="org-left">C-x 1</td>
<td class="org-left">delete-other-windows</td>
<td class="org-left">Delete all other windows.</td>
</tr>

<tr>
<td class="org-left">C-x o</td>
<td class="org-left">other-window</td>
<td class="org-left">Switch to the next window.</td>
</tr>

<tr>
<td class="org-left">C-l</td>
<td class="org-left">recenter-top-bottom</td>
<td class="org-left">Recenter the current line in the window.</td>
</tr>

<tr>
<td class="org-left">M-g g</td>
<td class="org-left">goto-line</td>
<td class="org-left">Go to a specific line number.</td>
</tr>

<tr>
<td class="org-left">C-x u</td>
<td class="org-left">undo</td>
<td class="org-left">Undo the last change.</td>
</tr>

<tr>
<td class="org-left">C-/</td>
<td class="org-left">redo</td>
<td class="org-left">Redo the last undone change.</td>
</tr>

<tr>
<td class="org-left">C-j</td>
<td class="org-left">newline</td>
<td class="org-left">Insert a newline.</td>
</tr>

<tr>
<td class="org-left">TAB</td>
<td class="org-left">indent-for-tab-command</td>
<td class="org-left">Indent the current line (or region).</td>
</tr>

<tr>
<td class="org-left">M-TAB</td>
<td class="org-left">completion-at-point</td>
<td class="org-left">Attempt completion at point.</td>
</tr>

<tr>
<td class="org-left">C-t</td>
<td class="org-left">transpose-chars</td>
<td class="org-left">Transpose the characters around point.</td>
</tr>

<tr>
<td class="org-left">M-t</td>
<td class="org-left">transpose-words</td>
<td class="org-left">Transpose the words around point.</td>
</tr>

<tr>
<td class="org-left">C-x C-l</td>
<td class="org-left">downcase-region</td>
<td class="org-left">Convert the selected region to lowercase.</td>
</tr>

<tr>
<td class="org-left">C-x C-u</td>
<td class="org-left">upcase-region</td>
<td class="org-left">Convert the selected region to uppercase.</td>
</tr>

<tr>
<td class="org-left">M-u</td>
<td class="org-left">upcase-word</td>
<td class="org-left">Uppercase the word at point.</td>
</tr>

<tr>
<td class="org-left">M-l</td>
<td class="org-left">downcase-word</td>
<td class="org-left">Lowercase the word at point.</td>
</tr>

<tr>
<td class="org-left">M-c</td>
<td class="org-left">capitalize-word</td>
<td class="org-left">Capitalize the word at point.</td>
</tr>

<tr>
<td class="org-left">C-x h</td>
<td class="org-left">mark-whole-buffer</td>
<td class="org-left">Select the entire buffer.</td>
</tr>

<tr>
<td class="org-left">C-v</td>
<td class="org-left">scroll-down</td>
<td class="org-left">Scroll down in the buffer</td>
</tr>

<tr>
<td class="org-left">M-v</td>
<td class="org-left">scroll-up</td>
<td class="org-left">Scroll up in the buffer</td>
</tr>
</tbody>
</table>

---


<a id="org5a8323e"></a>

# SSS project

Contributing to free software is a uniquely beautiful act because it embodies principles of generosity, collaboration, and empowerment.

We welcome everyone to feel invited to the SSS Project, and encourage active contribution in all forms, to improve it and/or suggest improvements, brainstorm with me, make it more modular/flexible, etc, feel free to contact me <jjbigorra@gmail.com> to chat, discuss or report feedback.

Find here the Backlog and Kanban boards for SSS: <https://lucidplan.jointhefreeworld.org/tickets/sss>

---


<a id="orgf46b6b2"></a>

# Glossary

-   ****GNU/Linux****: A free and open-source operating system combining the GNU system and the Linux kernel.
-   ****Lisp Machine****: A type of computer optimized for running Lisp, a family of programming languages.
-   ****GNU Guix****: A functional package management tool and standalone distribution of the GNU system.
-   ****REPL (Read Eval Print Loop)****: An interactive programming environment for evaluating code and seeing immediate results.
-   ****TTY (TeleTYpewriter)****: A text terminal for interacting with a computer system.
-   ****Scheme****: A Lisp dialect often used for scripting in GNU Guix.
-   ****Wayland****: A protocol for a display server, often used as a modern alternative to X11.
-   ****Hyprland****: A Wayland compositor with great and smooth graphics.
-   ****PipeWire****: A modern multimedia framework for managing audio and video streams.
-   ****Elpaca****: A package manager for Emacs that supports advanced configuration options.
-   ****Libre****: Free and open-source software that respects user freedom.

---


<a id="orgf102177"></a>

# Acronyms

-   ****SSS****: Supreme Sexp System
-   ****GNU****: GNU's Not Unix
-   ****OS****: Operating System
-   ****REPL****: Read Eval Print Loop
-   ****TTY****: TeleTYpewriter
-   ****X11****: The X Window System
-   ****DBus****: Desktop Bus (inter-process communication system)
-   ****RTC****: Real-Time Communication

---


<a id="orgff9e385"></a>

# Postume: Inheriting an SSS/GNU system

While we may not like thinking about these situations, life has an expiry date for us all, and as such we should prepare for a day when we are no more.

Instructions are crucial in this case because the computer systems we posess might hold valuable or sentimental information.

Without guidance, it could be difficult to figure out how to access these computers, specially a somewhat niche setup like SSS.

Our loved ones can hopefully thanks to this section of the manual understand how to use the computer, retrieve important files, or preserve their work.

Firstly, get a hold of as many passwords as you can and account information, before turning on the device.

Proceed to turn on the device. If immediately a password prompt appears, this is likely a system-wide BIOS password, which you will need to unlock to even use the computer.

Choose the boot option for Guix/GNU/Linux if the choice is presented. If multiple options are shown, just press ENTER to choose the default option or use the arrow keys to move around the GRUB boot menu. If the machine struggles to boot, something like Universal Rescue Disk could come in handy.

Once you boot into SSS (Guix + GNU + Linux), you will see a fast succession of letters in a black screen, wait a bit until you see appear something like:

This is the GNU system!
login:

At this point you should type the username of the session you want to log into (generally this is short and all lowercase letters), followed by ENTER.

Then you will get a password prompt. Type the password and press ENTER. Don't worry if you don't see any \* characters for the password, your typing worked, this is just a security measure.

If the details were not correct, you will get prompted to login again.

If they were correct, then you will enter the user's shell, at which point you could type `gui` followed by ENTER to start a graphical user interface. If it doesn't work, try `hyprland` or `labwc`.

You should have then booted into a more familiar environment. If the user you logged into has the Hyprland session, the keyboard bindings are documented in sections above. You could for example use `Super+/` to open the fuzzy application finder (Super is often the "Windows" or "command" key).

Good luck!

---


<a id="org7f0fbed"></a>

# Software engineering


<a id="orgc69dd14"></a>

## Development environments, manifests and flakes

I would encourage that all your software projects have a reproducible build process, and preferably use **Guix** or Nix to declare a `manifest.scm` or `flake.nix`.

This way, and leveraging `direnv` and `.envrc` we can enter in our editor (Emacs, VSCode, IntelliJ&#x2026;) in a reproducible build environment and dependencies.


<a id="orgbe10a1a"></a>

### Guix and manifests

Using Guix is fantastic , and for me it's my first choice to build software with:

    (use-modules (guix packages)
                 (gnu)
                 ;;;
                 ;;; ...
                 ;;;
                 (gnu packages autotools)
                 ((guix licenses)
                  #:prefix license:))
    
    (define-public guile-uuid
      (let ((commit "64002d74025f577e1eeea7bc51218a2c7929631f")
            (revision "0"))
        (package
          (name "guile-uuid")
          (version (git-version "0.0.0" revision commit))
          (source
           (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://codeberg.org/elb/guile-uuid.git")
                   (commit commit)))
             (file-name (git-file-name name version))
             (sha256
              (base32 "1q6dqm2hzq75aa5mrrwgqdml864pdrxc98j7pyj1y0827phnzjfj"))))
          (build-system guile-build-system)
          (native-inputs (list guile-3.0
                               (specification->package "guile-gcrypt")))
          (home-page "https://codeberg.org/elb/guile-uuid")
          (synopsis
           "Guile-UUID is a UUID generation and manipulation module for GNU Guile.")
          (description
           "This package implements RFC 9562 UUIDs, and can generate versions 1 and 3–8 from that specification.
            It provides parsing for UUIDs in standard hex-and-dash format of any variant and version.
            It can also query the variant and version of UUIDs from the RFC.
            Simple routines for converting between binary and hex-and-dash string UUIDs are included.")
          (license license:gpl3+))))
    
    (define-public guile-hygguile
      (let ((commit "4b9989caa65ebacf56c0e48df68f812daf254e71")
            (base32-sha-signature
             "1r5i9fcc4syf4p7xr1b7ml5v93pnkmxn2dy0m1qyvd6y2vbbhxjf")
            (revision "0"))
        (package
          (name "guile-hygguile")
          (version (git-version "0.0.0" revision commit))
          (source
           (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://codeberg.org/jjba23/hygguile.git")
                   (commit commit)))
             (file-name (git-file-name name version))
             (sha256
              (base32 base32-sha-signature))))
          (build-system guile-build-system)
          (native-inputs (list guile-3.0))
          (arguments
           (list
            #:source-directory "src"))
          (home-page "https://codeberg.org/jjba23/hygguile")
          (synopsis
           "SXML and TailwindCSS UI component library for Lisp (Guile Scheme) software projects")
          (description
           "Cozy and professional user-interfaces for everyone.
            SXML and TailwindCSS UI component library for Lisp (Guile Scheme) software projects.
            hygge + guile = hygguile")
          (license license:lgpl3+))))
    
    (packages->manifest (list (specification->package "make")
                              (specification->package "gettext")
                              guile-next
                              guile-uuid
                              guile-ares-rs
                              artanis
                              guile-hygguile
                              guile-dbi
                              guile-dbd-sqlite3))


<a id="org3c8dff6"></a>

### Nix and flakes

Using Nix (and flakes) allows one to quickly spin up and manage multiple reproducible development environments, as well as development shells.

Read more about Nix here: <https://nixos.org/>.

In a nutshell you get a "per project" isolated environment, allowing you to for example seamlessly switch between Scala versions for different projects.

You can search for packages (80k+) here: <https://search.nixos.org/packages>.

With this setup you don't need to install things globally, just on a per project level, allowing more flexibility and reproducibility.

See here how a simple Scala 2.13 development flake looks like.

      {
      inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        systems.url = "github:nix-systems/default";
      };
      outputs = { systems, nixpkgs, ... }:
        let
          eachSystem = f:
            nixpkgs.lib.genAttrs (import systems)
            (system: f nixpkgs.legacyPackages.${system});
        in {
          devShells = eachSystem (pkgs: {
            default = pkgs.mkShell {
              buildInputs = with pkgs; [
                scala_2_13
                jdk21
                metals
                sbt
                scalafmt
                scalafix
                scala-cli
                coursier
              ];
            };
          });
        };
    }

In order to use this flake, you can use direnv: <https://github.com/direnv/direnv> and combine it with a `.envrc` to allow your editor to enter this isolated environment.

Assuming you place the Nix flake above at the root of a repo, at `flake.nix`, you can have a `.envrc` file with the contents:

    use flake

You will then just do a one time `direnv allow` and now your editor will magically load the right env variables and tools from the environment.

