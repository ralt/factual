(defpackage #:factual.core
  (:use #:cl)
  (:shadow :variable
           :package)
  (:export :define-fact-type
           :add-variable
           :add-fact
           :add-dependency
           :add-data-file))

(defpackage #:factual
  (:use #:cl)
  (:export :define-variable
           :ensure
           :template))
