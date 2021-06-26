(progn
  (ql:quickload :cffi)
  (pushnew '(merge-pathnames #p"documents/common-lisp/cl-webengine/source/" (user-homedir-pathname))
           cffi:*foreign-library-directories*
           :test #'equal)
  (ql:quickload :helvetios))

(helvetios:run)

(trivial-main-thread:stop-main-runner)

(helvetios:stop)
