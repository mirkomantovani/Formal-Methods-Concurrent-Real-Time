(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(defconstant operator-close-to-wall
  (alw (-A- x areas
            (-A- y areas
                 (-> (&& (operator-in x)
                         (cart-in y)
                         (-P- danger x)
                         (are-adjacent x y))
                     (|| (futr (&& ;; only the operator can go to the position of the cart, not the opposite
                                (cart-speed-is speed-none)
                                (cart-in x)
                                (operator-in x))
                               1)
                      (futr (-E- w areas
                                 (-E- z areas
                                      (&& (!! ([=] z w))
                                          (cart-in w)
                                          (operator-in z))))
                            1)
                      ))))))

(defconstant do-not-squish-operator
  (alw (-A- x areas
            (-A- y areas
                 (-A- z areas
                      (-> (&& (operator-in x)
                              (cart-in y)
                              (are-adjacent x z)
                              (are-adjacent z y)
                              (-P- danger z))
                          (futr (!! (cart-in z)) 1)
                          ))))))

(defconstant cart-does-not-move-if-operator-same-area
  (alw (-A- x areas (-> (&& (-P- danger x)
                            (cart-in x)
                            (operator-in x))
                        (cart-speed-is speed-none)))))

(defconstant speed-when-in-transit-zone
  (alw (-A- x areas (-> (&& (!! (-P- danger x))
                                (cart-in x)
                                (operator-in x))
                        (!! (cart-speed-is speed-normal))))))

(defconstant arm-cannot-move-if-operator-same-area
  (alw (-A- x areas (-> (&& (arm-in x)
                            (operator-in x))
                        (arm-speed-is speed-none)))))

(defconstant arm-moves-slowly-if-operator-near
  (alw (-A- x areas
            (-A- y areas
                 (-> (&& (arm-in x)
                         (operator-in y)
                         (are-adjacent x y))
                     (!! (arm-speed-is speed-normal)))))))

(defconstant safety-axioms
  (&& operator-close-to-wall
      do-not-squish-operator
      cart-does-not-move-if-operator-same-area
      speed-when-in-transit-zone
      arm-cannot-move-if-operator-same-area
      arm-moves-slowly-if-operator-near))