(define-module (yggdrasil modules docker)
  #:use-module ((gnu packages docker) #:select (docker-cli
                                                docker-compose))
  #:use-module (gnu services)
  #:use-module ((gnu services docker) #:select (docker-service-type
                                                docker-configuration
                                                containerd-service-type))
  #:use-module (guix build-system copy)
  #:use-module (guix download)

  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (ice-9 match))

(define-public docker-compose-plugin
  (package
    (inherit docker-compose)
    (version "2.24.5")
    (source
     (let ((arch (match (or (%current-target-system) (%current-system))
                   ("aarch64-linux" "aarch64")
                   ("armhf-linux" "armv7")
                   (_ "x86_64"))))
       (origin
         (method url-fetch)
         (uri
          (string-append
           "https://github.com/docker/compose/releases/download/v"
           version "/docker-compose-linux-" arch))
         (sha256
          (base32
           (match arch
             ("aarch64" "0j392awfb4fh4rrdmzz5gapqam0j96nzky9qi97kh93zkbzr0pjk")
             ("armv7" "1d7g3cmbd0bwyhvq2nww4fbwmrvbfrp6vzwn92r24ys05i68n940")
             (_ "1qdklhrxm3x7ybhmaycag4q7qqn7snc0yjd1pl5h95fks7hmndcl")))))))
    (build-system copy-build-system)
    (native-inputs
     (list))
    (inputs
     (list))
    (propagated-inputs
     (list))
    (arguments
     (list
      #:substitutable? #f
      #:install-plan
      #~'(("docker-compose" "libexec/docker/cli-plugins/"))
      #:phases
      #~(modify-phases %standard-phases
          (replace 'unpack
            (lambda _
              (copy-file #$source "./docker-compose")
              (chmod "docker-compose" #o644)))
          (add-before 'install 'chmod
            (lambda _
              (chmod "docker-compose" #o555)))
          (add-after 'install 'setup-bin
            (lambda _
              (let ((bin (string-append #$output "/bin"))
                    (lib (string-append #$output "/libexec/docker/cli-plugins")))
                (mkdir bin)
                (symlink (string-append lib "/docker-compose")
                         (string-append bin "/docker-compose"))))))))
    (supported-systems '("armhf-linux" "aarch64-linux" "x86_64-linux"))))

(define-public docker-cli-with-compose
  (package
    (inherit docker-cli)
    (arguments
     (substitute-keyword-arguments (package-arguments docker-cli)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'unpack 'patch-plugin-path
              (lambda _
                (substitute* "src/github.com/docker/cli/cli-plugins/manager/manager_unix.go"
                  (("/usr/libexec/docker/cli-plugins")
                   (string-append #$output "/libexec/docker/cli-plugins")))))
            (add-after 'install 'symlink-plugin
              (lambda _
                (let ((plugins-directory
                       (string-append #$output "/libexec/docker/cli-plugins")))
                  (mkdir-p plugins-directory)
                  (symlink (string-append #$(this-package-input "docker-compose")
                                          "/libexec/docker/cli-plugins/docker-compose")
                           (string-append plugins-directory "/docker-compose")))))))))
    (inputs (list docker-compose-plugin))))


(define-public (system-services)
  (list
   ;; TODO: migrate to podman
   (service
    containerd-service-type)
   (service
    docker-service-type
    (docker-configuration
     (docker-cli docker-cli-with-compose)))))
