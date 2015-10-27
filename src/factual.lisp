(in-package #:factual)

(defun template (path))

(factual.core:define-fact-type :package (package value)
  (factual.core:add-dependency package value))

(factual.core:define-fact-type :packages (package values)
  (dolist (value values)
    (factual.core:add-dependency package value)))

(factual.core:define-fact-type :file (package file)
  (factual.core:add-data-file package (file-to-data-file file)))

(factual.core:define-fact-type :files (package files)
  (dolist (file files)
    (factual.core:add-data-file package (file-to-data-file file))))

(factual.core:define-fact-type :user (package user))

(factual.core:define-fact-type :users (package users))
