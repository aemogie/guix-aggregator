function xdg-user-directory
    eval (string join '' 'echo $XDG_' \
           (string replace '@' '' (string upper $argv[1])) \
                         '_DIR')
end

function bang-bang-k
    set -l k (string replace '!!:' '' $argv[1])
    set -l arr (string replace -ra '([^\\\ ])( |\n)+' '$1\n' $history[1])
    echo $arr[$k]
end

function bang-star
    set -l arr (string replace -ra '([^\\\ ])( |\n)+' '$1\n' $history[1])
    string replace '!*' "$arr[..-2]" $argv[1]
end
