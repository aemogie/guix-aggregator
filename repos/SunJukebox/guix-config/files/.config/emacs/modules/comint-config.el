;;; comint-config.el --- Configure comint -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package comint
  :ensure nil ; built-in
  :custom
  ;; Make sure comint's prompt is always read-only. I don't like accidentally
  ;; deleting part of the prompt, that is just confusing.
  (comint-prompt-read-only t)
  ;; Buffer's max size is 2KiB, default 1KiB is a bit small.
  (comint-buffer-maximum-size (* 2 1024)))

(provide 'comint-config)
;;; comint-config.el ends here
