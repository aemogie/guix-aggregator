(define-module (mrh-guix system om oci-containers)
  #:use-module (mrh-guix personal)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (gnu services containers))

(define oci-uid (get-line (open-input-pipe "id oci-container -u")))
(define oci-gid (get-line (open-input-pipe "id oci-container -g")))

(define-public %sabnzbd-oci
  (let ((sabnzbd-name "sabnzbd"))
    (list
     (oci-container-configuration
       (environment '(("TZ" . "Etc/UTC")))
       (image "linuxserver/sabnzbd")
       (provision sabnzbd-name)
       (network "media")
       (ports '("[::1]:8081:8081"))
       (volumes
        `((,(format #f "~a/dot-config/~a" %dots-dir sabnzbd-name) . "/config")
          ("/mnt/wd/media/downloads" . "/media/downloads")))
       (container-user (format #f "~a:~a" oci-uid oci-gid))))))

(define-public %jellyfin-oci
  (let ((jellyfin-name "jellyfin"))
    (list
     (oci-container-configuration
       (image "jellyfin/jellyfin")
       (provision jellyfin-name)
       (network "media")
       (ports (list "[::1]:8096:8096"
                    (format #f "[~a]:8096:8096" %ipv6-ula-om)
                    (format #f "~a:8096:8096" %ipv4-lan-om)
                    "[::]:7359:7359"))
       (volumes
        `((,(format #f "~a/dot-config/~a" %dots-dir jellyfin-name) . "/config")
          ("jellyfin-cache" . "/cache")
          ("/mnt/wd/media" . "/media")))
       (container-user (format #f "~a:~a" oci-uid oci-gid))
       (extra-arguments
        (let ((video-group-id (get-line
                               (open-input-pipe
                                "awk -F ':' '/^video/ {print $3}' /etc/group"))))
          (list "--device=/dev/dri/renderD128:/dev/dri/renderD128"
                (format #f "--group-add=~a" video-group-id))))))))

(define-public %arrs-oci
  (let ((radarr-name "radarr")
        (sonarr-name "sonarr"))
    (list
     (oci-container-configuration
       (environment '(("TZ" . "Etc/UTC")))
       (image "lscr.io/linuxserver/radarr")
       (provision radarr-name)
       (network "media")
       (ports '("[::1]:7878:7878"))
       (volumes
        `((,(format #f "~a/dot-config/~a" %dots-dir radarr-name) . "/config")
          ("/mnt/wd/media" . "/media")))
       (container-user (format #f "~a:~a" oci-uid oci-gid)))

     (oci-container-configuration
       (environment '(("TZ" . "Etc/UTC")))
       (image "ghcr.io/linuxserver/sonarr")
       (provision sonarr-name)
       (network "media")
       (ports '("[::1]:8989:8989"))
       (volumes
        `((,(format #f "~a/dot-config/~a" %dots-dir sonarr-name) . "/config")
          ("/mnt/wd/media" . "/media")))
       (container-user (format #f "~a:~a" oci-uid oci-gid))))))

(define-public %paperless-oci
  (let ((redis-name "paperless-redis")
        (postgres-name "paperless-postgres")
        (paperless-name "paperless"))
    (list
     (oci-container-configuration
       (image "docker.io/library/redis")
       (provision redis-name)
       (network "paperless")
       (respawn? #t)
       (volumes
        `((,(format #f "~a/redis" %paperless-share) . "/data"))))

     (oci-container-configuration
       (environment
        '(("POSTGRES_DB" . "paperless")
          ("POSTGRES_USER" . "paperless")
          ("POSTGRES_PASSWORD" . "paperless")))
       (image "docker.io/library/postgres:18")
       (provision postgres-name)
       (network "paperless")
       (respawn? #t)
       (volumes
        `((,(format #f "~a/postgres" %paperless-share) . "/var/lib/postgresql"))))

     (oci-container-configuration
       (environment
        `(("PAPERLESS_REDIS" . ,(format #f "redis://~a:6379" redis-name))
          ("PAPERLESS_DBHOST" . ,postgres-name)
          ("PAPERLESS_URL" . ,(format #f "http://paper.sec.~a" %domain-name))))
       (image "ghcr.io/paperless-ngx/paperless-ngx:latest")
       (provision "paperless")
       (network "paperless")
       (requirement (map string->symbol (list redis-name postgres-name)))
       (ports '("[::1]:8000:8000"))
       (volumes
        (cons* (cons (format #f "~a/data/paperless" %user-home)
                     "/usr/src/paperless/consume")
               (map (lambda (volume)
                      (cons (format #f "~a/~a" %paperless-share volume)
                            (format #f "/usr/src/paperless/~a" volume)))
                    '("data" "media" "export"))))))))

(define-public %homepage-oci
  (let ((homepage-name "homepage"))
    (list
     (oci-container-configuration
       (environment '(("HOMEPAGE_ALLOWED_HOSTS" . "gethomepage.dev")))
       (image "ghcr.io/gethomepage/homepage")
       (provision homepage-name)
       (network "host")
       (ports '("[::1]:3000:3000"))
       (volumes
        `((,(format #f "~a/dot-config/~a" %dots-dir homepage-name) . "/app/config")))
       (container-user (format #f "~a:~a" oci-uid oci-gid))))))
