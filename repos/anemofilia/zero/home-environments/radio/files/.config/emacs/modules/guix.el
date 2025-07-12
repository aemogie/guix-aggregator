;; -*- lexical-binding: t; -*-

;; radix
(defun radix (dir)
  (lambda ()
    (let* ((radix "~/areas/code/scm/radix")
           (default-directory (concat radix "/radix/" dir "/")))
      (call-interactively 'find-file))))

(defun radix-packages ()
  (interactive)
  (funcall (radix "packages")))

(defun radix-services ()
  (interactive)
  (funcall (radix "services")))

(defun radix-home-services ()
  (interactive)
  (funcall (radix "home/services")))

(defun radix-system ()
  (interactive)
  (funcall (radix "system")))

;; zero
(defun zero (dir)
  (lambda ()
    (interactive)
    (let* ((zero "~/areas/code/scm/zero")
           (default-directory (concat zero "/" dir "/")))
      (call-interactively 'find-file))))

(defun home ()
  (interactive)
  (funcall (zero "home-environments")))

(defun system ()
  (interactive)
  (funcall (zero "operating-systems")))

(defun files ()
  (interactive)
  (funcall (zero "home-environments/radio/files")))

(defun config ()
  (interactive)
  (let* ((default-directory "~/.config/emacs/"))
    (call-interactively 'find-file)))

(defun radio-manifests ()
  (interactive)
  (funcall (zero "home-environments/radio/manifests")))

(defun radio-packages ()
  (interactive)
 (funcall (zero "home-environments/radio/packages")))

(provide 'anemofilia/guix)
