(define-module (mrh-guix oci-containers)
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
        '(("/mnt/big/services/sabnzbd" . "/config")
          ("/mnt/big/media/downloads" . "/media/downloads")))
       (container-user (format #f "~a:~a" oci-uid oci-gid))))))

(define-public %jellyfin-oci
  (let ((jellyfin-name "jellyfin"))
    (list
     (oci-container-configuration
       (image "jellyfin/jellyfin")
       (provision jellyfin-name)
       (network "media")
       (requirement '(networking))
       (ports (list "[::1]:8096:8096"
                    (format #f "[~a]:8096:8096" %ipv6-ula-om)
                    (format #f "~a:8096:8096" %ipv4-lan-om)
                    "[::]:7359:7359"))
       (volumes
        '(("/mnt/big/services/jellyfin" . "/config")
          ("/mnt/big/media" . "/media")
          ("jellyfin-cache" . "/cache")))
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
        '(("/mnt/big/services/radarr" . "/config")
          ("/mnt/big/media" . "/media")))
       (container-user (format #f "~a:~a" oci-uid oci-gid)))

     (oci-container-configuration
       (environment '(("TZ" . "Etc/UTC")))
       (image "ghcr.io/linuxserver/sonarr")
       (provision sonarr-name)
       (network "media")
       (ports '("[::1]:8989:8989"))
       (volumes
        '(("/mnt/big/services/sonarr" . "/config")
          ("/mnt/big/media" . "/media")))
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
        '(("/mnt/big/services/paperless/redis" . "/data"))))

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
        '(("/mnt/big/services/paperless/postgres" . "/var/lib/postgresql"))))

     (oci-container-configuration
       (environment
        `(("PAPERLESS_REDIS" . ,(format #f "redis://~a:6379" redis-name))
          ("PAPERLESS_DBHOST" . ,postgres-name)
          ("PAPERLESS_URL" . ,(format #f "http://paper.home.~a" %domain-name))))
       (image "ghcr.io/paperless-ngx/paperless-ngx:latest")
       (provision "paperless")
       (network "paperless")
       (requirement (map string->symbol (list redis-name postgres-name)))
       (ports '("[::1]:8000:8000"))
       (volumes
        (cons* (cons (format #f "~a/data/paperless" %user-home)
                     "/usr/src/paperless/consume")
               (map (lambda (volume)
                      (cons (format #f "/mnt/big/services/paperless/~a" volume)
                            (format #f "/usr/src/paperless/~a" volume)))
                    '("data" "media" "export"))))))))

(define-public %homepage-oci
  (let ((homepage-name "homepage"))
    (list
     (oci-container-configuration
       (environment
        `(("HOMEPAGE_ALLOWED_HOSTS" . ,(format #f "homepage.home.~a" %domain-name))))
       (image "ghcr.io/gethomepage/homepage")
       (provision homepage-name)
       (network "host")
       (ports '("[::1]:3000:3000"))
       (volumes
        '(("/mnt/big/services/homepage" . "/app/config")))
       (container-user (format #f "~a:~a" oci-uid oci-gid))))))

(define-public %immich-oci
  (let ((redis-name "immich_redis")
        (postgres-name "immich_postgres")
        (immich-name "immich_server"))
    (list
     (oci-container-configuration
       (image "docker.io/valkey/valkey:9@sha256:546304417feac0874c3dd576e0952c6bb8f06bb4093ea0c9ca303c73cf458f63")
       (provision redis-name)
       (network "immich")
       (respawn? #t)
       (container-user (format #f "~a:~a" oci-uid oci-gid)))

     (oci-container-configuration
       (environment
        '(("POSTGRES_PASSWORD" . "postgres")
          ("POSTGRES_USER" . "postgres")
          ("POSTGRES_DB" . "immich")
          ("POSTGRES_INITDB_ARGS" . "--data-checksums")
          ("DB_STORAGE_TYPE" . "HDD")))
       (image "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23")
       (provision postgres-name)
       (network "immich")
       (respawn? #t)
       (volumes
        `((,(format #f "~a/postgres" %immich-share) . "/var/lib/postgresql/data")))
       (container-user (format #f "~a:~a" oci-uid oci-gid)))

     (oci-container-configuration
       (image "ghcr.io/immich-app/immich-server:v2.1.0")
       (provision immich-name)
       (network "immich")
       (requirement (map string->symbol (list redis-name postgres-name)))
       (ports '("[::1]:2283:2283"))
       (volumes
        `((,(format #f "~a/data" %immich-share) . "/data")
          ("/etc/localtime" . "/etc/localtime:ro")))
       (container-user (format #f "~a:~a" oci-uid oci-gid))))))

(define-public %technitium-oci
  (let ((technitium-name "dns"))
    (list
     (oci-container-configuration
       (environment
        `(("DNS_SERVER_ADMIN_PASSWORD" . ,%technitium-password)
          ("DNS_SERVER_PREFER_IPV6" . "true")
          ("DNS_SERVER_LOG_USING_LOCAL_TIME" . "false")))
       (image "technitium/dns-server")
       (provision technitium-name)
       (network "host")
       (ports (list "[::]:5380:5380/tcp"
                    "[::]:53:53/tcp"
                    "[::]:53:53/udp"

                    "[0.0.0.0]:5380:5380/tcp"
                    "[0.0.0.0]:53:53/tcp"
                    "[0.0.0.0]:53:53/udp"))
       (volumes
        '(("technitium-dns-config" . "/etc/dns")))))))
