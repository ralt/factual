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

(defun read-nodes ()
  (mapcar
   (lambda (n)
     (let ((node (make-instance 'node
                                :name (pathname-name n)
                                :path n))
           (content (yaml:parse (alexandria:read-file-into-string n))))
       (populate-node node content)))
   (fad:list-directory "nodes")))

(defun populate-node (node content)
  (multiple-value-prog1 node
    (setf (packages node) (gethash "packages" content))
    (populate-variables node content)))

(defun populate-variables (node content)
  (let ((keys (remove-if (lambda (k) (string= k "packages"))
                         ;; Every key but "packages" is a variable
                         (alexandria:hash-table-keys content)))
        (packages (packages node)))
    (dolist (package packages)
      (dolist (key keys)
        (destructuring-bind (package-name variable-name)
            (ppcre:split "::" key)
          (when (string= package package-name)
            (push (make-instance 'variable
                                 :package package
                                 :name variable-name
                                 :value (gethash key content))
                  (variables node))))))))

(defun load-packages (node)
  (asdf:initialize-source-registry (packages-path))
  (asdf:clear-source-registry)
  (let ((pkgs (packages node)))
    (multiple-value-prog1 pkgs
      (dolist (p pkgs)
        (asdf:load-system p)))))

(defun packages-path ()
  (merge-pathnames #p"packages/"
                   ;; current working directory
                   #p""))

(defun fill-variables (package node))

(defun apply-facts (deb-package package))
