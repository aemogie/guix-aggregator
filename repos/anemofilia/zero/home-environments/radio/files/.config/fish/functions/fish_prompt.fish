# Utilities

function displayed_string_length
    string replace -ra -- '\x1b.*?[mGKH]' '' "$argv" | string length
end

function padding
    printf "%-"$argv[1]"s%s" " " "$output"
end

# Current working directory prompt
function fish_cwd_prompt
    set -l cwd (pwd)
    switch "$cwd"
        case "$HOME"
            printf "~"
        case "/"
            printf "/"
        case "*"
           set -l parent_dir (dirname "$cwd")
           switch "$parent_dir"
               case "$HOME"
                   printf "~/%s" (basename "$cwd")
               case "/"
                   printf "/%s" (basename "$cwd")
               case "*"
                   test (dirname "$parent_dir") = "/" && printf "/"
                   printf "%s/%s" (basename "$parent_dir") (basename "$cwd")
           end
    end
end

function fish_prompt
    # Color
    set -x red_or_blue (test "$USER" = "root" && printf "red" || printf "blue")

    function printc
        set_color $red_or_blue; printf $argv; set_color normal
    end

    # Guix environment prompt
    function fish_environment_prompt
        printf "(env "; printc "%s" $GUIX_ENVIRONMENT; printf ")"
    end

    if test -n "$GUIX_ENVIRONMENT"
        set -l fish_git_prompt (fish_git_prompt)
        set -l fish_environment_prompt (fish_environment_prompt)
        set -l fish_environment_prompt_length (displayed_string_length "$fish_environment_prompt")
        set -l fish_git_prompt_length (displayed_string_length "$fish_git_prompt")
        set -l fish_prompt_padding (math $COLUMNS - $fish_environment_prompt_length - $fish_git_prompt_length)

        printf "$fish_environment_prompt"
        printf (padding $fish_prompt_padding)
        printf "$fish_git_prompt\n"
    else
        function fish_right_prompt
            fish_git_prompt
        end
    end

    set -g fish_key_bindings fish_vi_key_bindings
    switch "$fish_key_bindings"
        case fish_vi_key_bindings fish_hybrid_key_bindings
            test $fish_bind_mode = 'default' && printf ':' || printf '+'
    end

    printc (whoami); printf ' at '; printc (prompt_hostname)
                     printf ' in '; printc (fish_cwd_prompt)
    printf ' > '
end

function fish_default_mode_prompt -d "Display vi prompt mode"
end
