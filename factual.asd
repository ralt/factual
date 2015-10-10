(asdf:defsystem #:factual
  :description "Make up and apply facts."
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :serial t
  :depends-on (:trivial-utf-8)
  :components ((:file "packages")
               (:module "src"
                :components ((:file "factual" :depends-on ("utils"))
                             (:file "utils")))
               (:module "core"
                :components ((:file "core")))))
