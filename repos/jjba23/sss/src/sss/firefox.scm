;;; SSS - Supreme Sexp System

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

(define-module (sss firefox)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sxml simple)
  #:use-module (json)
  #:use-module (sss process))

(define (serialize-firefox-ini-setting s)
  (format #f "~a=~a"
          (car s)
          (cdr s)))

(define (serialize-firefox-userjs-setting s)
  (define (userjs-value-quoting v)
    (cond
      ((string? v)
       (format #f "`~a`" v))
      ((symbol? v)
       (format #f "`~a`" v))
      ((eq? #t v)
       "true")
      ((eq? #f v)
       "false")
      (else v)))
  (format #f "user_pref(~a, ~a);"
          (userjs-value-quoting (car s))
          (userjs-value-quoting (cdr s))))

(define sss-firefox-profile-default
  `((Name . default) (Path . "qwexsrf7.default")
    (IsRelative . 1)
    (Default . 0)))

(define sss-firefox-profile-sss
  `((Name . sss) (Path . sss)
    (IsRelative . 1)
    (Default . 1)))

(define sss-firefox-profile-general
  `((StartWithLastProfile . 1) (Version . 2)))

(define sss-firefox-profiles-config
  (append (list "" "[Profile0]")
          (map serialize-firefox-ini-setting sss-firefox-profile-default)
          (list "" "[Profile1]")
          (map serialize-firefox-ini-setting sss-firefox-profile-sss)
          (list "" "[General]")
          (map serialize-firefox-ini-setting sss-firefox-profile-general)))

(define sss-firefox-userjs-fastfox
  '((content.notify.interval . 100000)
    ;; gfx
    (gfx.canvas.accelerated.cache-size . 512)
    (gfx.content.skia-font-cache-size . 20)
    ;; disk cache
    (browser.cache.disk.enable . #f)
    ;; media cache
    (media.memory_cache_max_size . 65536)
    (media.cache_readahead_limit . 7200)
    (media.cache_resume_threshold . 3600)
    ;; image cache
    (image.mem.decode_bytes_at_a_time . 32768)
    ;; network
    (network.http.max-connections . 1800)
    (network.http.max-persistence-connections-per-server . 10)
    (network.http.max-urgent-start-excessive-connections-per-host . 5)
    (network.http.pacing.requests.enabled . #f)
    (network.dnsCacheExpiration . 3600)
    (network.ssl_tokens_cache_capacity . 10240)
    ;; speculative loading
    (network.dsn.disablePrefetch . #t)
    (network.dns.disablePrefetchFromHTTPS . #t)
    (network.prefetch-next . #f)
    (network.predictor.enabled . #f)
    (network.predictor.enable-prefetch . #f)
    ;; experimental
    (layout.css.grid-template-masonry-value.enabled . #t)))

(define sss-firefox-userjs-securefox
  '(
    
    ;; TRACKING PROTECTION
    (browser.contentblocking.category . strict)
    (browser.download.start_downloads_in_tmp_dir . #t)
    (browser.helperApps.deleteTempFileOnExit . #t)
    (browser.uitour.enabled . #f)
    (privacy.globalprivacycontrol.enabled . #t)

    ;; OCSP & CERTS / HPKP
    (security.OCSP.enabled . 0)
    (security.pki.crlite_mode . 2)

    ;; SSL / TLS
    (security.ssl.treat_unsafe_negotiation_as_broken . #t)
    (browser.xul.error_pages.expert_bad_cert . #t)
    (security.tls.enable_0rtt_data . #f)

    ;; DISK AVOIDANCE
    (browser.privatebrowsing.forceMediaMemoryCache . #t)
    (browser.sessionstore.interval . 60000)

    ;; SHUTDOWN & SANITIZING
    (browser.privatebrowsing.resetPBM.enabled . #t)
    (privacy.history.custom . #t)

    ;; SEARCH / URL BAR
    (browser.urlbar.trimHttps . #t)
    (browser.urlbar.untrimOnUserInteraction.featureGate . #t)
    (browser.search.separatePrivateDefault.ui.enabled . #t)
    (browser.urlbar.update2.engineAliasRefresh . #t)
    (browser.search.suggest.enabled . #f)
    (browser.urlbar.quicksuggest.enabled . #f)
    (browser.urlbar.groupLabels.enabled . #f)
    (browser.formfill.enable . #f)
    (network.IDN_show_punycode . #t)

    ;; PASSWORDS
    (signon.formlessCapture.enabled . #f)
    (signon.privateBrowsingCapture.enabled . #f)
    (network.auth.subresource-http-auth-allow . 1)
    (editor.truncate_user_pastes . #f)

    ;; MIXED CONTENT + CROSS-SITE
    (security.mixed_content.block_display_content . #t)
    (pdfjs.enableScripting . #f)

    ;; EXTENSIONS
    (extensions.enabledScopes . 5)

    ;; HEADERS / REFERERS
    (network.http.referer.XOriginTrimmingPolicy . 2)

    ;; CONTAINERS
    (privacy.userContext.ui.enabled . #t)

    ;; SAFE BROWSING
    (browser.safebrowsing.downloads.remote.enabled . #f)

    ;; MOZILLA
    (permissions.default.desktop-notification . 2)
    (permissions.default.geo . 2)
    (geo.provider.network.url . "https://beacondb.net/v1/geolocate")
    (browser.search.update . #f)
    (permissions.manager.defaultsUrl . "")

    ;; TELEMETRY
    (datareporting.policy.dataSubmissionEnabled . #f)
    (datareporting.healthreport.uploadEnabled . #f)
    (toolkit.telemetry.unified . #f)
    (toolkit.telemetry.enabled . #f)
    (toolkit.telemetry.server . "data:,")
    (toolkit.telemetry.archive.enabled . #f)
    (toolkit.telemetry.newProfilePing.enabled . #f)
    (toolkit.telemetry.shutdownPingSender.enabled . #f)
    (toolkit.telemetry.updatePing.enabled . #f)
    (toolkit.telemetry.bhrPing.enabled . #f)
    (toolkit.telemetry.firstShutdownPing.enabled . #f)
    (toolkit.telemetry.coverage.opt-out . #t)
    (toolkit.coverage.opt-out . #t)
    (toolkit.coverage.endpoint.base . "")
    (browser.newtabpage.activity-stream.feeds.telemetry . #f)
    (browser.newtabpage.activity-stream.telemetry . #f)

    ;; EXPERIMENTS
    (app.shield.optoutstudies.enabled . #f)
    (app.normandy.enabled . #f)
    (app.normandy.api_url . "")

    ;; CRASH REPORTS
    (breakpad.reportURL . "")
    (browser.tabs.crashReporting.sendReport . #f)

    ;; DETECTION
    (captivedetect.canonicalURL . "")
    (network.captive-portal-service.enabled . #t)
    (network.connectivity-service.enabled . #t)))

(define sss-firefox-ui-customization
  `((placements (widget-overflow-fixed-list . #())
                (unified-extensions-area . #())
                (nav-bar . #(firefox-view-button alltabs-button reset-pbm-toolbar-button unified-extensions-button bookmarks-menu-button home-button developer-button customizableui-special-spring2 back-button forward-button urlbar-container customizableui-special-spring3 vertical-spacer sidebar-button find-button history-panelmenu downloads-button))
                (toolbar-menubar . #(menubar-items))
                (TabsToolbar . #())
                (vertical-tabs . #(tabbrowser-tabs))
                (PersonalToolbar . #(import-button personal-bookmarks)))
    (seen . #(reset-pbm-toolbar-button developer-button))
    (dirtyAreaCache . #(nav-bar TabsToolbar vertical-tabs PersonalToolbar toolbar-menubar))
    (currentVersion . 22)
    (newElementCount . 3)))

(define sss-firefox-userjs-peskyfox
  `(
    
    ;; Firefox UI
    (browser.privatebrowsing.vpnpromourl . "")
    (extensions.getAddons.showPane . #f)
    (extensions.htmlaboutaddons.recommendations.enabled . #f)
    (browser.discovery.enabled . #f)
    (browser.shell.checkDefaultBrowser . #f)
    (browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons . #f)
    (browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features . #f)
    (browser.preferences.moreFromMozilla . #f)
    (browser.aboutConfig.showWarning . #f)
    (browser.aboutwelcome.enabled . #f)
    (browser.profiles.enabled . #t)
    (browser.ml.chat.enabled . #f)
    (browser.uiCustomization.state unquote
                                   (scm->json-string
                                    sss-firefox-ui-customization))

    ;; Sidebar
    (sidebar.main.tools . "history,bookmarks")
    (sidebar.new-sidebar.has-used . #t)
    (sidebar.revamp . #t)
    (sidebar.verticalTabs . #t)

    ;; Theme adjustments
    (toolkit.legacyUserProfileCustomizations.stylesheets . #t)
    (browser.compactmode.show . #t)
    (browser.privateWindowSeparation.enabled . #f)

    ;; Fullscreen notice
    (full-screen-api.transition-duration.enter . "0 0")
    (full-screen-api.transition-duration.leave . "0 0")
    (full-screen-api.warning.timeout . 0)

    ;; Url bar
    (browser.toolbars.bookmarks.visibility . never)
    (browser.urlbar.unitConversion.enabled . #t)
    (browser.urlbar.trending.featureGate . #f)
    (dom.text_fragments.create_text_fragment.enabled . #t)

    ;; New tab page
    (browser.newtabpage.activity-stream.default.sites . "")
    (browser.newtabpage.activity-stream.showSponsoredTopSites . #f)
    (browser.newtabpage.activity-stream.feeds.section.topstories . #f)
    (browser.newtabpage.activity-stream.showSponsored . #f)

    ;; Pocket
    (extensions.pocket.enabled . #f)

    ;; Downloads
    (browser.download.manager.addToRecentDocs . #f)

    ;; PDF
    (browser.download.open_pdf_attachments_inline . #t)

    ;; Tab behavior
    (browser.bookmarks.openInTabClosesMenu . #f)
    (browser.menu.showViewImageInfo . #t)
    (findbar.highlightAll . #t)
    (layout.word_select.eat_space_to_next_word . #f)

    ;; Wallet
    (wallet.enabled . #f)

    ;; Bookmarks
    (browser.bookmarks.file . "~/.mozilla/firefox/sss/user-bookmarks.html")
    (browser.places.importBookmarksHTML . #t)
    (browser.bookmarks.addedImportButton . #f)

    ))

(define sss-firefox-userjs-config
  (map serialize-firefox-userjs-setting
       (append sss-firefox-userjs-fastfox sss-firefox-userjs-securefox
               sss-firefox-userjs-peskyfox)))

(begin
  (define* (sss-firefox-userchrome-css #:key palette)
    `(("*" (font-family . "\"Adwaita Sans\", sans-serif !important "))))
  (export sss-firefox-userchrome-css))

(define (serialize-sss-firefox-bookmark b)
  (cond
    ((list? (cdr b))
     `((dt (h3 ,(car b)))
       (dl ,(map serialize-sss-firefox-bookmark
                 (cdr b)))))
    ((string? (cdr b))
     `((dt (a (@ (href ,(cdr b)))
              ,(car b)))))))

(define sss-firefox-bookmarks
  '(("jointhefreeworld"
     ("jointhefreeworld.org" . "https://jointhefreeworld.org")
     ("wikimusic" . "https://wikimusic.jointhefreeworld.org")
     ("lucidplan" . "https://lucidplan.jointhefreeworld.org")
     ("byggsteg" . "https://byggsteg.jointhefreeworld.org")
     ("oculuslambda" . "https://oculuslambda.jointhefreeworld.org")
     ("hygguile" . "https://hygguile.jointhefreeworld.org"))
    ("jjba23 codeberg" . "https://codeberg.org/jjba23")
    ("socials" ("whatsapp" . "https://web.whatsapp.com/")
     ("mastodon" . "https://mastodon.social"))))

(define serialized-firefox-bookmarks
  `(dl ,(map serialize-sss-firefox-bookmark sss-firefox-bookmarks)))

(begin
  (define* (sss-firefox-capability #:key palette)
    `((".mozilla/firefox/profiles.ini" ,(plain-file "profiles.ini"
                                                    (string-join
                                                     sss-firefox-profiles-config
                                                     "\n")))
      (".mozilla/firefox/sss/user.js" ,(plain-file "user.js"
                                                   (string-join
                                                    sss-firefox-userjs-config
                                                    "\n")))
      (".mozilla/firefox/sss/user-bookmarks.html" ,(plain-file
                                                    "user-bookmarks.html"
                                                    (with-output-to-string (lambda ()
                                                                             (sxml->xml
                                                                              serialized-firefox-bookmarks)))))
      (".mozilla/firefox/sss/chrome/userChrome.css" ,(plain-file
                                                      "userChrome.css"
                                                      (mk-css-conf-lines (sss-firefox-userchrome-css
                                                                          #:palette
                                                                          palette))))))
  (export sss-firefox-capability))

