(in-package #:factual.core)

(defvar *variables* (make-hash-table))
(defvar *facts* (make-hash-table))
(defvar *fact-types* (make-hash-table))

(defmacro define-fact-type (type vars &body body)
  `(setf (gethash ,type *fact-types*)
         #'(lambda ,vars
             ,@body)))

(defun add-variable (package symbol-name key)
  (push `(:symbol ,symbol-name :key ,key)
        (gethash package *variables*)))

(defun add-fact (package type values)
  (push `(:type ,type :values ,values)
        (gethash package *facts*)))

(defun add-dependency (deb-package dependency)
  (push dependency (depends deb-package)))

(defun add-data-file (deb-package file)
  (push file (data-files deb-package)))

(defun main (&rest args)
  (declare (ignore args))
  (dolist (node (read-nodes))
    (log:info "Found node ~A" (name node))
    (make-debian-package node)))
