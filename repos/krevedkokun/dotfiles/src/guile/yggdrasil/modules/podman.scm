(define-module (yggdrasil modules podman)
  #:use-module (gnu home services)
  #:use-module ((gnu packages containers) #:select (podman
                                                    podman-compose))
  #:use-module (gnu services)
  #:use-module ((gnu services sysctl) #:select (sysctl-service-type))
  #:use-module (guix gexp))

(define-public (home-services)
  (list
   (simple-service
    'podman-add-podman-package
    home-profile-service-type
    (list podman podman-compose (@ (gnu packages containers) distrobox)))
   (simple-service
    'podman-configs
    home-xdg-configuration-files-service-type
    `(("containers/registries.conf"
       ,(plain-file
         "registries.conf"
         "unqualified-search-registries = ['docker.io']"))
      ("containers/storage.conf"
       ,(plain-file
         "storage.conf"
         "[storage]\ndriver = \"btrfs\""))
      ("containers/policy.json"
       ,(plain-file
         "policy.json"
         "{\"default\": [{\"type\": \"insecureAcceptAnything\"}]}"))
      #;("containers/containers.conf"
       ,(plain-file
         "containers.conf"
         "[Network]\nnetwork_backend = \"netavark\""))))))

(define-public (system-services)
  (list
   (simple-service
    'podman-subuid-subgid
    etc-service-type
    `(("subuid"
       ,(plain-file "subuid" "kreved:100000:65536\n"))
      ("subgid"
       ,(plain-file "subgid" "kreved:100000:65536\n"))))))
