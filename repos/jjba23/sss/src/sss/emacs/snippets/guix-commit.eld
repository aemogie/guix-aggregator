;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

text-mode :when (bound-and-true-p git-commit-mode)

(add-guix\ "gnu: Add "
      (p (with-temp-buffer
           (magit-git-wash #'magit-diff-wash-diffs
             "diff" "--staged")
           (goto-char (point-min))
           (when (re-search-forward "\\+(define-public \\(\\S-+\\)"
                                    nil 'noerror)
             (match-string-no-properties 1)))
         var)
      "." n n
      "* " (p (or (car (magit-staged-files)) ""))
      " (" (s var ) "): New variable.")

(remove-guix\ "gnu: Remove "
         (p (with-temp-buffer
              (magit-git-wash #'magit-diff-wash-diffs
                "diff" "--staged")
              (goto-char (point-min))
              (when (re-search-forward "\\-(define-public \\(\\S-+\\)"
                                       nil 'noerror)
                (match-string-no-properties 1)))
            var)
         "." n n
         "* " (p (or (car (magit-staged-files)) ""))
         " (" (s var) "): Delete variable.")

(rename-guix\ "gnu: "
         (p (with-temp-buffer
              (magit-git-wash #'magit-diff-wash-diffs
                "diff" "--staged")
              (beginning-of-buffer)
              (when (search-forward "-(define-public " nil 'noerror)
                (thing-at-point 'sexp 'no-properties)))
            prev-var)
         ": Rename package to "
         (p (with-temp-buffer
              (magit-git-wash #'magit-diff-wash-diffs
                "diff" "--staged")
              (beginning-of-buffer)
              (when (search-forward "+(define-public " nil 'noerror)
                (thing-at-point 'sexp 'no-properties)))
            new-var)
         "." n n
         "* " (p (or (car (magit-staged-files)) "")) " (" (s prev-var) "): "
         "Define in terms of" n
         "'deprecated-package'." n
         "(" (s new-var) "): New variable, formerly known as \""
         (s prev-var) "\".")

(update-guix\ "gnu: "
         (p (with-temp-buffer
              (magit-git-wash #'magit-diff-wash-diffs
                "diff" "--staged")
              (goto-char (point-min))
              (when (re-search-forward "^[ ]*(define-public \\(\\S-+\\)"
                                       nil 'noerror)
                (match-string-no-properties 1)))
            var)
         ": Update to "
         (p (with-temp-buffer
              (magit-git-wash #'magit-diff-wash-diffs
                "diff" "--staged")
              (goto-char (point-min))
              (search-forward "name" nil 'noerror)
              (search-forward "+" nil 'noerror)   ; first change
              (when (and (search-forward "version " nil 'noerror)
                         (looking-at-p "\""))
                (let ((end (save-excursion (search-forward "\")"
                                                           nil 'noerror))))
                  (when end
                    (forward-char)
                    (buffer-substring-no-properties (point) (- end 2))))))
            version)
         "." n n
         "* " (p (or (car (magit-staged-files)) "")) " (" (s var) "): "
         "Update to " (s version) "." n
         (mapconcat (lambda (file) (concat "* " file))
                    (cdr (magit-staged-files))
                    "\n"))

(addcl-guix\ "gnu: Add cl-"
        (p (replace-regexp-in-string
            "^cl-" "" (with-temp-buffer
                        (magit-git-wash #'magit-diff-wash-diffs
                          "diff" "--staged")
                        (beginning-of-buffer)
                        (when (search-forward "+(define-public " nil 'noerror)
                          (replace-regexp-in-string
                           "^sbcl-" ""
                           (thing-at-point 'sexp 'no-properties)))))
           var)
        "." n n
        "* " (p (or (car (magit-staged-files)) ""))
        " (cl-" (s var)
        ", ecl-" (s var)
        ", sbcl-" (s var) "): New variables.")

(https-guix\ "gnu: "
        (p (with-temp-buffer
             (magit-git-wash #'magit-diff-wash-diffs
               "diff" "--staged")
             (goto-char (point-min))
             (when (re-search-forward "^[ ]*(define-public \\(\\S-+\\)"
                                      nil 'noerror)
               (match-string-no-properties 1)))
           var)
        ": Use HTTPS home page." n n
        "* " (p (or (car (magit-staged-files)) ""))
        " (" (s var) ")[home-page]: Use HTTPS."
        n
        (mapconcat (lambda (file) (concat "* " file))
                   (cdr (magit-staged-files))
                   "\n"))

(move-guix\ "gnu: "
       (p (with-temp-buffer
            (magit-git-wash #'magit-diff-wash-diffs
              "diff" "--staged")
            (goto-char (point-min))
            (when (re-search-forward "\\-(define-public \\(\\S-+\\)"
                                     nil 'noerror)
              (match-string-no-properties 1)))
          var)
       ": Move to ("
       (p (with-temp-buffer
            (magit-git-wash #'magit-diff-wash-diffs
              "diff" "--staged")
            (goto-char (point-min))
            (when (and
                   (re-search-forward "\\+(define-public \\(\\S-+\\)"
                                      nil 'noerror)
                   (re-search-backward "modified[ ]*\\(\\S-+\\)"
                                       nil 'noerror))
              (string-replace
               "\.scm" ""
               (string-replace "/" " "
                               (match-string-no-properties 1)))))
          new-module)
       ")." n
       n
       "* " (p (with-temp-buffer
                  (magit-git-wash #'magit-diff-wash-diffs
                    "diff" "--staged")
                  (goto-char (point-min))
                  (when (and
                         (re-search-forward "\\-(define-public \\(\\S-+\\)"
                                            nil 'noerror)
                         (re-search-backward "modified[ ]*\\(\\S-+\\)"
                                             nil 'noerror))
                    (match-string-no-properties 1)))
                source)
       " (" (s var) "): Move from here…" n
       "* " (concat (string-replace " " "/" new-module) ".scm")
       " (" (s var) "): …to here.")
