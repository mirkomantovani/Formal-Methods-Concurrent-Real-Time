(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(defconstant *time* 10)
(load "zot/bin.lisp")

(defconstant test-1 ;; should give UNSAT
  (somf (-E- x bin-status-set
             (&& (bin-has x)
                 (past (bin-has (- x 1)) 1)
                 (!! (-V- piece-added)))
             )))

(defconstant test-2 ;; should give UNSAT
  (somf (-E- x bin-status-set
             (&& (bin-has x)
                 (past (bin-has (+ x 1)) 1)
                 (!! (-V- piece-removed)))
             )))

(defconstant test-3 ;; should give UNSAT
  (somf (-E- x bin-status-set
             (&& (bin-has x)
                 (past (bin-has x) 1)
                 (|| (-V- piece-added)
                  (-V- piece-removed))
                 ))))

(ae2zot:zot *time* (&&
                    bin-axioms
                    (somf (-V- piece-added))
                    ;; test-1
                    ;; test-2
                    ;; test-3
                    ))