(asdf:operate 'asdf:load-op 'ae2zot)
(use-package
    :trio-utils)

(defconstant no-dangerous-contact-operator-arm
  (alw (!! (-E- x areas (&& (operator-in x)
                            (arm-in x)
                            (!! (arm-speed-is speed-none)))))))

(defconstant no-dangerous-contact-operator-cart
  (alw (!! (-E- x areas
                (&& (-P- danger x)
                    (cart-in x)
                    (operator-in x)
                    (!! (cart-speed-is speed-none))
                    )))))

(defconstant no-dangerous-contact-operator-cart-transit
  (alw (!! (-E- x areas
                (&& (!! (-P- danger x))
                    (cart-in x)
                    (operator-in x)
                    (cart-speed-is speed-normal))
                ))))

(defconstant cart-does-not-move-into-operators-area
  (alw (!! (-E- x areas
                (&& (-P- danger x)
                    (operator-in x)
                    (cart-in x)
                    (-V- cart-moved))
                ))))