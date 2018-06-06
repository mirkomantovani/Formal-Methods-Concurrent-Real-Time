(asdf:operate 'asdf:load-op 'ae2zot)
(use-package
    :trio-utils)

(define-tvar cart *int*)
(define-tvar cart-speed *int*)
(define-tvar cart-moved *bool*)

(defun cart-in (x)
  ([=] (-V- cart) x))

(defun cart-speed-is (x)
  ([=] (-V- cart-speed) x))

(defconstant cart-has-moved
  (alw (<-> (-V- cart-moved)
            (-E- x areas
                 (&& (cart-in x)
                     (past (!! (cart-in x)) 1)))
            )))

(defconstant cart-position-definition
  (alw (-E- x areas (cart-in x))))

(defconstant cart-cannot-be-in-special-areas
  (alw (-A- x (list bin-area tombstone conveyor-belt)
            (!! (cart-in x)))))

(defconstant cart-cannot-teleport
  (alw (-A- x areas
            (-> (cart-in x)
                (futr (|| (cart-in x)
                          (-E- y areas (&& (cart-in y)
                                           (are-adjacent x y))))
                      1)))))

(defconstant cart-speed-definition
  (alw (-E- x speeds (cart-speed-is x))))

(defconstant cart-speed-controller
  (alw (<-> (-V- cart-moved)
            (|| (past (cart-speed-is speed-normal) 1)
                (past (&& (cart-speed-is speed-low)
                          (!! (-V- cart-moved)))
                      1)
                ))))

(defconstant cart-axioms
  (&& cart-has-moved
      cart-position-definition
      cart-cannot-be-in-special-areas
      cart-cannot-teleport
      cart-speed-definition
      cart-speed-controller))