hook -group config global WinSetOption filetype=scheme %{
  add-highlighter window/ column 85 StatusLine
  set-option window indentwidth 2

  set-option window auto_pairs ( ) [ ] '"' '"' '{' '}'
  evaluate-commands enable-auto-pairs

  set-option window lsp_servers %{
    [guile-language-server]
    filetypes = ["scheme"]
    command = "guile-lsp-server"
    args = ["--stdio"]
  }

  evaluate-commands rainbow-enable-window

  declare-option str snippet
  set-option -add global snippets 'shebang' '@scm' %{
    snippets-insert '#!/usr/bin/env -S guile$n!#'
    nop %sh{ chmod u+x $kak_buffile }
  }
  set-option -add window snippets 'origin' '@ori' %{
    snippets-insert %sh{
      printf '
(origin
 (method ${})
 (uri (git-reference
       (url "${}")
       (commit "${}")))
 (file-name (git-file-name name version))
 (sha256
  (base32 "${0000000000000000000000000000000000000000000000000000}")))' \
      | kak -f 'gkd%s\n<ret>c$n<esc>glHd'
    }
    phantom-selection-add-selection
    phantom-selection-iterate-next
  }
  set-option -add window snippets 'package' '@pkg' %{
    snippets-insert %sh{
      printf '
(package
  (name "${}")
  (version "${}")
  (source ${})
  (build-system ${}-build-system)
  (synopsis "${}")
  (description "${}")
  (home-page "${}")
  (license license:${}))' \
      | kak -f 'gkd%s\n<ret>c$n<esc>glHd'
    }
    phantom-selection-add-selection
    phantom-selection-iterate-next
  }
  set-option -add window snippets 'module' '@pmod' %{
    snippets-insert %sh{
      printf "
(define-module (radix packages \${$(basename $kak_buffile | sed 's/\.scm//')})
  #:use-module (guix build-system \${})
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils))" \
      | kak -f 'gkd%s\n<ret>c$n<esc>glHd'
    }
    phantom-selection-add-selection
    phantom-selection-iterate-next
  }
}
