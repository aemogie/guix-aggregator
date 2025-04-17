;; suppress warning about following symlinks to vc-controlled dir
(setf vc-follow-symlinks t)
;; workaround initial white flashing (bug?)
(setf default-frame-alist '((background-color . "#000000")
                            (ns-appearance . dark)
                            (ns-transparent-titlebar . t)
                            (alpha-background . 85)))
