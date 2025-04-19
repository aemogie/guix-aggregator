;; suppress warning about following symlinks to vc-controlled dir
(setf vc-follow-symlinks t)

;; workaround initial white flashing (bug?)
(setf default-frame-alist '((background-color . "#000000")
                            (ns-appearance . dark)
                            (ns-transparent-titlebar . t)
                            (alpha-background . 85)))

;; speed up startup
(defun restore-gc-cons-threshold ()
  (setq gc-cons-threshold 800000
        gc-cons-percentage 0.1))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook #'restore-gc-cons-threshold 105)
