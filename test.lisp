(asdf:operate 'asdf:load-op 'ae2zot)
(use-package
    :trio-utils)

(load "zot/grid.lisp")
(load "zot/cart.lisp")

(defconstant *time* 5)

(ae2zot:zot *time* (&& cart-has-one-position
                       cart-has-only-one-position
                       cart-cannot-be-in-special-areas
                       cart-cannot-teleport
                       cart-has-moved
                       grid-adjacency
                       cart-speed-at-least-one
                       cart-speed-unique
                       cart-speed-controller
                       (-V- cart 1)
                       (somf (&& (-V- cart-moved)
                                 (past (-V- cart-speed speed-low) 1)))
                       ))