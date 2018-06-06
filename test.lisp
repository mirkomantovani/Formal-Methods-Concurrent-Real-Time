(asdf:operate 'asdf:load-op 'ae2zot)
(use-package
    :trio-utils)

(load "zot/grid.lisp")
(load "zot/operator.lisp")
(load "zot/robot.lisp")
(load "zot/safety.lisp")

(defconstant *time* 5)

(ae2zot:zot *time* (&& cart-has-one-position
                       cart-has-only-one-position
                       cart-cannot-be-in-special-areas
                       cart-cannot-teleport
                       cart-has-moved
                       grid-adjacency
                       grid-danger-areas
                       cart-speed-at-least-one
                       cart-speed-unique
                       cart-speed-controller
                       operator-has-one-position
                       operator-has-only-one-position
                       operator-cannot-teleport
                       operator-moved-definition
                       arm-has-one-position
                       arm-has-only-one-position
                       arm-cannot-teleport
                       arm-moved-definition
                       arm-speed-at-least-one
                       arm-speed-unique
                       arm-speed-controller
                       arm-connected-to-cart
                       arm-speed-related-to-cart-speed
                       arm-on-cart-if-moving
                       (somf (-V- operator-moved))
                       (somf (-V- cart-moved))
                       operator-close-to-wall
                       do-not-squish-operator
                       cart-does-not-move-if-operator-same-area
                       speed-when-in-transit-zone
                       (-V- operator 1)
                       (-V- cart 2)
                       ))