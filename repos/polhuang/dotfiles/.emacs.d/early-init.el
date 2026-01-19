;; increase GC threshold during startup (reset in init.el)
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; native compilation settings
(when (featurep 'native-compile)
  (setq native-comp-deferred-compilation t
        native-comp-async-report-warnings-errors nil))

;; UI optimizations - disable unnecessary UI elements early
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; disable startup screen
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; reduce rendering workload during startup
(setq frame-inhibit-implied-resize t)

;;; early-init.el ends here
