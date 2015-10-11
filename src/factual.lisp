(in-package #:factual)

(defun template (path))

(factual.core:define-constraint-type :package (package value)
  (factual.core:add-dependency package value))

(factual.core:define-constraint-type :packages (package values)
  (dolist (value values)
    (factual.core:add-dependency package value)))

(factual.core:define-constraint-type :file (package file)
  (factual.core:add-data-file package (file-to-data-file file)))

(factual.core:define-constraint-type :files (package files)
  (dolist (file files)
    (factual.core:add-data-file package (file-to-data-file file))))

(factual.core:define-constraint-type :user (package user))

(factual.core:define-constraint-type :users (package users))
