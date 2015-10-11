(in-package #:factual)

(defmacro define-variable (variable key)
  `(progn
     (defvar ,variable nil)
     (factual.core:add-variable *package* (symbol-name ',variable) ,key)))

(defmacro ensure (type values)
  `(factual.core:add-constraint *package* ,type #'(lambda () (progn ,values))))
