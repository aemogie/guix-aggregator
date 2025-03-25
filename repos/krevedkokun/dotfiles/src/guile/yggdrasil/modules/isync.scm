(define-module (yggdrasil modules isync)
  #:use-module ((gnu home-services mail)
                #:select (home-isync-service-type
                          home-isync-configuration))
  #:use-module (gnu services)
  #:use-module (guix gexp))

(define (home-services)
  (list
   (service
    home-isync-service-type
    (home-isync-configuration
     (config
      `((IMAPAccount private-remote)
        (Host imap.migadu.com)
        (User ,(getenv "MIGADU_USER"))
        (PassCmd ,(format #f "pass show mail/~a" (getenv "MIGADU_USER")))
        (SSLType IMAPS)
        ,#~""
        (MaildirStore private-local)
        (Path "~/docs/mail/private/")
        (INBOX "~/docs/mail/private/INBOX")
        (SubFolders Verbatim)
        ,#~""
        (IMAPStore private-remote)
        (Account private-remote)
        ,#~""
        (Channel private)
        (Far ":private-remote:")
        (Near ":private-local:")
        (Patterns *)
        (Create Both)
        (Expunge Both)
        ,#~""
        (IMAPAccount public-remote)
        (Host imap.migadu.com)
        (User "nikita@domnitskii.me")
        (PassCmd "pass show mail/nikita@domnitskii.me")
        (SSLType IMAPS)
        ,#~""
        (MaildirStore public-local)
        (Path "~/docs/mail/public/")
        (INBOX "~/docs/mail/public/INBOX")
        (SubFolders Verbatim)
        ,#~""
        (IMAPStore public-remote)
        (Account public-remote)
        ,#~""
        (Channel public)
        (Far ":public-remote:")
        (Near ":public-local:")
        (Patterns *)
        (Create Both)
        (Expunge Both)))))))
