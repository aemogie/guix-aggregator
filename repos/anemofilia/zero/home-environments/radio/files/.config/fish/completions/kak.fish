function __kak_git_files
    if git rev-parse --is-inside-work-tree 2>/dev/null
        git diff --name-only HEAD 2>/dev/null
        git ls-files --others --exclude-standard 2>/dev/null
    end
end

complete -c kak -a '(__kak_git_files)' -d 'git modified/untracked'
complete -c kak -F
