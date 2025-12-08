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
(define-module (radix packages \${$(basename $kak_buffile .scm)})
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

  require-module scheme

  # Properly highlight signed numbers
  remove-highlighter shared/scheme/code/regex_(#[bB]#[eiEI]|#[eiEI]#[bB]|#[bB])[01]+_0:value
  add-highlighter shared/scheme/code/ regex '(#[bB]#[eiEI]|#[eiEI]#[bB]|#[bB])[+-]?[01]+' 0:value

  remove-highlighter shared/scheme/code/regex_(#[oO]#[eiEI]|#[eiEI]#[oO]|#[oO])[0-7]+_0:value
  add-highlighter shared/scheme/code/ regex '(#[oO]#[eiEI]|#[eiEI]#[oO]|#[oO])[+-]?[0-7]+' 0:value

  remove-highlighter shared/scheme/code/regex_(#[dD](#[eiEI])?|#[eiEI]#[dD]|#[eiEI])(\d+(?:\.\d*)?|\.\d+)([esfdlESFDL][-+]?\d+)?_0:value
  add-highlighter shared/scheme/code/ regex '(?<=\s)(#[dD](#[eiEI])?|#[eiEI]#[dD]|#[eiEI])?[+-]?(\d+(?:\.\d*)?|\.\d+)([esfdlESFDL][-+]?\d+)?' 0:value

  remove-highlighter shared/scheme/code/regex_(#[xX]#[eiEI]|#[eiEI]#[xX]|#[xX])[0-9a-fA-F]+_0:value
  add-highlighter shared/scheme/code/ regex '(#[xX]#[eiEI]|#[eiEI]#[xX]|#[xX])[+-]?[0-9a-fA-F]+' 0:value

  evaluate-commands %sh{ exec awk -f - <<'EOF'
    BEGIN {
      split("chain chain-and chain-lambda chain-when nest nest-reverse "\
            "with-monad mlet mlet* mbegin mwhen munless define-template "\
            "define-monad match match-lambda match-lambda* match-let "\
            "match-let* match-record match-record-lambda lambda* define* "\
            "define-inlinable define-module define-record-type*", keywords);

      # Macro expressions, imports/exports/library
      split("define-syntax-rule define-syntax-parameter", meta);

      # Basic operators.
      split(">>= ->", operators);

      # Builtins
      split("format with-input-from-string add-to-load-path use-modules "\
            "filter find find-tail count any every filter-map fold fold-right "\
            "first second third fourth fifth sixth seventh eighth ninth "\
            "tenth last last-pair list-index partition reduce reduce-right "\
            "remove span split-at take take-right take-while drop drop-right "\
            "drop-while delete unfold unfold-right lift0 lift1 lift2 lift3 "\
            "lift4 lift5 lift6 lift7 lift listm foldm mapm sequence anym "\
            "mparameterize run-with-state state-with-parameters", builtins);

      # Procedures that create a base type and their predicates
      split("cons*", types);

      non_word_chars="['\"\\s\\(\\)\\[\\]\\{\\};]";

      normal_identifiers="-!$%&\\*\\+\\./:<=>\\?@\\^_~a-zA-Z0-9";
      identifier_chars="[" normal_identifiers "][" normal_identifiers ",#]*";
    }
    function kak_escape(s) {
      gsub(/'/, "''", s);
      return "'" s "'";
    }
    function add_highlighter(regex, highlight) {
      printf("add-highlighter shared/scheme/code/ regex %s %s\n", kak_escape(regex), highlight);
    }
    function quoted_join(prefix, words, quoted, first) {
      first=1
      for (i in words) {
          if (!first) { quoted=quoted "|"; }
          quoted=quoted prefix "\\Q" words[i] "\\E";
          first=0;
      }
      return quoted;
    }
    function add_word_highlighter(prefix, words, face, regex) {
      regex = "(?<![" normal_identifiers "])(" quoted_join(prefix, words) ")(?![" normal_identifiers "])";
      add_highlighter(regex, "1:" face);
    }
    function print_words(words) {
      for (i in words) { printf(" %s", words[i]); }
    }

    BEGIN {
      printf("set-option -add current scheme_static_words ");
      print_words(keywords); print_words(meta); print_words(operators); print_words(builtins);
      printf("\n");

      add_word_highlighter("(?<=\\()", keywords, "keyword");
      add_word_highlighter("(?<=\\()", meta, "meta");
      add_word_highlighter("", operators, "operator");
      add_word_highlighter("", builtins, "function");
    }
  EOF
  }
}
