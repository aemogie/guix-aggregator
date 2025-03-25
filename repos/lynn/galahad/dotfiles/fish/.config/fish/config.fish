if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_prompt -d "Write out the left prompt"
    printf '%s~>' $USER
end

function fish_right_prompt -d "Write out the right prompt"
    printf '%s%s%s' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end
