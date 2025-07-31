(define-module (galahad packages foot files)
  #:use-module (guix gexp)
  #:export(foot-files))
(define (foot-files)
  `(
    (".config/foot/foot.ini" ,(local-file "foot.ini"))))
