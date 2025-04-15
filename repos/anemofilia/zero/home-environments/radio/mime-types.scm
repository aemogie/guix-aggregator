(define-module (home-environments radio mime-types)
  #:export (audio
            audio+video
            browser
            document
            editor
            file-manager
            image
            video))

(define browser
  `("application/xhtml+xml"
    "application/x-extension-htm"
    "application/x-extension-xhtml"
    "application/x-extension-xht"
    "x-scheme-handler/http"
    "x-scheme-handler/https"))

(define editor
  `("text/html"
    "text/plain"
    "text/troff"
    "text/xml"
    "text/x-c"
    "text/x-c++"
    "text/x-clojure"
    "text/x-diff"
    "text/x-lisp"
    "text/x-patch"
    "text/x-scheme"
    "text/x-script.python"
    "text/x-shellscript"
    "text/x-tex"))

(define file-manager
  `("inode/directory"
    "x-scheme-handler/ftp"
    "x-scheme-handler/nfs"
    "x-scheme-handler/smb"
    "x-scheme-handler/ssh"
    "application/x-directory"))

(define audio
  `("video/mp4"
    "video/x-matroska"
    "video/webm"))

(define video
  `("audio/mpeg"
    "audio/ogg"
    "audio/opus"
    "audio/x-opus+ogg"))

(define audio+video
  (append audio video))

(define image
  `("image/avif"
    "image/bmp"
    "image/gif"
    "image/jpeg"
    "image/png"
    "image/svg+xml"
    "image/webp"))

(define document
  `("application/pdf"))
