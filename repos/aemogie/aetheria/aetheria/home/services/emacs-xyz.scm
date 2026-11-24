(define-module (aetheria home services emacs-xyz)
  #:use-module ((guix gexp) #:select (gexp))
  #:use-module ((srfi srfi-1) #:select (concatenate))
  #:use-module ((gnu services) #:select (service-type
                                          service-extension))
  #:use-module ((gnu packages emacs-xyz) #:select (emacs-vertico
                                                   emacs-marginalia
                                                   emacs-orderless))
  #:use-module ((aetheria home services emacs) #:select (home-emacs-service-type
                                                         home-emacs-configuration))
  #:export (aetheria-home-emacs-ui-service-type))

(define aetheria-home-emacs-ui-service-type
  (service-type
    (name 'aetheria-home-emacs-vertico)
    (description "aetheria emcas vertico configuration")
    (extensions (list (service-extension home-emacs-service-type identity)))
    (compose concatenate)
    (extend cons)
    (default-value
      (home-emacs-configuration
       (extra-packages (list emacs-vertico emacs-marginalia emacs-orderless))
       (extra-code
        (list
         #~(progn
             (vertico-mode 1)
             (vertico-flat-mode 1)
             (marginalia-mode 1)

             (setopt completion-category-overrides '((file . ((styles . (basic partial-completion))))))
             (setopt completion-styles '(orderless basic))
             (setopt default-frame-alist '((font . "Aporetic Sans Mono 13")
                                           (undecorated . t)
                                           (vertical-scroll-bars . nil)))
             (setopt custom-enabled-themes '(modus-vivendi))
             (setopt modus-themes-common-palette-overrides
                     '((bg-mode-line-inactive bg-main)
	               (bg-mode-line-active   bg-main)
	               (bg-dim                bg-main)))
             (setopt max-mini-window-height 1)
             (setopt menu-bar-mode nil)
             (setopt scroll-bar-mode nil)
             (setopt tool-bar-mode nil)
             (setopt tooltip-mode nil)
             (set-default-toplevel-value 'inhibit-startup-screen t))))))))
