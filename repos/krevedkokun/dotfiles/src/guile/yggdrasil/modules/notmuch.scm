(define-module (yggdrasil modules notmuch)
  #:use-module ((gnu home-services mail)
                #:select (home-notmuch-service-type
                          home-notmuch-configuration))
  #:use-module ((gnu packages mail) #:select (notmuch))
  #:use-module (gnu services)
  #:use-module (guix gexp))

(define (home-services)
  (define notmuch-bin (file-append notmuch "/bin/notmuch"))

  (list
   (service
    home-notmuch-service-type
    (home-notmuch-configuration
     (pre-new
      (list
       #~(for-each
          (lambda (args) (apply system* #$notmuch-bin args))
          '(("tag" "-new" "--" "tag:new" "and" "not" "tag:unread")))))
     (post-new
      (list
       #~(for-each
          (lambda (args) (apply system* #$notmuch-bin args))
          '(("tag" "+trash" "--" "path:/.*\\/Trash/")
            ("tag" "+lists" "--" "path:lists/**")
            ("tag" "+work" "--" "path:work/**")
            ("tag" "+guix-devel" "--" "path:lists/guix-devel/**")
            ("tag" "+guix-patches" "--" "path:lists/guix-patches/**")
            ("tag" "+guix-bugs" "--" "path:lists/guix-bugs/**")
            ("tag" "+guile-devel" "--" "path:lists/guile-devel/**")
            ("tag" "+guile-user" "--" "path:lists/guile-user/**")
            ("tag" "+emacs-devel" "--" "path:lists/emacs-devel/**")))))
     (config
      `((user
         ((name . "Nikita Domnitskii")
          (primary_email . "nikita@domnitskii.me")
          (other_email . ,(list (getenv "MIGADU_USER")))))
        (database
         ((mail_root . "docs/mail/")
          (path . "docs/mail/")))
        (maildir
         ((synchronize_flags . true)))
        (new
         ((tags . new)
          (ignore . (.mbsyncstate .uidvalidity))))))))))
