(setq package-archives
	'(("gnu" . "https://elpa.gnu.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")
	("melpa" . "https://melpa.org/packages/")))

;; (package-refresh-contents)

(setq custom-file (make-temp-file "emacs-custom"))

(setq compile-command "./build.sh")

(tool-bar-mode -1)
(scroll-bar-mode 0)
(menu-bar-mode 0)

(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

(setq mode-line-percent-position nil)

(global-set-key "\C-x2" (lambda () (interactive)(split-window-vertically) (other-window 1)))
(global-set-key "\C-x3" (lambda () (interactive)(split-window-horizontally) (other-window 1)))
(global-set-key "\C-x=" 'balance-windows)
(global-set-key "\C-x-" (lambda () (interactive) (shrink-window 5)))

(package-install 'evil)
(package-install 'evil-numbers) ;; for using numbers inside macros
(package-install 'evil-collection) ;; evil everywhere
(package-install 'evil-org) ;; evil on org mode duh

;; i use space as leader, if this is not setup, it works badly
(setq evil-collection-key-blacklist '("\"SPC\""))
(setq evil-mode-line-format nil) ;; evil collection complains if these two aren't set
(setq evil-want-keybinding nil)

;; it all needs to be done in this order
(evil-mode t)
(setq evil-collection-key-blacklist '("SPC")) ;; twice cuz unsure where it should go, works fine like this
;; enabling ctrl-r on evil
(evil-set-undo-system 'undo-redo)
(evil-collection-init)

(add-hook 'org-mode-hook                                                                      
		(lambda ()                                                                          
	    (define-key evil-normal-state-map (kbd "TAB") 'org-cycle))) 

;; leader key
(evil-set-leader 'normal (kbd "SPC"))
(evil-set-leader 'visual (kbd "SPC"))

(global-set-key [f3] 'compile) ;; really like to compile like this
(global-set-key (kbd "C-;") 'comment-line) ;; amazing, makes commenting easy
(global-set-key (kbd "C-/") 'comment-line) ;; amazing, makes commenting easy

(evil-define-key 'normal 'global (kbd "|") 'async-shell-command) ;; really nice, love it, should be in default vim
(evil-define-key 'normal 'global (kbd "gb") 'xref-go-back) ;; dumb jump

(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)

(define-key evil-insert-state-map (kbd "C-a") 'move-beginning-of-line)
(define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)
(define-key evil-normal-state-map (kbd "C-w") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-S-w") 'evil-numbers/dec-at-pt)

(evil-define-key 'normal 'global (kbd "<leader>e") 'find-file)

(evil-define-key 'normal 'global (kbd "gh") (lambda () (interactive)
					      (find-file "~/")))

(setq dired-dwim-target t)

(package-install 'dired-subtree)
(evil-define-key 'normal dired-mode-map (kbd "TAB") 'dired-subtree-toggle)

(evil-define-key 'normal dired-mode-map (kbd "l") 'dired-find-file)
(evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)

(setq dired-listing-switches "-goAht --group-directories-first")

(setq dired-kill-when-opening-new-dired-buffer t)

(add-hook 'dired-mode-hook (lambda ()
			     (dired-hide-details-mode)))

(setq delete-by-moving-to-trash t)

(evil-define-key 'normal 'global (kbd "<leader>,") 'previous-buffer)
(evil-define-key 'normal 'global (kbd "<leader>.") 'next-buffer)

(evil-define-key 'normal 'global (kbd "<leader>a") 'switch-to-buffer)

(evil-define-key 'normal 'global (kbd "<leader>k") 'kill-buffer)

(package-install 'fzf)
(require 'fzf) ;; not sure if necessary

(evil-define-key 'normal 'global (kbd "<leader>f") (lambda () (interactive)
						      (fzf-with-command "find -type f" 'fzf--action-find-file default-directory)))

(evil-define-key 'normal 'global (kbd "<leader>d") (lambda () (interactive)
						      (fzf-with-command "find -type d" 'fzf--action-find-file default-directory)))

(evil-define-key 'normal 'global (kbd "<leader>v") 'fzf-grep-with-narrowing)
;; alternative if you get mad with default implementation
;; (evil-define-key 'normal 'global (kbd "<leader>v") 'rgrep)

(package-install 'zoxide)
(require 'zoxide) ;; not sure if necessary

(add-hook 'find-file-hook 'zoxide-add)
(add-hook 'dired-mode-hook 'zoxide-add)

(evil-define-key 'normal 'global (kbd "<leader>z") (lambda () (interactive)
						      (find-file "~/")
						      (fzf-with-command "zoxide query -l" 'find-file)))

(package-install 'vertico)
(vertico-mode t)

(package-install 'consult)
(evil-define-key 'normal 'global (kbd "<leader>RET") 'consult-bookmark)

(setq bookmark-save-flag 1)

(package-install 'harpoon)

;; adding files to list
(global-set-key (kbd "C-s") 'harpoon-add-file)
;; browsing file listing, to change order, delete, etc
(evil-define-key 'normal 'global (kbd "<leader>h") 'harpoon-toggle-file)

(evil-define-key 'normal 'global (kbd "<leader>1") 'harpoon-go-to-1)
(evil-define-key 'normal 'global (kbd "<leader>2") 'harpoon-go-to-2)
(evil-define-key 'normal 'global (kbd "<leader>3") 'harpoon-go-to-3)
(evil-define-key 'normal 'global (kbd "<leader>4") 'harpoon-go-to-4)
(evil-define-key 'normal 'global (kbd "<leader>5") 'harpoon-go-to-5)
(evil-define-key 'normal 'global (kbd "<leader>6") 'harpoon-go-to-6)
(evil-define-key 'normal 'global (kbd "<leader>7") 'harpoon-go-to-7)
(evil-define-key 'normal 'global (kbd "<leader>8") 'harpoon-go-to-8)
(evil-define-key 'normal 'global (kbd "<leader>9") 'harpoon-go-to-9)

(evil-define-key 'normal 'global (kbd "C-f") 'avy-goto-char)

(evil-define-key 'normal 'global (kbd "<leader>bs") 'scratch-buffer)

(package-install 'persistent-scratch)
(persistent-scratch-setup-default)
(persistent-scratch-autosave-mode 1)
(setq persistent-scratch-backup-directory "~/.emacs.d/scratch/") ;; this is very important, dont forget it, otherwise your scratch might be pernamently lost

(setq initial-major-mode 'org-mode)

(package-install 'projectile)

(evil-define-key 'normal 'global (kbd "<leader>SPC") 'projectile-find-file)

(package-install 'perspective)
(setq persp-mode-prefix-key (kbd "C-'")) ;; not used, just set to make persp stop complaining
(persp-mode t)

(evil-define-key 'normal 'global (kbd "<leader>TAB") 'persp-switch)

;; next and prev
(evil-define-key 'normal 'global (kbd "<leader>[") 'persp-prev)
(evil-define-key 'normal 'global (kbd "<leader>]") 'persp-next)

;; since i dont use tabs, quick switching with gt
(define-key evil-normal-state-map (kbd "gt") 'persp-switch-last)

(evil-define-key 'normal 'global (kbd "<leader>wk") 'persp-kill)
(evil-define-key 'normal 'global (kbd "<leader>wr") 'persp-rename)
(evil-define-key 'normal 'global (kbd "<leader>ws") 'persp-state-save)

(package-install 'lsp-mode)

(package-install 'lsp-java)
(add-hook 'java-mode-hook 'lsp-mode)
(global-set-key [f10] 'lsp-execute-code-action)
(global-set-key [f9] 'lsp-workspace-restart)

(package-install 'rjsx-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))

(package-install 'jtsx) ;; IMPORTANT!! do M-x jtsx-install-treesit-language for it to work
(package-install 'typescript-mode)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . jtsx-tsx-mode))

(setq js-indent-level 2)

(add-hook 'rjsx-mode-hook 'lsp)
(add-hook 'jtsx-tsx-mode-hook 'lsp)
(add-hook 'typescript-mode-hook 'lsp)

(package-install 'prettier-js)
(add-to-list 'auto-mode-alist '("\\.js\\'"  . prettier-js-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . prettier-js-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'"  . prettier-js-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . prettier-js-mode))

(package-install 'envrc)
(package-install 'lsp-pyright)
(envrc-global-mode t)
(add-hook 'python-mode-hook (lambda ()
			      (require 'lsp-pyright)
			      (lsp-deferred)))

(package-install 'php-mode)
(add-hook 'php-mode-hook 'lsp-mode)

(package-install 'go-mode)
(add-hook 'go-mode-hook (lambda ()
		      (setq tab-width 4)
		      ))

(package-install 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; this completes after the first letter (default is 3)
(setq company-minimum-prefix-length 1)

(package-install 'flycheck)
(package-install 'flycheck-inline)
(global-flycheck-mode +1)
(add-hook 'flycheck-mode-hook #'flycheck-inline-mode)

(package-install 'dumb-jump)
(dumb-jump-mode t)
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
(evil-define-key 'normal 'global (kbd "gb") 'xref-go-back) ;; dumb jump

(package-install 'treemacs)

(setq treemacs-position 'right)
(setq treemacs-width 50)

(evil-define-key 'normal 'global (kbd "<leader>ss") 'lsp-treemacs-symbols)
(evil-define-key 'normal 'global (kbd "<leader>sf") 'treemacs)

(package-install 'magit)
(evil-define-key 'normal 'global (kbd "<leader>gg") 'magit)
(evil-define-key 'normal 'global (kbd "<leader>ga") 'magit-log-buffer-file)
(evil-define-key 'normal 'global (kbd "<leader>n") 'magit-blob-previous)
(evil-define-key 'normal 'global (kbd "<leader>m") 'magit-blob-next)

(package-install 'doom-themes)

;; (setq custom-safe-themes
;; '("0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1"
;;  default))

  (load-theme 'doom-ayu-mirage t)

(setq
 custom-enabled-themes '(doom-ayu-mirage))

(add-to-list 'default-frame-alist '(font . "OpenDyslexicMono Nerd Font 12"))

(package-install 'doom-modeline)
(doom-modeline-mode t)

(setq display-time-24hr-format t)
(setq display-time-default-load-average nil)
(display-time-mode t)

(package-install 'nerd-icons-dired)
(add-hook 'dired-mode-hook #'nerd-icons-dired-mode)

(evil-define-key 'normal 'global (kbd "<leader>o") 'other-window)
(evil-define-key 'normal 'global (kbd "<leader>i") 'delete-other-windows)

(package-install 'pdf-tools)
(pdf-tools-install)

(package-install 'yasnippet)
(package-install 'yasnippet-snippets)
(package-install 'react-snippets)

(yas-global-mode)

(package-install 'format-all)
(evil-define-key 'normal 'global (kbd "<leader>bf") 'format-all-buffer)

(package-install 'vterm)
(setq vterm-shell 'zsh)
(evil-define-key 'normal 'global (kbd "<leader>t") 'vterm)

(electric-pair-mode t)

(line-number-mode 0)
(setq display-line-numbers 'visual)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

(package-install 'indent-bars)
(setq indent-bars-starting-column 0)
(add-hook 'prog-mode-hook 'indent-bars-mode)

(setq show-trailing-whitespace t)

(package-install 'rainbow-identifiers)
(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)

(package-install 'toc-org)
(toc-org-enable)
(add-hook 'org-mode-hook 'toc-org-enable)

(setq org-export-with-broken-links t)
(setq org-babel-min-lines-for-block-output 0)

;; (package-install 'undo-tree)
;; (global-undo-tree-mode)
;; (setq undo-tree-save-history t)
;; (setq undo-tree-history-alist '(("." . "~/.emacs.d/undo-tree")))
;; (add-hook 'after-save-hook (lambda () (undo-tree-save-history nil t)))

(server-mode t)
(xclip-mode)

(package-install 'exec-path-from-shell)
(when (daemonp)
(exec-path-from-shell-initialize))

(package-install 'verb)
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c C-r") verb-command-map))
