(asdf:operate 'asdf:load-op 'ae2zot)
(use-package
    :trio-utils)

(load "zot/grid.lisp")
(load "zot/operator.lisp")
(load "zot/robot.lisp")
(load "zot/safety.lisp")

(defconstant *time* 10)

(ae2zot:zot *time* (&& grid-axioms
                       cart-axioms
                       arm-axioms
                       robot-axioms
                       operator-axioms
                       safety-axioms
                       (somf (&& (-V- arm-moved)
                                 (-V- operator-moved)
                                 (-V- touching)
                                 (past (-V- touching) 1)))
                       (somf (-V- cart-moved))
                       (somf (-V- arm-moved))
                       (somf (-V- operator-moved))
                       ))