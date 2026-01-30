#|General|#
set-option global source_local_kakrc true

#|Radix|#
declare-option str radix '~/areas/code/scm/radix'
define-command -override radix \
  -docstring 'edit files in the radix git repository' %{
  execute-keys ":e %opt{radix}/"
}

declare-option str radix_modules "%opt{radix}/radix"
define-command -override modules \
  -docstring 'edit radix modules' %{
  execute-keys ":e %opt{radix_modules}/"
}

declare-option str radix_services "%opt{radix_modules}/services"
define-command -override services \
  -docstring 'edit radix services' %{
  execute-keys ":e %opt{radix_services}/"
}

declare-option str radix_packages "%opt{radix_modules}/packages"
define-command -override packages \
  -docstring 'edit radix packages' %{
  execute-keys ":e %opt{radix_packages}/"
}

declare-option str radix_home_services "%opt{radix_modules}/home/services"
define-command -override home-services \
  -docstring 'edit radix home services' %{
  execute-keys ":e %opt{radix_home_services}/"
}

declare-option str zero '~/areas/code/scm/zero'
define-command -override zero \
  -docstring 'edit files in the zero git repository' %{
  execute-keys ":e %opt{zero}/"
}

#|Zero|#
declare-option str home "%opt{zero}/home-environments"
define-command -override home \
  -docstring 'edit home declaration' %{
  execute-keys ":e %opt{home}/"
}

declare-option str system "%opt{zero}/operating-systems"
define-command -override system \
  -docstring 'edit system declaration' %{
  execute-keys ":e %opt{system}/"
}

declare-option str home_files "%opt{home}/%sh{whoami}/files"
define-command -override files \
  -docstring 'edit dotfiles' %{
  execute-keys ":e %opt{home_files}/"
}
