(defun my/publish-html-build-author (html-info)
  (let ((author (substring-no-properties
                 (org-export-data (plist-get html-info :author) html-info))))
    (if (string-empty-p author)
        ""
      (jack-html
       `(:div (@ :class "author")
              ,author)))))

(defun my/publish-html-build-email (html-info)
  (let ((email (substring-no-properties
                (org-export-data (plist-get html-info :email) html-info))))
    (if (string-empty-p email)
        ""
      (jack-html
       `(:div (@ :class "email")
              "email: " ,email)))))

(defun my/publish-html-build-date (html-info)
  (if-let ((date (org-export-get-date
                  html-info
                  (plist-get html-info :html-metadata-timestamp-format))))
      (jack-html
       `(:div (@ :class "date")
              "posted on: " ,date))
    ""))

(defun my/publish-html-build-filetags (html-info)
  "Return the filetag string found in the current Org file.
INFO is the export plist, expected to contain the key :input-file.
Assumes \"tags.html\" file exists in same directory after export."
  (if-let ((filetags (plist-get html-info :filetags)))
      (jack-html
       `(:div (@ :id "filetags")
              (:a (@ :href ,(if-let ((tags-file
                                      (plist-get html-info :tags-file)))
                                (concat (file-name-sans-extension tags-file)
                                        ".html")
                              "tags.html"))
                  "tags")
              ": "
              ,(string-replace " " ", " (car filetags))))
    ""))

(defun my/publish-html-template (contents info)
  "This is essentially copied from `org-html-template' with small tweaks.

Removes some preamble navigation.
Adds author and date after title.
Adds link to tags file before postamble (for posts)."
  (concat
   (when (and (not (org-html-html5-p info)) (org-html-xhtml-p info))
     (let* ((xml-declaration (plist-get info :html-xml-declaration))
	        (decl (or (and (stringp xml-declaration) xml-declaration)
		              (cdr (assoc (plist-get info :html-extension)
				                  xml-declaration))
		              (cdr (assoc "html" xml-declaration))
		              "")))
       (when (not (or (not decl) (string= "" decl)))
	     (format "%s\n"
		         (format decl
			             (or (and org-html-coding-system
				                  (coding-system-get org-html-coding-system
                                                     'mime-charset))
			                 "iso-8859-1"))))))
   (org-html-doctype info)
   "\n"
   (concat "<html"
	       (cond ((org-html-xhtml-p info)
		          (format
		           " xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"%s\" xml:lang=\"%s\""
		           (plist-get info :language)
                   (plist-get info :language)))
		         ((org-html-html5-p info)
		          (format " lang=\"%s\"" (plist-get info :language))))
	       ">\n")
   "<head>"
   "\n"
   (org-html--build-meta-info info)
   (org-html--build-head info)
   (org-html--build-mathjax-config info)
   "</head>"
   "\n"
   "<body>"
   "\n"
   ;; Preamble.
   (org-html--build-pre/postamble 'preamble info)
   ;; Document contents.
   (let ((div (assq 'content (plist-get info :html-divs))))
     (format "<%s id=\"%s\" class=\"%s\">\n"
             (nth 1 div)
             (nth 2 div)
             (plist-get info :html-content-class)))
   ;; Document title.
   (when (plist-get info :with-title)
     (let ((title (plist-get info :title))
	       (subtitle (plist-get info :subtitle))
	       (html5-fancy (org-html--html5-fancy-p info)))
       (when title
	     (format
	      (if html5-fancy
	          "<header>\n<h1 class=\"title\">%s</h1>\n%s</header>"
	        "<h1 class=\"title\">%s%s</h1>\n")
	      (org-export-data title info)
	      (if subtitle
	          (format
	           (if html5-fancy
		           "<p class=\"subtitle\" role=\"doc-subtitle\">%s</p>\n"
		         (concat "\n" (org-html-close-tag "br" nil info) "\n"
			             "<span class=\"subtitle\">%s</span>\n"))
	           (org-export-data subtitle info))
	        "")))))
   "<br />"
   ;; Author, Email, and Date
   (my/publish-html-build-author info)
   (my/publish-html-build-email info)
   (my/publish-html-build-date info)
   ;; Page Contents
   contents
   (format "</%s>\n" (nth 1 (assq 'content (plist-get info :html-divs))))
   ;; Filetags
   (my/publish-html-build-filetags info)
   ;; Postamble.
   "<br />"
   (org-html--build-pre/postamble 'postamble info)
   ;; Possibly use the Klipse library live code blocks.
   (when (plist-get info :html-klipsify-src)
     (concat "<script>" (plist-get info :html-klipse-selection-script)
	         "</script><script src=\""
	         org-html-klipse-js
	         "\"></script><link rel=\"stylesheet\" type=\"text/css\" href=\""
	         org-html-klipse-css "\"/>"))
   ;; Closing document.
   "</body>"
   "\n"
   "</html>"))

(org-export-define-derived-backend 'my/publish-html 'html
  :translate-alist
  '((template . my/publish-html-template)))

(defun my/publish-to-html (plist filename pub-dir)
  (org-publish-org-to 'my/publish-html filename
		              (concat (when (> (length org-html-extension) 0) ".")
			                  (or (plist-get plist :html-extension)
				                  org-html-extension
				                  "html"))
		              plist pub-dir))

(defun my/publish-find-date-no-cache (file project)
  "Find the date of FILE in PROJECT.
This function assumes FILE is either a directory or an Org file.
If FILE is an Org file and provides a DATE keyword use it.  In
any other case use the file system's modification time.  Return
time in `current-time' format."
  (let ((file (org-publish--expand-file-name file project)))
    (if (file-directory-p file)
	    (file-attribute-modification-time (file-attributes file))
	  (let ((date (org-publish-find-property file :date project)))
	    ;; DATE is a secondary string.  If it contains
	    ;; a time-stamp, convert it to internal format.
	    ;; Otherwise, use FILE modification time.
	    (cond ((let ((ts (and (consp date) (assq 'timestamp date))))
		         (and ts
			          (let ((value (org-element-interpret-data ts)))
			            (and (org-string-nw-p value)
				             (org-time-string-to-time value))))))
		      ((file-exists-p file)
		       (file-attribute-modification-time (file-attributes file)))
		      (t (error "No such file: \"%s\"" file)))))))

(defun my/publish-index-format (entry project)
  (format "%s — [[file:%s][%s]] %s"
          (format-time-string "%Y-%m-%d"
                              (my/publish-find-date-no-cache entry project))
		  entry
		  (org-publish-find-title entry project)
          (org-publish-find-property entry :author project)))

(defun my/publish-html-posts-index-entry (entry style project)
  (cond ((string-match (org-publish-property :sitemap-exclude project) entry)
         "exclude-me")
        ((not (directory-name-p entry))
	     (my/publish-index-format entry project))
        ((eq style 'tree)
	     ;; Return only last subdir.
	     (file-name-nondirectory (directory-file-name entry)))
        (t entry)))

(defun my/publish-html-posts-index-function (title list)
  (concat "#+title: " title "\n\n"
          (org-list-to-org
           (cons (car list)
                 (cl-remove-if (lambda (post-filename)
                                 (string-equal "exclude-me"
                                               (car post-filename)))
                               (cdr list))))))

(defun my/publish-html-tags-base-files (project)
  (let* ((base-dir (file-name-as-directory
		            (org-publish-property :base-directory project)))
	     (filter-fn
	      (or (org-publish-property :tags-filter-function project)
              (lambda (filename) t)))
	     (base-files (seq-filter filter-fn
                                 (org-publish-get-base-files project))))
    (when (org-publish-property :auto-sitemap project)
      (delete (expand-file-name
	           (or (org-publish-property :sitemap-filename project)
		           "sitemap.org")
	           base-dir)
	          base-files))
    (when (org-publish-property :makeindex project)
      (delete (expand-file-name "theindex.org" base-dir) base-files))
    base-files))

(defun my/publish-html-tags-sort (tags)
  (dolist (tag tags)
    (let ((entries (cdr tag)))
      (setcdr tag (sort entries #'string>))))
  (sort tags (lambda (tag1 tag2)
               (string< (car tag1) (car tag2)))))

(defun my/publish-html-tags-builder (project)
  (let ((base-files (my/publish-html-tags-base-files project))
        (tags-and-entries ()))
    (dolist (file base-files)
      (when-let ((raw-file-tags (org-publish-find-property
                                 file :filetags project)))
        (let ((entry (my/publish-index-format file project))
              (file-tags (string-split (car raw-file-tags))))
          (dolist (file-tag file-tags)
            (if-let ((tag-and-entries (assoc file-tag tags-and-entries)))
                (push entry (cdr tag-and-entries))
              (push (list file-tag entry) tags-and-entries))))))
    (setf tags-and-entries (my/publish-html-tags-sort tags-and-entries))
    (concat "#+title: Tags"
            "\n"
            "#+options: toc:nil"
            "\n\n"
            (string-join
             (mapcar (lambda (tag-and-entries)
                       (let ((tag (car tag-and-entries))
                             (entries (cdr tag-and-entries)))
                         (concat "* " (capitalize tag)
                                 "\n"
                                 (org-list-to-org
                                  `(unordered ,@(mapcar #'list entries)))
                                 "\n")))
                     tags-and-entries)
             "\n"))))

(defun my/publish-html-tags (project)
  (interactive
   (list
    (assoc (completing-read "Generate tags for project: "
			                org-publish-project-alist nil t)
	       org-publish-project-alist)))
  (let ((project
	     (cond ((stringp project) (assoc project org-publish-project-alist))
	           ((not (stringp (car project))) (push "dummy-project" project))
	           (t project))))
    (when (and (not (null project))
	           (org-publish-property :auto-tags project))
      (let ((tags (my/publish-html-tags-builder project))
	        (filename
	         (expand-file-name
	          (if-let ((tags-file (org-publish-property :tags-file project)))
                  tags-file
                "tags.org")
	          (file-name-as-directory
		       (org-publish-property :base-directory project)))))
	    (with-temp-buffer
	      (insert tags)
	      (write-file filename))))))

(defun my/get-up-directory (level directory)
  (let ((result ""))
    (dotimes (_ level)
      (setf result (concat result "../")))
    (concat result directory)))

(defun my/publish-html-head (level)
  (jack-html
   `((:link (@ :rel "stylesheet" :type "text/css" :href ,(my/get-up-directory level "static/css/stylesheet.css")))
     (:link (@ :rel "icon" :href ,(my/get-up-directory level "static/images/icons/favicon.png")))
     (:link (@ :rel "me" :href (format "https://%s/@%s" mastodon-domain mastodon-user))))))

(defun my/publish-html-preamble (level)
  (jack-html
   `(:div (@ :class "navigation")
          (:a (@ :href ,(my/get-up-directory level "index.html"))
              (:img (@ :style "border-width:0" :src (my/get-up-directory level "static/images/icons/favicon.png")))
              " Homepage")
          (:br)
          (:a (@ :href ,(my/get-up-directory level "posts/index.html"))
              (:img (@ :style "border-width:0" :src (my/get-up-directory level "static/images/icons/blog.png")))
              " Posts")
          (:br)
          (:a (@ :href ,(my/get-up-directory level "posts/rss.xml"))
              (:img (@ :style "border-width:0" :src (my/get-up-directory level "static/images/icons/rss.png")))
              " RSS")
          (:br)
          (:a (@ :href ,my/code-repo)
              (:img (@ :style "border-width:0" :src ,(my/get-up-directory level "static/images/icons/git.png")))
              " Code")
          (:br)
          (:a (@ :href ,(my/get-up-directory level "donate.html"))
              (:img (@ :style "border-width:0" :src ,(my/get-up-directory level "static/images/icons/money-bag.png")))
              " Donate")
          (:br)
          (:a (@ :href ,(my/get-up-directory level "about.html"))
              (:img (@ :style "border-width:0" :src ,(my/get-up-directory level "static/images/icons/yes-man-sepia.jpg")))
              " About"))))

(defun my/publish-html-postamble (level)
  (jack-html
   `((:center
      (:a (@ :rel "license" :href "https://creativecommons.org/licenses/by-sa/4.0/")
          (:img (@ :alt "Creative Commons License" :style "border-width:0" :src "https://i.creativecommons.org/l/by-sa/4.0/88x31.png")))
      (:br)
      (:a (@ :xmlns:cc "https://creativecommons.org/ns" :href ,(format "https://%s/" my/website-domain) :property "cc:attributionName" :rel "cc:attributionURL")
          ,my/website-domain)
      " by "
      ,my/pen-name
      " is licensed under a "
      (:a (@ :rel "license" :href "https://creativecommons.org/licenses/by-sa/4.0/")
          "Creative Commons Attribution-ShareAlike 4.0 License")
      "."
      (:br)
      (:a (@ :href "https://www.gnu.org/software/emacs")
          (:img (@ :alt "emacs badge" :style "border-width:0" :src ,(my/get-up-directory level "static/images/badges/emacs.gif"))))
      (:a (@ :href "https://guix.gnu.org")
          (:img (@ :alt "guix badge" :style "border-width:0" :src ,(my/get-up-directory level "static/images/badges/gnu-guix-deployed.svg"))))
      (:a (@ :href "https://scheme.org")
          (:img (@ :alt "lisp badge" :style "border-width:0" :src ,(my/get-up-directory level "static/images/badges/lisp.png"))))
      (:a (@ :href "https://en.wikipedia.org/wiki/IPv6")
          (:img (@ :alt "ipv6 badge" :style "border-width:0" :src ,(my/get-up-directory level "static/images/badges/ipv6.gif"))))
      (:a (@ :href "https://xmpp.org/")
          (:img (@ :alt "xmpp badge" :style "border-width:0" :src ,(my/get-up-directory level "static/images/badges/xmpp.gif"))))
      (:a (@ :href "https://keepassxc.org/")
          (:img (@ :alt "keepassxc badge" :style "border-width:0" :src ,(my/get-up-directory level "static/images/badges/keepassxc.gif"))))
      (:a (@ :href "https://wiby.me/")
          (:img (@ :alt "wiby badge" :style "border-width:0" :src ,(my/get-up-directory level "static/images/badges/wiby.gif"))))))))

(defun my/publish-rss-filter (filename)
  (not (string-match "tags.org" filename)))

(let ((site-source-directory (concat my/website-local-directory "source/"))
      (site-target-directory (concat my/website-local-directory "target/")))
  (setf org-publish-project-alist
        `(("site.static"
           :base-directory ,(concat site-source-directory "static/")
           :publishing-directory ,(concat site-target-directory "static/")
           :publishing-function org-publish-attachment
           
           :base-extension ,(regexp-opt '("css"
                                          "asc"
                                          "gif"
                                          "ico"
                                          "js"
                                          "jpg"
                                          "jpeg"
                                          "mkv"
                                          "ogg"
                                          "opus"
                                          "pdf"
                                          "png"
                                          "svg"
                                          "webm"
                                          "ttf"
                                          "woff"))
           :recursive t)
          ("site.pages"
           :base-directory ,site-source-directory
           :publishing-directory ,site-target-directory
           :publishing-function my/publish-to-html
           
           :base-extension "org"
           :exclude ,(regexp-opt '("posts/" ".git"))
           :recursive t
           
           :author ""
           :email ""
           :with-toc nil
           :section-numbers nil

           :html-metadata-timestamp-format "%Y-%m-%d"           
           :html-head ,(my/publish-html-head 0)
           :html-preamble ,(my/publish-html-preamble 0)
           :html-postamble ,(my/publish-html-postamble 0))
          ("site.posts"
           :base-directory ,(concat site-source-directory "posts/")
           :publishing-directory ,(concat site-target-directory "posts/")
           :publishing-function my/publish-to-html
           
           :base-extension "org"
           :recursive nil

           :author ""
           :email ""
           :with-toc 2
           :section-numbers nil

           :auto-tags t
           
           :auto-sitemap t
           :sitemap-filename "index.org"
           :sitemap-title "Posts Index"
           :sitemap-exclude "tags.org"
           :sitemap-sort-files anti-chronologically
           :sitemap-format-entry my/publish-html-posts-index-entry
           :sitemap-function my/publish-html-posts-index-function
           
           :auto-rss t
           :rss-title "Wumpus Feed"
           :rss-description "rss feed for The Wumpus Warehouse"
           :rss-root-url ,(format "https://%s/posts/" my/website-domain)
           :rss-with-content all
           :rss-webmaster ,user-full-name
           :rss-editor ,user-full-name
           :rss-filter-function my/publish-rss-filter

           :html-metadata-timestamp-format "%Y-%m-%d"
           :html-link-home ,(format "https://%s/" my/website-domain)
           :html-head ,(my/publish-html-head 1)
           :html-preamble ,(my/publish-html-preamble 1)
           :html-postamble ,(my/publish-html-postamble 1)

           :preparation-function (my/publish-html-tags)
           :completion-function (org-publish-rss))
          ("site"
           :components ("site.static" "site.pages" "site.posts")))))
