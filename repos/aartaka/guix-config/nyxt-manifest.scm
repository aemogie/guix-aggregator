(use-modules (guix packages)
             (srfi srfi-1)
             (gnu packages aspell)
             (gnu packages base)
             (gnu packages commencement)
             (gnu packages glib)
             (gnu packages lisp)
             (gnu packages lisp-check)
             (gnu packages lisp-xyz)
             (gnu packages gnome)
             (gnu packages gnupg)
             (gnu packages gstreamer)
             (gnu packages gtk)
             (gnu packages pkg-config)
             (gnu packages version-control)
             (gnu packages webkit))

(packages->manifest
 (remove
  (lambda (p)
    (eq? sbcl p))
  (append
   (map second
        (package-inputs
         (load (string-append (getenv "HOME") "/git/nyxt/build-scripts/nyxt.scm"))))
   (list cl-osicat cl-markup glib))))
