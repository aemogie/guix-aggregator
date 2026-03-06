;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (ice-9 match)
             (guix build utils)
             (guix scripts system))

(match (command-line)
  ((_ dst . args)
   (let* ((output
           (with-output-to-string
             (lambda ()
               (apply guix-system "image" args))))
          (src (string-trim-both output)))
     (when (file-exists? src)
       (mkdir-p (dirname dst))
       (copy-file src dst)
       (make-file-writable dst)))))
