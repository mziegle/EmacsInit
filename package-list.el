(defvar mypackages '(airline-themes anaconda-mode anzu auto-dictionary benchmark-init buffer-stack circe-notifications alert circe clean-aindent-mode cmake-ide cmake-mode cmake-project company-auctex company-c-headers company-cmake company-irony company-irony-c-headers company-math company-rtags company-shell cpputils-cmake csv csv-mode dtrt-indent emacs-xkcd ess-R-data-view ess-R-object-popup ess-smart-equals ess-smart-underscore flycheck-clangcheck flycheck-cstyle flycheck-irony flycheck-rtags flylisp flymake-python-pyflakes flymake-shell flymake-easy function-args ggo-mode gntp gnuplot gnuplot-mode helm-R ess helm-bibtex biblio biblio-core helm-c-yasnippet helm-company company helm-dictionary helm-flycheck flycheck helm-flymake helm-flyspell helm-git helm-google google helm-gtags helm-make helm-mt helm-org-rifle helm-package helm-projectile helm-rtags helm-swoop helm-systemd helm helm-core highlight highlight-blocks highlight-indent-guides highlight-parentheses highlight-symbol hlinum htmlize iedit indent-guide irony jedi jedi-core epc ctable concurrent julia-shell julia-mode latex-extra auctex latex-math-preview latex-pretty-symbols latex-preview-pane latex-unicode-math-mode levenshtein linum-relative macrostep magit git-commit magit-popup math-symbol-lists matlab-mode mc-extras multi-term multiple-cursors org-ac auto-complete-pcmp log4e auto-complete org-bullets org-projectile ox-html5slide ox-reveal org ox-twbs paredit parsebib popup projectile-codesearch projectile pkg-info epl codesearch projmake-mode indicators python-environment deferred pythonic f rainbow-delimiters rainbow-mode rtags s smart-mode-line-powerline-theme smart-mode-line rich-minority powerline smartparens speed-type sr-speedbar swiper ivy undo-tree volatile-highlights web-mode with-editor dash async ws-butler yasnippet yaxception ))
          (unless package-archive-contents
            (package-refresh-contents))
          (dolist (package mypackages)
            (unless (package-installed-p package)
              (package-install package)))
