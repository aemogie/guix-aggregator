;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025 Hilton Chain <hako@ultrarare.space>

(use-modules (guix gexp)
             (guix modules)
             (guix packages)
             (guix build-system copy)
             (gnu packages linux)
             (gnu packages xorg))

(define %set-keymap-script
  (program-file "set-keymap"
    (with-imported-modules (source-module-closure '((guix build utils)))
      #~(begin
          (use-modules (srfi srfi-1)
                       (srfi srfi-26)
                       (srfi srfi-37)
                       (ice-9 match)
                       (ice-9 popen)
                       (guix build utils))

          (define* (build-keyboard-layout file layout #:optional variant #:key model options)
            (define pipe
              (apply open-pipe* OPEN_READ
                     #$(file-append console-setup "/bin/ckbcomp")
                     (string-append "-I" #$xkeyboard-config "/share/X11/xkb")
                     "-rules" "base"
                     `(,@(if model
                             '("-model" ,model)
                             '())
                       ,layout
                       ,(or variant "")
                       ,(string-join options ","))))
            (mkdir-p (dirname file))
            (call-with-output-file file
              (lambda (output)
                (dump-port pipe output))))

          (define* (set-keyboard-layout layout #:optional variant #:key model options)
            (define file-name
              (port-filename
               (mkstemp "/tmp/console-keymap.XXXXXX")))
            (build-keyboard-layout file-name layout variant #:model model #:options options)
            (invoke "sudo" #$(file-append kbd "/bin/loadkeys") file-name)
            (false-if-exception
             (substitute*
                 (in-vicinity
                  (if (zero? (getuid))
                      "/home/live/.config"
                      (getenv "XDG_CONFIG_HOME"))
                  "niri/config.kdl")
               (("^            (layout|variant|model|options) .*") "")
               (("^        xkb \\{.*" line)
                (string-append
                 line
                 (format             #f "            layout ~s~%"  layout)
                 (if variant (format #f "            variant ~s~%" variant) "")
                 (if model   (format #f "            model ~s~%"   model)   "")
                 (format             #f "            options ~s~%" (string-join options ",")))))))

          (define (show-help-and-exit)
            (display "\
Usage: set-keymap LAYOUT [VARIANT] [-m MODEL] [-o OPTIONS]

OPTIONS are comma-separated e.g. \"ctrl:nocaps,grp:alt_shift_toggle\"

Examples:
set-keymap us
set-keymap us dvorak
set-keymap us dvorak -o ctrl:nocaps\n")
            (quit))

          (define (parse-options)
            (args-fold (cdr (program-arguments))
                       (list (option '(#\m "model") #t #f
                                     (lambda (opt name arg result)
                                       (alist-cons 'model arg result)))
                             (option '(#\o "options") #t #f
                                     (lambda (opt name arg result)
                                       (alist-cons 'options (string-split arg #\,)
                                                   result)))
                             (option '("help") #f #f
                                     (lambda _
                                       (show-help-and-exit))))
                       (lambda (opt name arg loads)
                         (error "Unrecognized option `~A'" name))
                       (lambda (opt loads) (cons opt loads))
                       '()))

          (let* ((opts (parse-options))
                 (model (assoc-ref opts 'model))
                 (options (or (assoc-ref opts 'options) '()))
                 (args (remove pair? (reverse opts))))
            (match args
              ((layout)
               (set-keyboard-layout layout #:model model #:options options))
              ((layout variant)
               (set-keyboard-layout layout variant #:model model #:options options))
              (_
               (show-help-and-exit))))))))

(list (package
        (name "set-keymap")
        (version "0.0.0")
        (source %set-keymap-script)
        (build-system copy-build-system)
        (arguments
         (list
          #:phases
          #~(modify-phases %standard-phases
              (replace 'install
                (lambda _
                  (install-file "set-keymap" (in-vicinity #$output "bin")))))))
        (home-page "")
        (synopsis "")
        (description "")
        (license #f)))
