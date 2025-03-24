(define-module (aetheria build-system file-like)
  #:use-module ((ice-9 match) #:select (match))
  #:use-module ((guix monads) #:select (return
                                        with-monad
                                        mlet))
  #:use-module ((guix store) #:select (%store-monad))
  #:use-module ((guix gexp) #:select (gexp
                                      lower-object
                                      gexp->derivation
                                      program-file?
                                      program-file-name
                                      with-imported-modules))
  #:use-module ((guix build-system) #:select (bag build-system))
  #:export (raw-build-system
            program-file-build-system))

(define* (build-raw _name _inputs #:key system source target #:allow-other-keys)
  (mlet %store-monad ((obj source))
    (apply lower-object obj system (if target `(#:target ,target) '()))))

;; copied and tweaked from trivial build system
(define* (lower-raw name #:key source inputs native-inputs outputs
                    system target #:rest rest)
  (bag
    (name name)
    (system system)
    (target target)
    (host-inputs inputs)
    (build-inputs native-inputs)
    (outputs outputs)
    (build build-raw)
    (arguments `(#:source ,source #:target ,target))))

(define raw-build-system
  (build-system
    (name 'raw)
    (description "package anything that can be lowered with a <gexp-compiler>")
    (lower lower-raw)))

(define* (lower-program-file name #:key source inputs native-inputs outputs
                             system target #:rest rest)
  (unless (program-file? source) (throw 'not-a-program-file source))
  (define wrapped
    (gexp->derivation
     (program-file-name source) ;; #:system system #:target target
     (with-imported-modules '((guix build utils))
       #~(begin
           (use-modules (guix build utils))
           (mkdir-p (string-append #$output "/bin/"))
           (symlink #$source (string-append #$output "/bin/" #$(program-file-name source)))))))
  (bag
    (name name)
    (system system)
    (target target)
    (host-inputs inputs)
    (build-inputs native-inputs)
    (outputs outputs)
    (build build-raw)
    (arguments `(#:source ,wrapped #:target ,target))))

(define program-file-build-system
  (build-system
    (name 'program-file)
    (description "package a <program-file> into /bin/")
    (lower lower-program-file)))
