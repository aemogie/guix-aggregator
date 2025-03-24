(defmethod customize-instance ((browser browser) &key)
  (setf (slot-value browser 'theme) theme:+dark-theme+))
(defmethod customize-instance ((input-buffer input-buffer) &key)
  (disable-modes* 'nyxt/mode/emacs:emacs-mode input-buffer)
  (enable-modes* 'nyxt/mode/vi:vi-normal-mode input-buffer))
(define-configuration (web-buffer prompt-buffer panel-buffer
                       nyxt/mode/editor:editor-buffer)
  ((default-modes (pushnew 'nyxt/mode/emacs:emacs-mode %slot-value%))))
(define-configuration (web-buffer)
  ((default-modes (pushnew 'nyxt/mode/style:dark-mode %slot-value%))))
(define-configuration (web-buffer)
  ((default-modes
    (pushnew 'nyxt/mode/reduce-tracking:reduce-tracking-mode %slot-value%))))
(define-configuration (web-buffer)
  ((default-modes (pushnew 'nyxt/mode/blocker:blocker-mode %slot-value%))))
(define-configuration (web-buffer)
  ((default-modes
    (remove-if (lambda (nyxt::m) (string= (symbol-name nyxt::m) "DARK-MODE"))
               %slot-value%))))
