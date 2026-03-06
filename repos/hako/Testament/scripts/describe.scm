;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (ice-9 pretty-print)
             (srfi srfi-26)
             (guix channels)
             (guix describe)
             (guix utils))

(with-atomic-file-output "channels.lock"
  (cut pretty-print `(list ,@(map channel->code (current-channels))) <>))
