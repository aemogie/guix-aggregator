(define-module (yggdrasil modules l2md)
  #:use-module ((gnu home services mcron)
                #:select (home-mcron-service-type
                          home-mcron-configuration))
  #:use-module ((gnu home-services mail)
                #:select (home-l2md-service-type
                          home-l2md-configuration
                          l2md-repo))
  #:use-module ((gnu packages mail) #:select (l2md notmuch))
  #:use-module (gnu services)
  #:use-module (guix gexp))

(define (home-services)
  (list
   (service
    home-l2md-service-type
    (home-l2md-configuration
     (oneshot 1)
     (repos
      (list (l2md-repo
             (name "guix-devel")
             (maildir "~/docs/mail/lists/guix-devel")
             (urls "https://yhetil.org/guix-devel/0"))
            (l2md-repo
             (name "guix-patches")
             (maildir "~/docs/mail/lists/guix-patches")
             (urls "https://yhetil.org/guix-patches/1"))
            (l2md-repo
             (name "guix-bugs")
             (maildir "~/docs/mail/lists/guix-bugs")
             (urls "https://yhetil.org/guix-bugs/0"))
            (l2md-repo
             (name "guile-devel")
             (maildir "~/docs/mail/lists/guile-devel")
             (urls "https://yhetil.org/guile-devel/0"))
            (l2md-repo
             (name "guile-user")
             (maildir "~/docs/mail/lists/guile-user")
             (urls "https://yhetil.org/guile-user/0"))
            (l2md-repo
             (name "emacs-devel")
             (maildir "~/docs/mail/lists/emacs-devel")
             (urls "https://yhetil.org/emacs-devel/0"))))))

   (service
    home-mcron-service-type
    (home-mcron-configuration
     (jobs
      (list
       #~(job
          '(next-hour)
          #$(program-file
             "sync-mail.scm"
             #~(begin
                 (system* (string-append #$l2md "/bin/l2md"))
                 (system* (string-append #$notmuch "/bin/notmuch") "new"))))))))))
