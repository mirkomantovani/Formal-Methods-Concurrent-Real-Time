(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(define-tvar arm *int*)
(define-tvar arm-moved *bool*)
(define-tvar arm-speed *int*)
(define-tvar holding *bool*)
(define-tvar pick *bool*)
(define-tvar drop *bool*)

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
  (alw (-E- x speeds (arm-speed-is x))
       ))

(defconstant drop-lasts-one-instant
  (alw (-> (past (-V- drop) 1)
           (!! (-V- drop))
           )))

(defconstant pick-lasts-one-instant
  (alw (-> (past (-V- pick) 1)
           (!! (-V- pick))
           )))

(defconstant mutually-exclusive
  (alw (&& (-> (-V- pick)
               (&& (!! (-V- drop))
                   (!! (-V- holding))))
           (-> (-V- drop)
               (&& (!! (-V- pick))
                   (!! (-V- holding))))
           (-> (-V- holding)
               (&& (!! (-V- pick))
                   (!! (-V- drop))))
           )))

(defconstant pick-implies-holding
  (alw (-> (past (-V- pick) 1)
           (-V- holding))))

(defconstant drop-implies-holding
  (alw (-> (-V- drop)
           (past (-V- holding) 1)
           )))

(defconstant holding-until-drop
  (alw (-> (&& (past (-V- holding) 1) 
               (!! (-V- drop)))
           (-V- holding))))

(defconstant holding-implies-holding-or-pick
  (alw (-> (-V- holding)
           (||
            (past (-V- holding) 1)
            (past (-V- pick) 1)
            ))))

(defconstant arm-axioms
  (&& arm-cannot-teleport
      arm-moved-definition
      arm-speed-definition
      mutually-exclusive
      pick-lasts-one-instant
      drop-lasts-one-instant
      pick-implies-holding
      drop-implies-holding
      holding-until-drop
      holding-implies-holding-or-pick
      ))