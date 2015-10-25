(asdf:defsystem #:factual
  :description "Make up and apply facts."
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :serial t
  :depends-on (:trivial-utf-8
               :deb-packager
               :cl-fad
               :alexandria
               :cl-yaml
               :cl-ppcre
               :local-time
               :log4cl)
  :components ((:file "packages")
               (:module "core"
                :components ((:file "core" :depends-on ("classes" "deb-package"))
                             (:file "classes")
                             (:file "deb-package" :depends-on ("classes"))))
               (:module "src"
                :components ((:file "factual" :depends-on ("utils"))
                             (:file "core-bridge")
                             (:file "utils")))))
