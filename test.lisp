(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(load "zot/grid.lisp")
(load "zot/operator.lisp")
(load "zot/robot.lisp")
(load "zot/safety.lisp")
(load "zot/ensured-safety-properties.lisp")
(load "zot/robot-controller.lisp")

(defconstant test-1
  (somf (&& (-V- pick)
            (action-is pick-from-bin-area))))

(defconstant test-2
  (somf (&& (-V- holding)
            (action-is pick-from-bin-area))))

(defconstant test-3
  (somf (&& (-V- holding)
            (action-is drop-to-local-bin))))

(defconstant test-4
  (somf (&& (-V- drop)
            (action-is drop-to-local-bin))))

(defconstant test-5
  (somf (&& (-V- pick)
            (action-is pick-from-local-bin))))

(defconstant test-6
  (somf (&& (-V- holding)
            (action-is pick-from-local-bin))))

(defconstant test-7
  (somf (&& (-V- holding)
            (action-is drop-to-tombstone))))

(defconstant test-8
  (somf (&& (-V- drop)
            (action-is drop-to-tombstone))))

(defconstant unsat-1
  (somf (&& (-V- drop)
            (-E- x action-set (&& (!! ([=] (-V- current-action) drop-to-tombstone))
                                  (!! ([=] (-V- current-action) drop-to-local-bin))
                                  (action-is x))))))

(defconstant unsat-2
  (somf (&& (-V- pick)
            (-E- x action-set (&& (!! ([=] (-V- current-action) pick-from-bin-area))
                                  (!! ([=] (-V- current-action) pick-from-local-bin))
                                  (action-is x))))))


(defconstant *time* 20)
(ae2zot:zot *time* (&& grid-axioms
                       cart-axioms
                       arm-axioms
                       robot-axioms
                       operator-axioms
                       safety-axioms
                       bin-axioms
                       robot-controller-axiom
                       ;; (!! no-dangerous-contact-operator-arm)
                       ;; (!! no-dangerous-contact-operator-cart)
                       ;; (!! no-dangerous-contact-operator-cart-transit)
                       ;; (!! cart-does-not-move-into-operators-area)
                       test-1
                       test-2
                       test-3
                       test-4
                       test-5
                       test-6
                       test-7
                       test-8
                       ;; unsat-1
                       ;; unsat-2
                       ))