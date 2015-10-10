(defpackage #:factual.core
  (:use #:cl)
  (:export :add-dependency
           :add-data-file))

(defpackage #:factual
  (:use #:cl #:factual.core)
  (:export :define-variable
           :ensure))
