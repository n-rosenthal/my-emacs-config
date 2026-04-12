;;; my-org.el --- Configuração do Org-mode -*- lexical-binding: t; -*-
;;; Commentary:
;;  Cobre: org core, org-roam (notas de CS, referências, projetos),
;;  org-roam-dailies (diário), org-agenda, capturas,
;;  e polimento visual (superstar, visual-fill-column).
;;; Code:


;;  Configurações principais do org 
(use-package org
  :ensure nil
  :hook
  (org-mode . org-indent-mode)
  (org-mode . variable-pitch-mode)
  (org-mode . (lambda () (display-line-numbers-mode -1)))
  :custom
  ;; Diretórios e arquivos
  (org-directory          "~/org")
  (org-default-notes-file "~/org/inbox.org")

  ;; Aparência
  (org-ellipsis              " ▾")
  (org-hide-emphasis-markers t)
  (org-pretty-entities       t)
  (org-startup-folded        'overview)

  ;; Desativa _ e ^ como marcadores de sub/sobrescrito nas exportações
  (org-export-with-sub-superscripts nil)

  ;; Blocos de código-fonte
  (org-src-fontify-natively          t)
  (org-src-tab-acts-natively         t)
  (org-edit-src-content-indentation  0)
  (org-confirm-babel-evaluate        nil)

  ;; Registro de alterações
  (org-log-done       'time)
  (org-log-into-drawer t)

  ;; Refile
  (org-refile-targets                '((org-agenda-files :maxlevel . 3)))
  (org-refile-use-outline-path       t)
  (org-outline-path-complete-in-steps nil)
  (org-refile-allow-creating-parent-nodes 'confirm)

  ;; Etiquetas (tags)
  (org-tag-alist
   '(("@work"     . ?w) ("@home"    . ?h) ("@computer" . ?c)
     ("@errands"  . ?e) ("@phone"   . ?p) (:newline)
     ("deep"      . ?d) ("quick"    . ?q) ("meeting"   . ?m)
     ("reading"   . ?r) ("cs"       . ?s) ("review"    . ?v)))

  ;; Prioridades
  (org-priority-highest ?A)
  (org-priority-default ?C)
  (org-priority-lowest  ?D)

  ;; Relógio (clock)
  (org-clock-persist                    'history)
  (org-clock-in-resume                   t)
  (org-clock-out-remove-zero-time-clocks t)
  (org-clock-report-include-clocking-task t)

  :config
  (org-clock-persistence-insinuate)

  ;; Estados de TODO
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "|"
                    "DONE(d!)" "CANCELLED(c@)")))

  (setq org-todo-keyword-faces
        '(("TODO"      . (:foreground "#ff6c6b" :weight bold))
          ("NEXT"      . (:foreground "#ECBE7B" :weight bold))
          ("WAITING"   . (:foreground "#a9a1e1" :weight bold))
          ("DONE"      . (:foreground "#98be65" :weight bold))
          ("CANCELLED" . (:foreground "#5B6268" :weight bold))))

  ;; Linguagens suportadas pelo Babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t) (python . t) (shell . t) (sql . t))))


;;  Templates de captura 
;; Mantidos simples: inbox, reunião, leitura, someday.
;; Capturas diárias passam pelo org-roam-dailies (ver abaixo).
(with-eval-after-load 'org
  (setq org-capture-templates
        '(("i" "Inbox" entry
           (file "~/org/inbox.org")
           "* TODO %?\n  %U\n  %a\n"
           :empty-lines 1)

          ("m" "Reunião" entry
           (file+datetree "~/org/meetings.org")
           "* MEETING %? :meeting:\n  %U\n** Participantes\n** Notas\n** Ações\n"
           :empty-lines 1)

          ("r" "Leitura" entry
           (file "~/org/reading.org")
           "* TODO Ler: %?\n  %U\n"
           :empty-lines 1)

          ("s" "Someday/Maybe" entry
           (file "~/org/someday.org")
           "* %?\n  %U\n"
           :empty-lines 1))))


;;  org-superstar 
;; Substitui os asteriscos de heading por símbolos visuais.
(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "◆"))
  (org-superstar-item-bullet-alist     '((?- . ?•) (?+ . ?➤))))


;;  visual-fill-column 
;; Centraliza e limita a largura do texto em buffers org — simula margens.
(use-package visual-fill-column
  :hook (org-mode . visual-fill-column-mode)
  :custom
  (visual-fill-column-width       90)
  (visual-fill-column-center-text t))


;;  org-roam 
;; Declaração antecipada de my/zettelkasten-id (definida em my-definitions.el,
;; carregado após este módulo — a resolução ocorre em tempo de execução).
(declare-function my/zettelkasten-id "my-definitions")

(use-package org-roam
  :custom
  (org-roam-directory          "~/org/roam")
  (org-roam-completion-everywhere t)

  :config
  (org-roam-db-autosync-mode)

  ;;  Templates de captura de nós 
  ;; Todos os nomes de arquivo usam YYYYMMDDhhmm via my/zettelkasten-id.
  (setq org-roam-capture-templates
        '(;; Nota permanente genérica
          ("d" "padrão" plain "%?"
           :if-new (file+head "%(my/zettelkasten-id)-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n#+filetags: :draft:\n\n")
           :unnarrowed t)

          ;; Nota de estudo de Ciência da Computação
          ("c" "nota CS" plain
           "* ${title}\n:PROPERTIES:\n:ID: %(my/zettelkasten-id)\n:END:\n\n%?\n\n* Relacionado\n"
           :if-new (file+head "cs/%(my/zettelkasten-id)-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n#+filetags: :cs:draft:\n\n")
           :unnarrowed t)

          ;; Nota de literatura / referência bibliográfica
          ("r" "referência" plain
           "* Fonte\n%?\n\n* Resumo\n\n* Pontos principais\n\n* Meus pensamentos\n\n* Relacionado"
           :if-new (file+head "references/%(my/zettelkasten-id)-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n#+filetags: :reference:\n\n")
           :unnarrowed t)

          ;; Nota de projeto
          ("p" "projeto" plain
           "* Objetivo\n%?\n\n* Tarefas\n** TODO Primeiro passo\n\n* Notas\n\n* Log"
           :if-new (file+head "projects/%(my/zettelkasten-id)-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n#+filetags: :project:\n\n")
           :unnarrowed t)

          ;; Nó-índice acadêmico — um por área, agrupa nós de tópicos
          ("i" "índice academia/computação" plain
           "* Tópicos\n\n* Recursos\n\n* Status\n%?"
           :if-new (file+head "studies/academia/%(my/zettelkasten-id)-${slug}-index.org"
                              "#+title: ${title}\n#+date: %U\n#+filetags: :cs:index:\n\n")
           :unnarrowed t)))

  ;;  org-roam-dailies (diário) 
  (setq org-roam-dailies-directory "~/org/journal/")

  (setq org-roam-dailies-capture-templates
        '(;; "d" é obrigatório — usado por org-roam-dailies-capture-today
          ("d" "diário" entry
           "** %<%H:%M> %?"
           :if-new (file+head "%<%Y-%m-%d>.org"
                              ":PROPERTIES:\n:ID: %(org-id-new)\n:END:\n#+title: %<%Y-%m-%d>\n#+zid: %(my/zettelkasten-id)\n\n* Entradas\n\n* Atividades\n\n| Atividade | Início | Fim | Notas |\n|-----------|--------|-----|-------|\n")
           :empty-lines 1)

          ;; Entrada avulsa numa seção específica do diário do dia
          ("e" "entrada" entry
           "** %<%H:%M> %?"
           :if-new (file+head+olp "%<%Y-%m-%d>.org"
                                  ":PROPERTIES:\n:ID: %(org-id-new)\n:END:\n#+title: %<%Y-%m-%d>\n#+zid: %(my/zettelkasten-id)\n\n* Entradas\n\n* Atividades\n\n| Atividade | Início | Fim | Notas |\n|-----------|--------|-----|-------|\n"
                                  ("Entradas"))
           :empty-lines 1)

          ;; Linha de atividade diretamente na tabela de atividades
          ("a" "atividade" table-line
           "| %? | %<%H:%M> | | |"
           :if-new (file+head+olp "%<%Y-%m-%d>.org"
                                  ":PROPERTIES:\n:ID: %(org-id-new)\n:END:\n#+title: %<%Y-%m-%d>\n#+zid: %(my/zettelkasten-id)\n\n* Entradas\n\n* Atividades\n\n| Atividade | Início | Fim | Notas |\n|-----------|--------|-----|-------|\n"
                                  ("Atividades"))
           :empty-lines 0)))

  ;;  Atalhos do diário 
  (global-set-key (kbd "C-c j") #'org-roam-dailies-capture-today)   ; nova entrada hoje
  (global-set-key (kbd "C-c J") #'org-roam-dailies-find-today)      ; abre arquivo de hoje
  (global-set-key (kbd "C-c n") #'org-roam-dailies-find-yesterday)  ; dia anterior
  (global-set-key (kbd "C-c p") #'org-roam-dailies-find-tomorrow))  ; dia seguinte


;;  org-roam-ui 
;; Visualização interativa do grafo de notas no navegador.
(use-package org-roam-ui
  :after org-roam
  :custom
  (org-roam-ui-sync-theme      t)   ;; sincroniza o tema do Emacs
  (org-roam-ui-follow          t)   ;; grafo segue o nó atual
  (org-roam-ui-update-on-save  t)   ;; atualiza ao salvar
  (org-roam-ui-open-on-start   nil));; não abre o navegador automaticamente


(provide 'my-org)
;;; my-org.el ends here
