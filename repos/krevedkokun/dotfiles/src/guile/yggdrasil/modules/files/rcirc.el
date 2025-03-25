(eval-when-compile (require 'subr-x))
(eval-when-compile (require 'pcase))

(defun kreved--rcirc-get-server-password (server)
  (pcase-let (((map :user-name :port) (map-elt rcirc-server-alist server)))
    (thread-first
      (auth-source-search :host server
                          :user user-name
                          :port port)
      (car)
      (auth-info-password))))

(defun kreved--rcirc-handler-AUTHENTICATE (process _cmd _args _text)
  (rcirc-send-string
   process
   "AUTHENTICATE"
   (base64-encode-string
    (concat "\0" (nth 3 rcirc-connection-info)
            "\0" (rcirc-get-server-password rcirc-server))
    t)))

(defun rcirc-handler-903 (process sender args _text)
  (rcirc-handler-generic process "903" sender args nil)
  (when (not rcirc-finished-sasl)
    (setq-local rcirc-finished-sasl t)
    (rcirc-send-string process "CAP" "END"))
  (rcirc-join-channels-post-auth process))

(with-eval-after-load 'rcirc
  (advice-add 'rcirc-get-server-password :override 'kreved--rcirc-get-server-password)
  (advice-add 'rcirc-handler-AUTHENTICATE :override 'kreved--rcirc-handler-AUTHENTICATE))
