(asdf:defsystem #:factual
  :description "Make up and apply facts."
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :serial t
  :depends-on (:trivial-utf-8 :deb-packager)
  :components ((:file "packages")
               (:module "core"
                :components ((:file "core" :depends-on ("classes"))
                             (:file "classes")))
               (:module "src"
                :components ((:file "factual" :depends-on ("utils"))
                             (:file "core-bridge")
                             (:file "utils")))))
