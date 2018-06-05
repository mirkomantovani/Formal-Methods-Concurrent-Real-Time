(asdf:operate 'asdf:load-op 'ae2zot)
(use-package
    :trio-utils)

(load "zot/grid.lisp")

(define-tvar cart *int* *bool*)
(define-tvar cart-moved *bool*)

(defconstant *time* 5)

(defconstant cart-has-moved
  (alw (<-> (-V- cart-moved)
            (-E- x areas
                 (&& (-V- cart x)
                     (past (!! (-V- cart x)) 1)))
            )))

(defconstant cart-has-one-position (alw (-E- x areas (-V- cart x))))

(defconstant cart-has-only-one-position
  (alw (-A- x areas
            (-A- y areas
                 (-> (!! ([=] x y))
                     (-> (-V- cart x)
                         (!! (-V- cart y)))
                     )))))
                     

(defconstant cart-cannot-be-in-special-areas
  (alw (-A- x (list bin-area tombstone conveyor-belt)
            (!! (-V- cart x)))))

(defconstant cart-cannot-teleport
  (alw (-A- x areas
            (-> (-V- cart x)
                (futr (|| (-V- cart x)
                          (-E- y areas (&& (-V- cart y)
                                           (-P- adjacent x y))))
                      1)))))


(ae2zot:zot *time* (&& cart-has-one-position
                       cart-has-only-one-position
                       cart-cannot-be-in-special-areas
                       cart-cannot-teleport
                       cart-has-moved
                       grid-adjacency
                       (-V- cart 1)
                       (somf (-V- cart-moved))
                       ))