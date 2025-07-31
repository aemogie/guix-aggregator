(define-module (galahad packages foot foot)
  #:export(foot-files))
(define (foot-files)
  `(
    (".config/foot/foot2.ini" ,(local-file "foot.ini"))))
