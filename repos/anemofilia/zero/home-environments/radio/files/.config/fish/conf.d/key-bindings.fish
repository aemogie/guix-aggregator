set -l init_mode insert

if contains -- $argv[1] insert default visual
    set init_mode $argv[1]
else if set -q argv[1]
    # We should still go on so the bindings still get set.
    echo "Unknown argument $argv" >&2
end

# Inherit shared key bindings.
# Do this first so vi-bindings win over default.
for mode in insert default visual
    __fish_shared_key_bindings -s -M $mode
end

# Add a way to switch from insert to normal (command) mode.
# Note if we are paging, we want to stay in insert mode
# See #2871
bind -s --user -M insert \e "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint-mode; end"

# Default (command) mode
bind -s --user :q exit
bind -s --user -m insert \cc cancel-commandline repaint-mode
bind -s --user -M default h backward-char
bind -s --user -M default l forward-char
bind -s --user -M visual h begin-selection backward-char
bind -s --user -M visual l begin-selection forward-char
bind -s --user -m insert \n execute
bind -s --user -m insert \r execute
bind -s --user -m insert o insert-line-under repaint-mode
bind -s --user -m insert O insert-line-over repaint-mode
bind -s --user -m insert i repaint-mode
bind -s --user -m insert I beginning-of-line repaint-mode
bind -s --user -m insert a forward-single-char repaint-mode
bind -s --user -m insert A end-of-line repaint-mode

# Selection keys (if in default mode)
bind -s --user -M default -m visual H begin-selection backward-char
bind -s --user -M default -m visual L begin-selection forward-char
bind -s --user -M default -m visual J begin-selection down-or-search
bind -s --user -M default -m visual K begin-selection up-or-search
bind -s --user -M default -m visual x beginning-of-line begin-selection end-of-line
# TODO: Implement x when already in visual mode
# (if already in visual mode)
bind -s --user -M visual H backward-char
bind -s --user -M visual L forward-char
bind -s --user -M visual J backward-char
bind -s --user -M visual K backward-char

# Goto keys
bind -s --user gh end-selection beginning-of-line
bind -s --user gj end-selection end-of-buffer
bind -s --user gk end-selection beginning-of-buffer
bind -s --user gl end-selection end-of-line
bind -s --user gg end-selection beginning-of-buffer

# (Goto+Selection) keys
bind -s --user -M default -m visual gH begin-selection beginning-of-line
bind -s --user -M default -m visual gJ begin-selection end-of-buffer
bind -s --user -M default -m visual gK begin-selection beginning-of-buffer
bind -s --user -M default -m visual gL begin-selection end-of-line
bind -s --user -M visual gH beginning-of-line
bind -s --user -M visual gJ end-of-buffer
bind -s --user -M visual gK beginning-of-buffer
bind -s --user -M visual gL end-of-line

# Undo keys
bind -s --user u undo
bind -s --user U redo

# History navigation
bind -s --user / history-pager --sets-mode insert repaint

bind -s --user k up-or-search
bind -s --user j down-or-search
bind -s --user b -m visual backward-word
bind -s --user B -m visual backward-bigword
bind -s --user w -m visual forward-word forward-single-char
bind -s --user W -m visual forward-bigword forward-single-char

# Backspace deletes a char in insert mode
bind -s --user -M insert -k backspace backward-delete-char
bind -s --user -M insert \ch backward-delete-char
bind -s --user -M insert \x7f backward-delete-char

bind -s --user -M visual d kill-selection

bind -s --user '~' togglecase-char forward-single-char
bind -s --user gu downcase-word
bind -s --user gU upcase-word

bind -s --user J end-of-line delete-char
bind -s --user K 'man (commandline -t) 2>/dev/null; or echo -n \a'

bind -s --user y yank-selection

bind -s --user -m normal -M visual f forward-jump
bind -s --user -m normal -M visual t forward-jump-till
bind -s --user -m normal -M visual F backward-jump
bind -s --user -m normal -M visual T backward-jump-till

bind -s --user p forward-char yank
bind -s --user P yank
bind -s --user gp yank-pop

# same vim 'pasting' note as upper
bind -s --user '"*p' forward-char "commandline -i ( xsel -p; echo )[1]"
bind -s --user '"*P' "commandline -i ( xsel -p; echo )[1]"

#
# Lowercase r, enters replace_one mode
#
bind -s --user -m replace_one r repaint-mode
bind -s --user -M replace_one -m default '' delete-char self-insert backward-char repaint-mode
bind -s --user -M replace_one -m default \r 'commandline -f delete-char; commandline -i \n; commandline -f backward-char; commandline -f repaint-mode'
bind -s --user -M replace_one -m default \e cancel repaint-mode

#
# Uppercase R, enters replace mode
#
bind -s --user -m replace R repaint-mode
bind -s --user -M replace '' delete-char self-insert
bind -s --user -M replace -m insert \r execute repaint-mode
bind -s --user -M replace -m default \e cancel repaint-mode

bind -s --user -M visual -m insert c kill-selection end-selection repaint-mode
bind -s --user -M visual -m default '~' togglecase-selection end-selection repaint-mode

bind -s --user -M visual -m default \cc end-selection repaint-mode
bind -s --user -M visual -m default \e end-selection repaint-mode

# Make it easy to turn an unexecuted command into a comment in the shell history. Also, remove
# the commenting chars so the command can be further edited then executed.
bind -s --user -M default \# __fish_toggle_comment_commandline
bind -s --user -M visual \# __fish_toggle_comment_commandline
bind -s --user -M replace \# __fish_toggle_comment_commandline

# Set the cursor shape
# After executing once, this will have defined functions listening for the variable.
# Therefore it needs to be before setting fish_bind_mode.
set -g fish_vi_cursor             inclusive
set -g fish_cursor_selection_mode inclusive

set fish_bind_mode $init_mode
