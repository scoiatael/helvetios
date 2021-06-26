(ql:quickload :cffi)
(pushnew '(merge-pathnames #p"Documents/common-lisp/cl-webengine/source/" (user-homedir-pathname))
            cffi:*foreign-library-directories*
            :test #'equal)

(ql:quickload :trivial-main-thread)
(ql:quickload :cl-webengine)
(ql:quickload :helvetios)

(trivial-main-thread:call-in-main-thread
 (lambda () (sb-int:with-float-traps-masked (:invalid :inexact :overflow :divide-by-zero) (cl-webengine::run))))

(helvetios:start)
(helvetios:quit)

(trivial-main-thread:call-in-main-thread
 (lambda () (sb-int:with-float-traps-masked (:invalid :inexact :overflow :divide-by-zero) (helvetios:main))))