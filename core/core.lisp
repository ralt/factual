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

(defun make-debian-package (node)
  (let ((deb-package (make-instance 'deb-package)))
    (dolist (package (load-packages node))
      (fill-variables package node)
      (apply-facts deb-package package))
    (let* ((changelog-entries (get-changelog-entries))
           (deb (get-deb node deb-package changelog-entries))
           (data-files (get-data-files deb-package)))
      (deb-packager:initialize-control-files deb #())
      (deb-packager:initialize-data-files deb data-files)
      (deb-packager:write-deb-file (deb-pathname node) deb))))

(defun get-changelog-entries ()
  (make-array
   1
   :initial-contents
   `(,(make-instance 'deb-packager:changelog-entry
                     :version "1"
                     :author "author"
                     :message "message"
                     :date 1434665998))))

(defun get-deb (node deb-package changelog-entries)
  (make-instance 'deb-packager:deb-package
                 :name (intern (name node))
                 :changelog changelog-entries
                 :description "description"
                 :architecture "amd64"
                 :depends (depends deb-package)
                 :build-depends nil
                 :long-description "long-description"
                 :maintainer "maintainer"))

(defun get-data-files (deb-package)
  (make-array (length (data-files deb-package))
              :initial-contents
              (mapcar
               (lambda (file)
                 (make-instance
                  'deb-packager:deb-file
                  :path (getf file :path)
                  :content (getf file :content)
                  :size (length (getf file :content))
                  :mode (getf file :mode)))
               (data-files deb-package))))

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
