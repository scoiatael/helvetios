(ql:quickload :cffi)
(pushnew '(merge-pathnames #p"documents/common-lisp/cl-webengine/source/" (user-homedir-pathname))
            cffi:*foreign-library-directories*
            :test #'equal)

(ql:quickload :helvetios)

(trivial-main-thread:call-in-main-thread
 (lambda () (sb-int:with-float-traps-masked (:invalid :inexact :overflow :divide-by-zero) (helvetios:run))))

(trivial-main-thread:stop-main-runner)

(helvetios:stop)
