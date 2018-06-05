(asdf:operate 'asdf:load-op 'ae2zot)
(use-package
    :trio-utils)

(define-tvar cart *int* *bool*)
(define-tvar cart-moved *bool*)
(define-tvar cart-speed *int* *bool*)

(defconstant speed-none 0)
(defconstant speed-low 1)
(defconstant speed-normal 2)
(defconstant speeds (list speed-none speed-low speed-normal))

(defconstant cart-has-moved
  (alw (<-> (-V- cart-moved)
            (-E- x areas
                 (&& (-V- cart x)
                     (past (!! (-V- cart x)) 1)))
            )))

(defconstant cart-speed-at-least-one
  (alw (-E- x speeds (-V- cart-speed x))))

(defconstant cart-speed-unique
  (alw (-A- x speeds
            (-A- y speeds (-> (!! ([=] x y))
                              (-> (-V- cart-speed x)
                                  (!! (-V- cart-speed y))))))))

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

(defconstant cart-speed-controller
  (alw (<-> (-V- cart-moved)
            (|| (past (-V- cart-speed speed-normal) 1)
                (past (&& (-V- cart-speed speed-low)
                          (!! (-V- cart-moved)))
                      1)
                ))))