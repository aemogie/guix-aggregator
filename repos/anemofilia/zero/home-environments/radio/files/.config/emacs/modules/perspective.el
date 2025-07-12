;; -*- lexical-binding: t; -*-

(use-package perspective
  :after (meow)
  :diminish persp-mode
  :hook (kill-emacs . persp-state-save)
  :custom
  (persp-state-default-file (expand-file-name "persp-state.eld" user-emacs-directory))
  :config
  (persp-turn-off-modestring)
  (setq persp-initial-frame-name "α")
  (apply 'meow-normal-define-key
         `(("<escape> n" . persp-switch)
           ("<escape> d" . persp-kill)
           ("<escape> h" . persp-prev)
           ("<escape> l" . persp-next)
           ("<escape> r" . persp-rename)
           ("<escape> <escape>" . ignore)))
  :preface
  (defun anemofilia/load-persp ()
    (when (file-exists-p persp-state-default-file)
      (persp-state-load persp-state-default-file)))
  :init
  (persp-mode 1)
  (anemofilia/load-persp)
  (dolist (persp-name '("α" "β" "γ" "δ" "ε" "ζ" "η"))
    (unless (member persp-name (persp-names))
      (persp-new persp-name))))

(use-package perspective-tabs
  :after (perspective)
  :config
  (defun anemofilia/persp-tab-name (tab)
    (aref (alist-get 'perspective tab) 1))

  (defun anemofilia/persp-tab-buffers (tab)
    (aref (alist-get 'perspective tab) 2))

  (defun anemofilia/persp-tab-occupiedp (tab)
    (let* ((persp-tab-name (anemofilia/persp-tab-name tab))
           (ignored-buffers
            `(,(format "*scratch* (%s)" persp-tab-name)
              "*messages*"
              "*straight-process*"
              "*help*"
              "*Backtrace*")))
      (if (-filter
           (lambda (buffer)
             (not (member (buffer-name buffer)
                          ignored-buffers)))
           (anemofilia/persp-tab-buffers tab))
        t)))

  (defun anemofilia/persp-tab-currentp (tab)
    (eq (car tab) 'current-tab))

  (defun anemofilia/persp-tab-bar-tab-name-format (tab i)
    (let* ((occupied (anemofilia/persp-tab-occupiedp tab))
           (current (anemofilia/persp-tab-currentp tab))
           (base-face-name
            (if current 'tab-bar-tab 'tab-bar-tab-inactive))
           (face-name (intern (format "tab-bar-tab-%d" i)))
           (face (copy-face base-face-name face-name))
           (face-foreground (face-attribute face-name :foreground)))
      (if occupied
          (set-face-attribute face-name nil
                              :overline face-foreground))
      (propertize
       (format " %s " (anemofilia/persp-tab-name tab))
       'face face-name)))
  (setq tab-bar-tab-name-format-function
        #'anemofilia/persp-tab-bar-tab-name-format)

  (defun anemofilia/tab-bar-buffer-format (buffer)
    (let* ((selected-p (eq buffer (window-buffer)))
           (name (buffer-name buffer))
           (face (if selected-p
                     (if (mode-line-window-selected-p)
                         'tab-bar-tab
                       'tab-bar-tab-inactive)
                   'tab-bar-tab-inactive)))
      (propertize (format " %s " name) 'face face)))

  (defun anemofilia/persp-tab-bar-format-current-tab-buffers ()
    (defun relevant-bufferp (buffer)
      (cl-every (lambda (re)
                  (not (string-match re (buffer-name buffer))))
                hidden-persp-buffers))
    (defun sep (n)
      (intern (format "sep-%d" n)))
    (defun tab (n)
      (intern (format "buffer-%d" n)))
    (let ((i 0)
          (j (length (tab-bar-tabs))))
      (mapcan (lambda (buffer)
                (setq i (1+ i))
                `((,(sep (+ i j)) menu-item "" ignore)
                  (,(if (= i 1) 'current-buffer (tab (+ i j))) menu-item
                   ,(anemofilia/tab-bar-buffer-format buffer)
                   (lambda () (interactive) (switch-to-buffer ,buffer)))))
              (-filter #'relevant-bufferp
                       (anemofilia/persp-tab-buffers
                        (seq-find #'anemofilia/persp-tab-currentp
                                  (funcall tab-bar-tabs-function)))))))

  (setq hidden-persp-buffers
        '("\\*which-key\\*"
          "\\*Minibuf-[0-9]+\\*"
          "\\*Echo Area [0-9]+\\*"
          "\\*Backtrace\\*"
          "\\*Messages\\*"))

  (setq tab-bar-format
        '(tab-bar-format-tabs
          tab-bar-separator
          (lambda () (propertize " • " 'face 'tab-bar-tab-inactive))
          anemofilia/persp-tab-bar-format-current-tab-buffers))

  (setq-default tab-bar-show t
                tab-bar-border 10
                tab-bar-separator ""
                tab-bar-close-button nil
                tab-bar-auto-width-max '((20) 20)
                tab-bar-auto-width-min '((20) 20))
  :init (perspective-tabs-mode +1))

(use-package consult
  :after (perspective)
  :config
  (consult-customize consult--source-buffer :hidden t :default nil)
  (add-to-list 'consult-buffer-sources persp-consult-source)
  :bind (("C-x b" . consult-buffer)))

(provide 'anemofilia/perspective)
