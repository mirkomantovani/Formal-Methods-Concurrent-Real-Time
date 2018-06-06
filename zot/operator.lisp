(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(define-tvar operator *int*)
(define-tvar operator-moved *bool*)

(defun operator-in (x)
  ([=] (-V- operator) x))

(defconstant operator-position
  (alw (-E- x areas
            (operator-in x))))
                     
(defconstant operator-cannot-teleport
  (alw (-A- x areas
            (-> (operator-in x)
                (futr (|| (operator-in x)
                          (-E- y areas (&& (operator-in y)
                                           (are-adjacent x y))))
                      1)))))

(defconstant operator-moved-definition
  (alw (<-> (-V- operator-moved)
            (-E- x areas
                 (&& (operator-in x)
                     (past (!! (operator-in x)) 1))))))

(defconstant operator-axioms
  (&& operator-position
      operator-cannot-teleport
      operator-moved-definition))