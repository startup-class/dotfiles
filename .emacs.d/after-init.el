; color theme
(load-theme 'solarized-dark t)

; helm
(helm-mode 1)


; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
(ac-config-default)

; ac-helm
(ac-complete-with-helm)

; pair mode
(show-paren-mode)
(electric-pair-mode)

;;yasnippet enable. not sure what the first line does
(setq ac-source-yasnippet nil)
(yas-global-mode 1)


;;jslint
(require 'flymake-jslint)
(add-hook 'js-mode-hook 'flymake-jslint-load)
