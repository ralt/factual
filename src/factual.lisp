(in-package #:factual)

(defvar *variables* (make-hash-table))

(defmacro define-variable (variable key)
  `(progn
     (defvar ,variable)
     (push ,key (gethash *package* factual::*variables*))))

(defgeneric ensure (type value)
  (:documentation "Ensures a fact."))

(defmethod ensure ((type (eql :package)) package)
  (add-dependency package))

(defmethod ensure ((type (eql :packages)) packages)
  (dolist (package packages)
    (ensure :package package)))

(defmethod ensure ((type (eql :file)) file)
  (add-data-file `(:path ,(remove-leading-slash (getf file :path))
                   :content ,(string-to-bytes-vector (getf file :content))
                   :mode ,(getf file :mode))))

(defmethod ensure ((type (eql :files)) files)
  (dolist (file files)
    (ensure :file file)))

(defmethod ensure ((type (eql :user)) user))

(defmethod ensure ((type (eql :users)) users)
  (dolist (user users)
    (ensure :user user)))
