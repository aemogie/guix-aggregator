;;; https://magnus.therning.org/2021-07-23-keeping-todo-items-in-org-roam-v2.html
(require 'org-roam)

(defun org-roam-todo-get-filetags ()
  (split-string (or (org-roam-get-keyword "filetags") "")))

(defun org-roam-todo-add-filetag (tag)
  (let* ((new-tags (cons tag (org-roam-todo-get-filetags)))
         (new-tags-str (combine-and-quote-strings new-tags)))
    (org-roam-set-keyword "filetags" new-tags-str)))

(defun org-roam-todo-del-filetag (tag)
  (let* ((new-tags (seq-difference (org-roam-todo-get-filetags) `(,tag)))
         (new-tags-str (combine-and-quote-strings new-tags)))
    (org-roam-set-keyword "filetags" new-tags-str)))

(defun org-roam-todo-p ()
  "Return non-nil if current buffer has any TODO entry.

TODO entries marked as done are ignored, meaning the this
function returns nil if current buffer contains only completed
tasks."
  (org-element-map
      (org-element-parse-buffer 'headline)
      'headline
    (lambda (h)
      (eq (org-element-property :todo-type h)
          'todo))
    nil 'first-match))

(defun org-roam-todo-update-tag ()
  "Update TODO tag in the current buffer."
  (when (and (not (active-minibuffer-window))
             (org-roam-file-p))
    (org-with-point-at 1
      (let* ((tags (org-roam-todo-get-filetags))
             (is-todo (org-roam-todo-p)))
        (cond ((and is-todo (not (seq-contains-p tags "todo")))
               (org-roam-todo-add-filetag "todo"))
              ((and (not is-todo) (seq-contains-p tags "todo"))
               (org-roam-todo-del-filetag "todo")))))))

(defun org-roam-todo-files ()
  "Return a list of roam files containing todo tag."
  (org-roam-db-sync)
  (let ((todo-nodes (seq-filter (lambda (n)
                                  (seq-contains-p (org-roam-node-tags n) "todo"))
                                (org-roam-node-list))))
    (seq-uniq (seq-map #'org-roam-node-file todo-nodes))))

(defun org-roam-todo-update-files (&rest _)
  "Update the value of `org-agenda-files'."
  (setq org-agenda-files (org-roam-todo-files)))

(provide 'org-roam-todo)
