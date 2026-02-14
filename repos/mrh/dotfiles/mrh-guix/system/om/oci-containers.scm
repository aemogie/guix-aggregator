(define-module (mrh-guix system om oci-containers)
  #:use-module (mrh-guix personal)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (gnu services containers))

(define oci-uid (get-line (open-input-pipe "id oci-container -u")))
(define oci-gid (get-line (open-input-pipe "id oci-container -g")))

(define-public %paperless-oci
  (let ((redis-name "paperless-redis")
        (postgres-name "paperless-postgres"))
    (list
     (oci-container-configuration
       (provision redis-name)
       (respawn? #t)
       (image "docker.io/library/redis")
       (network "paperless-network")
       (volumes
        (list (cons (format #f "~a/redis" %paperless-share)
                    "/data"))))

     (oci-container-configuration
       (provision postgres-name)
       (respawn? #t)
       (image "docker.io/library/postgres:18")
       (network "paperless-network")
       (volumes
        (list (cons (format #f "~a/postgres" %paperless-share)
                    "/var/lib/postgresql")))
       (environment
        '(("POSTGRES_DB" . "paperless")
          ("POSTGRES_USER" . "paperless")
          ("POSTGRES_PASSWORD" . "paperless"))))

     (oci-container-configuration
       (provision "paperless")
       (image "ghcr.io/paperless-ngx/paperless-ngx:latest")
       (network "paperless-network")
       (requirement (map string->symbol (list redis-name postgres-name)))
       (ports '("[::1]:8000:8000"))
       (volumes
        (cons* (cons (format #f "~a/data/paperless" %user-home)
                     "/usr/src/paperless/consume")
               (map (lambda (volume)
                      (cons (format #f "~a/~a" %paperless-share volume)
                            (format #f "/usr/src/paperless/~a" volume)))
                    '("data" "media" "export"))))
       (environment
        (list (cons "PAPERLESS_REDIS"
                    (format #f "redis://~a:6379" redis-name))
              (cons "PAPERLESS_DBHOST"
                    postgres-name)
              (cons "PAPERLESS_URL"
                    (format #f "http://paper.sec.~a" %domain-name))))))))

(define-public %jellyfin-oci
  (list
   (oci-container-configuration
     (provision "jellyfin")
     (image "jellyfin/jellyfin")
     (ports (list "[::1]:8096:8096"
                  (format #f "[~a]:8096:8096" %ipv6-ula-om)
                  (format #f "~a:8096:8096" %ipv4-lan-om)
                  "[::]:7359:7359"))
     (container-user (format #f "~a:~a" oci-uid oci-gid))
     (volumes '(("jellyfin-config" . "/config")
                ("jellyfin-cache" . "/cache")
                ("/mnt/wd/media" . "/media")))
     (extra-arguments
      (let ((video-group-id (get-line
                             (open-input-pipe
                              "awk -F ':' '/^video/ {print $3}' /etc/group"))))
        (list "--device=/dev/dri/renderD128:/dev/dri/renderD128"
              (format #f "--group-add=~a" video-group-id)))))))

(define-public %sabnzbd-oci
  (list
   (oci-container-configuration
     (provision "sabnzbd")
     (image "linuxserver/sabnzbd")
     (ports '("[::1]:8081:8081"))
     (environment '(("TZ" . "Etc/UTC")))
     (container-user (format #f "~a:~a" oci-uid oci-gid))
     (volumes
      '(("sabnzbd-config" . "/config")
        ("/mnt/wd/media" . "/media"))))))
