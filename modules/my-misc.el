;;; my-misc.el --- Configurações diversas -*- lexical-binding: t; -*-
;;; Commentary:
;;  Pacotes utilitários que não se encaixam em outros módulos:
;;  delimitadores coloridos, marcadores TODO, salvamento automático,
;;  expansão de região, arrastar linhas e gerenciador de buffers.
;;; Code:


;;  LaTeX / org-mode
;; Compilador usado ao exportar org para PDF (xelatex suporta UTF-8 e fontes do sistema).
(setq org-latex-compiler "xelatex")


;;  Rainbow Delimiters
;; Colore parênteses, colchetes e chaves por nível de profundidade.
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


;;  hl-todo
;; Destaca palavras-chave de anotação (TODO, FIXME, etc.) no código.
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :custom
  (hl-todo-keyword-faces
   '(("TODO"  . "#ff6c6b")
     ("FIXME" . "#ff6c6b")
     ("HACK"  . "#ECBE7B")
     ("NOTE"  . "#98be65")
     ("DONE"  . "#5B6268"))))


;;  Super-save
;; Salva buffers automaticamente ao trocar de janela ou após inatividade.
(use-package super-save
  :config (super-save-mode 1)
  :custom
  (super-save-auto-save-when-idle t)
  (super-save-idle-duration 5)
  (super-save-silent t))  ;; não exibe mensagem "Wrote..." a cada salvamento


;;  Expand Region
;; Expande progressivamente a região selecionada por unidades sintáticas.
;; C-= para expandir; C-- C-= para contrair.
(use-package expand-region
  :bind ("C-=" . er/expand-region))


;;  Drag Stuff
;; Arrasta linhas ou regiões com M-↑ / M-↓.
(use-package drag-stuff
  :config
  (drag-stuff-global-mode 1)
  (drag-stuff-define-keys))


;;  IBuffer
;; Gerenciador de buffers nativo melhorado — substitui o buffer-list padrão.
(use-package ibuffer
  :ensure nil  ;; pacote nativo, não requer instalação
  :bind ("C-x C-b" . ibuffer))


(provide 'my-misc)
;;; my-misc.el ends here
