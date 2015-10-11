(in-package #:factual)

(defmacro define-variable (variable key)
  `(progn
     (defvar ,variable nil)
     (factual.core:add-variable *package* (symbol-name ',variable) ,key)))

(defmacro ensure (type values)
  `(factual.core:add-constraint *package* ,type #'(lambda () (progn ,values))))

(defun template (path))

(factual.core:define-constraint-type :package (package value)
  (factual.core:add-dependency package value))

(factual.core:define-constraint-type :packages (package values)
  (dolist (value values)
    (factual.core:add-dependency package value)))

(factual.core:define-constraint-type :file (package file)
  (factual.core:add-data-file package file))

(factual.core:define-constraint-type :files (package files)
  (dolist (file files)
    (factual.core:add-data-file package file)))

(factual.core:define-constraint-type :user (package user))

(factual.core:define-constraint-type :users (package users))
