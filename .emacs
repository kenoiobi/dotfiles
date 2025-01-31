(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compile-command "./build.sh")
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
   '(doom-themes harpoon flycheck-inline rjsx-mode flycheck lsp-mode ranger projectile evil-collection vertico consult evil))
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
 '(default ((t (:inherit nil :extend nil :stipple nil :background "black" :foreground "wheat" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 158 :width normal :foundry "PfEd" :family "Noto Sans Mono")))))

;; functionality
(package-install 'vertico)
(package-install 'consult)
(package-install 'evil)
(package-install 'projectile)
(package-install 'evil-collection)
(package-install 'harpoon)

;; lsp bs
(package-install 'rjsx-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))

(package-install 'lsp-mode)
(add-hook 'rjsx-mode-hook 'lsp)

(package-install 'flycheck)
(package-install 'flycheck-inline)
(global-flycheck-mode +1)
(add-hook 'flycheck-mode-hook #'flycheck-inline-mode)

;; evil
(evil-mode t)
(evil-collection-init)

;; key chords
(defvar pchord (make-sparse-keymap))

(define-key pchord (kbd "p") 'projectile-switch-project)
(define-key pchord (kbd "a") 'projectile-add-known-project)

(defvar chord (make-sparse-keymap))

(define-key chord (kbd "e") 'eshell)
(define-key chord (kbd "RET") 'consult-bookmark)
(define-key chord (kbd "p") pchord)
(define-key chord (kbd "SPC") 'projectile-find-file)
(define-key chord (kbd ".") 'find-file)

(evil-global-set-key 'normal (kbd "SPC") chord)
(evil-define-key 'normal dired-mode-map (kbd "SPC") chord)

;; keybindings
(global-set-key [f4] 'compile)
(global-set-key (kbd "C-;") 'comment-line)
(setq default-directory "~/")

;; harpoon
(global-set-key (kbd "C-s") 'harpoon-add-file)
(define-key chord (kbd "1") 'harpoon-go-to-1)
(define-key chord (kbd "2") 'harpoon-go-to-2)
(define-key chord (kbd "3") 'harpoon-go-to-3)
(define-key chord (kbd "4") 'harpoon-go-to-4)
(define-key chord (kbd "5") 'harpoon-go-to-5)
(define-key chord (kbd "6") 'harpoon-go-to-6)
(define-key chord (kbd "7") 'harpoon-go-to-7)
(define-key chord (kbd "8") 'harpoon-go-to-8)
(define-key chord (kbd "9") 'harpoon-go-to-9)

(defvar jchord (make-sparse-keymap))
(define-key jchord (kbd "c") 'harpoon-clear)
(define-key jchord (kbd "f") 'harpoon-toggle-file)

(define-key chord (kbd "j") jchord)

(global-set-key "\C-x2" (lambda () (interactive)(split-window-vertically) (other-window 1)))
(global-set-key "\C-x3" (lambda () (interactive)(split-window-horizontally) (other-window 1)))
(define-key evil-normal-state-map (kbd "C-w") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-S-w") 'evil-numbers/dec-at-pt)
(define-key evil-normal-state-map (kbd "C-e") 'move-end-of-line)

(define-key evil-insert-state-map (kbd "C-a") 'move-beginning-of-line)
(define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)
