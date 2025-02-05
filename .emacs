(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bookmark-save-flag 1)
 '(compile-command "./build.sh")
 '(custom-enabled-themes '(doom-one))
 '(custom-safe-themes
   '("0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1" default))
 '(dired-dwim-target t)
 '(display-line-numbers 'relative)
 '(display-time-mode t)
 '(evil-want-keybinding nil)
 '(inhibit-startup-screen t)
 '(max-lisp-eval-depth 3200)
 '(menu-bar-mode nil)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("nongnu" . "https://elpa.nongnu.org/nongnu/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-selected-packages
   '(evil-numbers perspective doom-themes harpoon flycheck-inline rjsx-mode flycheck lsp-mode ranger projectile evil-collection vertico consult evil))
 '(persp-mode t)
 '(projectile-mode t nil (projectile))
 '(scroll-bar-mode nil)
 '(timeclock-mode-line-display nil)
 '(tool-bar-mode nil)
 '(vertico-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#282c34" :foreground "#bbc2cf" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 150 :width normal :foundry "GOOG" :family "Noto Sans Mono")))))

;; functionality
(package-install 'evil)
(package-install 'evil-collection)
(package-install 'evil-numbers)
(package-install 'vertico)
(package-install 'consult)
(package-install 'projectile)
(package-install 'harpoon)
(package-install 'doom-themes)
(package-install 'perspective)

;; lsp bs
;; (package-install 'rjsx-mode)
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))

;; (package-install 'lsp-mode)
;; (add-hook 'rjsx-mode-hook 'lsp)

;; (package-install 'flycheck)
;; (package-install 'flycheck-inline)
;; (global-flycheck-mode +1)
;; (add-hook 'flycheck-mode-hook #'flycheck-inline-mode)

;; basic settings
(setq default-directory "~/")

;; basic mappings
(global-set-key [f4] 'compile)
(global-set-key (kbd "C-;") 'comment-line)

(global-set-key "\C-x2" (lambda () (interactive)(split-window-vertically) (other-window 1)))
(global-set-key "\C-x3" (lambda () (interactive)(split-window-horizontally) (other-window 1)))



;; evil
(evil-mode t)
(evil-collection-init)


(evil-set-leader 'normal (kbd "SPC"))
(evil-define-key 'normal 'global (kbd "<leader>RET") 'consult-bookmark)
(evil-define-key 'normal 'global (kbd "<leader>SPC") 'projectile-find-file)
(evil-define-key 'normal 'global (kbd "<leader>TAB") 'persp-switch)
(evil-define-key 'normal 'global (kbd "<leader>[") 'persp-prev)
(evil-define-key 'normal 'global (kbd "<leader>]") 'persp-next)
(evil-define-key 'normal 'global (kbd "<leader>,") 'previous-buffer)
(evil-define-key 'normal 'global (kbd "<leader>.") 'next-buffer)

(evil-define-key 'normal 'global (kbd "<leader>e") 'find-file)
(evil-define-key 'normal 'global (kbd "<leader>r") 'eval-buffer)
(evil-define-key 'normal 'global (kbd "<leader>t") 'eshell)


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

(define-key evil-normal-state-map (kbd "C-w") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-S-w") 'evil-numbers/dec-at-pt)
(define-key evil-normal-state-map (kbd "C-e") 'move-end-of-line)
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-normal-state-map (kbd "gt") 'persp-switch-last)
(define-key evil-insert-state-map (kbd "C-a") 'move-beginning-of-line)
(define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)
