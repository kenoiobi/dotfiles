;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Consolas Nerd Font" :size 30 :weight 'regular)
     doom-variable-pitch-font (font-spec :family "Consolas Nerd Font" :size 30))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-solarized-light)
(setq doom-theme 'doom-oceanic-next)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(setq neo-window-position 'right)

(map! :leader
 "e" #'find-file
 "t" #'term
 "k" #'kill-buffer
 "," #'previous-buffer
 "." #'next-buffer
 "a" #'consult-buffer
 "f" #'consult-ripgrep

 "TAB s" (lambda () (interactive)
           (doom/save-session "~/.config/doom/session")
           )

 "x" (lambda () (interactive)
       (doom/open-scratch-buffer)
       (delete-other-windows)
       )

 "1" #'+workspace/switch-to-0
 "2" #'+workspace/switch-to-1
 "3" #'+workspace/switch-to-2
 "4" #'+workspace/switch-to-3
 "5" #'+workspace/switch-to-4
 "6" #'+workspace/switch-to-5
 "7" #'+workspace/switch-to-6
 "8" #'+workspace/switch-to-7
 "9" #'+workspace/switch-to-8
 "0" #'+workspace/switch-to-9
 )

(map!
 :e
 "<escape>" (lambda () (interactive)
              (evil-normal-state)
              )

 :i
 "C-p" #'previous-line
 :i
 "C-n" #'next-line
 :i
 "M-a" #'backward-paragraph
 :i
 "M-e" #'forward-paragraph

 :n
 "C-e" #'doom/forward-to-last-non-comment-or-eol
 :n
 "M-a" #'backward-paragraph
 :n
 "M-e" #'forward-paragraph
)
(map!
 "C-<prior>" #'+tabs:previous-or-goto
 "C-<next>" #'+tabs:next-or-goto
 "C-S-<prior>" #'centaur-tabs-move-current-tab-to-left
 "C-S-<next>" #'centaur-tabs-move-current-tab-to-right
 "<f3>" #'compile
 )

(add-hook 'find-file-hook 'zoxide-add)
(add-hook 'dired-mode-hook 'zoxide-add)

(require 'fzf)

(map! :leader
      "z" #'my-zoxide
)

(defun my-zoxide () (interactive)
       (find-file "~/")
       (fzf-with-command "zoxide query -l" 'find-file)
       )


(global-blamer-mode 1)

(centaur-tabs-mode t)
(after! centaur-tabs (centaur-tabs-group-buffer-groups))

;; (doom/load-session "~/.config/doom/session")

(setq indent-bars-starting-column 0)
(add-hook 'prog-mode-hook 'indent-bars-mode)

(setq show-trailing-whitespace t)
(setq dired-listing-switches "-goAht --group-directories-first")
(setq delete-by-moving-to-trash t)
(setq auto-save-visited-interval 0)

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . rjsx-mode))
(display-time-mode t)
;; (auto-save-visited-mode +1)
(require 'org-mouse)
