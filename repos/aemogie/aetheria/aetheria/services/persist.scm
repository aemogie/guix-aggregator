(define-module (aetheria services persist)
  #:use-module ((srfi srfi-1) #:select (delete
                                        delete-duplicates
                                        concatenate))
  #:use-module ((srfi srfi-26) #:select (cut))
  #:use-module ((guix gexp) #:select (gexp
                                      with-imported-modules
                                      plain-file
                                      file-append))
  #:use-module ((guix records) #:select (match-record-lambda
                                            this-record))
  #:use-module ((gnu packages file-systems) #:select (bindfs))
  #:use-module ((gnu system) #:select (%root-account))
  #:use-module ((gnu system file-systems) #:select (file-system-mount-point
                                                    file-system?))
  #:use-module ((gnu services) #:select (service-type
                                          service-extension
                                          etc-service-type))
  #:use-module ((gnu services configuration) #:select (define-configuration/no-serialization
                                                        list-of-symbols?
                                                        define-maybe/no-serialization
                                                        maybe-value-set?))
  #:use-module ((gnu services base) #:select (file-system-service-type))
  #:use-module ((gnu services shepherd) #:select (shepherd-root-service-type
                                                  shepherd-service))
  #:use-module ((gnu system accounts) #:select (user-account?
                                                user-account-name
                                                user-account-group
                                                user-account-home-directory))
  #:use-module ((aetheria records) #:select (define-record-type2
                                              conflict-strategy
                                              append-strategy))
  #:export (btrfs-file-system
            persist-service-type
            persist-configuration
            persist-configuration-defaults
            efaults
            user-home-persist-service-type))

(define file-system->shepherd-service-name (@@ (gnu services base) file-system->shepherd-service-name))

(define (rooted-path? path)
  (and (string? path) (string-prefix? "/" path)))

(define (file-system-or-path? drive)
  (or (and (file-system? drive) (rooted-path? (file-system-mount-point drive)))
      (rooted-path? drive)))

(define-maybe/no-serialization rooted-path)
(define-maybe/no-serialization file-system-or-path)
(define-maybe/no-serialization user-account)

(define-configuration/no-serialization persist-configuration
  (drive        (maybe-file-system-or-path)
                "The backing store for the persistent files")
  (user         (maybe-user-account)
                "The expected file owner of the persisted path, defaults to root")
  (dest         (rooted-path)
                "The fully qualified path to be persisted")
  (src          (maybe-rooted-path)
                "Optionally configure the internal source locaition within the persistent drive")
  (requirements (list-of-symbols '())
                "Extra shepherd requirements to wait for prior to bind mounting"))

(define-record-type2 persist-configuration-defaults #:fold
  (drive        (merge conflict-strategy))
  (user         (merge conflict-strategy)))

(define persist-shepherd-service
  (match-record-lambda <persist-configuration>
      (drive user dest src requirements)
    (shepherd-service
      (documentation (string-append "persist '" dest "'."))
      (provision (list (symbol-append 'persist- (string->symbol dest))))
      (requirement (append (if (file-system? drive) (list (file-system->shepherd-service-name drive)) '())
                           requirements))
      (start #~(lambda args
                 (define src (string-append #$(if (file-system? drive) (file-system-mount-point drive) drive)
                                            #$(if (maybe-value-set? src) src dest)))
                 ;; dest is not guaranteed relative to root
                 (define dest #$dest)
                 (mkdir-p dest)
                 ;; !! reverse copy up
                 (unless (file-exists? src) (copy-recursively dest src #:keep-mtime? #t #:keep-permissions? #t))
                 ;; then mount it right back down
                 (define ctor
                   (make-forkexec-constructor
                    (list #$(file-append bindfs "/bin/bindfs")
                          (format #f "--force-user=~a" #$(user-account-name user))
                          (format #f "--force-group=~a" #$(user-account-group user))
                          "-f" "-o" "nonempty"
                          src dest)))
                 (ctor args)))
      (stop #~(make-kill-destructor)))))

(define persist-service-type
  (service-type
    (name 'persist)
    (description "Manage whitelisted peristance on an impermenant root filesystem")
    (extensions (list
                 (service-extension file-system-service-type
                                    (lambda (xs) (delete-duplicates (filter file-system? (map persist-configuration-drive xs)))))
                 (service-extension shepherd-root-service-type (cut map persist-shepherd-service <>))
                 (service-extension etc-service-type
                                    (const `(("fuse.conf" ,(plain-file "fuse.conf" "user_allow_other\n")))))))
    (compose concatenate)
    (extend (lambda (_ configurations)
              (define defaults
                (fold-persist-configuration-defaults (filter persist-configuration-defaults? configurations)))
              (map (lambda (cfg)
                     (persist-configuration
                      (inherit cfg)
                      (drive (if (maybe-value-set? (persist-configuration-drive cfg))
                                 (persist-configuration-drive cfg)
                                 (if (unspecified? (persist-configuration-defaults-drive defaults))
                                     "/var/persist"
                                     (persist-configuration-defaults-drive defaults))))
                      (user (if (maybe-value-set? (persist-configuration-user cfg))
                                (persist-configuration-user cfg)
                                (if (unspecified? (persist-configuration-defaults-user defaults))
                                    %root-account
                                    (persist-configuration-defaults-user defaults))))))
                   (append (map (lambda (dest) (persist-configuration (dest dest)))
                                (filter string? configurations))
                           (filter persist-configuration? configurations)))))
    (default-value #f)))
