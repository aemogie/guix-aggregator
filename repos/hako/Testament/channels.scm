;;; SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later

(load "common.scm")

(list (channel
        (inherit %default-guix-channel)
        (url
         (if (file-exists? "/home/hako/Workspace/Guix")
             "file:///home/hako/Workspace/Guix"
             "https://git.boiledscript.com/hako/guix.git"))
        (branch "trunk"))
      (channel
        (inherit %channel-nonguix)
        (url
         (if (file-exists? "/home/hako/Workspace/Nonguix")
             "file:///home/hako/Workspace/Nonguix"
             "https://git.boiledscript.com/hako/nonguix.git"))
        (branch "trunk"))
      (channel
        (inherit %channel-rosenthal)
        (url
         (if (file-exists? "/home/hako/Workspace/Rosenthal")
             "file:///home/hako/Workspace/Rosenthal"
             "https://git.boiledscript.com/hako/rosenthal.git"))
        (branch "trunk"))
      %channel-sops-guix)
