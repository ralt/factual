(in-package #:utils)

(define-variable *user* "user")

(ensure :package "vagrant")

(ensure :packages '("software-properties-common"
                    "git"
                    "emacs24"
                    "tmux"
                    "gnupg"
                    "iojs"
                    "unzip"
                    "lxc"
                    "tree"
                    "isync"
                    "aspell-fre"
                    "gpgsm"
                   "cloc"
                    "exuberant-ctags"
                    "equivs"
                    "devscripts"))

(ensure :file `(:path #p"/usr/bin/lock"
                :content ,(format nil "#!/bin/bash~%pyxtrlock~%")
                :mode 755))

(ensure :files `((:path #p"/usr/bin/repo"
                  :content ,(template "utils://repo")
                  :mode 755)
                 (:path #p"/usr/bin/setkeyboard"
                  :content ,(template "utils://setkeyboard")
                  :mode 755)
                 (:path #p"/usr/bin/suspend"
                  :content ,(template "utils://suspend")
                  :mode 755)))

(ensure :files `((:path ,(pathname (format nil "/home/~A/.emacs" *user*))
                  :content ,(template "utils://emacs")
                  :mode 666)
                 (:path ,(pathname (format nil "/home/~A/.gitconfig" *user*))
                  :content ,(template "utils://gitconfig")
                  :mode 666)
                 (:path ,(pathname (format nil "/home/~A/.tmux.conf" *user*))
                  :content ,(template "utils://tmux.conf")
                  :mode 666)))

(ensure :user `(:user ,*user*
                :group "sudo"))
