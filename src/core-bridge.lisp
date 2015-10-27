(in-package #:factual)

(defmacro define-variable (variable key)
  `(progn
     (defvar ,variable nil)
     (factual.core:add-variable (package-name *package*)
                                (symbol-name ',variable) ,key)))

(defmacro ensure (type values)
  `(factual.core:add-fact (package-name *package*)
                          ,type
                          (lambda () (progn ,values))))
