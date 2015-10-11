(in-package #:factual.core)

(defclass deb-package ()
  ((depends :accessor :depends :initform nil)
   (data-files :accessor :data-files :initform nil)))

(defclass node ()
  ((name :accessor :name :initarg :name)))

(defmethod deb-path ((node node))
  (name node))
