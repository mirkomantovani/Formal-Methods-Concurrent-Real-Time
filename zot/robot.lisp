(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(defconstant speed-none 0)
(defconstant speed-low 1)
(defconstant speed-normal 2)
(defconstant speeds (list speed-none speed-low speed-normal))

(load "zot/cart.lisp")
(load "zot/arm.lisp")

(define-tvar touching *bool*)

(defconstant arm-connected-to-cart
  (alw (-E- x areas
            (&& (cart-in x)
                 (|| (arm-in x)
                     (-E- y areas (&& (arm-in y)
                                      (are-adjacent x y))))))))

(defconstant arm-movement
  (alw (<-> (-V- arm-moved)
            (||
             (-V- cart-moved)
             (|| (past (arm-speed-is speed-normal) 1)
              (past (&& (arm-speed-is speed-low)
                        (!! (-V- arm-moved)))
                    1))
             (&& (past (-V- touching) 1)
                 (-V- touching)
                 (-V- operator-moved))))))

;; The three reasons why the arm can move are mutually exclusive
(defconstant cart-speed-not-none
  (alw (-> (!! (cart-speed-is speed-none))
           (&& (arm-speed-is speed-none)
               (!! (-V- touching))))))

(defconstant arm-speed-not-none
  (alw (-> (!! (arm-speed-is speed-none))
           (&& (cart-speed-is speed-none)
               (!! (-V- touching))))))

(defconstant no-speed-while-touching
  (alw (-> (-V- touching)
           (&& (cart-speed-is speed-none)
               (arm-speed-is speed-none)))))


;; While the cart is moving, the arm needs to stay on top
(defconstant arm-on-cart-if-moving
  (alw (-> (-V- cart-moved)
           (&& (past (-E- x areas (&& (cart-in x)
                                      (arm-in x)))
                     1)
               (-E- x areas (&& (cart-in x)
                                (arm-in x)))
               ))))

(defconstant operator-touching-arm
  (alw (-> (-V- touching)
           (-E- x areas (&& (arm-in x)
                            (operator-in x))))))

(defconstant robot-axioms
  (&& arm-connected-to-cart
      arm-movement
      arm-speed-not-none
      cart-speed-not-none
      no-speed-while-touching
      arm-on-cart-if-moving
      operator-touching-arm
      ))