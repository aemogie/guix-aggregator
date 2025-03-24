(in-package :stumpwm)

;; Setting up the prefix key
(set-prefix-key (kbd "s-/"))

;; Setting up Modules
(set-module-dir "~/.dotfiles/.stumpwm.d/modules/")

(load-module "swm-gaps")
(load-module "amixer")
(load-module "binwarp")
(load-module "winner-mode")
(load-module "scratchpad")
(load-module "end-session")
;(load-module "notify")
(load-module "mpd")

;; Setting up windows
(setf *message-window-gravity* :center
      *input-window-gravity* :center
      *window-border-style* :thin
      *message-window-padding* 10
      *maxsize-border-width* 1
      *normal-border-width* 3
      *transient-border-width* 2
      stumpwm::*float-window-border* 0
      stumpwm::*float-window-title-height* 0
      *mouse-focus-policy* :click)


;; Setting up colors
(setf *colors* (list "#1C2028"      ; 0 black
                     "#BF616A"      ; 1 red
                     "#A3BE8C"      ; 2 green
                     "#EBCB8B"      ; 3 yellow
                     "#5E81AC"      ; 4 blue
                     "#B48EAD"      ; 5 magenta
                     "#8FBCBB"      ; 6 cyan
                     "#ECEFF4"))    ; 7 white
(when *initializing*
  (update-color-map (current-screen)))

;; Setting up workspaces
(defvar *ce/workspaces* (list "1" "2" "3" "4" "5" "6" "7" "8" "9"))
(stumpwm:grename (nth 0 *ce/workspaces*))
(dolist (workspace (cdr *ce/workspaces*))
  (stumpwm:gnewbg workspace))
(defvar *move-to-keybinds* (list "1" "2" "3" "4" "5" "6" "7" "8" "9"))
(dotimes (y (length *ce/workspaces*))
  (let ((workspace (write-to-string (+ y 1))))
    (define-key *root-map* (kbd workspace) (concat "gselect " workspace))
    (define-key *root-map* (kbd (nth y *move-to-keybinds*)) (concat "gmove-and-follow " workspace))))

;; We need a terminal!
; (run-shell-command "exec $HOME/scripts/script.sh")
(defvar *alacritty* "exec LIBGL_ALWAYS_SOFTWARE=1 alacritty")
;;(defcommand alacritty-hsplit () ()
;; (hsplit)
;; (move-focus :right)
;; (*alacritty*))

(define-key *top-map* (kbd "s-RET") "exec alacritty")
;;(defien-key *top-map* (kbd "s-S-RET") "alacritty-hsplit")
(define-key *top-map* (kbd "s-C-RET") "exec xst")

;; Kill a window but also murder the frame, because we can't waste another 3 keypresses to do that!
(defcommand del-win-and-frame ()()
            (delete-window)
            (remove-split))

;; Setting up keybindings for movements
(define-key *top-map* (kbd "s-h") "move-focus left")
(define-key *top-map* (kbd "s-j") "move-focus down")
(define-key *top-map* (kbd "s-k") "move-focus up")
(define-key *top-map* (kbd "s-l") "move-focus right")
(define-key *top-map* (kbd "s-H") "move-window left")
(define-key *top-map* (kbd "s-J") "move-window down")
(define-key *top-map* (kbd "s-K") "move-window up")
(define-key *top-map* (kbd "s-L") "move-window right")
(define-key *top-map* (kbd "s-f") "fullscreen")
(define-key *top-map* (kbd "s-F") "float-this")
(define-key *top-map* (kbd "s-q")  "del-win-and-frame")
(define-key *root-map* (kbd "SPC") "unfloat-this")

(setf *menu-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "k")   'menu-up)
        (define-key m (kbd "j")   'menu-down)
        (define-key m (kbd "SPC") 'menu-finish)
        (define-key m (kbd "RET") 'menu-finish)
        (define-key m (kbd "ESC") 'menu-abort)
        m))
;;
;; turn on/off the mode line for the current head only.
(define-key *root-map* (kbd "B") "mode-line")

;;; Scratchpads
;; ;; Toggle-able Scratchpads
(defcommand scratchpad-term () ()
            (scratchpad:toggle-floating-scratchpad "st" *alacritty*
                                                   :initial-gravity :center
                                                   :initial-width 800
                                                   :initial-height 500))
(define-key *top-map*  (kbd "s-S-RET") "scratchpad-term")

;; Frames
;; Instead of just creating an empty frame, create a horizontal split and focus on the right window
(defcommand hsplit-focus () ()
            (hsplit)
            (move-focus :right))

;;Instead of just creating an empty frame, create a vertical split and focus on the bottom window
(defcommand vsplit-focus () ()
            (vsplit)
            (move-focus :down))

(defvar *frame-map* nil
  "To manage frames better")
(setf *frame-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "v")   "vsplit-focus")
        (define-key m (kbd "s")   "hsplit-focus")
        (define-key m (kbd "e")   "expose")
        (define-key m (kbd "x")   "remove")
        (define-key m (kbd "r")   "iresize")
        (define-key m (kbd "m")   "pull-hidden-next")
        m))
(define-key *root-map* (kbd "f") '*frame-map*)

(setf *resize-increment* 25)

;; Customizing Groups
; Dealing with dynamic groups
(setf *dynamic-group-master-split-ration* 1/2)

(defvar *group-map* nil
  "Keymap for doing stuffs to groups")
(setf *group-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "g")   "groups")
        (define-key m (kbd "C-n") "gnext")
        (define-key m (kbd "C-p") "gprev")
        (define-key m (kbd ":") "gnext")
        (define-key m (kbd "L") "gprev")
        (define-key m (kbd "quoteright")   "gselect")
        (define-key m (kbd "l")    "grouplist")
        (define-key m (kbd "n")   "gnew")
        (define-key m (kbd "f")   "gnew-float")
        (define-key m (kbd "N")   "gnewbg")
        (define-key m (kbd "F")   "gnewbg-float")
        (define-key m (kbd "k")   "gkill")
        (define-key m (kbd "m")   "gmove")
        (define-key m (kbd "r")   "grename")
        (define-key m (kbd "1")   "gselect 1")
        (define-key m (kbd "2")   "gselect 2")
        (define-key m (kbd "3")   "gselect 3")
        (define-key m (kbd "4")   "gselect 4")
        (define-key m (kbd "5")   "gselect 5")
        (define-key m (kbd "6")   "gselect 6")
        (define-key m (kbd "7")   "gselect 7")
        (define-key m (kbd "8")   "gselect 8")
        (define-key m (kbd "9")   "gselect 9")
        (define-key m (kbd "0")   "gselect 10")
        m))
(define-key *root-map* (kbd "g") '*group-map*)


;; Some useful keybindings for custom scripts
(defvar *script-map* nil
  "Keymaps for running custom scripts.")
(setf *script-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "Sys_Req")  "exec ~/.local/bin/maimpick")
        (define-key m (kbd "C-SunPrint_Screen")  "exec dmenurecord")
        (define-key m (kbd "C-Sys_Req") "exec dmenurecord kill") ; Shift + SunPrint_Screen is understood as Sys_Req by StumpWM
        (define-key m (kbd "C-c") "exec clipmenu")
        (define-key m (kbd "p")   "exec $HOME/audio/pulseaudio_snapshot.sh")
        (define-key m (kbd "Scroll_Lock") "exec killall screenkey || screenkey &")
        (define-key m (kbd "F12") "exec setxkbmap -option caps:escape && notify-send 'Remapping ESC to CAPS'")
        (define-key m (kbd "F9")  "exec dmenumount")
        (define-key m (kbd "F10") "exec dmenuumount")
;;        (define-key m (kbd "w") "exec wal -i '/mnt/LDisk-E/Albert Einstein/THE UNIVERSE/WALLPAPERS/'")
        (define-key m (kbd "w") "exec feh --bg-fill --randomize '/mnt/LDisk-E/Albert Einstein/THE UNIVERSE/WALLPAPERS/'")
	(define-key m (kbd "b") "exec /usr/bin/bookmark")
	(define-key m (kbd "C-b") "exec xdotool type $(grep -v '^#' ~/Sync/bookmarks.txt| dmenu -i -l 50 | cut -d' ' -f1)")
        (define-key m (kbd "r")   "exec dbib")
        m))
(define-key *root-map* (kbd "s")  '*script-map*)

;; Closing programs
(define-key *top-map* (kbd "s-q") "delete")
(define-key *root-map* (kbd "r") "remove")


;; Well we gotta get out when we want
(defparameter *threads* '())
(defun kill-all-threads ()
  (loop for th in *threads*
        do
        (if (sb-thread:thread-alive-p th) (sb-thread:terminate-thread th))))

(defcommand better-restart () ()
            (kill-all-threads)
            (eval-command "restart-hard"))

(defcommand better-quit () ()
            (let ((output (string-downcase (completing-read
                                             (current-screen)
                                             "Command: "
                                             (list "restart" "shutdown" "log out" "suspend" "sleep" "hibernate")))))
              (if (string/= output "")
                  (cond ((string= output "restart")
                         (kill-all-threads)
                         (run-shell-command "reboot"))
                        ((string= output "shutdown")
                         (kill-all-threads)
                         (run-shell-command "shutdown -h now"))
                        ((string= output "log out")
                         (kill-all-threads)
                         (eval-command "quit"))
                        ((or (string= output "suspend") (string= output "sleep"))
                         (run-shell-command "systemctl suspend"))
                        ((string= output "hibernate")
                         (run-shell-command "systemctl hibernate"))
                        (t (echo "Please enter restart, shutdown, log out, suspend or hibernate."))))))

;; Closing StumpWM
(define-key *top-map* (kbd "s-Delete") "better-quit")
(define-key *root-map* (kbd "R") "better-restart")

;; Closing the whole thing
(defvar *shut-map* nil
  "Keymap for shutting things down.")
(setf *shut-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "S-Delete")   "exec reboot")
        (define-key m (kbd "C-Delete")   "exec poweroff")
        (define-key m (kbd "M-Delete")   "exec pkill -u divya")
        m))
(define-key *root-map* (kbd "Delete") '*shut-map*)


;; Mangaing Gaps
(defcommand increase-gaps () ()
            (setf swm-gaps:*outer-gaps-size* (+ swm-gaps:*outer-gaps-size* 5)
                  swm-gaps:*inner-gaps-size* (+ swm-gaps:*inner-gaps-size* 5))
            (swm-gaps:toggle-gaps)
            (swm-gaps:toggle-gaps))

(defcommand decrease-gaps () ()
            (setf swm-gaps:*outer-gaps-size* (- swm-gaps:*outer-gaps-size* 5)
                  swm-gaps:*inner-gaps-size* (- swm-gaps:*inner-gaps-size* 5))
            (swm-gaps:toggle-gaps)
            (swm-gaps:toggle-gaps))

(defvar *gaps-map* nil
  "Keymaps for toggling and changing gaps.")
(setf *gaps-map*
      (let ((m(make-sparse-keymap)))
        (define-key m (kbd "t")      "toggle-gaps")
        (define-key m (kbd "x")      "increase-gaps")
        (define-key m (kbd "z")      "decrease-gaps")
        m))
(define-key *root-map* (kbd "o")  '*gaps-map*)

;; prompt the user for an interactive command. The first arg is an
;; optional initial contents.
(defcommand colon1 (&optional (initial "")) (:rest)
            (let ((cmd (read-one-line (current-screen) ": " :initial-input initial)))
              (when cmd
                (eval-command cmd t))))

;; Dmenu
(define-key *top-map* (kbd "s-d") "exec dmenu_run")

;; Browse somewhere
(define-key *top-map* (kbd "s-w") "exec $BROWSER")

;;  Don't surf, jump the web!
(defmacro make-web-jump (name url-prefix)
  `(defcommand ,name (search)
               ((:rest ,(concatenate 'string (symbol-name name) ": ")))
               "Search web"
               (run-shell-command (format nil "vieb '~A'"
                                          (concat ,url-prefix (substitute #\+ #\Space search))))))

(make-web-jump duckduckgo "https://www.duckduckgo.com/?q=")
(make-web-jump scihub 	  "http://sci-hu.se/")
(make-web-jump zlib 	  "https://1lib.in/s/")
(make-web-jump music      "https://music.youtube.com/search?q=")
(make-web-jump gaana      "https://gaana.com/search/")
(make-web-jump wikipedia  "https://en.wikipedia.org/wiki/Special:Search?fulltext=Search&search=")
(make-web-jump youtube    "https://youtube.com/results?search_query=")
(make-web-jump awiki      "https://wiki.archlinux.org/index.php/Special:Search?fulltext=Search&search=")
(make-web-jump pac        "https://www.archlinux.org/packages/?q=")
(make-web-jump aur        "https://aur.archlinux.org/packages.php?K=")

; Mapping the jumpings
(defvar *web-map* nil
  "Keymap for searching the web")
(setf *web-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "g") "gaana")
        (define-key m (kbd "w") "wikipedia")
        (define-key m (kbd "y") "youtube")
        (define-key m (kbd "a") "awiki")
        (define-key m (kbd "p") "pac")
        (define-key m (kbd "u") "aur")
        (define-key m (kbd "z") "zlib")
        (define-key m (kbd "d") "duckduckgo")
        (define-key m (kbd "m") "music")
        (define-key m (kbd "s") "scihub")
        m))
(define-key *root-map* (kbd "w") '*web-map*)

;; Using Binwarp to control the cursor with keyboard
(binwarp:define-binwarp-mode my-binwarp-mode "s-m" (:map *top-map*)
                             ((kbd "SPC") "ratclick 1")
                             ((kbd "RET") "ratclick 3")
                             ((kbd "h")   "binwarp left")
                             ((kbd "l")   "binwarp right")
                             ((kbd "j")   "binwarp down")
                             ((kbd  "k")   "binwarp up"))

;; Controlling Audio Stuff
;; (mpd:mpd-connect)
(defvar *music-map* nil
  "Keymap for controlling MPD and other audio stuff")
(setf *music-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "n") "exec st ncmpcpp")
        (define-key m (kbd "p") "exec mpc toggle")
        (define-key m (kbd ",") "exec mpc prev")
        (define-key m (kbd ".") "exec mpc next")
        (define-key m (kbd "S-.") "exec mpc repeat")
        (define-key m (kbd "[") "exec mpc seek -10")
        (define-key m (kbd "]") "exec mpc seek +10")
        (define-key m (kbd "S-[") "exec mpc seek -60")
        (define-key m (kbd "S-]") "exec mpc seek +60")
        m))
(define-key *root-map* (kbd "m") '*music-map*)

;; Shortcuts for opening certain directories quickly in lf
(defvar *alc-dir* "exec LIBGL_ALWAYS_SOFTWARE=1 alacritty -e lfrun")
(defvar *directories-map* nil
  "Keymaps for shortcuts to directories.")
(setf *directories-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "e")  "exec st lfrun '/mnt/LDisk-E/Albert Einstein'")
        (define-key m (kbd "m")  "exec st lfrun '/mnt/LDisk-E/Albert Einstein/Books & Resources/MIT OCW/Mathematics'")
        (define-key m (kbd "P")  "exec st lfrun '/mnt/LDisk-E/Albert Einstein/Books & Resources/Psychology'")
        (define-key m (kbd "p")  "exec st lfrun '/mnt/LDisk-E/Albert Einstein/Books & Resources/Philosophy'")
        (define-key m (kbd "l")  "exec st lfrun '/mnt/LDisk-E/Albert Einstein/Books & Resources/Literature'")
        (define-key m (kbd "w")  "exec st lfrun '/mnt/LDisk-E/Albert Einstein/Books & Resources/Writing'")
        (define-key m (kbd "b")  "exec st lfrun '/mnt/LDisk-E/Albert Einstein/Books & Resources/'")
        (define-key m (kbd "c")  "exec st lfrun '/home/divya/.config/'")
        (define-key m (kbd "h")  "exec st lfrun '/home/divya/'")
        (define-key m (kbd "s")   "exec st lfrun '/home/divya/.stumpwm.d/'")
      ;  (define-key m (kbd "S")   "exec st lfrun '/home/divya/scripts/'")
        m))
(define-key *root-map* (kbd "d") '*directories-map*)

;; Opening certain apps quickly
(defvar *apps-map* nil
  "Keymaps for certain applications")
(setf *apps-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "d") "exec flatpak run com.discordapp.Discord")
	(define-key m (kbd "a") "exec flatpak run net.ankiweb.Anki")
	(define-key m (kbd "s") "exec flatpak run com.stremio.Stremio")
        (define-key m (kbd "p") "exec pavucontrol")
        (define-key m (kbd "M") "exec st -e alsamixer")
        (define-key m (kbd "x") "exec xournalpp")
	(define-key m (kbd "t") "exec flatpak run org.telegram.desktop")
        (define-key m (kbd "c") "exec picom --backend glx")
        (define-key m (kbd "C") "exec killall picom")
        m))
(define-key *root-map* (kbd "a")  '*apps-map*)

;; Playing with layouts
(defvar *layouts-map* nil
  "Keymaps for different layouts")
(setf *layouts-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "a") "restore-from-file ~/.stumpwm.d/layouts/audio")
        (define-key m (kbd "c") "restore-from-file ~/.stumpwm.d/layouts/centered")
        (define-key m (kbd "d") "restore-from-file ~/.stumpwm.d/layouts/double-center")
        (define-key m (kbd "s") "restore-from-file ~/.stumpwm.d/layouts/stacked")
        (define-key m (kbd "g") "restore-from-file ~/.stumpwm.d/layouts/4-grid")
        (define-key m (kbd "G") "restore-from-file ~/.stumpwm.d/layouts/6-grid")
        m))
(define-key *root-map* (kbd "l") '*layouts-map*)

;; Running emacs from `emacsclient`
(define-key *root-map* (kbd "e") "exec emacsclient -c")
(define-key *root-map* (kbd "E") "exec emacsclient --eval '(emacs-everywhere)'")

;; Editing some Stump config files in emacs/vim
(define-key *root-map* (kbd "c") "exec st -e  vim ~/.stumpwm.d/init.lisp")
(define-key *root-map* (kbd "C-c") "exec emacsclient -c ~/.stumpwm.d/init.lisp")
(define-key *root-map* (kbd "C-s") "exec st -e vim /usr/bin/stumpstart")

;; Emacs-everywhere
(define-key *root-map* (kbd "C-e") "exec emacsclient --eval '(emacs-everywhere)'")

;; Clear rules
(clear-window-placement-rules)

;; Notifications
;(notify:notify-server-toggle)

;; So that when you use the devilish mouse, you can scroll and have the damn pointer
(run-shell-command "xsetroot -cursor_name left_ptr")
(setf (getenv "GDK_CORE_DEVICE_EVENTS") "1")

;; Start other things
;; (run-shell-command "sh stumpstart")

;; Wait there were no gaps?!
(setf swm-gaps:*inner-gaps-size* 0
      swm-gaps:*head-gaps-size* 0
      swm-gaps:*outer-gaps-size* 0)
;; There still aren't ;)

;;(when *initializing*
 ;; (increase-gaps))

;;(when *initializing*
 ;; (swm-gaps:toggle-gaps))

;; (when (and (< ow width)
;; 	   (>= width (- (frame-width frame) ow)))
;;   (setf width (- width ow)))

;; (when (and (< oh height)
;; 	   (>= height (- (stumpwm::frame-display-height (window-group win) frame) oh)))
;;   (setf height (- height oh))
;;   (message (princ-to-string height)))
