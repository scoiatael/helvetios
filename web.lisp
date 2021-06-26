(in-package #:helvetios)

(defvar *application* nil)

(defun wrap-float-traps (f)
  (sb-int:with-float-traps-masked (:invalid :inexact :overflow :divide-by-zero)) f)

(defun queue-in-main-thread (f)
  (trivial-main-thread:call-in-main-thread f))

(defclass webview-window ()
    ((qt-widget :initform (cl-webengine:new-q-widget) :reader qt-widget)
     (qt-layout :initform (cl-webengine:new-qv-box-layout) :reader qt-layout)
     (qt-webview :initform (cl-webengine:new-q-web-engine-view) :reader qt-webview)))

(defun web (window)
  (cl-webengine:layout-add-widget (qt-layout window) (qt-webview window))
  (cl-webengine:widget-set-layout (qt-widget window) (qt-layout window))
  (log:info "Layout created")
  (cl-webengine:web-engine-view-load (qt-webview window) "https://www.duckduckgo.com")
  (log:info "Webview loaded")
  (cl-webengine:widget-show (qt-widget window)))

(defun run ()
  (let ((application
          (cl-webengine:new-q-application 1 (cffi:foreign-alloc :string
                                                                :initial-contents (list "cl-webengine.lib")
                                                                :null-terminated-p t)))
        (window (make-instance 'webview-window)))
    (log:info "Application created")
    (setf *application* application)
    (web window)
    (log:info "Running exec...")
    (cl-webengine:application-exec application)))

;; (defun run ()
;;   "Start main application"
;;   (log:info "Starting...")
;;   (trivial-main-thread:call-in-main-thread
;;    (lambda ()
;;      (with-qapplication "Swatchblade"
;;        (lambda ()
;;          (web "https://google.com"))))))
;; (export 'run)

;; (defun make-qapplication-name (name)
;;   (cffi:foreign-alloc :string
;;                       :initial-contents (list name)
;;                       :null-terminated-p t))

;; (defun with-qapplication (name f)
;;   (log:info "Creating application...")
;;   (let ((application (cl-webengine:new-q-application 1 (make-qapplication-name name))))
;;     (log:info "Creating application... done.")
;;     (setf *application*  application)
;;     (f)
;;     (cl-webengine:application-exec *application*)))

;; (defun web (url)
;;   (let ((window (cl-webengine:new-q-widget))
;;         (layout (cl-webengine:new-qv-box-layout))
;;         (webview (cl-webengine:new-q-web-engine-view)))
;;     (cl-webengine:layout-add-widget layout webview)
;;     (cl-webengine:widget-set-layout window layout)
;;     (cl-webengine:web-engine-view-load webview url)))


(defun stop () (when *application* (cl-webengine:application-quit *application*)))
