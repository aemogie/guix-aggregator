(setf org-static-blog-publish-title my/website-title
      org-static-blog-publish-url (format "https://%s/" my/website-domain)
      org-static-blog-publish-directory my/website-local-directory
      org-static-blog-posts-directory (concat my/website-local-directory "posts/")
      org-static-blog-drafts-directory (concat my/website-local-directory "drafts/")
      org-static-blog-preview-ellipsis "( . . . )"
      org-static-blog-preview-link-p t
      org-static-blog-enable-tags t
      org-export-with-toc t
      org-export-with-section-numbers t
      org-static-blog-use-preview t)

(defun org-static-blog-assemble-multipost-page
    (pub-filename post-filenames &optional front-matter)
  "Assemble a page that contains multiple posts one after another.
Posts are sorted in descending time."
  (setf post-filenames
        (sort post-filenames
              (lambda (filename-1 filename-2)
                (time-less-p (org-static-blog-get-date filename-2)
                             (org-static-blog-get-date filename-1)))))
  (let ((archive-file-url
         (org-static-blog-get-absolute-url org-static-blog-archive-file)))
    (org-static-blog-with-find-file
     pub-filename
     (org-static-blog-template
      org-static-blog-publish-title
      (concat
       (when front-matter front-matter)
       (apply 'concat (mapcar
                       (if org-static-blog-use-preview
                           'org-static-blog-get-preview
                         'org-static-blog-get-body)
                       post-filenames))
       (jack-html
        `(:div (@ :id "archive")
               (:a (@ :href ,archive-file-url)))))))))

(defun org-static-blog-post-taglist (post-filename)
  "Returns the tag list of the post.
This part will be attached at the end of the post, after
the taglist, in a <div id=\"taglist\">...</div> block."
  (let* ((tags (remove org-static-blog-rss-excluded-tag
                       (org-static-blog-get-tags post-filename)))
         (last-tag (car (last tags)))
         (tag-page-url (org-static-blog-get-absolute-url
                        org-static-blog-tags-file)))
    (jack-html
     `((:a (@ :href ,tag-page-url)
           "tags")
       ": "
       ,(mapcar (lambda (tag)
                  (let ((tag-url (org-static-blog-get-absolute-url
                                  (concat "tag-" (downcase tag) ".html"))))
                    (jack-html
                     `((:a (@ :href ,tag-url)
                           ,tag)
                       ,(if (eql tag last-tag) "" ", ")))))
                tags)))))

(defun org-static-blog-get-post-summary (post-filename)
  "Assemble post summary for an archive page.
This function is called for every post on the archive and
tags-archive page. Modify this function if you want to change an
archive headline."
  (let ((post-date (org-static-blog-get-date post-filename))
        (post-url (org-static-blog-get-post-url post-filename))
        (post-title (org-static-blog-get-title post-filename)))
    (jack-html
     `(:div (@ :id "post-archive")
            ,(format "%s - %s"
                     (format-time-string "%Y-%m-%d" post-date)
                     (jack-html
                      `(:a (@ :href ,post-url)
                           ,post-title)))))))

(defun org-static-blog-assemble-tags-archive-tag (tag)
  "Assemble single TAG for all filenames."
  (let ((post-filenames (cdr tag)))
    (setf post-filenames
	      (sort post-filenames (lambda (x y)
                                 (time-less-p (org-static-blog-get-date y)
						                      (org-static-blog-get-date x)))))
    (jack-html
     `((:h2 (@ :class "tags-title")
            ,(format "%s \"%s\":"
                     (org-static-blog-gettext 'posts-tagged)
                     (downcase (car tag))))
       ,(apply 'concat
               (mapcar 'org-static-blog-get-post-summary post-filenames))))))

(defun org-static-blog-assemble-tags-archive ()
  "Assemble the blog tag archive page.
The archive page contains single-line links and dates for every
blog post, sorted by tags, but no post body."
  (let ((tags-archive-filename (concat-to-dir org-static-blog-publish-directory
                                              org-static-blog-tags-file))
        (tag-tree (org-static-blog-get-tag-tree)))
    (setf tag-tree (sort tag-tree (lambda (x y)
                                    (string-greaterp (car y) (car x)))))
    (org-static-blog-with-find-file
     tags-archive-filename
     (org-static-blog-template
      org-static-blog-publish-title
      (jack-html
       `((:h1 (@ :class "title")
              "Tags")
         ,(apply 'concat
                 (mapcar 'org-static-blog-assemble-tags-archive-tag tag-tree))
         (:br)))))))

(defun org-static-blog-create-new-post (&optional draft)
  "Creates a new blog post.
Prompts for a title and proposes a file name. The file name is
only a suggestion; You can choose any other file name if you so
choose."
  (interactive)
  (let ((title (read-string (org-static-blog-gettext 'title))))
    (find-file (concat-to-dir
                (if draft
                    org-static-blog-drafts-directory
                  org-static-blog-posts-directory)
                (read-string (org-static-blog-gettext 'filename)
                             (format
                              "%s.org"
                              (replace-regexp-in-string "\s"
                                                        "-"
                                                        (downcase title))))))
    (insert "#+title: " title "\n"
            "#+date: " (format-time-string "<%Y-%m-%d>") "\n"
            "#+description: \n"
            "#+filetags: ")))

(setf org-static-blog-page-header
      (jack-html
       '((:meta (@ :name "author" :content ,user-full-name))
         (:meta (@ :name "referrer" :content "no-referrer"))
         (:meta (@ :name "viewport" :content "initial-scale=1,width=device-width,minimum-scale=1"))
         (:link (@ :rel "stylesheet" :href "static/css/style.css" :type "text/css"))
         (:link (@ :rel "icon" :href "static/images/icons/favicon.ico"))
         (:script (@ :id "MathJax-script" :src "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js")))))

(setf org-static-blog-index-front-matter (jack-html '(:h1 "Λ")))

(setf org-static-blog-page-preamble
      (jack-html
       `(:div (@ :class "navigation")
              (:a (@ :href ,org-static-blog-publish-url)
                  ,org-static-blog-publish-title)
              " | "
              (:a (@ :href ,my/code-repo)
                  (:img (@ :style "border-width:0" :src "static/images/icons/git-icon.png"))
                  " Code")
              " | "
              (:a (@ :href "rss.xml")
                  (:img (@ :style "border-width:0" :src "static/images/icons/rss-icon.png"))
                  " RSS"))))

(setf org-static-blog-page-postamble
      (jack-html
       `((:br)
         (:div (@ :id "archive")
               (:a (@ :href ,(format "%s/archive.html"
                                     org-static-blog-publish-url))
                   "other posts"))
         (:center
          (:div (@ :id "fineprint")
                (:a (@ :rel "license" :href "https://creativecommons.org/licenses/by-sa/4.0/")
                    (:img (@ :alt "Creative Commons License" :style "border-width:0" :src "https://i.creativecommons.org/l/by-sa/4.0/88x31.png")))
                (:br)
                (:span (@ :xmlns:dct "https://purl.org/dc/terms/" :href "https://purl.org/dc/dcmitype/Text" :property "dct:title" :rel "dct:type")
                       ,my/website-domain)
                " by "
                (:a (@ :xmlns:cc "https://creativecommons.org/ns#" :href ,org-static-blog-publish-url :property "cc:attributionName" :rel "cc:attributionURL")
                    ,user-full-name)
                " is licensed under a "
                (:a (@ :rel "license" :href "https://creativecommons.org/licenses/by-sa/4.0/")
                    "Creative Commons Attribution-ShareAlike 4.0 License")
                ".")))))

(defun org-static-blog-post-preamble (post-filename)
  "Returns the formatted date and headline of the post.
This function is called for every post and prepended to the post body.
Modify this function if you want to change a posts headline."
  (let ((post-date (org-static-blog-get-date post-filename))
        (post-url (org-static-blog-get-post-url post-filename))
        (post-title (org-static-blog-get-title post-filename)))
    (jack-html
     `((:div (@ :class "post-date")
             ,(format "posted on %s"
                      (format-time-string "%Y-%m-%d" post-date)))
       (:h1 (@ :class "post-title")
            (:a (@ :href ,post-url)
                ,post-title))))))

(defun org-static-blog-get-preview (post-filename)
  "Get title, date, tags from POST-FILENAME and get the first paragraph from the rendered HTML.
If the HTML body contains multiple paragraphs, include only the first paragraph,
and display an ellipsis.
Preamble and Postamble are excluded, too."
  (with-temp-buffer
    (insert-file-contents
     (org-static-blog-matching-publish-filename post-filename))
    (let ((post-title (org-static-blog-get-title post-filename))
          (post-url (org-static-blog-get-post-url post-filename))
          (post-date (org-static-blog-get-date post-filename))
          (post-taglist (org-static-blog-post-taglist post-filename))
          (post-ellipsis org-static-blog-preview-ellipsis)
          (preview-region (org-static-blog--preview-region)))
      (jack-html
       `((:h2 (@ :class "post-title")
              (:a (@ :href ,post-url)
                  ,post-title))
         (:div (@ :class "date")
               ,(format "posted on %s"
                        (format-time-string "%Y-%m-%d"
                                            post-date)))
         ,(org-static-blog--preview-region)
         (:a (@ :href ,post-url)
             ,post-ellipsis)
         (:br)
         (:br)
         (:div (@ :class "taglist")
               ,post-taglist)
         (:br)
         (:hr))))))
