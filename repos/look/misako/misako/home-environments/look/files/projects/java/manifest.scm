(use-modules (guix profiles)
             (gnu packages java)
             (gnu packages python)
             (saayix packages binaries))

(packages->manifest
  (list jdtls-bin
        `(,openjdk "jdk")
        maven-bin
        python))
