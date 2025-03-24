function __guix_shell --on-variable PWD
    if test -n (grep -x $PWD ~/.config/guix/shell-authorized-directories)
        guix shell
    end
end
