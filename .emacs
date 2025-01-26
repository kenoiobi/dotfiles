(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compile-command "./build.sh")
 '(custom-enabled-themes '(wheatgrass))
 '(dired-dwim-target t)
 '(display-line-numbers 'relative)
 '(display-time-mode t)
 '(evil-want-keybinding nil)
 '(max-lisp-eval-depth 3200)
 '(menu-bar-mode nil)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("nongnu" . "https://elpa.nongnu.org/nongnu/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-selected-packages
   '(rjsx-mode flycheck lsp-mode ranger projectile evil-collection vertico consult evil))
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

;; packages
(package-install 'vertico)
(package-install 'consult)
(package-install 'evil)
(package-install 'projectile)
(package-install 'evil-collection)

;; evil
(evil-mode t)
(evil-collection-init)

(defvar pchord (make-sparse-keymap)

  "Keymap for project-related commands.")

(define-key pchord (kbd "p") 'projectile-switch-project)
(define-key pchord (kbd "a") 'projectile-add-known-project)

(defvar chord (make-sparse-keymap)

  "Keymap for project-related commands.")

(define-key chord (kbd "e") 'eshell)
(define-key chord (kbd "RET") 'consult-bookmark)
(define-key chord (kbd "p") pchord)
(define-key chord (kbd "SPC") 'projectile-find-file)

(evil-global-set-key 'normal (kbd "SPC") chord)
(evil-define-key 'normal dired-mode-map (kbd "SPC") chord)

;; keybindings
(global-set-key [f4] 'compile)
(global-set-key (kbd "C-;") 'comment-line)
