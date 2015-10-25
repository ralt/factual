(in-package #:factual.core)

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
