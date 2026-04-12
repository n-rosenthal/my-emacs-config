;;; my-ui.el --- Configuração visual -*- lexical-binding: t; -*-
;;; Commentary:
;;  Configura a aparência visual: tema, fontes, modeline, números de linha,
;;  transparência e a tela inicial (dashboard).
;;; Code:


;; Suprimir elementos visuais desnecessários
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(set-fringe-mode  8)


;;  Transparência da janela
;; (ativa . inativa) — leve transparência
(add-to-list 'default-frame-alist '(alpha . (92 . 95)))


;;  Fontes 
(defvar my/font-family "JetBrains Mono"
  "Fonte monoespaçada principal.")

(defvar my/font-size 13
  "Tamanho base da fonte em pontos.")

(set-face-attribute 'default nil
                    :family my/font-family
                    :height (* my/font-size 10))  ;; height é em unidades de 1/10 pt

;; Face de largura variável (usada em prosa no org, dashboard, etc.)
(set-face-attribute 'variable-pitch nil
                    :family "JetBrains Mono"
                    :height (* my/font-size 10))

;; Face de largura fixa (blocos de código dentro do org)
(set-face-attribute 'fixed-pitch nil
                    :family my/font-family
                    :height (* my/font-size 10))


;;  Tema 
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold   t
        doom-themes-enable-italic t)
  (load-theme 'doom-tokyo-night t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))        ;; corrige a fontificação do org-mode


;;  Doom Modeline 
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height          32)
  (doom-modeline-bar-width        4)
  (doom-modeline-icon             t)
  (doom-modeline-major-mode-icon  t)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (doom-modeline-minor-modes      nil)
  (doom-modeline-enable-word-count nil)
  (doom-modeline-checker-simple-format t))

;; nerd-icons é exigido pelo doom-modeline (substitui o all-the-icons).
;; Execute M-x nerd-icons-install-fonts uma vez após a primeira instalação.
(use-package nerd-icons)


;;  Números de linha 
;; Exibe números de linha absolutos em todos os buffers de edição.
(setq display-line-numbers-type t)
(global-display-line-numbers-mode 1)

;; Desativa números de linha em modos onde são distrativos
(dolist (mode '(term-mode-hook
                vterm-mode-hook
                shell-mode-hook
                eshell-mode-hook
                org-agenda-mode-hook
                dashboard-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode -1))))


;;  Dashboard 
(use-package dashboard
  :after nerd-icons
  :custom
  ;; Banner
  (dashboard-startup-banner     'logo) ;; substitua 'logo por um caminho de arquivo para arte ASCII personalizada
  (dashboard-banner-logo-title  "olá, nícolas.")
  (dashboard-center-content      t)
  (dashboard-vertically-center-content t)

  ;; Widgets e seus limites de itens
  (dashboard-items '((recents   . 7)
                     (bookmarks . 5)
                     (agenda    . 7)))

  ;; Ícones ao lado de cada item (requer nerd-icons)
  (dashboard-display-icons-p     t)
  (dashboard-icon-type          'nerd-icons)
  (dashboard-set-heading-icons   t)
  (dashboard-set-file-icons      t)

  ;; Agenda: exibe tarefas dos próximos 7 dias
  (dashboard-week-agenda         t)
  (dashboard-agenda-sort-strategy '(time-up priority-down))

  ;; Rodapé
  (dashboard-set-footer          t)
  (dashboard-footer-messages    '("be kind."))
  (dashboard-footer-icon
   (nerd-icons-octicon "nf-oct-smiley" :height 1.1 :v-adjust -0.05))

  :config
  (dashboard-setup-startup-hook))

;; Faz com que frames abertos via emacsclient também exibam o dashboard
;; em vez do buffer *scratch*
(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))


(provide 'my-ui)
;;; my-ui.el ends here
