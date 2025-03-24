hook global KakEnd .* %{
  evaluate-commands 'state-save-reg-save colon'
  evaluate-commands 'state-save-reg-save pipe'
  evaluate-commands 'state-save-reg-save slash'
} # save kakoune state

hook global KakBegin .* %{
  evaluate-commands 'state-save-reg-load colon'
  evaluate-commands 'state-save-reg-load pipe'
  evaluate-commands 'state-save-reg-load slash'
} # restore kakoune state
