(define-module (misako home-environments look ssh)
  #:use-module (gnu home services ssh)
  #:use-module (misako utils)
  #:export (aur
            github
            codeberg
            sourcehut
            gitlab
            forgejo
            yumiko
            gimai))

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

(define gimai
  (openssh-host
    (name (secret '("ssh" "gimai" "name")))
    (host-name (secret '("ssh" "gimai" "host-name")))
    (user (secret '("ssh" "gimai" "user")))
    (identity-file "~/.ssh/gimai")))
