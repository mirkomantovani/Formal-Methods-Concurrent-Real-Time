(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(defconstant speed-none 0)
(defconstant speed-low 1)
(defconstant speed-normal 2)
(defconstant speeds (list speed-none speed-low speed-normal))

(load "zot/grid.lisp")
(load "zot/arm.lisp")

(defconstant test-1 ;; should be UNSAT
  (somf (&& (-V- holding)
            (!! (somp (-V- pick)))
            )))

(defconstant test-2 ;; should be UNSAT
  (somf (&& (-V- drop)
            (!! (somp (-V- pick)))
            )))

(defconstant test-3 ;; should be UNSAT
  (somf (&& (-V- drop)
            (!! (somp (-V- holding)))
            )))

(defconstant test-4 ;; should be UNSAT
  (somf (&& (-V- pick)
            (-V- drop))))

(defconstant test-5 ;; should be SAT
  (somf (&& (!! (-V- pick))
            (!! (-V- drop))
            (!! (-V- holding))
            )))

(defconstant test-6 ;; should be SAT
  (&& (somf (-V- pick))
      (somf (-V- holding))
      (somf (-V- drop))
      ))

(defconstant test-7 ;; should be SAT
  (somf (&& (-V- holding)
            (past (-V- holding) 1))))

(defconstant test-8 ;; should be UNSAT
  (somf (&& (past (-V- holding) 1)
            (!! (|| (-V- holding)
                 (-V- drop)))
            )))
            

(defconstant *time* 10)
(ae2zot:zot *time* (&&
                    grid-axioms
                    arm-axioms
                    ;; test-1
                    ;; test-2
                    ;; test-3
                    ;; test-4
                    test-5
                    test-6
                    test-7
                    ;; test-8
                    ))