(in-package #:factual.core)

(defclass deb-package ()
  ((depends :accessor depends :initform nil)
   (data-files :accessor data-files :initform nil)))

(defclass node ()
  ((name :accessor name :initarg :name :type string)
   (path :reader path :initarg :path :type pathname)
   (packages :accessor packages :type list)
   (variables :accessor variables :type list :initform nil)))

(defclass variable ()
  ((package :initarg :package :reader package)
   (name :initarg :name :reader name)
   (value :initarg :value :reader value)))

(defmethod deb-pathname ((node node))
  (pathname
   (format nil "~A_~A.deb"
           (name node)
           (local-time:format-rfc3339-timestring nil (local-time:now)))))
