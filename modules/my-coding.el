;;; my-coding.el --- programming configuration -*- lexical-binding: t; -*-

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook
  (python-mode     . lsp-deferred)
  (js-mode         . lsp-deferred)
  (typescript-mode . lsp-deferred)
  :init (setq lsp-keymap-prefix "C-c l")
  :custom
  (lsp-prefer-flymake nil)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-enable-which-key-integration t)
  (lsp-idle-delay 0.3))

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-enable t))

(use-package treesit-auto
  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode))

(use-package projectile
  :init (projectile-mode 1)
  :custom
  (projectile-enable-caching t)
  (projectile-completion-system 'auto)
  (projectile-switch-project-action #'projectile-dired)
  :bind-keymap ("C-c p" . projectile-command-map))

(use-package consult-projectile
  :after (consult projectile))


(use-package vterm
  :commands vterm
  :custom
  (vterm-max-scrollback 10000)
  (vterm-timer-delay 0.01))

(provide 'my-coding)
;;; my-coding.el ends here
