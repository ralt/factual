(defpackage #:factual.core
  (:use #:cl)
  (:export :define-constraint-type
           :add-variable
           :add-constraint
           :add-dependency
           :add-data-file))

(defpackage #:factual
  (:use #:cl)
  (:export :define-variable
           :ensure
           :template))
