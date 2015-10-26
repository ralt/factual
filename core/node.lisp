(in-package #:factual.core)

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
