
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(setq package-enable-at-startup nil)
(package-initialize)
;(benchmark-init/activate)

(org-babel-load-file "~/.emacs.d/configuration.org")
;(load "~/.emacs.d/configuration.el")
(load custom-file 'noerror)

;(add-hook 'after-init-hook 'benchmark-init/deactivate)
