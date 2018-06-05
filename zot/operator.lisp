(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(define-tvar operator *int* *bool*)
(define-tvar operator-moved *bool*)

(defconstant operator-has-one-position (alw (-E- x areas (-V- operator x))))

(defconstant operator-has-only-one-position
  (alw (-A- x areas
            (-A- y areas
                 (-> (!! ([=] x y))
                     (-> (-V- operator x)
                         (!! (-V- operator y)))
                     )))))
                     
(defconstant operator-cannot-teleport
  (alw (-A- x areas
            (-> (-V- operator x)
                (futr (|| (-V- operator x)
                          (-E- y areas (&& (-V- operator y)
                                           (-P- adjacent x y))))
                      1)))))

(defconstant operator-moved-definition
  (alw (<-> (-V- operator-moved)
            (-E- x areas
                 (&& (-V- operator x)
                     (past (!! (-V- operator x)) 1))))))