(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
                                        ;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

(setq package-file "~/.emacs.d/package-list.el")
(load package-file)

(setq user-full-name "Marc Ziegler"
      user-email-adress "marc.ziegler@uk-erlangen.de")

(setq custom-file "~/.emacs.d/emacs-custom.el")

(setq auto-save-default nil)
(setq make-backup-files nil)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq gc-cons-threshold 1000000)
(setq byte-compile-warnings '(not free-vars ))
(setq max-lisp-eval-depth 5000)
(setq max-specpdl-size 5000)
(setq debug-on-error nil)
(defalias 'yes-or-no-p 'y-or-n-p)
(winner-mode t)

;; use space to indent by default
(setq-default indent-tabs-mode nil)

;; set appearance of a tab that is represented by 4 spaces
(setq-default tab-width 2)

;; for fill column mode
(setq-default fill-column 100)

(setq global-mark-ring-max 5000         ; increase mark ring to contains 5000 entries
      mark-ring-max 5000                ; increase kill ring to contains 5000 entries
      mode-require-final-newline t      ; add a newline to end of file
      )

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

(setq-default indent-tabs-mode nil)
(delete-selection-mode)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-linum-mode t)
(display-time-mode t)
(column-number-mode t)
(global-prettify-symbols-mode t)
(add-hook 'fundamental-mode-hook 'rainbow-delimiters-mode)
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
            '(buffer-file-name "%f" (dired-directory dired-directory "%b"))
            )
      )
(which-function-mode)
(require 'hlinum)
(hlinum-activate)


(setq-default header-line-format
              '((which-func-mode ("" which-func-format " "))))
(setq mode-line-misc-info
      ;; We remove Which Function Mode from the mode line, because it's mostly
      ;; invisible here anyway.
      (assq-delete-all 'which-func-mode mode-line-misc-info))

(require 'smart-mode-line)
(setq sml/no-confirm-load-theme t)
(setq sml/theme 'dark)
(sml/setup)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-1-face ((t (:foreground "white"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "dark orange"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "chartreuse"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "dark green"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "cyan"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "blue"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "magenta"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "sienna")))))

(load-theme 'CrapCram t)
(set-face-attribute 'default nil :height 95)

(if (eq system-type 'windows-nt)
    (set-face-font 'default "-outline-Courier New-normal-normal-normal-mono-13-*-*-*-c-*-fontset-startup")
  (set-face-font 'default "-1ASC-Liberation Mono-normal-italic-normal-*-*-*-*-*-m-0-iso10646-1"))

(defun mz/emacs-reload()
  "Reload the emacs ini file (~/.emacs.d/init.el)"
  (interactive)
  (load-file '"~/.emacs.d/init.el")
  )

(defun mz/indent-buffer ()
  "Indents an entire buffer using the default intenting scheme."
  (interactive)
  (point-to-register 'o)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max))
  (jump-to-register 'o)
  )

(defun mz/prelude-smart-open-line-above ()
  "Insert an empty line above the current line.
              Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(defun mz/mark-done-and-archive ()
  "Mark the state of an org-mode item as DONE and archive it."
  (interactive)
  (org-todo 'done)
  (org-archive-subtree))

(defmacro def-pairs (pairs)
  `(progn
     ,@(cl-loop for (key . val) in pairs
                collect
                `(defun ,(read (concat
                                "wrap-with-"
                                (prin1-to-string key)
                                "s"))
                     (&optional arg)
                   (interactive "p")
                   (sp-wrap-with-pair ,val)))))

(def-pairs ((paren        . "(")
            (bracket      . "[")
            (brace        . "{")
            (single-quote . "'")
            (double-quote . "\"")
            (back-quote   . "`"));     (global-set-key (kbd "M-p \" ") 'wrap-with-double-quotes)
  )

(defun mz/print-list (list)
  (dotimes (item (length list))
    (insert (prin1-to-string (elt list item)))
    (insert " ")
    )
  )

(defun mz/write-package-install ()
  (insert "
              (unless package-archive-contents
                (package-refresh-contents))
              (setq pp '())
              (dolist (p package-archive-contents)
                      (push (car p) pp))
              (dolist (package mypackages)
                (unless (package-installed-p package)
                  (if (member package pp) (package-install package))))"
          )
  )

(defun mz/print-package-list ()
  (interactive)
  (find-file package-file)
  (erase-buffer)
  (insert "(defvar mypackages '(")
  (mz/print-list package-activated-list)
  (insert "))")
  (mz/write-package-install)
  (save-buffer)
  (kill-buffer)
  )

(defun mz/my_compile ()
  "Take the makefile in current folder or in build folder"
  (interactive)
  (if (file-exists-p "Makefile")
      (progn
        (setq compile-command "make -j4")
        )
    (progn
      (setq compile-command
            (concat "cd " (replace-regexp-in-string "src" "build" (file-name-directory buffer-file-name)) " && make -j4"))
      )
    )
  (compile compile-command)
  )

(defun mz/workwndw()
  "Load specific files and the window accordingly"
  (interactive)
  (find-file "~/Stuff/ToDo/todo.org")
  (split-window-right)
  (find-file "~/Stuff/ToDo/agenda.org")
  (split-window-below)
  (find-file "~/Stuff/ToDo/worktime.org")
  (windmove-right)
  (outline-show-all)
  )

(defun mz/fast-calc()
  "Parse for ++$1++ and substiute with the calculated result of $1."
  (interactive)
  (save-excursion)
  (beginning-of-buffer)
  (while (re-search-forward "\\+\\+" nil t)
    (progn
      (beginning-of-buffer)
      (when (re-search-forward "\\+\\+[ \\.0-9\\+\\(\\)\\*\\/\\-]+\\+\\+" nil t)
        (setf
         (point) (match-beginning 0)
         (mark) (match-end 0)
         )
        )
      (save-restriction
        (narrow-to-region (region-beginning) (region-end))
        (replace-string "++" "")
        (exchange-point-and-mark)
        (replace-string
         (buffer-substring (region-beginning) (region-end))
         (calc-eval (buffer-substring (region-beginning) (region-end)))
         )
        )
      )
    )
  )

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(require 'cl)

(require 'smartparens)
(require 'smartparens-config)
(setq sp-base-key-bindings 'paredit)
(setq sp-hybrid-kill-entire-symbol nil)
(sp-use-paredit-bindings)
(show-smartparens-global-mode 1)
(smartparens-global-mode 1)

(require 'indent-guide)
(indent-guide-global-mode 1)

(require 'multiple-cursors)

(require 'company)
(add-to-list 'company-backends 'company-elisp)

(add-hook 'after-init-hook 'global-company-mode)
(global-company-mode 1)
(setq company-idle-delay 'nil)

(require 'volatile-highlights)
(volatile-highlights-mode t)

;; Package: clean-aindent-mode
(require 'clean-aindent-mode)
(set 'clean-aindent-is-simple-indent t)

;; Package: ws-butler
(require 'ws-butler)
(ws-butler-global-mode)

(require 'undo-tree)
(global-undo-tree-mode)

(require 'anzu)
(global-anzu-mode)

(require 'dictcc)
(require 'epc)

(require 'yasnippet)
(yas-global-mode 1)

;; Jump to end of snippet definition
(define-key yas-keymap (kbd "<return>") 'yas/exit-all-snippets)

;; Inter-field navigation
(defun yas/goto-end-of-active-field ()
  (interactive)
  (let* ((snippet (car (yas--snippets-at-point)))
         (position (yas--field-end (yas--snippet-active-field snippet))))
    (if (= (point) position)
        (move-end-of-line 1)
      (goto-char position))))

(defun yas/goto-start-of-active-field ()
  (interactive)
  (let* ((snippet (car (yas--snippets-at-point)))
         (position (yas--field-start (yas--snippet-active-field snippet))))
    (if (= (point) position)
        (move-beginning-of-line 1)
      (goto-char position))))

(define-key yas-keymap (kbd "C-e") 'yas/goto-end-of-active-field)
(define-key yas-keymap (kbd "C-a") 'yas/goto-start-of-active-field)
;; (define-key yas-minor-mode-map [(tab)] nil)
;; (define-key yas-minor-mode-map (kbd "TAB") nil)
;; (define-key yas-minor-mode-map (kbd "C-<tab>") 'yas-expand)
;; No dropdowns please, yas
(setq yas-prompt-functions '(yas/ido-prompt yas/completing-prompt))

;; No need to be so verbose
(setq yas-verbosity 1)

;; Wrap around region
(setq yas-wrap-around-region t)

(require 'helm)
(require 'helm-config)
(require 'helm-google)
(require 'helm-flycheck)
(require 'helm-flyspell)
(require 'helm-company)
(defvar helm-alive-p)
(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-autoresize-mode t)

(setq helm-apropos-fuzzy-match t)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)
(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)

(require 'helm-grep)

(helm-mode 1)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebihnd tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
(define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
(define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)

(require 'magit)

(require 'flycheck)
(global-flycheck-mode 1)

(defun my-flycheck-rtags-setup ()
  (require 'rtags)
  (require 'company-rtags)
  (require 'flycheck-rtags)
  (setq rtags-autostart-diagnostics t)
  (rtags-diagnostics)
  (setq rtags-completions-enabled t)
  (eval-after-load 'company
    '(add-to-list
      'company-backends 'company-rtags))
  (require 'helm-rtags)
  (setq rtags-display-result-backend 'helm)
  (setq rtags-display-result-backend 'helm)
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  (setq-local flycheck-check-syntax-automatically nil))

;; setup GDB
(setq gdb-many-windows t ;; use gdb-many-windows by default
      gdb-show-main t  ;; Non-nil means display source file containing the main routine at startup
      )
(setq c-default-style "linux" )
(setq c-basic-offset 4)

(defun my-c-mode-common-hook ()
  ;; my customizations for all of c-mode and related modes
  (require 'irony)
  (unless (irony--find-server-executable) (call-interactively #'irony-install-server))
  (setq irony-cdb-compilation-databases '(irony-cdb-libclang irony-cdb-clang-complete))
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

  (require 'company-irony)
  (require 'company-irony-c-headers)
  (add-to-list 'company-backends 'company-c-headers)
  (add-to-list 'company-backends 'company-irony-c-headers)
  (add-to-list 'company-backends 'company-clang)
  (add-to-list 'company-backends 'company-irony)
  (rtags-start-process-unless-running)
  (hs-minor-mode)
  (my-flycheck-rtags-setup)
  (rainbow-mode)
  (rainbow-delimiters-mode)
  (hs-minor-mode)
  (irony-mode)
  (turn-on-auto-fill)
  (global-set-key [f6] 'run-cfile)
  (global-set-key [C-c C-y] 'uncomment-region)
  )

(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-hook 'c++-mode-hook 'my-c-mode-common-hook)

(add-hook 'R-mode-hook #'rainbow-delimiters-mode)
(add-hook 'R-mode-hook #'rainbow-mode)
(add-hook 'R-mode-hook 'hs-minor-mode)

;(add-hook 'matlab-mode-hook 'auto-complete-mode)
(add-hook 'matlab-mode-hook 'company-mode)
(add-hook 'matlab-mode-hook 'hs-minor-mode)
(add-hook 'matlab-mode-hook #'rainbow-delimiters-mode)
(add-to-list 'auto-mode-alist '("\\.m$" . matlab-mode))
(add-hook 'matlab-mode-hook
          (lambda () (local-set-key (kbd "<f5>") 'matlab-shell-run-cell)))
(add-hook 'matlab-mode-hook
          (lambda () (local-set-key (kbd "S-<f5>") 'matlab-shell-run-region)))
(add-hook 'matlab-mode-hook
          (lambda () (local-unset-key (kbd "M-s"))))
(add-hook 'matlab-mode-hook
          (lambda () (local-set-key (kbd "C-m m") 'matlab-show-matlab-shell-buffer)))
(add-hook 'matlab-mode-hook
          (lambda () (local-set-key (kbd "C-m e") 'matlab-end-of-defun)))
(add-hook 'matlab-mode-hook
          (lambda () (local-set-key (kbd "C-m a") 'matlab-beginning-of-defun)))
(defun matlab/db (com)
  (interactive)
  (switch-to-buffer "*MATLAB*")
  (end-of-buffer)
  (insert com)
  (comint-send-input)
  )
(add-hook 'matlab-mode-hook
          (lambda () (local-set-key (kbd "<f9>") (lambda () (interactive) (matlab/db "dbcont")))))
(add-hook 'matlab-mode-hook
          (lambda () (local-set-key (kbd "<f6>") (lambda () (interactive) (matlab/db "dbstep")))))
(add-hook 'matlab-mode-hook
          (lambda () (local-set-key (kbd "<f7>") (lambda () (interactive) (matlab/db "dbstep in")))))
(add-hook 'matlab-mode-hook
          (lambda () (local-set-key (kbd "<f8>") (lambda () (interactive) (matlab/db "dbstep out")))))

(add-hook 'julia-mode-hook #'rainbow-delimiters-mode)
(add-hook 'julia-mode-hook 'hs-minor-mode)
(add-to-list 'auto-mode-alist '("\\.jl$" . julia-mode))

(add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-mode-hook 'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-to-list 'company-backends 'company-elisp)
(add-to-list 'auto-mode-alist '("\\.el$" . lisp-interaction-mode))
(add-hook 'lisp-interaction-mode 'rainbow-delimiters-mode)
(add-hook 'lisp-interaction-mode 'hs-minor-mode)

(require 'slime)
(setq inferior-lisp-program "/usr/bin/sbcl")

(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t)

(add-to-list 'auto-mode-alist '("\\.gnu$" . gnuplot-mode))
(add-to-list 'auto-mode-alist '("\\.plt$" . gnuplot-mode))

(add-hook 'gnuplot-mode-hook
          (lambda () (local-set-key (kbd "C-c C-c") 'gnuplot-run-buffer)))
(add-hook 'gnuplot-mode-hook #'rainbow-delimiters-mode)
(add-hook 'gnuplot-mode-hook #'rainbow-mode)
(add-hook 'gnuplot-mode-hook 'hs-minor-mode)

(add-hook 'shell-script-mode-hook #'rainbow-delimiters-mode)
(add-hook 'shell-script-mode-hook #'rainbow-mode)
(add-hook 'sh-mode-hook #'rainbow-delimiters-mode)
(add-hook 'sh-mode-hook #'rainbow-mode)
(add-hook 'sh-mode-hook 'hs-minor-mode)
(add-to-list 'hs-special-modes-alist '(sh-mode "\\(do\\|then\\|in\\)" "\\(done\\|fi\\|esac\\|elif\\)" "/[*/]" nil nil))

(defun my-python-mode-common-hook ()
  ;; my customizations for all of c-mode and related modes
  (require 'jedi)
  (require 'ede)
  (require 'elpy)
  (require 'py-autopep8)
  (add-to-list 'company-backends 'company-jedi)
  (add-to-list 'company-backends 'company-anaconda)
  (global-ede-mode)
  (hs-minor-mode)
  (elpy-mode)
  (rainbow-mode)
  (rainbow-delimiters-mode)
  (turn-on-auto-fill)
  (jedi-mode)
  (pyvenv-mode)
  (anaconda-mode)
  )

(add-hook 'python-mode-hook 'my-python-mode-common-hook)

(with-eval-after-load 'python
  (defun python-shell-completion-native-try ()
    "Return non-nil if can trigger native completion."
    (let ((python-shell-completion-native-enable t)
          (python-shell-completion-native-output-timeout
           python-shell-completion-native-try-output-timeout))
      (python-shell-completion-native-get-completions
       (get-buffer-process (current-buffer))
       nil "_"))))

(setq-default TeX-engine 'xetex)
(setq latex-run-command "xelatex --shell-escape")
(setq TeX-parse-self t)
(setq-default TeX-PDF-mode t)
(setq-default TeX-master nil)
(company-auctex-init)

(defun my-latex-mode-hook()
  (require 'company-auctex)
  (require 'company-bibtex)
  (add-to-list 'company-backends 'company-bibtex)
  (flyspell-mode 1)
  (TeX-fold-mode 1)
  (hs-minor-mode)
  (add-hook 'find-file-hook 'TeX-fold-buffer t t)
  (local-set-key [C-c C-g] 'TeX-kill-job)
  (turn-on-auto-fill)
  (rainbow-delimiters-mode)
  (rainbow-mode)
  (local-set-key [C-tab] 'TeX-complete-symbol)
  (LaTeX-math-mode)
  (TeX-source-correlate-mode)
  (turn-on-reftex)
  (require 'auto-dictionary)
  (add-hook 'flyspell-mode-hook (lambda () (auto-dictionary-mode 1)))

  (require 'writegood-mode)
  (global-set-key "\C-cg" 'writegood-mode)

  )

(add-hook 'TeX-mode-hook
          (lambda ()
            (my-latex-mode-hook)
            )
          )
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (my-latex-mode-hook)
            )
          )

(setq reftex-plug-into-AUCTeX t)

(add-to-list 'auto-mode-alist '("\\.tex$" . TeX-mode))
(add-to-list 'auto-mode-alist '("\\.sty$" . TeX-mode))

(TeX-add-style-hook
 "latex"
 (lambda ()
   (LaTeX-add-environments
    '("frame" LaTeX-env-contents))))

(setq TeX-view-program-selection
      (quote
       (((output-dvi style-pstricks)
         "dvips and gv")
        (output-dvi "xdvi")
        (output-pdf "Okular")
        (output-html "xdg-open"))))
(setq LaTeX-command-style (quote (("" "%(PDF)%(latex) --shell-escape %S%(PDFout)"))))

(add-to-list 'auto-mode-alist '("\\.sql$" . sql-mode))

(require 'sgml-mode)
(require 'nxml-mode)
(add-to-list 'hs-special-modes-alist
             '(nxml-mode
               "<!--\\|<[^/>]*[^/]>"
               "-->\\|</[^/>]*[^/]>"

               "<!--"
               sgml-skip-tag-forward
               nil))
(add-hook 'nxml-mode-hook 'hs-minor-mode)
(define-key nxml-mode-map (kbd "M-h") nil)

(if (eq system-type 'windows-nt)
    (setq org-directory "C:/zieglemc/Stuff/ToDo")
  (setq org-directory "/home/zieglemc/Stuff/ToDo"))

(define-obsolete-function-alias 'org-define-error 'define-error)
(defun org-file-path (filename)
  "Return the absolute adress of an org file, given its relative name"
  (interactive)
  (message "%s" (concat (file-name-as-directory org-directory) filename))
  )

(setq org-archive-location
      (concat (org-file-path "archive.org") "::* From %s" ))

(setq org-reveal-root "file:///home/zieglemc/src/reveal.js-master/js/reveal.js")
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(add-to-list 'auto-mode-alist '("\\.todo$" . org-mode))

(setq org-hide-leading-stars t)
(setq org-ellipsis " ↷")
(require 'org-bullets)

(defun my-org-mode-hook ()
  (writegood-mode 1)
  (org-bullets-mode 1)
  (hs-minor-mode 1)
  (visual-line-mode 1)
  (auto-fill-mode 1)
  (flyspell-mode 1)
  (setq sentence-end-double-space nil)
  (rainbow-mode 1)
  (rainbow-delimiters-mode 1)
  )

(add-hook 'org-mode-hook 'my-org-mode-hook)

(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)

(setq org-agenda-custom-commands
      '(("W" agenda "" ((org-agenda-ndays 21)))))

(setq org-agenda-files `(
                         ,(org-file-path "worktime.org")
                         ,(org-file-path "todo.org")
                         ,(org-file-path "ideas.org")
                         ,(org-file-path "to-read.org")
                         ,(org-file-path "agenda.org")
                         ))

(setq org-log-done 'time)
(define-key global-map "\C-c\C-x\C-s" 'mz/mark-done-and-archive)

(setq org-file-apps
      '((auto-mode . emacs)
        ("\\.x?html?\\'" . "firefox %s")
        ("\\.pdf\\'" . "okular \"%s\"")
        ("\\.pdf::\\([0-9]+\\)\\'" . "okular \"%s\"")
        ("\\.nrrd\\'" . "vv %s")
        ("\\.jpg\\'" . "gpicview %s")
        ("\\.raw\\'" . "imagej %s")
        ("\\.png\\'" . "gpicview $s")))

(org-babel-do-load-languages 'org-babel-load-languages
                             '((emacs-lisp . t) (ruby . t) (gnuplot . t) (python . t) (gnuplot . t) (shell . t) (org . t) (lisp . t) (R . t)))
(setq org-confirm-babel-evaluate nil)

(setq org-export-coding-system 'utf-8)

(require 'ox-reveal)
(require 'ox-twbs)
(require 'ox-pandoc)
                                        ;(require 'org-ref)
                                        ;
                                        ;(setq reftex-default-bibliography '("~/Documents/Literature/bibliography.bib"))
                                        ;
;; see org-ref for use of these variables
                                        ;(setq org-ref-bibliography-notes "~/Documents/Literature/Papers.org"
                                        ;      org-ref-default-bibliography '("~/Documents/Literature/bibliography.bib")
                                        ;      org-ref-pdf-directory "~/Documents/Literature/bibtex-pdfs/")

(setq bibtex-completion-bibliography "~/Documents/Literature/bibliography.bib"
      bibtex-completion-library-path "~/Documents/Literature/bibtex-pdfs/"
      bibtex-completion-notes-path "~/Documents/Literature/helm-bibtex-notes")



(setq org-pandoc-options-for-docx '((standalone . nil)))

(setq helm-bibtex-format-citation-functions
      '((org-mode . (lambda (x) (insert (concat
                                         "[[bibentry:"
                                         (mapconcat 'identity x ",")
                                         "]]")) ""))))

(require 'org-drill)
(add-to-list 'org-modules 'org-drill)
(setq org-drill-add-random-noise-to-intervals-p t)
(setq org-drill-hint-separator "|")
(setq org-drill-left-cloze-delimiter "<[")
(setq org-drill-right-cloze-delimiter "]>")
(setq org-drill-learn-fraction 0.25)

(load-file "~/.emacs.d/mz-functions/learnjapanese.el")

(setq org-capture-templates
      '(
        ("t" "Todo"
         entry
         (file (org-file-path "todo.org")))
        ("i" "Ideas"
         entry
         (file (org-file-path "ideas.org")))
        ("r" "To Read"
         checkitem
         (file (org-file-path "to-read.org")))
        ("h" "How-To"
         entry
         (file (org-file-path "how-to.org")))
        ))

(setq jp/vocabulary-file(org-file-path "Vocabulary.org"))
(add-to-list 'org-capture-templates
             '("j" "Japanese Word/Phrase" entry (file+headline jp/vocabulary-file "Words and Phrases")
               "** %(jp/type-prompt)     :drill:\n   :PROPERTIES:\n   :DRILL_CARD_TYPE: multisided\n   :ADDED:    %U\n   :END:\n*** Japanese\n    %(jp/japanese-get-word (jp/japanese-prompt))\n*** English\n    %(jp/english-prompt)"))
(add-to-list 'org-capture-templates
             '("J" "Japanese Grammar" entry (file+headline jp/vocabulary-file "Grammar")
               "** %(jp/grammar-type-prompt) :drill:\n   :PROPERTIES:\n   :DRILL_CARD_TYPE: hide2cloze\n   :ADDED:    %U\n   :END:\n   %(jp/definition-prompt)\n*** Example\n    %(jp/japanese-get-word (jp/japanese-prompt))\n    %(jp/english-prompt)"))

(global-set-key (kbd "M-%") 'anzu-query-replace)
(global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)
(global-set-key (kbd "M-o") 'mz/prelude-smart-open-line)
(global-set-key (kbd "<f12>") 'eval-buffer)
(global-set-key (kbd "<f5>") 'mz/my_compile)
(global-set-key (kbd "M-+") 'mz/fast-calc)

(fset 'make_newline
      [?\C-e tab return])
(global-set-key (kbd "C-<return>") 'make_newline)

(global-set-key "\C-x\\" 'mz/indent-buffer)
(global-set-key (kbd "RET") 'newline-and-indent)  ; automatically indent when press RET
(global-set-key (kbd "C-<tab>") 'helm-company)
(define-key global-map (kbd "C-.") 'company-files)
(global-set-key (kbd "C-!") 'repeat)
(global-set-key (kbd "C-x g") 'magit-status)

(define-key input-decode-map [?\C-m] [C-m])
(global-set-key (kbd "<C-m> d") 'dictcc)
(global-set-key (kbd "<C-m> D") 'dictcc-at-point)
;; movement between different frames
(global-set-key (kbd "M-g <left>") 'windmove-left)
(global-set-key (kbd "M-g <right>") 'windmove-right)
(global-set-key (kbd "M-g <up>") 'windmove-up)
(global-set-key (kbd "M-g <down>") 'windmove-down)
(global-set-key (kbd "M-g <prior>") 'winner-undo)
(global-set-key (kbd "M-g <next>") 'winner-redo)
(define-key winner-mode-map (kbd "C-c <left>") nil)
(define-key winner-mode-map (kbd "C-c <right>") nil)

;; smartparens bindings
(global-set-key (kbd "M-p a") 'sp-beginning-of-sexp)
(global-set-key (kbd "M-p e") 'sp-end-of-sexp)
(global-set-key (kbd "M-p <down>") 'sp-down-sexp)
(global-set-key (kbd "M-p <up>") 'sp-up-sexp)
(global-set-key (kbd "M-p f") 'sp-forward-sexp)
(global-set-key (kbd "M-p b") 'sp-backward-sexp)
(global-set-key (kbd "M-p n") 'sp-next-sexp)
(global-set-key (kbd "M-p r") 'sp-rewrap-sexp)
(global-set-key (kbd "M-p <left>") 'sp-backward-slurp-sexp)
(global-set-key (kbd "M-p <right>") 'sp-forward-slurp-sexp)
(global-set-key (kbd "M-p C-<left>") 'sp-backward-barf-sexp)
(global-set-key (kbd "M-p C-<right>") 'sp-previous-barf-sexp)
(define-key smartparens-mode-map (kbd "C-<left>") nil)
(define-key smartparens-mode-map (kbd "C-<right>") nil)
(define-key smartparens-mode-map (kbd "M-r") nil)
(define-key smartparens-mode-map (kbd "M-s") nil)
(global-set-key (kbd "M-p t") 'sp-transpose-sexp)
(global-set-key (kbd "M-p k") 'sp-kill-sexp)
(global-set-key (kbd "M-p ( ")  'wrap-with-parens)
(global-set-key (kbd "M-p [ ")  'wrap-with-brackets)
(global-set-key (kbd "M-p { ")  'wrap-with-braces)
(global-set-key (kbd "M-p ' ")  'wrap-with-single-quotes)
(global-set-key (kbd "M-p _ ")  'wrap-with-underscores)
(global-set-key (kbd "M-p ` ")  'wrap-with-back-quotes)
(global-set-key (kbd "M-p d") 'sp-unwrap-sexp)

;; multiple cursors
(global-set-key (kbd "M-n <right>") 'mc/mark-next-like-this)
(global-set-key (kbd "M-n <left>") 'mc/mark-previous-like-this)
(global-set-key (kbd "M-n C-<right>") 'mc/skip-to-next-like-this)
(global-set-key (kbd "M-n C-<left>") 'mc/skip-to-previous-like-this)
(global-set-key (kbd "M-n <") 'mc/unmark-next-like-this)
(global-set-key (kbd "M-n >") 'mc/unmark-previous-like-this)
(global-set-key (kbd "M-n a") 'mc/mark-all-like-this)

;; sr-speedbar
(global-set-key (kbd "M-g f") 'sr-speedbar-toggle)

;; ibuffer
(global-unset-key (kbd "C-x C-b"))
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; hide and show region
(global-unset-key (kbd "M-h"))
(global-set-key (kbd "M-h a") 'hs-hide-all)
(global-set-key (kbd "M-h <tab>") 'hs-toggle-hiding)
(global-set-key (kbd "M-h s a") 'hs-show-all)
(global-set-key (kbd "M-h r") 'hs-hide-block)
(global-set-key (kbd "M-h s r") 'hs-show-block)

;; rtags
(global-unset-key (kbd "M-r"))
(global-set-key (kbd "M-r d") 'rtags-find-symbol-at-point)
(global-set-key (kbd "M-r f") 'rtags-find-symbol)
(global-set-key (kbd "M-r <left>") 'rtags-location-stack-back)
(global-set-key (kbd "M-r <right>") 'rtags-location-stack-forward)
(global-set-key (kbd "M-r l") 'rtags-taglist)
(global-set-key (kbd "M-r r") 'rtags-rename-symbol)
(global-set-key (kbd "M-r p") 'rtags-reparse-file)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "M-s") 'helm-swoop)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c h o") 'helm-occur)

(global-set-key (kbd "C-c h C-c w") 'helm-wikipedia-suggest)

(global-set-key (kbd "C-c h x") 'helm-register)
;; (global-set-key (kbd "C-x r j") 'jump-to-register)

(define-key 'help-command (kbd "C-f") 'helm-apropos)
(define-key 'help-command (kbd "r") 'helm-info-emacs)
(define-key 'help-command (kbd "C-l") 'helm-locate-library)

(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key org-mode-map (kbd "C-<tab>") nil)

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(define-key org-mode-map (kbd "C-c <left>") 'org-metaleft)
(define-key org-mode-map (kbd "C-c <right>") 'org-metaright)
(define-key org-mode-map (kbd "C-c <up>") 'org-metaup)
(define-key org-mode-map (kbd "C-c <down>") 'org-metadown)
(define-key org-mode-map (kbd "C-c S-<left>") 'org-metashiftleft)
(define-key org-mode-map (kbd "C-c S-<right>") 'org-metashiftright)
(define-key org-mode-map (kbd "C-c S-<up>") 'org-metashiftup)
(define-key org-mode-map (kbd "C-c S-<down>") 'org-metashiftdown)
(define-key org-mode-map (kbd "C-c <left>") 'org-metaleft)
(define-key org-mode-map (kbd "C-c <right>") 'org-metaright)
(define-key org-mode-map (kbd "C-c <up>") 'org-metaup)
(define-key org-mode-map (kbd "C-c <down>") 'org-metadown)
(define-key org-mode-map (kbd "C-c S-<left>") 'org-metashiftleft)
(define-key org-mode-map (kbd "C-c S-<right>") 'org-metashiftright)
(define-key org-mode-map (kbd "C-c S-<up>") 'org-metashiftup)
(define-key org-mode-map (kbd "C-c S-<down>") 'org-metashiftdown)

(define-key org-mode-map (kbd "C-c C-r") nil)
(define-key org-mode-map (kbd "C-c C-r b") 'org-ref-helm-insert-cite-link)
(define-key org-mode-map (kbd "C-c C-r r") 'org-ref-helm-insert-ref-link)

(global-set-key (kbd "<f10>") 'gud-cont)
(global-set-key (kbd "<f9>") 'gud-step);; equiv matlab step in
(global-set-key (kbd "<f8>") 'gud-next) ;; equiv matlab step 1
(global-set-key (kbd "<f7>") 'gud-finish) ;; equiv matlab step out

;; this is down here because it destroyes parens matching and coloring
(global-set-key (kbd "M-p \" ") 'wrap-with-double-quotes)

(if (file-exists-p "~/PATIENTS/PatDB.el")
    (load-file "~/PATIENTS/PatDB.el")
  )
