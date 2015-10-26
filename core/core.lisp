(in-package #:factual.core)

(defvar *variables* (make-hash-table))
(defvar *constraints* (make-hash-table))
(defvar *constraint-types* (make-hash-table))

(defmacro define-constraint-type (type vars &body body)
  `(setf (gethash ,type *constraint-types*)
         #'(lambda ,vars
             ,@body)))

(defun add-variable (package symbol-name key)
  (push `(:symbol ,symbol-name :key ,key)
        (gethash package *variables*)))

(defun add-constraint (package type values)
  (push `(:type ,type :values ,values)
        (gethash package *constraints*)))

(defun add-dependency (deb-package dependency)
  (push dependency (depends deb-package)))

(defun add-data-file (deb-package file)
  (push file (data-files deb-package)))

(defun main (&rest args)
  (declare (ignore args))
  (dolist (node (read-nodes))
    (log:info "Found node ~A" (name node))
    (make-debian-package node)))
