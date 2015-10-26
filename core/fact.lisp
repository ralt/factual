(in-package #:factual.core)

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

(defun fill-variables (node)
  (dolist (var (variables node))
    (load-packages node)
    (let ((symbol (intern (name var) (find-package
                                      (intern
                                       (string-upcase (package var))
                                       :keyword)))))
      (setf symbol (value var)))))

(defun apply-facts (deb-package node)
  (dolist (p (packages node))
    (dolist (constraint (gethash p *constraints*))
      (funcall (gethash (getf constraint :type) *constraint-types*)
               deb-package
               (funcall (getf constraint :values))))))
