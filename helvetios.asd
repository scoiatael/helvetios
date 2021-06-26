;;;; helvetios.asd

(asdf:defsystem #:helvetios
  :description "Describe helvetios here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:trivial-main-thread #:cl-webengine #:cffi #:log4cl #:dispatch)
  :components ((:file "package")
               (:file "web")))
