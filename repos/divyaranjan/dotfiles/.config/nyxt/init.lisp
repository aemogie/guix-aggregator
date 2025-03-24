(in-package #:nyxt-user)


(define-configuration browser
    ((session-restore-prompt :never-restore) 
     (external-editor-program (list "emacslcient -c"))))


;; Custom Search Engines
(define-configuration buffer
    ((search-engines 
      (list
       (make-instance 'search-engine
		      :shortcut "wiki"
		      :search-url "https://en.wikipedia.org/wiki/~a")

       (make-instance 'search-engine
		      :shortcut "yt"
		      :search-url "https://www.youtube.com/results?search_query=~a")

       (make-instance 'search-engine
		      :shortcut "lib"
		      :search-url "http://libgen.is/search.php?req=~a&lg_topic=libgen&open=0&view=simple&res=25&phrase=1&column=def")
       (make-instance 'search-engine
		      :shortcut "z"
		      :search-url  "https://1lib.in/s/~a")
       (make-instance 'search-engine
		      :shortcut "music"
		      :search-url  "https://music.youtube.com/search?q=~a")
       (make-instance 'search-engine 
		      :shortcut "sci"
		      :search-url "https://sci-hub.se/~a")
       (make-instance 'search-engine
		      :shortcut "aw"
		      :search-url "https://wiki.archlinux.org/index.php/Special:Search?fulltext=Search&search=~a")
       (make-instance 'search-engine
		      :shortcut "r"
		      :search-url "https://www.reddit.com/r/~a")

       (make-instance 'search-engine
		      :shortcut "gaana"
		      :search-url "https://gaana.com/search/~a")
       (make-instance 'search-engine 
		      :shortcut "g"
		      :search-url "https://www.google.com/?q=~a")
       (make-instance 'search-engine
		      :shortcut "ocw"
		      :search-url "https://ocw.mit.edu/search/ocwsearch.htm?q=~a")

       (make-instance 'search-engine 
		      :shortcut "ddg"
		      :search-url "https://www.duckduckgo.com/?q=~a") ))))
;; ;; Setting downloader to ask for path before downloading
;; (define-command load-file
;;     nil
;;   "Select path for downloading."
;;   (prompt :prompt "Select path" :input(uiop/filesystem:native-namestring
;; 				       (alexandria:if-let ((nyxt::init-path (expand-path *init-file-path*)))
;; 					   (uiop/pathname:pathname-directory-pathname
;; 					    (pathname nyxt::init-path))
;; 					 (uiop/os:getcwd)))

;; 	  :download
;; 	  (make-instance 'user-file-source :actions
;; 			 (list 
;; 			  (make-command nyxt::download-file*
;; 					(nyxt::files)
;; 					(dolist (file nyxt::files)
;; 					  (nyxt::load-listp file)))))))

;; Redefining some bindings

(define-configuration nyxt/web-mode:web-mode
    ((keymap-scheme (let ((scheme %slot-default%))
		      (keymap:define-key (gethash scheme:vi-normal scheme)
			  "b b" 'toggle-toolbars)
		      scheme))))

(define-configuration nyxt/web-mode:web-mode
    ((keymap-scheme (let ((scheme %slot-default%))
		      (keymap:define-key (gethash scheme:vi-normal scheme)
			  "C-x" 'delete-buffer)
		      scheme))))


