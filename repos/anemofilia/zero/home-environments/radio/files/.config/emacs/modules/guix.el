;; -*- lexical-binding: t; -*-

;; radix
(defun radix (dir)
  (lambda ()
    (let* ((radix "~/areas/code/scm/radix")
           (default-directory (concat radix "/radix/" dir "/")))
      (call-interactively 'find-file))))

(defun radix-packages ()
  "Find files in ~/areas/code/scm/radix/modules/radix/packages."
  (interactive)
  (funcall (radix "packages")))

(defun radix-services ()
  "Find files in ~/areas/code/scm/radix/modules/radix/services."
  (interactive)
  (funcall (radix "services")))

(defun radix-home-services ()
  "Find files in ~/areas/code/scm/radix/modules/radix/home/services."
  (interactive)
  (funcall (radix "home/services")))

(defun radix-system ()
  "Find files in ~/areas/code/scm/radix/modules/radix/system."
  (interactive)
  (funcall (radix "system")))

;; zero
(defun zero (dir)
  (lambda ()
    (interactive)
    (let* ((zero "~/areas/code/scm/zero")
           (default-directory (concat zero "/" dir "/")))
      (call-interactively 'find-file))))

(defun home-environments ()
  "Find files in ~/areas/code/scm/zero/home-environments."
  (interactive)
  (funcall (zero "home-environments")))

(defun operating-systems ()
  "Find files in ~/areas/code/scm/zero/operating-systems."
  (interactive)
  (funcall (zero "operating-systems")))

(defun user-files ()
  "Find files in ~/areas/code/scm/zero/home-environments/(user-login-name)/files."
  (interactive)
  (let* ((user (user-login-name))
         (dir (format "home-environments/%s/files" user)))
    (funcall (zero dir))))

(defun user-emacs-config ()
  "Find files in ~/areas/code/scm/zero/home-environments/radio/files/.config/emacs."
  (interactive)
  (let* ((user (user-login-name))
         (dir (format "home-environments/%s/files/.config/emacs" user)))
    (funcall (zero dir))))

(provide 'anemofilia/guix)
