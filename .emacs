(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(column-number-mode t)
 '(company-backends
   '(company-bbdb company-semantic company-cmake company-capf company-clang company-files
                  (company-dabbrev-code company-gtags company-etags company-keywords)
                  company-oddmuse company-dabbrev))
 '(compilation-scroll-output 'first-error)
 '(compile-command "./build.sh")
 '(cua-mode t)
 '(custom-enabled-themes '(tsdh-dark))
 '(display-line-numbers 'visual)
 '(display-time-24hr-format t)
 '(display-time-mode t)
 '(evil-default-state 'emacs)
 '(evil-mode t)
 '(evil-toggle-key "C-z")
 '(indent-bars-display-on-blank-lines t)
 '(indent-bars-spacing-override 4)
 '(indent-bars-starting-column 0)
 '(indent-bars-width-frac 1)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(line-number-mode nil)
 '(lsp-headerline-breadcrumb-enable nil)
 '(lsp-java-workspace-dir "/home/kayon/java/springboot/apisocialmedia")
 '(menu-bar-mode nil)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("nongnu" . "https://elpa.nongnu.org/nongnu/")
     ("melpa-stable" . "https://stable.melpa.org/packages/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-selected-packages
   '(eyebrowse-restore eyebrowse god-mode lsp-pyright lsp-jedi rjsx-mode free-keys imenu-anywhere helm-lsp which-key lsp-ui company yasnippet flycheck projectile lsp-java indent-bars rainbow-identifiers evil))
 '(scroll-bar-mode nil)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(yas-global-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Noto Sans Mono" :foundry "GOOG" :slant normal :weight regular :height 180 :width normal)))))

;; java

(condition-case nil
    (require 'use-package)
  (file-error
   (require 'package)
   (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
   (package-initialize)
   (package-refresh-contents)
   (package-install 'use-package)
   (setq use-package-always-ensure t)
   (require 'use-package)))

(use-package projectile)
(use-package flycheck)
(use-package yasnippet :config (yas-global-mode))
(use-package lsp-mode :hook ((lsp-mode . lsp-enable-which-key-integration)))
(use-package hydra)
(use-package company)
(use-package lsp-ui)
(use-package which-key :config (which-key-mode))
(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))
(use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
(use-package dap-java :ensure nil)
(use-package helm-lsp)
(use-package helm
  :config (helm-mode))
(use-package lsp-treemacs)

;; python

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred


;; eyebrowser (i3-like workspaces)

(eyebrowse-mode t)
(global-set-key (kbd "C-1") 'eyebrowse-switch-to-window-config-1)
(global-set-key (kbd "C-2") 'eyebrowse-switch-to-window-config-2)
(global-set-key (kbd "C-3") 'eyebrowse-switch-to-window-config-3)
(global-set-key (kbd "C-4") 'eyebrowse-switch-to-window-config-4)
(global-set-key (kbd "C-5") 'eyebrowse-switch-to-window-config-5)
(global-set-key (kbd "C-6") 'eyebrowse-switch-to-window-config-6)
(global-set-key (kbd "C-7") 'eyebrowse-switch-to-window-config-7)
(global-set-key (kbd "C-8") 'eyebrowse-switch-to-window-config-8)
(global-set-key (kbd "C-9") 'eyebrowse-switch-to-window-config-9)
(global-set-key (kbd "C-0") 'eyebrowse-switch-to-window-config-0)
(eyebrowse-create-window-config)
(global-set-key (kbd "C-'") #'(lambda () (interactive)
                                (eyebrowse-switch-to-window-config 10)
                                (find-file "~/.emacs")
                                ))

;; my configs

(evil-mode 1)
(global-set-key [f4] 'compile)
(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)
(add-hook 'prog-mode-hook 'indent-bars-mode)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(global-set-key [f12] 'lsp-execute-code-action)
(global-set-key [f9] 'lsp-workspace-restart)
(add-hook 'js-mode-hook #'lsp)

