(define-module (mrh-guix system om oci-containers)
  #:use-module (mrh-guix personal)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (gnu services containers))

(define-public %paperless-ngx-oci
  (let ((redis-name "paperless-ngx-redis")
        (postgresql-name "paperless-ngx-postgresql"))
    (list
     (oci-container-configuration
       (provision redis-name)
       (image "docker.io/library/redis")
       (network "paperless")
       (volumes
        (list (cons (format #f "~a/redis" %paperless-share)
                    "/data"))))

     (oci-container-configuration
       (provision postgresql-name)
       (image "docker.io/library/postgres:18")
       (network "paperless")
       (volumes
        (list (cons (format #f "~a/postgresql" %paperless-share)
                    "/var/lib/postgresql")))
       (environment
        '(("POSTGRES_DB" . "paperless")
          ("POSTGRES_USER" . "paperless")
          ("POSTGRES_PASSWORD" . "paperless"))))

     (oci-container-configuration
       (provision "paperless-ngx")
       (image "ghcr.io/paperless-ngx/paperless-ngx:latest")
       (network "paperless")
       (requirement (map string->symbol (list redis-name postgresql-name)))
       (ports '("[::1]:8000:8000"))
       (volumes
        (map (lambda (volume)
               (cons (format #f "~a/~a" %paperless-share volume)
                     (format #f "/usr/src/paperless/~a" volume)))
             '("data" "media" "export" "consume")))
       (environment
        (list (cons "PAPERLESS_REDIS"
                    (format #f "redis://~a:6379" redis-name))
              (cons "PAPERLESS_DBHOST"
                    postgresql-name)
              (cons "PAPERLESS_URL"
                    (format #f "http://paper.home.~a" %domain-name))))))))

(define-public %jellyfin-oci
  (list
   (let ((oci-uid (get-line (open-input-pipe "id oci-container -u")))
         (oci-gid (get-line (open-input-pipe "id oci-container -g")))
         (video-group-id (get-line
                          (open-input-pipe
                           "awk -F ':' '/^video/ {print $3}' /etc/group"))))
     (oci-container-configuration
       (provision "jellyfin")
       (image "jellyfin/jellyfin")
       (ports (list "[::1]:8096:8096"
                    (format #f "[~a]:8096:8096" %ipv6-ula-om)
                    (format #f "~a:8096:8096" %ipv4-lan-om)
                    "[::]:7359:7359"))
       (environment `(("PUID" . ,oci-uid)
                      ("PGID" . ,oci-gid)))
       (volumes '(("jellyfin-config" . "/config")
                  ("jellyfin-cache" . "/cache")
                  ("/mnt/wd/media" . "/media")))
       (extra-arguments
        (list "--device=/dev/dri/renderD128:/dev/dri/renderD128"
              (format #f "--group-add=~a" video-group-id)))))))

(define-public %sabnzbd-oci
  (list
   (let ((oci-uid (get-line (open-input-pipe "id oci-container -u")))
         (oci-gid (get-line (open-input-pipe "id oci-container -g"))))
     (oci-container-configuration
       (provision "sabnzbd")
       (image "linuxserver/sabnzbd")
       (ports '("[::1]:8081:8081"))
       (environment `(("PUID" . ,oci-uid)
                      ("PGID" . ,oci-gid)
                      ("TZ" . "Etc/UTC")))
       (volumes
        `((,(format #f "~a/.config/sabnzbd" %user-home) . "/config")
          ("/mnt/wd/media" . "/media")))))))
