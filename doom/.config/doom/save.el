;; -*- mode: emacs-lisp; eval: (progn (pp-buffer) (indent-buffer)) -*-
((def-persp nil
            ((def-eshell-buffer "*eshell*"
                                ((major-mode . eshell-mode)
                                 (default-directory
                                  . "/home/kayon/git/illusion-front/"))))
            (def-wconf
             (((min-height . 4) (min-width . 10) (min-height-ignore . 2)
               (min-width-ignore . 4) (min-height-safe . 1) (min-width-safe . 2)
               (min-pixel-height . 120) (min-pixel-width . 130)
               (min-pixel-height-ignore . 60) (min-pixel-width-ignore . 52)
               (min-pixel-height-safe . 30) (min-pixel-width-safe . 26))
              leaf (pixel-width . 1056) (pixel-height . 1050) (total-width . 81)
              (total-height . 35) (normal-height . 1.0) (normal-width . 1.0)
              (parameters
               (better-jumper-struct . #s(better-jumper-jump-list-struct nil -1)))
              (buffer "*scratch*" (selected . t) (hscroll . 0)
                      (fringes 8 8 nil nil) (margins nil)
                      (scroll-bars nil 0 t nil 0 t nil) (vscroll . 0)
                      (dedicated) (point . 1) (start . 1))))
            (def-params nil) t nil t)
 (def-persp "illusion"
            ((def-buffer "Navbar.jsx"
                         "/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                         rjsx-mode)
             (def-buffer "illusion-front" "/home/kayon/git/illusion-front/"
                         dired-mode)
             (def-buffer "vite.config.js"
                         "/home/kayon/git/illusion-front/vite.config.js"
                         rjsx-mode)
             (def-buffer "style.css"
                         "/home/kayon/git/illusion-front/src/Components/Navbar/style.css"
                         css-mode)
             (def-buffer "Navbar"
                         "/home/kayon/git/illusion-front/src/Components/Navbar/"
                         dired-mode)
             (def-buffer "Programming.jsx"
                         "/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                         rjsx-mode)
             (def-buffer "init.el"
                         "/home/kayon/dotfiles/doom/.config/doom/init.el"
                         emacs-lisp-mode)
             (def-buffer "List.jsx"
                         "/home/kayon/git/illusion-front/src/Pages/Roadmaps/List.jsx"
                         rjsx-mode)
             (def-buffer "main.css"
                         "/home/kayon/git/illusion-front/src/main.css" css-mode)
             (def-buffer "config.el"
                         "/home/kayon/dotfiles/doom/.config/doom/config.el"
                         emacs-lisp-mode)
             (def-buffer "accounts.txt"
                         "/home/kayon/drive/passwords/accounts.txt" text-mode))
            (def-wconf
             (((min-height . 4) (min-width . 10) (min-height-ignore . 2)
               (min-width-ignore . 4) (min-height-safe . 1) (min-width-safe . 2)
               (min-pixel-height . 120) (min-pixel-width . 130)
               (min-pixel-height-ignore . 60) (min-pixel-width-ignore . 52)
               (min-pixel-height-safe . 30) (min-pixel-width-safe . 26))
              leaf (pixel-width . 1056) (pixel-height . 1050) (total-width . 81)
              (total-height . 35) (normal-height . 1.0) (normal-width . 1.0)
              (parameters
               (better-jumper-struct
                . #s(better-jumper-jump-list-struct
                     (78 100
                         . [("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "1wrrkg")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "e9hajd")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "zbmewa")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "4q7f3a")
                            ("/home/kayon/git/illusion-front/vite.config.js" 1
                             "ilaadb")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/style.css"
                             1 "pmmf0k")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/style.css"
                             32 "nxn84x")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             1 "cuyi4l")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             322 "zmtwoo")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             291 "6chajf")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "48qfo4")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "128jh2")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "pram94")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "lk1wkq")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "bw12g6")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "ec9uon")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "mng9ed")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "an7075")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "rjchgx")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "pq7img")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "bteb7z")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "zkwyzy")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "mabb3c")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "xftlj6")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "j6yad6")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "pbupci")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "po8xtk")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "5ddvrq")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "f3cgon")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "scypgk")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "7ear4o")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "89yuo5")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "4n17cb")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "8eibk3")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "eyj5ex")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "rlgj1l")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "xe5s4m")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "2w5s83")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "jbpkpi")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "7sunva")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "ovt5ax")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "jae079")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "jhhi8r")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "z1y5dm")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "bcsl6j")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "z8mmhr")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             23 "odtae8")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "rm9gz2")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "zlqdqn")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "x2wcmp")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "wbny0s")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "4qamrn")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "ddjbv4")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "9ie692")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "azhlan")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "hhekmy")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "6d2s1p")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "659gpk")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "erwp99")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "f16sdm")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "h124ma")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "6ch14o")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "i8uzz8")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "w3k2nu")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "xz8ri7")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "subbph")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "bg08ry")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "plu1bw")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "kb867q")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "1dslmu")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "8dgz3a")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "wf47ly")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "3tjohm")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "q85e51")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "gokyv9")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             380 "ivxtst")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             21 "f43235")
                            ("/home/kayon/git/illusion-front/src/Components/Navbar/Navbar.jsx"
                             357 "s21jem")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "ntsbd8")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "brh9r8")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "d5nvjq")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "iqpcn0")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "20rt9p")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "buyp78")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "dz3di3")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "zpbtrk")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "zw6nn6")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "1y8182")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "cryfh4")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "5i834a")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "4kvtvj")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "cg9hkh")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "c77iea")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "99fmem")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "4smb7g")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "upbu5v")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "ddn650")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "cgy3ff")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1115 "xmfhp2")
                            ("/home/kayon/git/illusion-front/src/Pages/Roadmaps/Programming/Programming.jsx"
                             1 "tz9kn0")])
                     -1)))
              (buffer "Navbar.jsx" (selected . t) (hscroll . 0)
                      (fringes 8 8 t nil) (margins nil)
                      (scroll-bars nil 0 t nil 0 t nil) (vscroll . 0)
                      (dedicated) (point . 358) (start . 88))
              (prev-buffers ("*scratch*" 1 1) ("Navbar.jsx" 88 357)
                            ("*eshell*" 1 381) ("illusion-front" 1 196)
                            ("style.css" 1 1) ("vite.config.js" 1 149)
                            ("Programming.jsx" 820 1115) ("List.jsx" 1 108)
                            ("Navbar" 1 158) ("accounts.txt" 1 1)
                            ("config.el" 3291 3623) ("init.el" 1 119)
                            ("main.css" 1 5))))
            (def-params nil) nil nil nil)
 (def-persp "scratch" nil
            (def-wconf
             (((min-height . 4) (min-width . 10) (min-height-ignore . 2)
               (min-width-ignore . 4) (min-height-safe . 1) (min-width-safe . 2)
               (min-pixel-height . 120) (min-pixel-width . 130)
               (min-pixel-height-ignore . 60) (min-pixel-width-ignore . 52)
               (min-pixel-height-safe . 30) (min-pixel-width-safe . 26))
              leaf (pixel-width . 1056) (pixel-height . 1050) (total-width . 81)
              (total-height . 35) (normal-height . 1.0) (normal-width . 1.0)
              (parameters
               (better-jumper-struct
                . #s(better-jumper-jump-list-struct
                     (0 1
                        . [("*scratch*" 1 "0zth6l") nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil])
                     -1)))
              (buffer "*doom:scratch*" (selected . t) (hscroll . 0)
                      (fringes 8 8 t nil) (margins nil)
                      (scroll-bars nil 0 t nil 0 t nil) (vscroll . 0)
                      (dedicated) (point . 4634) (start . 4012))
              (prev-buffers ("*scratch*" 1 1) ("*doom:scratch*" 4012 4634)
                            ("Navbar.jsx" 88 358) ("*eshell*" 1 381)
                            ("illusion-front" 1 196) ("style.css" 1 1)
                            ("vite.config.js" 1 149)
                            ("Programming.jsx" 820 1115) ("List.jsx" 1 108)
                            ("Navbar" 1 158) ("accounts.txt" 1 1)
                            ("config.el" 3291 3623) ("init.el" 1 119)
                            ("main.css" 1 5))))
            (def-params nil) nil nil nil)
 (def-persp "dotfiles"
            ((def-magit-status-buffer "*magit: ~/dotfiles/*"
                                      ((major-mode . magit-status-mode)
                                       (default-directory
                                        . "/home/kayon/dotfiles/")))
             (def-buffer "dotfiles" "/home/kayon/dotfiles/" dired-mode))
            (def-wconf
             (((min-height . 4) (min-width . 10) (min-height-ignore . 2)
               (min-width-ignore . 3) (min-height-safe . 1) (min-width-safe . 2)
               (min-pixel-height . 120) (min-pixel-width . 130)
               (min-pixel-height-ignore . 60) (min-pixel-width-ignore . 39)
               (min-pixel-height-safe . 30) (min-pixel-width-safe . 26))
              leaf (pixel-width . 1056) (pixel-height . 1050) (total-width . 81)
              (total-height . 35) (normal-height . 1.0) (normal-width . 1.0)
              (parameters
               (better-jumper-struct
                . #s(better-jumper-jump-list-struct
                     (0 1
                        . [("*scratch*" 1 "csnzp0") nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil nil nil nil nil nil nil nil nil nil nil nil nil
                           nil])
                     -1)))
              (buffer "dotfiles" (selected . t) (hscroll . 0)
                      (fringes 3 1 nil nil) (margins nil)
                      (scroll-bars nil 0 t nil 0 t nil) (vscroll . 0)
                      (dedicated) (point . 288) (start . 1))
              (next-buffers "*magit: ~/dotfiles/*")
              (prev-buffers ("*magit: ~/dotfiles/*" 1 127) ("dotfiles" 1 288)
                            ("*scratch*" 1 1) ("*doom:scratch*" 4012 4634)
                            ("Navbar.jsx" 88 358) ("*eshell*" 1 381)
                            ("illusion-front" 1 196) ("style.css" 1 1)
                            ("vite.config.js" 1 149)
                            ("Programming.jsx" 820 1115) ("List.jsx" 1 108)
                            ("Navbar" 1 158) ("accounts.txt" 1 1)
                            ("config.el" 3291 3623) ("init.el" 1 119)
                            ("main.css" 1 5))))
            (def-params nil) nil nil nil))
