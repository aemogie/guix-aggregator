function __guix_shell --on-variable PWD
    grep -qx $PWD ~/.config/guix/shell-authorized-directories && guix shell
end
