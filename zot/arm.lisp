(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(define-tvar arm *int* *bool*)
(define-tvar arm-moved *bool*)
(define-tvar arm-speed *int* *bool*)

(defconstant arm-has-one-position (alw (-E- x areas (-V- arm x))))

(defconstant arm-has-only-one-position
  (alw (-A- x areas
            (-A- y areas
                 (-> (!! ([=] x y))
                     (-> (-V- arm x)
                         (!! (-V- arm y)))
                     )))))
                     
(defconstant arm-cannot-teleport
  (alw (-A- x areas
            (-> (-V- arm x)
                (futr (|| (-V- arm x)
                          (-E- y areas (&& (-V- arm y)
                                           (-P- adjacent x y))))
                      1)))))

(defconstant arm-moved-definition
  (alw (<-> (-V- arm-moved)
            (-E- x areas
                 (&& (-V- arm x)
                     (past (!! (-V- arm x)) 1))))))

(defconstant arm-speed-at-least-one
  (alw (-E- x speeds (-V- arm-speed x))))

(defconstant arm-speed-unique
  (alw (-A- x speeds
            (-A- y speeds (-> (!! ([=] x y))
                              (-> (-V- arm-speed x)
                                  (!! (-V- arm-speed y))))))))

(defun xor (a b)
  (&& (|| a b) (!! (&& a b))))