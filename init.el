;;; init.el --- Entry point -*- lexical-binding: t; -*-

;; config. pré-loading
;; aumenta o threshold de garbage collection para melhor inicialização
(setq gc-cons-threshold (* 50 1000 1000))
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 2 1000 1000))))

;; silecia warnings
(setq native-comp-async-report-warnings-errors 'silent)

;; insere "./.emacs.d/modules/" ao =load-path=
(add-to-list 'load-path (expand-file-name "modules/" user-emacs-directory))

;; Bootstrap ELPACA package manager
(defvar elpaca-installer-version 0.8)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el")
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process
                                 `("git" nil ,buffer t "clone"
                                   ,@(when-let* ((depth (plist-get order :depth)))
                                       (list (format "--depth=%d" depth)
                                             "--no-single-branch"))
                                   ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode))
(setq use-package-always-ensure t)

;; Config. ambiente básica ;;
(use-package exec-path-from-shell
  :config (exec-path-from-shell-initialize))


;; Config. sistema operacional ;;
(when (eq system-type 'gnu/linux)
  (setq x-super-keysym 'meta))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; leitura dos módulos
(require 'my-ui)            ;; UI config. (Doom, theme, modeline, fonts)
(require 'my-org)           ;; org, org-journal, org-roam, org-roam-ui
(require 'my-keybindings)   ;; all keybindings (now without general.el/SPC dependency)
(require 'my-completion)    ;; vertico, orderless, consult, corfu, cape
(require 'my-help)          ;; which-key, helpful, flycheck
(require 'my-coding)        ;; sp-mode, lsp-ui, treesit-auto, projectile, consult-projectile, vterm
(require 'my-misc)          ;; rainbow-delimiters, hl-todo, super-save

;; módulos experimentais pessoais
(require 'my-definitions)

;; -*- begin outros -*-
;; Config. =sane defaults=
(setq-default
  indent-tabs-mode nil
  tab-width 4
  fill-column 80)
(setq
  require-final-newline t
  sentence-end-double-space nil
  delete-by-moving-to-trash t)
(global-auto-revert-mode 1)   ; reload files changed on disk
(delete-selection-mode 1)     ; typing replaces selected region
(show-paren-mode 1)

;; Backup/ higiene de lockfile
(setq
  make-backup-files nil
  auto-save-default nil
  create-lockfiles nil)

;; Arquivos recentes
(recentf-mode 1)
(setq recentf-max-saved-items 50)

;; Display para line numbers
(global-display-line-numbers-mode 1)
;; Disable in certain modes:
(dolist (mode '(org-mode-hook term-mode-hook vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; História persistente
(savehist-mode 1)
(setq history-length 100)

;; Gerenciamento de janelas
(winner-mode 1)

;; -*- end outros -*-

;; Custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

;;; init.el ends here
