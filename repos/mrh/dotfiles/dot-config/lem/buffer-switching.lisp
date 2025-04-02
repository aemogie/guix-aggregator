(in-package :lem-user)

;; to skip warnings about re-defining functions
(defmacro continue-from-simple-error (&body body)
  `(handler-bind
       ((simple-error
          (lambda (c)
            (format t "ERROR: ~A~%" c)
            (invoke-restart 'continue))))
     ,@body))

(in-package :lem-core)

(lem-user::continue-from-simple-error
 (defun switch-to-buffer (buffer &optional (record t)
                                           (move-prev-point t)
                                           kill-old-buffer)
   (check-type buffer buffer)
   (when (deleted-buffer-p buffer)
     (editor-error "This buffer has been deleted"))
   (when (or (not-switchable-buffer-p (window-buffer (current-window)))
             (not-switchable-buffer-p buffer)
             (not (window-buffer-switchable-p (current-window))))
     (editor-error "This buffer is not switchable"))
   (let ((old-buffer (current-buffer)))
     (run-hooks *switch-to-buffer-hook* buffer)
     (run-hooks (window-switch-to-buffer-hook (current-window)) buffer)
     (%switch-to-buffer buffer record move-prev-point)
     (when kill-old-buffer 
       (delete-buffer old-buffer)))))

(in-package :lem-core/commands/file)

(lem-user::continue-from-simple-error
  (define-command read-file 
      (filename &optional kill-old-buffer)
      ((:new-file "Read File: "))
    "Open the file as a read-only."
    (when (pathnamep filename)
      (setf filename (namestring filename)))
    (dolist (pathname (expand-files* filename))
      (let ((buffer (find-file-buffer (namestring pathname))))
        (setf (buffer-read-only-p buffer) t)
        (switch-to-buffer buffer t nil kill-old-buffer)))
    t)

  (define-command find-file (arg &optional kill-old-buffer) (:universal)
    "Open the file."
    (let ((*default-external-format* *default-external-format*))
      (let ((filename
              (cond ((and (numberp arg) (= 1 arg))
                     (prompt-for-file
                      "Find File: "
                      :directory (buffer-directory)
                      :default nil
                      :existing nil))
                    ((numberp arg)
                     (setf *default-external-format*
                           (prompt-for-encodings
                            "Encodings: "
                            :history-symbol 'mh-read-file-encodings))
                     (prompt-for-file
                      "Find File: "
                      :directory (buffer-directory)
                      :default nil
                      :existing nil))
                    ((or (pathnamep arg)
                         (uiop:absolute-pathname-p arg))
                     (namestring arg)))))
        (let (buffer)
          (dolist (pathname (expand-files* filename))
            (setf buffer (execute-find-file *find-file-executor*
                                            (get-file-mode pathname)
                                            pathname)))
          (when (bufferp buffer)
            (switch-to-buffer buffer t nil kill-old-buffer)))))))

(in-package :lem-core/commands/window)

(lem-user::continue-from-simple-error
 (define-next-window-command lem-core/commands/file:read-file
   (:new-file "READ File Other Window: " &optional kill-old-buffer)
   "Read a file in another window.")

 (define-next-window-command lem-core/commands/file:find-file
   (:new-file "Find File Other Window: " &optional kill-old-buffer)
   "Open a file in another window. Split the screen vertically if needed."))

(in-package :lem/directory-mode/internal)

(lem-user::continue-from-simple-error
 (defun open-selected-file (&key read-only next-window kill-old-buffer)
   (if read-only
       (process-current-line-pathname 
        (if next-window
            (lambda (file) 
              (read-file-next-window file kill-old-buffer))
            (lambda (file) 
              (read-file file kill-old-buffer))))
       (process-current-line-pathname 
        (if next-window
            (lambda (file) 
              (find-file-next-window file kill-old-buffer))
            (lambda (file) 
              (find-file file kill-old-buffer)))))))

(in-package :lem/directory-mode/commands)

(lem-user::continue-from-simple-error
 (define-command directory-mode-up-directory () ()
   (let ((dir (buffer-directory)))
     (switch-to-buffer
      (directory-buffer (uiop:pathname-parent-directory-pathname
                         (buffer-directory)))
      t t t)
     (search-filename-and-recenter
      (concatenate
       'string
       (car
        (reverse
         (split-sequence:split-sequence
          (uiop:directory-separator-for-host)
          dir
          :remove-empty-subseqs t)))
       (string (uiop:directory-separator-for-host))))))

 (define-command directory-mode-find-file () ()
   (lem/directory-mode/internal:open-selected-file :kill-old-buffer t)))
