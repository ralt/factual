(in-package #:factual)

(defun remove-leading-slash (pathname)
  (let ((path-as-string (namestring pathname)))
    (pathname (subseq path-as-string 1))))

(defun string-to-bytes-vector (string)
  (trivial-utf-8:string-to-utf-8-bytes string))

(defun file-to-data-file (file)
  `(:path ,(remove-leading-slash (getf file :path))
    :content ,(string-to-bytes-vector (getf file :content))
    :mode ,(getf file :mode)))
