(use-modules (guix cache)
             (guix build syscalls)
             (guix build utils))

(define %publish-cache "/var/cache/guix/publish")
(define %mirror-cache  "/var/cache/guix-moe")
(define %rclone-arguments
  '("--config" "/run/secrets/rclone"
    "--verbose"
    "--size-only"
    "--no-traverse"
    "--s3-no-check-bucket"
    "--s3-upload-concurrency=8"
    "--s3-chunk-size=16M"))

(define (invoke* . args)
  (invoke "/bin/sh" "-c" (string-join args)))

(define (sync-narinfo mirror-cache publish-cache)
  (invoke "rsync" "-a" "--delete"
          "--include" "*.narinfo"
          "--exclude" "*"
          (string-append publish-cache "/")
          (in-vicinity mirror-cache "narinfo/")))

;; Reduce S3 operations.
;; A bit hacky but it works and takes least time to think and write.
(define %nars-list      "nars.txt")
(define %nars-list-new  (string-append %nars-list ".new"))
(define %nars-diff      (string-append %nars-list ".diff"))
(define %nars-to-copy   (string-append %nars-list ".to_copy"))
(define %nars-to-delete (string-append %nars-list ".to_delete"))

(define (list-changed-nars mirror-cache publish-cache)
  (with-directory-excursion (in-vicinity publish-cache "nar")
    (invoke* "fd" "--exclude" "'*.tmp'" "--type" "f" "|" "sort" ">" (in-vicinity mirror-cache %nars-list-new)))
  (with-directory-excursion mirror-cache
    (unless (file-exists? %nars-list)
      (call-with-output-file %nars-list (const #t)))
    (invoke* "diff" "--unified" %nars-list %nars-list-new "|" "tail" "+4" ">" %nars-diff)
    (false-if-exception
     (invoke* "rg" "'^\\+'" %nars-diff "--no-line-number" "--replace" "''" ">" %nars-to-copy))
    (false-if-exception
     (invoke* "rg" "'^-'"   %nars-diff "--no-line-number" "--replace" "''" ">" %nars-to-delete))
    (delete-file* %nars-diff)))

(define (upload-new-nars mirror-cache publish-cache rclone-s3-bucket)
  (with-directory-excursion mirror-cache
    (apply invoke "rclone" "copy" "--files-from" %nars-to-copy
           (in-vicinity publish-cache "nar")
           (in-vicinity rclone-s3-bucket "nar")
           %rclone-arguments)
    (delete-file* %nars-to-copy)))

(define (delete-expired-nars mirror-cache rclone-s3-bucket)
  (with-directory-excursion mirror-cache
    (apply invoke "rclone" "delete" "--files-from" %nars-to-delete
           (in-vicinity rclone-s3-bucket "nar")
           %rclone-arguments)
    (delete-file* %nars-to-delete)))

(with-file-lock/no-wait "/var/lock/guix-moe-mirror.lock"
  (lambda _
    (error "found ongoing syncing process, exiting"))
  (begin
    (setenv "PATH" "/run/current-system/profile/bin")
    (mkdir-p %mirror-cache)

    (list-changed-nars   %mirror-cache %publish-cache)
    (upload-new-nars     %mirror-cache %publish-cache "r2:substitutes-apac")
    (sync-narinfo        %mirror-cache %publish-cache)
    (delete-expired-nars %mirror-cache "r2:substitutes-apac")

    (with-directory-excursion %mirror-cache
      (rename-file %nars-list-new %nars-list))))
