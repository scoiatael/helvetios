(in-package #:helvetios)

(defmacro with-wrap-float-traps (&rest body)
  `(sb-int:with-float-traps-masked (:invalid :inexact :overflow :divide-by-zero) ,@body))

(defmacro queue-in-main-thread (&rest body)
  `(trivial-main-thread:call-in-main-thread
   (lambda ()
     (handler-bind ((error #'(lambda (error) (log:fatal "In main thread:" error))))
       ,@body))))

(defmacro dispatch-in-main-thread (&rest body)
  `(dispatch:dispatch-async (dispatch:main-queue)
   (lambda ()
     (handler-bind ((error #'(lambda (error) (log:fatal "In main thread:" error))))
       ,@body))))

(defclass qt-browser ()
  ((qt-widget :initform (cl-webengine:new-q-widget) :reader qt-widget)
   (qt-layout :initform (cl-webengine:new-qv-box-layout) :reader qt-layout)
   (qt-webview :initform (cl-webengine:new-q-web-engine-view) :reader qt-webview)
   (url :initarg :url :reader current-url)))

(defun web (window)
  (cl-webengine:layout-add-widget (qt-layout window) (qt-webview window))
  (cl-webengine:widget-set-layout (qt-widget window) (qt-layout window))
  (log:info "Layout created")
  (cl-webengine:web-engine-view-load (qt-webview window) (current-url window))
  (log:info "Webview loaded")
  (cl-webengine:widget-show (qt-widget window)))

(defun alloc-argv (type &rest argv)
  (list
   (length argv)
   (cffi:foreign-alloc type
                       :initial-contents argv
                       :null-terminated-p t)))

(defvar *application* nil)
(defvar *browser* nil)

(defun run ()
  (queue-in-main-thread
   (with-wrap-float-traps
       (setf *application* (apply #'cl-webengine:new-q-application (alloc-argv :string "helvetios")))
     (setf *browser* (make-instance 'qt-browser :url "https://joemonster.org"))
     (log:info "Application created")
     (web *browser*)
     (log:info "Running exec...")))
  (dispatch-in-main-thread
   (with-wrap-float-traps
       (cl-webengine:application-exec *application*))))

(defun stop () (when *application* (cl-webengine:application-quit *application*)))
