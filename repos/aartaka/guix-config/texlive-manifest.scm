(use-modules (gnu packages)
             (gnu packages compression)
             (gnu packages fonts)
             (gnu packages tex)
             (gnu packages texlive)

             (guix packages))

(packages->manifest
 (list texlive
       texlive-biber texlive-biblatex texlive-bibtex texlive-beamer
       texlive-natbib texlive-fontspec texlive-polyglossia
       texlive-cyrillic
       font-tex-gyre
       zziplib))
