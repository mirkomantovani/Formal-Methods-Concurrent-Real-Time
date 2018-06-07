(asdf:operate 'asdf:load-op 'ae2zot)
(use-package
    :trio-utils)

(load "zot/grid.lisp")
(load "zot/operator.lisp")
(load "zot/robot.lisp")
(load "zot/safety.lisp")
(load "zot/ensured-safety-properties.lisp")
(load "zot/robot-controller.lisp")

(defconstant *time* 5)

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
                       (yesterday (action-is go-to-bin-area))
                       (somf (action-is pick-from-bin-area))
                       ))