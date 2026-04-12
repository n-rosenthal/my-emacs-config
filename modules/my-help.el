;;; my-help.el --- Configuração de ajuda -*- lexical-binding: t; -*-
;;; Commentary:
;;  Ferramentas de descoberta e documentação: which-key para dicas de atalhos,
;;  helpful para páginas de ajuda enriquecidas, e flycheck para checagem de erros.
;;; Code:


;; Which-key
;; Exibe um painel com os atalhos disponíveis após uma tecla de prefixo.
(use-package which-key
  :init (which-key-mode)
  :custom
  (which-key-idle-delay 0.4)
  (which-key-max-description-length 32))


;; Helpful
;; Substitui os buffers de ajuda padrão por versões mais ricas,
;; com código-fonte, exemplos e referências cruzadas.
(use-package helpful
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key]      . helpful-key)
  ([remap describe-command]  . helpful-command))  ;; cobre M-x também


;; Flycheck
;; Checagem de sintaxe e erros em tempo real para modos de programação.
(use-package flycheck
  :hook (prog-mode . flycheck-mode)
  :custom
  (flycheck-display-errors-delay 0.3)
  (flycheck-indication-mode 'left-fringe))  ;; indicador na franja esquerda


(provide 'my-help)
;;; my-help.el ends here
