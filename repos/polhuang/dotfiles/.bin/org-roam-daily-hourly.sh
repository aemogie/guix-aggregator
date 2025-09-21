#!/usr/bin/env bash
set -euo pipefail

# --- Skip if you're away/locked ---
# Idle?
if [[ "$(loginctl show-user "$USER" -p IdleHint --value)" == "yes" ]]; then
  exit 0
fi
# Locked?
sid="$(loginctl list-sessions --no-legend | awk -v u="$USER" '$3==u{print $1; exit}')"
if [[ -n "${sid:-}" && "$(loginctl show-session "$sid" -p LockedHint --value)" == "yes" ]]; then
  exit 0
fi
# Wayland session present?
if [[ -z "${WAYLAND_DISPLAY:-}" && -z "${DISPLAY:-}" ]]; then
  exit 0
fi

# Ensure an emacs server is available (optional)
if ! emacsclient -e t >/dev/null 2>&1; then
  emacs --daemon || true
fi

# Show notification with two actions. When a button is pressed, notify-send
# prints the action key (here: "add" or "skip") to stdout. (--action implies --wait)
choice="$(
  notify-send \
    --app-name="Org-roam" \
    --urgency=normal \
    --icon=dialog-information \
    --action="add=Add" \
    --action="skip=Skip" \
    "Reminder: Add an org-roam-daily entry" \
    "Capture a quick note for today."
)"

case "${choice:-}" in
  add)
    # Open a new frame and run your capture
    emacsclient -c -a='' -e \
      "(progn
         (org-roam-dailies-capture-today)
         (delete-other-windows)
         (setq my/delete-frame-after-capture 1))" >/dev/null 2>&1 || true
    ;;
  skip|"" )
    # do nothing
    ;;
  * )
    # unknown action (shouldn't happen)
    ;;
esac
