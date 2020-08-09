(uiop:define-package :acacia/core
    (:use :cl
          :trivia))

(in-package :acacia/core)

(defparameter *states* nil)
(defparameter *parser-name* nil)

(defmacro define-parser ((name) (parser-configuration) &body rules)
  "(define-parser (some-parser)
     (name-rule -> states-list)
     ....)
   `:or' - use for alternative state-rule
   `:empty' - use for empty rule"
  `(generate-parser ,name '(,@body)))


(defmacro with-states (&body body)
  `(let ((*states* (make-hash-table :test #'eq)))
     ,@body))

(defmacro with-parser-name ((parser-name) &body body)
  `(let ((*parser-name* ,parser-name))
     ,@body))

(defun get-state-function-by-rule-name (name)
  (gethash name *states*))

(defun generate-parser (name rules-list &optional)
  (with-states
    (predefine-state-functions (mapcar #'car rules-list))
    (mapcar #'parse-rule rules-list)))

(defmacro predefine-state-functions (names-list)
  `(progn
     ,@ (mapcar (lambda (name)
                  (let ((fun-name (create-state-fun-name name)))
                    (setf (gethash name *states*))
                    `(defun ,fun-name ())))
                names-list)))

(defmacro set-state-function-body ((name) &body body)
  `(setf (fdefinition ,(gethash name *states*))
         (lambda ()
           ,@body)))

(defun create-state-fun-name (name)
  (intern (concatenate 'string "@<" (symbol-name name) ">")
          *package*))

(defun parse-rule (rule)
  (match rule
    ((list :main '-> start-rule)
     (generate-parser-entry-point start-rule))
    ((list* :main '-> start-rule)
     (error "err"))
    ((list* rule-name '-> dep-rules)
     (generate-body-of-state-function rule-name dep-rules))))

;;TODO: reformat code here
(defmacro generate-parser-entry-point (start-rule-name)
  `(defun ,(intern (concatenate 'string
                                "@start-"
                                (symbol-name *parser-name*)
                                "-parser")
                   *package*)
       ()
     (when (,(get-state-function-by-rule-name start-rule-name))
       (when (get-tokens)
         (error "err")))))

(defmacro generate-body-of-state-function (rule-name dep-rules)
  (with-gensyms (name-of-state-fun reformats-rules)
    `(let ((,name-of-state-fun (get-state-function-by-rule-name rule-name))
           (,reformats-rules (reformat-dep-rules dep-rules)))
       (set-state-function-body (,name-of-state-fun)
                                ))))

(defun reformat-dep-rules (der-rules)
  )
