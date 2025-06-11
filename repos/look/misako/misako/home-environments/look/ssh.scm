(define-module (misako home-environments look ssh)
  #:use-module (gnu home services ssh)
  #:use-module (misako utils)
  #:export (aur
            github
            codeberg
            sourcehut
            gitlab
            forgejo
            shadow-primary
            shadow-secondary
            yumiko))

(define aur
  (openssh-host
    (name "aur.archlinux.org")
    (host-name "aur.archlinux.org")
    (user "look")
    (identity-file "~/.ssh/aur")))

(define github
  (openssh-host
    (name "github.com")
    (host-name "github.com")
    (user "git")
    (identity-file "~/.ssh/github")))

(define codeberg
  (openssh-host
    (name "codeberg.org")
    (host-name "codeberg.org")
    (user "git")
    (identity-file "~/.ssh/codeberg")))

(define sourcehut
  (openssh-host
    (name "git.sr.ht")
    (host-name "git.sr.ht")
    (user "git")
    (identity-file "~/.ssh/sourcehut")))

(define gitlab
  (openssh-host
    (name "gitlab.com")
    (host-name "gitlab.com")
    (user "git")
    (identity-file "~/.ssh/gitlab")))

(define forgejo
  (openssh-host
    (name "forgejo.yuria")
    (host-name "forgejo.yuria")
    (user "git")
    (identity-file "~/.ssh/codeberg")))

(define yumiko
  (openssh-host
    (name "yumiko.local")
    (host-name "yumiko.local")
    (user "look")
    (identity-file "~/.ssh/look")))

(define shadow-primary
  (openssh-host
    (name (secret '("ssh" "shadow-primary" "name")))
    (host-name (secret '("ssh" "shadow-primary" "host-name")))
    (user (secret '("ssh" "shadow-primary" "user")))
    (port (string->number (secret '("ssh" "shadow-primary" "port"))))
    (identity-file "~/.ssh/shadow")))

(define shadow-secondary
  (openssh-host
    (name (secret '("ssh" "shadow-secondary" "name")))
    (host-name (secret '("ssh" "shadow-secondary" "host-name")))
    (user (secret '("ssh" "shadow-secondary" "user")))
    (port (string->number (secret '("ssh" "shadow-secondary" "port"))))
    (identity-file "~/.ssh/shadow")))
