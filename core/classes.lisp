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
   (format nil "~A_~{~A~^-~}.deb"
           (name node)
           (let ((now (local-time:now)))
             (list (local-time:timestamp-year now)
                   (local-time:timestamp-month now)
                   (local-time:timestamp-day now)
                   (local-time:timestamp-hour now)
                   (local-time:timestamp-minute now)
                   (local-time:timestamp-second now))))))
