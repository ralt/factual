(asdf:defsystem #:factual.utils
  :description "Utils"
  :serial t
  :depends-on (:factual)
  :components ((:file "package")
               (:file "utils")))
