;; -*- lexical-binding: t; -*-

(use-package dirvish
  :config
  (defun dirvish-dotfiles-toggle ()
    (interactive)
    (setq-default dired-listing-switches
                  (let ((switches (split-string dired-listing-switches)))
                    (string-join (if (member "--almost-all" switches)
                                     (remove "--almost-all" switches)
                                   (cons "--almost-all" switches))
                                 " ")))
    (revert-buffer-quick))
  :custom
  ((dired-recursive-deletes 'always)
   (dired-recursive-copies 'always)
   (dired-listing-switches
    "-l --human-readable --group-directories-first --no-group")
   (dirvish-quick-access-entries
    '(("h" "~/"                          "~")
      ("c" "~/.config/"                  "~/areas")
      ("c" "~/.config/"                  "~/.config")
      ("d" "~/media/downloads/"          "~/media/downloads")
      ("m" "~/media/music/"              "~/media/music")
      ("p" "~/media/pictures/"           "~/media/pictures")
      ("v" "~/media/videos/"             "~/media/videos")
      ("z" "~/areas/code/scm/zero/"      "~/areas/code/scm/zero")
      ("x" "~/areas/code/scm/radix/"      "~/areas/code/scm/radix")))
   (dirvish-header-line-format
    '(:left (path)
      :right (free-space)))
   (dirvish-mode-line-format
    '(:left (sort file-time " " file-size symlink)
      :right (omit yank index)))
   (dirvish-attributes
    '(all-the-icons git-msg file-size)))
  :bind (("C-x d" . dirvish)
         :map dirvish-mode-map
         ("h" . dired-up-directory)
         ("l" . dired-view-file)
         ("RET" . dired-view-file)
         ("C-z h" . dirvish-dotfiles-toggle))
  :init (dirvish-override-dired-mode))

(provide 'anemofilia/file-managing)
