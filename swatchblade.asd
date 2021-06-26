;;;; swatchblade.asd

(asdf:defsystem #:swatchblade
  :description "Describe swatchblade here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:trivial-main-thread #:cl-webengine #:cffi #:log4cl #:qtools #:qtcore #:qtgui)
  :components ((:file "package")
               (:file "swatchblade")))
