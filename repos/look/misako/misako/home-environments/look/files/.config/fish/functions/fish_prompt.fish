function fish_prompt

	set -l null "\x02"
	set -l git (fish_vcs_prompt $null)
	set -l user $USER
	set -l prompt_hostname (prompt_hostname)
	set -l pwd (prompt_pwd)
	set -l user_type '$'
	set -l suffix ":"
	set -l normal (set_color normal)
	set -l bold (set_color --bold)
	set -l blue (set_color blue)
	set -l red (set_color red)
	set -l green (set_color green)
	set -l purple (set_color purple)
	set -l brred (set_color brred)

    if functions -q fish_is_root_user; and fish_is_root_user
        set -l user_type '#'
    end

    if test -n "$GUIX_ENVIRONMENT"
		echo -s $normal $bold "(" $purple $bold (basename $GUIX_ENVIRONMENT) $normal $bold ")"
		echo -s -n $normal $bold ' ↪ '
    end

	if ! test -z $git
		echo -s -n $normal $bold "(" $green $bold $git $normal $bold ")" " "
	end

	echo -n -s $brred $bold $user $normal $bold @ $blue $bold $prompt_hostname " " $normal $bold in " " $red $bold $pwd " " $normal $bold $user_type $suffix " " $normal
end

