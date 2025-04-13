;; disable Emacs' built-in package manager (in favor of Elpaca)
(setq package-enable-at-startup nil)

;; temporarily increase GC threshold at startup
(setq gc-cons-threshold most-positive-fixnum)

;; restore threshold to normal value after startup
(add-hook 'emacs-startup-hook
          (lambda() (setq gc-cons-threshold (* 50 1024 1024))))

;; hide certain UI elements of Emacs
;; which are not that interesting for power users
;;
;; if you're a beginner, consider setting these to 1
;;
(tool-bar-mode -1) 
(scroll-bar-mode -1) 
(menu-bar-mode -1)

(setq inhibit-startup-message t
      inhibit-startup-screen t)

;; tweak native compilation settings
(setq native-comp-speed 2)
