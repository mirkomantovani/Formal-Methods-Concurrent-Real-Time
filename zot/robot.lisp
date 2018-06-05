(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(defconstant speed-none 0)
(defconstant speed-low 1)
(defconstant speed-normal 2)
(defconstant speeds (list speed-none speed-low speed-normal))

(load "zot/cart.lisp")
(load "zot/arm.lisp")

(defconstant arm-connected-to-cart
  (alw (-E- x areas
            (&& (-V- cart x)
                 (|| (-V- arm x)
                     (-E- y areas (&& (-V- arm y)
                                      (-P- adjacent x y))))))))

(defconstant arm-speed-related-to-cart-speed
  (alw (-> (!! (-V- arm-speed 0))
           (-V- cart-speed 0))))

(defun xor (a b)
  (&& (|| a b) (!! (&& a b))))

(defconstant arm-speed-controller
  (alw (<-> (-V- arm-moved)
            (xor (-V- cart-moved)
                 (|| (past (-V- arm-speed speed-normal) 1)
                     (past (&& (-V- arm-speed speed-low)
                               (!! (-V- arm-moved)))
                           1)
                     )))))

(defconstant arm-on-cart-if-moving
  (alw (-> (-V- cart-moved)
           (&& (past (-E- x areas (&& (-V- cart x)
                                      (-V- arm x)))
                     1)
               (-E- x areas (&& (-V- cart x)
                                (-V- arm x)))
               ))))