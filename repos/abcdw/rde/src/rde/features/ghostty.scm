;;; rde --- Reproducible development environment.
;;;
;;; SPDX-FileCopyrightText: 2026 Andrew Tropin <andrew@trop.in>
;;; SPDX-License-Identifier: GPL-3.0-or-later
;;;
;;; This file is part of rde.
;;;
;;; rde is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; rde is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with rde.  If not, see <http://www.gnu.org/licenses/>.

(define-module (rde features ghostty)
  #:use-module (rde features)
  #:use-module (rde features emacs)
  #:use-module (rde packages ghostty)
  #:use-module (rde predicates)

  #:export (feature-ghostty))


;;;
;;; Ghostty.
;;;

(define* (feature-ghostty
          #:key
          (emacs-ghostel emacs-ghostel)
          (ghostel-key "s-t")
          (project-ghostel-key "t"))
  "Configure Ghostty related tooling.

For now, this only configures Ghostel, an Emacs terminal emulator powered by
Ghostty's VT engine."
  (ensure-pred file-like? emacs-ghostel)
  (ensure-pred maybe-string? ghostel-key)
  (ensure-pred maybe-string? project-ghostel-key)

  (define (get-home-services config)
    "Return home services related to Ghostty."
    (require-value 'emacs config)
    (list
     (rde-elisp-configuration-service
      'ghostel
      config
      `((setq ghostel-module-auto-install nil)
        ,@(if ghostel-key
              `((autoload 'ghostel "ghostel" nil t)
                (define-key global-map (kbd ,ghostel-key) 'ghostel))
              '())
        ,@(if (and project-ghostel-key
                   (get-value 'emacs-project config #f))
              `((with-eval-after-load
                 'project
                 (autoload 'ghostel-project "ghostel" nil t)
                 (define-key project-prefix-map
                   (kbd ,project-ghostel-key)
                   'ghostel-project)))
              '()))
      #:elisp-packages (list emacs-ghostel)
      #:summary "Ghostel terminal emulator setup"
      #:commentary "\
Adds Ghostel, the Emacs terminal emulator powered by Ghostty's VT engine.
When `emacs-project' is configured, adds `ghostel-project' to
`project-prefix-map'."
      #:keywords '(convenience terminals))))

  (feature
   (name 'ghostty)
   (values `((ghostty . #t)
             (emacs-ghostel . ,emacs-ghostel)))
   (home-services-getter get-home-services)))
