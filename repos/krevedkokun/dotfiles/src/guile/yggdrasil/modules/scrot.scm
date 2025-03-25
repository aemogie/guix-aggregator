(define-module (yggdrasil modules scrot)
  #:use-module (gnu services)
  #:use-module ((yggdrasil home services swappy)
                #:select (home-swappy-service-type
                          home-swappy-configuration))
  #:use-module (ice-9 match)
  #:use-module ((rde home services wm)
                #:select (home-sway-service-type
                          home-sway-configuration))
  #:use-module (srfi srfi-1))

(use-modules (guix gexp)
             ((gnu packages guile-xyz) #:select (guile-srfi-180)))

(define (find-focused tree)
  (if (assq-ref tree 'focused)
      tree
      (let lp ((nodes (vector->list (assq-ref tree 'nodes))))
        (match nodes
          (() #f)
          ((node . rest)
           (or (find-focused node)
               (lp rest)))))))

#;(define (make-scrot-cmd target edit?)
  (with-extensions (list guile-srfi-180)
    (program-file
     "scrot"
     #~(begin
         (use-modules (ice-9 popen)
                      (ice-9 rdelim)
                      (ice-9 match)
                      (srfi srfi-1)
                      (srfi srfi-2)
                      (srfi srfi-26)
                      (srfi srfi-71)
                      (srfi srfi-180))
         (let* ((grim-args #$(match target
                               ('screen
                                (let* ((pipe (open-pipe*
                                              OPEN_READ
                                              (file-append #$sway "/bin/swaymsg")
                                              "-t" "get_outputs"))
                                       (out (vector->list (json-read pipe)))
                                       (focused (find (cut assq-ref <> 'focused) out)))
                                  (close-pipe pipe)
                                  (list "-o" (assq-ref focused 'name))))
                               ('window
                                (let* ((pipe (open-pipe*
                                              OPEN_READ
                                              (file-append #$sway "/bin/swaymsg")
                                              "-t" "get_tree"))
                                       (out (json-read pipe))
                                       (rect (assq-ref (find-focused out) 'rect)))
                                  (close-pipe pipe)
                                  (list "-g" (format #f "~a,~a ~ax~a"
                                                     (assq-ref rect 'x)
                                                     (assq-ref rect 'y)
                                                     (assq-ref rect 'width)
                                                     (assq-ref rect 'height)))))
                               ('region (let* (((pipe (open-pipe*
                                                       OPEN_READ
                                                       (file-append #$slurp "/bin/slurp")))
                                                (out (read-line pipe))))
                                          (close-pipe pipe)
                                          (list "-g" out)))))
                (cmds (list
                       `(,(file-append #$grim "/bin/grim") ,@grim-args)
                       (if #$edit?
                           (list (file-append #$swappy "/bin/swappy") "-f" "-")
                           (list (file-append #$wl-clipboard "/bin/wl-copy") "-t" "image/png"))))
                (out in _ (pipeline cmds)))
           (close out)
           (close in)
           (close-pipe pipe))))))

(define (home-services)
  (list
   (service
    home-swappy-service-type
    (home-swappy-configuration
     (config
      `((Default
          ((show_panel           . #t)
           (save_dir             . $HOME/img)
           (save_filename_format . scrot-%Y%m%d-%H%M%S.png)
           (early_exit           . #t)))))))
   #;(simple-service 'sway-bindsym-scrot
     home-sway-service-type
     (home-sway-configuration
      (config
       '((mode scrot
           (( bindsym
              ((q mode default)
               (s exec ,(make-scrot-cmd 'screen #f) "," exit)
               (Shift+s exec ,(make-scrot-cmd 'screen #t) "," exit)
               (w exec ,(make-scrot-cmd 'window #f) "," exit)
               (Shift+w exec ,(make-scrot-cmd 'window #t) "," exit)
               (r exec ,(make-scrot-cmd 'region #f) "," exit)
               (Shift+r exec ,(make-scrot-cmd 'region #t) "," exit)))))
         (bindsym (($mod+s mode scrot)))))))))
