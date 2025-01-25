;; my config

(global-set-key (kbd "C-;") (quote comment-line))
(global-set-key (kbd "<f4>") (quote compile))
(map! :leader "e" (quote eshell))

(map! :leader "'"
      (lambda () (interactive)
        (let (project-root (projectile-project-root))
          (find-file (expand-file-name "project.org" project-root))
          )))

;; harpoon

(map! :n "C-s" 'harpoon-add-file)
(map! :leader "j c" 'harpoon-clear)
(map! :leader "j f" 'harpoon-toggle-file)
(map! :leader "1" 'harpoon-go-to-1)
(map! :leader "2" 'harpoon-go-to-2)
(map! :leader "3" 'harpoon-go-to-3)
(map! :leader "4" 'harpoon-go-to-4)
(map! :leader "5" 'harpoon-go-to-5)
(map! :leader "6" 'harpoon-go-to-6)
(map! :leader "7" 'harpoon-go-to-7)
(map! :leader "8" 'harpoon-go-to-8)
(map! :leader "9" 'harpoon-go-to-9)
