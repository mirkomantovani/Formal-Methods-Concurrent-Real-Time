(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(define-tvar arm *int*)
(define-tvar arm-moved *bool*)
(define-tvar arm-speed *int*)

(defun arm-in (x)
  ([=] (-V- arm) x))

(defun arm-speed-is (x)
  ([=] (-V- arm-speed) x))

(defconstant arm-cannot-teleport
  (alw (-A- x areas
            (-> (arm-in x)
                (futr (|| (arm-in x)
                          (-E- y areas (&& (arm-in y)
                                           (are-adjacent x y))))
                      1)
                ))))

(defconstant arm-moved-definition
  (alw (<-> (-V- arm-moved)
            (-E- x areas
                 (&& (arm-in x)
                     (past (!! (arm-in x)) 1))))))

(defconstant arm-speed-definition
  (alw (-E- x speeds (arm-speed-is x))))

(defconstant arm-axioms
  (&& arm-cannot-teleport
      arm-moved-definition
      arm-speed-definition))