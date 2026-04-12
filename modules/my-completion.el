;;; my-completion.el --- Configuração de completion em múltiplos níveis -*- lexical-binding: t; -*-
;;; Commentary:
;;  Camadas de completion: Vertico (minibuffer), Orderless (estilo de busca),
;;  Marginalia (anotações), Consult (comandos enriquecidos), Embark (ações
;;  contextuais), Corfu (completion inline) e Cape (fontes adicionais).
;;; Code:


;;  Vertico 
;; UI vertical para o minibuffer — substitui o completion padrão.
(use-package vertico
  :init (vertico-mode)
  :custom
  (vertico-cycle t)    ;; navega ciclicamente entre candidatos
  (vertico-count 15))  ;; número de candidatos visíveis


;;  Orderless 
;; Estilo de completion por componentes separados por espaço (fuzzy poderoso).
;; Ex.: "buf sw" encontra "switch-to-buffer".
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))


;;  Marginalia 
;; Adiciona anotações (docstring, tipo, atalho) ao lado de cada candidato.
(use-package marginalia
  :init (marginalia-mode))


;;  Consult 
;; Comandos de busca e navegação enriquecidos com preview em tempo real.
(use-package consult
  :bind (("C-s"   . consult-line)       ;; busca no buffer atual
         ("C-x b" . consult-buffer)     ;; troca de buffer com preview
         ("M-y"   . consult-yank-pop)   ;; histórico de yank navegável
         ("C-c s" . consult-ripgrep))   ;; busca no projeto via ripgrep
  :custom (consult-preview-key 'any))   ;; preview ao mover o cursor


;;  Embark 
;; Menu de ações contextuais sobre o candidato ou símbolo sob o cursor.
;; C-. para agir; C-; para a ação mais provável (dwim).
(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim))
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil (window-parameters (mode-line-format . none)))))

;; Integração entre Embark e Consult (preview nas coleções do Embark).
(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))


;;  Corfu 
;; Completion inline no buffer (popup sobre o cursor), substitui company-mode.
(use-package corfu
  :init (global-corfu-mode)
  :custom
  (corfu-auto t)              ;; dispara automaticamente
  (corfu-auto-delay 0.2)      ;; aguarda 200ms antes de abrir o popup
  (corfu-auto-prefix 2)       ;; exige ao menos 2 caracteres digitados
  (corfu-cycle t)             ;; navega ciclicamente
  (corfu-quit-no-match 'separator))


;;  Cape 
;; Fontes adicionais de completion para o Corfu (dabbrev, arquivos, keywords).
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)  ;; palavras do buffer
  (add-to-list 'completion-at-point-functions #'cape-file)     ;; caminhos de arquivo
  (add-to-list 'completion-at-point-functions #'cape-keyword)) ;; keywords da linguagem


(provide 'my-completion)
;;; my-completion.el ends here
