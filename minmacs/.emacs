(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(setq display-line-numbers-type 'visual)
(global-display-line-numbers-mode t)

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "<C-return>") 'org-meta-return)
)
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  (setopt evil-disable-insert-state-bindings t) 
  :config
  (evil-mode t)
  (define-key evil-insert-state-map (kbd "TAB") 'indent-for-tab-command)
  (define-key evil-normal-state-map (kbd "TAB") 'indent-for-tab-command)
  (define-key evil-visual-state-map (kbd "TAB") 'indent-for-tab-command)
  )

(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (require 'evil-org-agenda)
  (setq evil-org-special-o/O nil)
  (evil-org-agenda-set-keys))

(use-package evil-leader
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>")
  )

(evil-leader/set-key "b" 'switch-to-buffer)

(use-package vertico
  :config
  (vertico-mode)
  )


(use-package consult
  :init
  (evil-leader/set-key "<RET>" 'consult-bookmark)
  )


(use-package xclip
  :config
  (xclip-mode)
  )

(use-package vundo
  :init
  (evil-leader/set-key "u" 'vundo)
  )

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package vterm
  )
(use-package vterm-toggle
  :init
  (global-set-key [f2] 'vterm-toggle-cd)
  )

(electric-pair-mode t)
(setq dired-dwim-target t)
(setq evil-ex-search-case 'insensitive)

(load-theme 'modus-vivendi-deuteranopia)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(display-time-mode 1)
(setq display-time-24hr-format t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-time-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(consult doom-modeline evil-leader evil-org magit sudo-edit vertico
	     vterm-toggle vundo xclip))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "PfEd" :slant normal :weight regular :height 158 :width normal)))))
