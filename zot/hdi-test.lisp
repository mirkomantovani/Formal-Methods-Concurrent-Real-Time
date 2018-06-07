(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(load "zot/grid.lisp")
(load "zot/operator.lisp")
(load "zot/robot.lisp")

(define-tvar hdi-command *int*)

(defconstant hdi-emergency 2)
(defconstant hdi-continue 1)
(defconstant hdi-none 0)
(defconstant hdi-command-set (list hdi-emergency hdi-continue hdi-none))

(defun hdi-is (x)
  ([=] (-V- hdi-command) x))

(defconstant hdi-definition
  (alw (-E- x hdi-command-set (hdi-is x))))

(defconstant hdi-behavior
  (alw (-> (hdi-is hdi-emergency)
           (&& (cart-speed-is speed-none)
               (arm-speed-is speed-none)))))

(defconstant hdi-after-emergency
  (alw (-> (hdi-is hdi-emergency)
           (until_ie (hdi-is hdi-emergency) (hdi-is hdi-none)
                     ))))

(defconstant hdi-before-emergency
  (alw (-> (hdi-is hdi-emergency)
           (|| (past (hdi-is hdi-emergency) 1)
            (past (hdi-is hdi-none) 1)))))

(defconstant hdi-before-continue
  (alw (-> (hdi-is hdi-continue)
           (past (hdi-is hdi-none) 1))))

(defconstant hdi-after-continue
  (alw (-> (hdi-is hdi-continue)
           (futr (hdi-is hdi-none) 1))))

(defconstant test-1
  (&& (somf (hdi-is hdi-emergency))
      (somf (hdi-is hdi-continue))
      (somf (hdi-is hdi-none))))

(defconstant test-2
  (somf (&& (past (hdi-is hdi-emergency) 1)
            (hdi-is hdi-emergency))))
            

(defconstant *time* 10)
(ae2zot:zot *time* (&&
                    grid-axioms
                    cart-axioms
                    arm-axioms
                    robot-axioms
                    operator-axioms
                    hdi-definition
                    hdi-behavior
                    hdi-after-emergency
                    hdi-before-emergency
                    hdi-before-continue
                    hdi-after-continue
                    test-1
                    test-2
                    ))