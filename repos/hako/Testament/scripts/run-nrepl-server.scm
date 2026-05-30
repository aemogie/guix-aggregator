;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (ares server)
             ;; Load reader extensions.
             (guix gexp))
(run-nrepl-server)
