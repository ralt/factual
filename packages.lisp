(defpackage #:factual.core
  (:use #:cl)
  (:shadow :variable)
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
