#!/usr/bin/env sh
set -euo pipefail

STATE_CSS="/home/pol/.dotfiles/polterguix/files/waybar/org-clock-state.css"
DEFAULT_STATE="/* Not clocked in */"

# Function to write not-clocked state
write_not_clocked() {
    echo "$DEFAULT_STATE" > "$STATE_CSS" 2>/dev/null || true
}

# Check if emacsclient is available
if ! command -v emacsclient >/dev/null 2>&1; then
    write_not_clocked
    exit 0
fi

# Check if emacs server is running (with timeout)
if ! timeout 2s emacsclient -e t >/dev/null 2>&1; then
    write_not_clocked
    exit 0
fi

# Check org-clock status (with timeout)
clocking=$(timeout 2s emacsclient -e '(org-clocking-p)' 2>/dev/null || echo "nil")

if [[ "$clocking" == "t" ]]; then
    cat > "$STATE_CSS" << 'EOF'
window#waybar {
    background: alpha(#ea76cb, 0.3) !important;
    transition: background 0.5s ease-in-out;
}
EOF
else
    write_not_clocked
fi
