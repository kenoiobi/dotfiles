(setq custom-file (make-temp-file "emacs-custom"))
;; (add-to-list 'load-path "~/.emacs.d/custom/sunrise-commander/")
;; (require 'sunrise)

;; functionality
(package-install 'evil)
(package-install 'evil-numbers)
(package-install 'evil-collection)
(package-install 'evil-org)
(package-install 'vertico)
(package-install 'consult)
(package-install 'projectile)
(package-install 'harpoon)
(package-install 'doom-themes)
(package-install 'perspective)
(package-install 'rainbow-identifiers)
(package-install 'magit)
(package-install 'dumb-jump)
(package-install 'company)
(package-install 'envrc)
(package-install 'dired-subtree)
(package-install 'doom-modeline)
(package-install 'fzf)

(add-hook 'find-file-hook 'zoxide-add)
(add-hook 'dired-mode-hook 'zoxide-add)

;; lsp bs
;; javascript
(package-install 'rjsx-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))

(package-install 'lsp-mode)
(add-hook 'rjsx-mode-hook 'lsp)
(add-hook 'typescript-mode-hook 'lsp)

;; python
(add-hook 'python-mode-hook 'lsp-deferred)

(package-install 'flycheck)
(package-install 'flycheck-inline)
(global-flycheck-mode +1)
(add-hook 'flycheck-mode-hook #'flycheck-inline-mode)

(add-hook 'after-init-hook 'global-company-mode)

;; java
(package-install 'lsp-java)
(add-hook 'java-mode-hook 'lsp-mode)
(global-set-key [f10] 'lsp-execute-code-action)
(global-set-key [f9] 'lsp-workspace-restart)

;; php
(package-install 'php-mode)
(add-hook 'php-mode-hook 'lsp-mode)


;; in depth customization
(custom-set-faces
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#1f2430" :foreground "#cbccc6" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 130 :width normal :foundry "ADBO" :family "Source Code Pro")))))

(setq display-line-numbers 'visual)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)
(setq persp-mode-prefix-key (kbd "C-'"))
(setq initial-major-mode 'org-mode)
(setq bookmark-save-flag 1)
(setq company-minimum-prefix-length 1)
(setq compile-command "./build.sh")
(setq custom-enabled-themes '(doom-one))
(setq custom-safe-themes
 '("0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1"
   default))
(setq delete-by-moving-to-trash t)
(setq dired-dwim-target t)
(setq dired-kill-when-opening-new-dired-buffer t)
(setq dired-listing-switches "-ahlBo --group-directories-first")
;; (set-face-foreground 'dired-directory "yellow" )
(setq display-time-24hr-format t)
(setq display-time-default-load-average nil)
(display-time-mode t)
(doom-modeline-mode t)
(dumb-jump-mode t)
(electric-pair-mode t)
(envrc-global-mode t)
(setq evil-collection-key-blacklist '("\"SPC\""))
(setq evil-mode-line-format nil)
(setq evil-want-keybinding nil)
(indent-tabs-mode 1)
(setq inhibit-startup-screen t)
;; (setq initial-major-mode 'org-mode)
(setq initial-scratch-message nil)
(line-number-mode 0)
;; (setq major-mode 'org-mode)
(setq max-lisp-eval-depth 3200)
(menu-bar-mode 0)
(setq mode-line-percent-position nil)
(setq org-adapt-indentation nil)
(setq package-archives
 '(("gnu" . "https://elpa.gnu.org/packages/")
   ("nongnu" . "https://elpa.nongnu.org/nongnu/")
   ("melpa" . "https://melpa.org/packages/")))
(setq package-selected-packages
 '(company consult dired-subtree doom-modeline doom-themes dumb-diff
    dumb-jump envrc evil evil-collection evil-numbers
    evil-org flycheck flycheck-inline general harpoon
    indent-bars lsp-mode lua-mode magit minions mood-line
    perspective projectile rainbow-identifiers ranger
    rjsx-mode smart-mode-line vertico vterm yasnippet))
(persp-mode t)
(setq pop-up-windows nil)
;; (setq projectile-mode t nil (projectile))
(scroll-bar-mode 0)
(setq timeclock-mode-line-display nil)
(tool-bar-mode -1)
(vertico-mode t)
;; (setq consult-find-args "find . -type d -not ( -path */.[A-Za-z]* -prune )")

(setq consult-find-args "find . -type d")


;; basic mappings
(global-set-key [f3] 'compile)
(global-set-key (kbd "C-;") 'comment-line)
(global-set-key (kbd "C-t") 'persp)

(global-set-key "\C-x2" (lambda () (interactive)(split-window-vertically) (other-window 1)))
(global-set-key "\C-x3" (lambda () (interactive)(split-window-horizontally) (other-window 1)))
(global-set-key "\C-x=" 'balance-windows)
(global-set-key "\C-x-" (lambda () (interactive) (shrink-window 5)))


;; evil
(require 'fzf)

(evil-mode t)
(setq evil-collection-key-blacklist '("SPC"))
(evil-set-undo-system 'undo-redo)
(evil-collection-init)

(evil-define-key 'normal 'global (kbd "|") 'async-shell-command)
(evil-define-key 'normal 'global (kbd "gb") 'xref-go-back)
(evil-define-key 'normal 'global (kbd "gh") (lambda () (interactive)
					      (find-file "~/")))

(evil-set-leader 'normal (kbd "SPC"))
(evil-set-leader 'visual (kbd "SPC"))

(evil-define-key 'normal 'global (kbd "<leader>RET") 'consult-bookmark)
(evil-define-key 'normal 'global (kbd "<leader>SPC") 'projectile-find-file)
(evil-define-key 'normal 'global (kbd "<leader>TAB") 'persp-switch)
(evil-define-key 'normal 'global (kbd "<leader>[") 'persp-prev)
(evil-define-key 'normal 'global (kbd "<leader>]") 'persp-next)
(evil-define-key 'normal 'global (kbd "<leader>,") 'previous-buffer)
(evil-define-key 'normal 'global (kbd "<leader>.") 'next-buffer)
(evil-define-key 'normal 'global (kbd "<leader>'") (lambda () (interactive)
        (let (project-root (projectile-project-root))
          (find-file (expand-file-name "project.org" project-root))
						     )))


(evil-define-key 'normal 'global (kbd "<leader>e") 'find-file)
(evil-define-key 'normal 'global (kbd "<leader>c") 'eval-buffer)
(evil-define-key 'normal 'global (kbd "<leader>t") 'vterm)
(evil-define-key 'normal 'global (kbd "<leader>a") 'switch-to-buffer)
(evil-define-key 'normal 'global (kbd "<leader>k") 'kill-buffer)
(evil-define-key 'normal 'global (kbd "<leader>bs") 'scratch-buffer)
(evil-define-key 'normal 'global (kbd "<leader>z") 'zoxide-find-file)

(evil-define-key 'normal 'global (kbd "<leader>wk") 'persp-kill)
(evil-define-key 'normal 'global (kbd "<leader>wr") 'persp-rename)
(evil-define-key 'normal 'global (kbd "<leader>ws") 'persp-state-save)

(evil-define-key 'normal 'global (kbd "<leader>q") 'eval-buffer)
(evil-define-key 'visual 'global (kbd "<leader>q") 'eval-region)
(evil-define-key 'normal 'global (kbd "<leader>pa") 'projectile-add-known-project)
(evil-define-key 'normal 'global (kbd "<leader>pp") 'projectile-switch-project)

;; python
(evil-define-key 'normal 'global (kbd "<leader>rt") 'run-python)
(evil-define-key 'normal 'global (kbd "<leader>rf") 'python-shell-send-buffer)
(evil-define-key 'normal python-mode-map (kbd "<leader>rr") 
  (lambda ()
    (interactive)
    (let ((beg (line-beginning-position))
          (end (line-end-position)))
      (python-shell-send-region beg end))))

(evil-define-key 'visual 'global (kbd "<leader>r") 'python-shell-send-region)

(evil-define-key 'normal 'global (kbd "<leader>1") 'harpoon-go-to-1)
(evil-define-key 'normal 'global (kbd "<leader>2") 'harpoon-go-to-2)
(evil-define-key 'normal 'global (kbd "<leader>3") 'harpoon-go-to-3)
(evil-define-key 'normal 'global (kbd "<leader>4") 'harpoon-go-to-4)
(evil-define-key 'normal 'global (kbd "<leader>5") 'harpoon-go-to-5)
(evil-define-key 'normal 'global (kbd "<leader>6") 'harpoon-go-to-6)
(evil-define-key 'normal 'global (kbd "<leader>7") 'harpoon-go-to-7)
(evil-define-key 'normal 'global (kbd "<leader>8") 'harpoon-go-to-8)
(evil-define-key 'normal 'global (kbd "<leader>9") 'harpoon-go-to-9)

(global-set-key (kbd "C-s") 'harpoon-add-file)
(evil-define-key 'normal 'global (kbd "<leader>h") 'harpoon-toggle-file)
(evil-define-key 'normal 'global (kbd "<leader>gg") 'magit)
(evil-define-key 'normal 'global (kbd "<leader>ga") 'magit-log-buffer-file)
;; (evil-define-key 'normal 'global (kbd "<leader>s") 'magit-file-dispatch)
(evil-define-key 'normal 'global (kbd "<leader>n") 'magit-blob-previous)
(evil-define-key 'normal 'global (kbd "<leader>m") 'magit-blob-next)

(define-key evil-normal-state-map (kbd "C-w") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-S-w") 'evil-numbers/dec-at-pt)
(define-key evil-normal-state-map (kbd "C-e") 'move-end-of-line)
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-normal-state-map (kbd "gt") 'persp-switch-last)
(define-key evil-insert-state-map (kbd "C-a") 'move-beginning-of-line)
(define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)
(evil-define-key 'normal dired-mode-map (kbd "TAB") 'dired-subtree-toggle)
(evil-define-key 'normal dired-mode-map (kbd "l") 'dired-find-file)
(evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
(evil-define-key 'insert java-mode-map (kbd ";") 'self-insert-command)

(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)
(add-hook 'prog-mode-hook 'indent-bars-mode)

(add-hook 'org-mode-hook (lambda () (interactive) (setq-local evil-shift-width 2)))
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
(setq persp-state-default-file "~/.emacs.d/persp")
(persp-state-load "~/.emacs.d/persp")
(setq frame-resize-pixelwise t) 
(load-theme 'doom-ayu-mirage t)


;; when there's a vterm buffer, auto update vterm's directory with dired
(defun sync-dired-to-vterm ()
    (when (derived-mode-p 'dired-mode)
	(let ((dir (dired-current-directory)))

	(when (get-buffer "*vterm*")
	    (with-current-buffer (get-buffer "*vterm*")
		(vterm-send-string (concat "cd " dir))
		(vterm-send-return)
		(vterm-send-string "clear")
		(vterm-send-return)
		)))
    )
)

(add-hook 'dired-after-readin-hook 'sync-dired-to-vterm)


;; (defun locate-dir ()
;;   (interactive)
;;   (let ((name (read-string "Search for: ")))
;;     (locate-with-filter name (concat (regexp-quote name) "$"))))

;; (evil-define-key 'normal 'global (kbd "<leader>d") 'locate-dir)

(evil-define-key 'normal 'global (kbd "<leader>ff") (lambda () (interactive)
						     (fzf-with-command "find -type f" 'fzf--action-find-file default-directory)))

(evil-define-key 'normal 'global (kbd "<leader>fd") (lambda () (interactive)
						     (fzf-with-command "find -type d" 'fzf--action-find-file default-directory)))

(evil-define-key 'normal 'global (kbd "<leader>z") (lambda () (interactive)
						     (fzf-with-command "zoxide query -l" 'find-file)))
