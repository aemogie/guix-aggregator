;; -*- lexical-binding: t; -*-
(use-package activities
  :config
  ;; Prevent `edebug' default bindings from interfering.
  (setq edebug-inhibit-emacs-lisp-mode-bindings t)

  :bind
  (("C-x C-a C-n" . activities-new)
   ("C-x C-a C-d" . activities-define)
   ("C-x C-a C-a" . activities-resume)
   ("C-x C-a C-s" . activities-suspend)
   ("C-x C-a C-k" . activities-kill)
   ("C-x C-a RET" . activities-switch)
   ("C-x C-a b" . activities-switch-buffer)
   ("C-x C-a g" . activities-revert)
   ("C-x C-a l" . activities-list))
  :hook (after-init . activities-mode))

(use-package perspective
  :after (meow)
  :diminish persp-mode
  :custom
  (persp-initial-frame-name "α")
  (persp-state-default-file
   (expand-file-name "persp-state.eld"
                     user-emacs-directory))
  :preface
  (defun kill-this-buffer-no-prompt ()
    "Kill current buffer without confirmation, even if modified."
    (interactive)
    (set-buffer-modified-p nil)
    (kill-this-buffer))
  :config
  (setq switch-to-prev-buffer-skip
        (lambda (win buff bury-or-kill)
          (not (persp-is-current-buffer buff))))
  (persp-turn-off-modestring)
  (apply 'meow-normal-define-key
         `(("<escape> n" . persp-switch)
           ("<escape> d" . persp-kill)
           ("<escape> H" . persp-prev)
           ("<escape> L" . persp-next)
           ("<escape> r" . persp-rename)
           ("<escape> q" . kill-this-buffer)
           ("<escape> Q" . kill-this-buffer-no-prompt)
           ("<escape> l" . next-buffer)
           ("<escape> h" . previous-buffer)
           ("<escape> <escape>" . ignore)))
  :init
  (persp-mode 1))

(use-package perspective-tabs
  :after (perspective)
  :hook (after-init . anemofilia/perspective-tabs-state-load)
  :preface
  (defun anemofilia/perspective-tabs-state-load ()
    (let ((current-persp-tab-name
           (anemofilia/persp-tab-name (tab-bar--current-tab))))
      (dolist (persp-name '("α" "β" "γ" "δ" "ε" "ζ" "η"))
        (unless (member persp-name (persp-names))
          (persp-activate (persp-new persp-name))))
      (persp-switch current-persp-tab-name)))

  (defun anemofilia/persp-tab-name (persp-tab)
    "Returns the name of PERSP-TAB."
    (aref (alist-get 'perspective persp-tab) 1))

  (defun anemofilia/persp-tab-buffers (persp-tab)
    "Returns a list of all buffers in PERSP-TAB."
    (aref (alist-get 'perspective persp-tab) 2))

  (defun anemofilia/persp-tab-currentp (persp-tab)
    "Returns t if PERSP-TAB is the current perspective tab and
nil otherwise."
    (eq (car persp-tab) 'current-tab))

  (defun ignored-persp-tab-buffers (persp-tab)
    "Returns a list of regular expressions for matching buffers
in PERSP-TAB that should be ignored when determining if the tab
is occupied."
    `(,(format "\\*scratch\\* \\(.*\\)"
               (anemofilia/persp-tab-name persp-tab))
      " \\*which-key\\*" ; which-key
      "Preview:.*"))     ; recentf previews

  (defun hidden-persp-tab-buffers (persp-tab)
    "Returns a list of regular expressions for matching buffers
in PERSP-TAB that should be hidden in the tab-bar buffer list."
    '("\\*which-key\\*"
      "\\*Minibuf-[0-9]+\\*"
      "\\*Echo Area [0-9]+\\*"
      "Preview:.*"))

  (defun anemofilia/persp-tab-occupiedp (persp-tab)
    "Checks whether TAB is occupied with relevant, non-ignored
buffers."
    (cl-some (lambda (buffer)
               (cl-every (lambda (regex)
                           (not (string-match regex (buffer-name buffer))))
                         (ignored-persp-tab-buffers persp-tab)))
            (anemofilia/persp-tab-buffers persp-tab)))

  (defun anemofilia/persp-tab-bar-tab-name-format (persp-tab i)
    (let* ((name (anemofilia/persp-tab-name persp-tab))
           (occupied (anemofilia/persp-tab-occupiedp persp-tab))
           (current (anemofilia/persp-tab-currentp persp-tab))
           (face (intern
                  (format "tab-bar-tab-%sfocused-%s"
                          (if current "" "un")
                          (if occupied "occupied" "empty")))))
      (propertize (format " %s " name) 'face face)))
  (setq tab-bar-tab-name-format-function
        #'anemofilia/persp-tab-bar-tab-name-format)

  (defun anemofilia/tab-bar-buffer-format (buffer)
    (let* ((selected-p (eq buffer (window-buffer)))
           (name (s-truncate 20 (buffer-name buffer)
                             truncate-string-ellipsis))
           (face (if selected-p
                     'tab-bar-tab
                   'tab-bar-tab-inactive)))
      (propertize (format " %s " name) 'face face)))

  (defun anemofilia/persp-tab-bar-format-current-tab-buffers ()
    (defun relevant-bufferp (persp-tab buffer)
      (cl-every (lambda (re)
                  (not (string-match re (buffer-name buffer))))
                (hidden-persp-tab-buffers persp-tab)))
    (let ((i 0)
          (current-persp-tab
           (seq-find #'anemofilia/persp-tab-currentp
                     (funcall tab-bar-tabs-function))))
      (mapcan (lambda (buffer)
                (setq i (1+ i))
                `((,(if (eq buffer (window-buffer))
                        'current-buffer
                      (intern (format "buffer-%d" i)))
                   menu-item
                   ,(anemofilia/tab-bar-buffer-format buffer)
                   (lambda () (interactive) (switch-to-buffer ,buffer)))))
              (-filter (lambda (buffer)
                         (relevant-bufferp current-persp-tab buffer))
                       (anemofilia/persp-tab-buffers current-persp-tab)))))

  :config
  (setq tab-bar-format
        '(tab-bar-format-tabs
          (lambda () (propertize " • " 'face 'tab-bar-tab-inactive))
          anemofilia/persp-tab-bar-format-current-tab-buffers
          (lambda () (propertize " " 'face 'tab-bar))))

  (setq-default tab-bar-show t
                tab-bar-border 10
                tab-bar-separator ""
                tab-bar-close-button nil
                tab-bar-auto-width-max '((20) 20)
                tab-bar-auto-width-min '((20) 20))
  :init (perspective-tabs-mode 1))

(use-package consult
  :after (perspective)
  :config
  (consult-customize consult--source-buffer :hidden t :default nil)
  (add-to-list 'consult-buffer-sources persp-consult-source)
  :bind (("C-x b" . consult-buffer)))

(use-package recentf
  :hook (after-init . recentf-mode))

(provide 'anemofilia/wm)
