(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compile-command "./build.sh")
 '(custom-enabled-themes '(wheatgrass))
 '(display-line-numbers 'relative)
 '(display-time-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages '(vertico consult evil))
 '(scroll-bar-mode nil)
 '(timeclock-mode-line-display nil)
 '(tool-bar-mode nil)
 '(vertico-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight regular :height 157 :width normal)))))

(package-install 'vertico)
(package-install 'consult)
(package-install 'evil)

(evil-mode t)
(evil-global-set-key 'normal (kbd "SPC RET") (quote consult-bookmark))
(evil-global-set-key 'normal (kbd "SPC e") (quote eshell))
(global-set-key [f4] 'compile)
(global-set-key (kbd "C-;") 'comment-line)
