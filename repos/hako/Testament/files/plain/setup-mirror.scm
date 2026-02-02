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
(define (list-changed-nars mirror-cache publish-cache)
  (let* ((file "nars.txt")
         (new  (string-append file ".new"))
         (diff (string-append file ".diff"))
         (to-copy   (string-append file ".to_copy"))
         (to-delete (string-append file ".to_delete")))
    (unless (file-exists? file)
      (call-with-output-file file (const #t)))
    (with-directory-excursion (in-vicinity publish-cache "nar")
      (invoke* "fd" "--exclude" "'*.tmp'" "--type" "f" "|" "sort" ">" (in-vicinity mirror-cache new)))
    (with-directory-excursion mirror-cache
      (invoke* "diff" "--unified" file new "|" "tail" "+4" ">" diff)
      (false-if-exception
       (invoke* "rg" "'^\\+'" diff "--no-line-number" "--replace" "''" ">" to-copy))
      (false-if-exception
       (invoke* "rg" "'^-'"   diff "--no-line-number" "--replace" "''" ">" to-delete)))))

(define (upload-new-nars mirror-cache publish-cache rclone-s3-bucket)
  (with-directory-excursion mirror-cache
    (apply invoke "rclone" "copy" "--files-from" "nars.txt.to_copy"
           (in-vicinity publish-cache "nar")
           (in-vicinity rclone-s3-bucket "nar")
           %rclone-arguments)))

(define (delete-expired-nars mirror-cache rclone-s3-bucket)
  (with-directory-excursion mirror-cache
    (apply invoke "rclone" "delete" "--files-from" "nars.txt.to_delete"
           (in-vicinity rclone-s3-bucket "nar")
           %rclone-arguments)))

(define (clean-up mirror-cache)
  (with-directory-excursion mirror-cache
    (for-each delete-file*
              '("nars.txt.diff"
                "nars.txt.to_copy"
                "nars.txt.to_delete"))
    (rename-file "nars.txt.new" "nars.txt")))

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
    (clean-up %mirror-cache)))
