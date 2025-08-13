;;; SPDX-FileCopyrightText: 2023, 2024, 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (srfi srfi-1)
             (srfi srfi-26)
             (ice-9 match)
             (ice-9 popen)
             (ice-9 textual-ports)
             (guix diagnostics)
             (guix i18n)
             (guix store)
             (nonguix transformations)
             (rosenthal)
             (sops secrets))

(define %guix-authorized-key-dorphine
  (plain-file "dorphine.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #A279175682D0DAE3E11268E67E1F3FA47C38D7E509F7725567CF891E248E719F#)))"))

(define %guix-authorized-key-gokuraku
  (plain-file "gokuraku.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #374EC58F5F2EC0412431723AF2D527AD626B049D657B5633AAAEBC694F3E33F9#)))"))

(define %guix-authorized-key-ignamma
  (plain-file "ignamma.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #6FEEB15C4363F9975EB15C908EC911A4362E486DA642431FA2438C0B1C3D55F5#)))"))

(define %hako-guix-authorized-keys-lan
  (list %guix-authorized-key-dorphine
        %guix-authorized-key-gokuraku

        %guix-authorized-key-ignamma))

;; Managed by Zheng Junjie.
(define %guix-authorized-key-sin
  (plain-file "sin.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #CC7E2CD7CA12B6CB9A822C0BFD14E2D7347FF6B96CB1D796513A813F07475B20#)))"))

(define %hako-guix-authorized-keys-head
  (list %guix-authorized-key-dorphine
        %guix-authorized-key-gokuraku

        %guix-authorized-key-ignamma
        %guix-authorized-key-sin))


;; Source: <https://wiki.archlinux.org/title/XDG_Base_Directory>
(define %testament-xdg-base-directory-env-vars
  '(;; bash
    ("HISTFILE" . "$XDG_STATE_HOME/bash/history")
    ;; gdb
    ("GDBHISTFILE" . "$XDG_STATE_HOME/gdb/history")
    ;; go
    ("GOMODCACHE" . "$XDG_CACHE_HOME/go/mod")
    ("GOPATH" . "$XDG_DATA_HOME/go")
    ;; guile
    ("GUILE_HISTORY" . "$XDG_STATE_HOME/guile/history")
    ;; node
    ("NPM_CONFIG_USERCONFIG" . "$XDG_CONFIG_HOME/npm/npmrc")
    ;; nvidia-driver
    ("CUDA_CACHE_PATH" . "$XDG_CACHE_HOME/nv")
    ;; password-store
    ("PASSWORD_STORE_DIR" . "$XDG_DATA_HOME/pass")
    ;; python
    ;; TODO: Python 3.13.
    ("PYTHON_HISTORY" . "$XDG_STATE_HOME/python/history")
    ;; rust
    ("CARGO_HOME" . "$XDG_DATA_HOME/cargo")
    ;; sqlite
    ("SQLITE_HISTORY" . "$XDG_STATE_HOME/sqlite_history")
    ;; wget
    ("WGETRC" . "$XDG_CONFIG_HOME/wgetrc")))

(define %xdg-data-home
  (or (getenv "XDG_DATA_HOME")
      (in-vicinity (getenv "HOME") ".local/share")))


(define testament-path
  (getcwd))

(define (testament-blobs . name)
  (let ((blobs (in-vicinity testament-path "files/blobs")))
    (match name
      (()
       (local-file blobs #:recursive? #t))
      ((file)
       (or (search-path (list blobs) file)
           (leave (G_ "file '~a' not found.~%") file))))))

(define (testament-plain . name)
  (let ((plain (in-vicinity testament-path "files/plain")))
    (match name
      (()
       (local-file plain #:recursive? #t))
      ((file)
       (or (search-path (list plain) file)
           (leave (G_ "file '~a' not found.~%") file))))))


(define* (get-sops-secret key #:key file (number? #f))
  "Return a string (or number if NUMBER? is set to #t) of SOPS secret for KEY
stored in FILE.  The result will be publicly available in '/gnu/store', YOU ARE
WARNED."
  (let* ((file-path
          (with-store store
            (run-with-store store
              (lower-object file))))
         (cmd
          (format #f "sops --decrypt --extract '~a' '~a'"
                  (sanitize-sops-key key)
                  file-path))
         (port (open-input-pipe cmd))
         (secret (get-string-all port)))
    (close-pipe port)
    (if number?
        (string->number secret)
        secret)))

(define (sops-str file key)
  (get-sops-secret key #:file file))

(define (sops-num file key)
  (get-sops-secret key #:file file #:number? #t))

(define dorphine.yaml
  (local-file (testament-blobs "dorphine.yaml")))

(define gokuraku.yaml
  (local-file (testament-blobs "gokuraku.yaml")))


(define* (sing-box-config #:optional (ip-addresses '("172.19.0.1/30" "fd00::1/126"))
                          #:key android? clash-api?)
  (define %direct-processes
    '(".qbittorrent-nox-real"
      "cs2"
      "rclone"
      "sing-box"
      "smartdns"
      "steam"
      "syncthing"
      "wineserver"))

  (define %direct-rules
    '((("protocol" . "bittorrent"))
      (("rule_set" . "geosite-geolocation-cn"))
      (("type" . "logical")
       ("mode" . "and")
       ("rules"
        . #((("rule_set" . "geosite-geolocation-!cn")
             ("invert" . #t))
            (("rule_set" . "geoip-cn")))))))

  (define %config
    `(("log"
       ("level" . "warn"))
      ("dns"
       ("servers"
        . #((("type" . "tls")
             ("tag" . "DNS: Proxy")
             ("detour" . "OUT: Proxy")
             ("server" . "1.1.1.1"))
            (("type" . "tls")
             ("tag" . "DNS: Direct")
             ("server" . "223.5.5.5"))))
       ("rules"
        . #(,@(map (lambda (rule)
                     `(,@rule
                       ("server" . "DNS: Direct")))
                   %direct-rules)
            (("process_name" . #(,@%direct-processes))
             ("server" . "DNS: Direct")))))
      ("endpoints"
       . #((("type" . "tailscale")
            ("tag" . "EP: Tailscale")
            ("domain_resolver" . "DNS: Direct"))))
      ("inbounds"
       . #((("type" . "tun")
            ("tag" . "IN: Tun")
            ("address" . #(,@ip-addresses))
            ("auto_route" . #t)
            ("auto_redirect" . ,(not android?))
            ("strict_route" . #t))))
      ("outbounds"
       . #(,(call-with-input-string (sops-str dorphine.yaml '("sing-box")) read)
           (("type" . "direct")
            ("tag" . "OUT: Direct")
            ("domain_resolver" . "DNS: Direct"))))
      ("route"
       ("rules"
        . #((("action" . "sniff"))
            (("protocol" . "dns")
             ("action" . "hijack-dns"))
            (("ip_cidr" . #("100.64.0.0/10" "fd71:115c:a1e0::/48"))
             ("outbound" . "EP: Tailscale"))
            (("ip_is_private" . #t)
             ("outbound" . "OUT: Direct"))
            ,@(map (lambda (rule)
                     `(,@rule
                       ("outbound" . "OUT: Direct")))
                   %direct-rules)
            (("process_name" . #(,@%direct-processes))
             ("outbound" . "OUT: Direct"))))
       ("rule_set"
        . #((("type" . "remote")
             ("tag" . "geosite-geolocation-cn")
             ("url" . "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-geolocation-cn.srs"))
            (("type" . "remote")
             ("tag" . "geosite-geolocation-!cn")
             ("url" . "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-geolocation-!cn.srs"))
            (("type" . "remote")
             ("tag" . "geoip-cn")
             ("url" . "https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set/geoip-cn.srs"))))
       ("find_process" . #t)
       ("auto_detect_interface" . #t)
       ("default_domain_resolver" . "DNS: Direct"))
      ("experimental"
       ("cache_file"
        ("enabled" . #t)
        ("store_rdrc" . #t))
       ,@(if clash-api?
             '(("clash_api"
                ("external_controller" . "127.0.0.1:9090")
                ("external_ui" . "ui")
                ("external_ui_download_url" . "https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip")
                ("external_ui_download_detour" . "OUT: Proxy")))
             '()))))

  (computed-file "sing-box.json"
    (with-extensions (map specification->package '("guile-json@4"))
      #~(begin
          (use-modules (json))
          (call-with-output-file #$output
            (lambda (port)
              (display (scm->json-string '#$%config #:pretty #t) port)))))))
