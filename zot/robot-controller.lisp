(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(define-tvar can-arm-move *bool*)

(define-tvar current-action *int*)

(defconstant go-to-bin-area 0)
(defconstant pick-from-bin-area 1)
(defconstant drop-to-local-bin 2)
(defconstant go-to-tombstone 3)
(defconstant pick-from-local-bin 4)
(defconstant drop-to-tombstone 5)
(defconstant action-set (list go-to-bin-area
                              pick-from-bin-area
                              drop-to-local-bin
                              go-to-tombstone
                              pick-from-local-bin
                              drop-to-tombstone))

(defun action-is (x)
  ([=] (-V- current-action) x))

(defconstant action-definition
  (alw (-E- x action-set (action-is x))))

(defconstant action-order
  (alw (&& (-> (action-is go-to-bin-area)
               (until_ie (action-is go-to-bin-area) (action-is pick-from-bin-area)))
           (-> (action-is pick-from-bin-area)
               (until_ie (action-is pick-from-bin-area) (action-is drop-to-local-bin)))
           (-> (action-is drop-to-local-bin)
               (|| (until_ie (action-is drop-to-local-bin) (action-is pick-from-bin-area))
                (until_ie (action-is drop-to-local-bin) (action-is go-to-tombstone))))
           (-> (action-is go-to-tombstone)
               (until_ie (action-is go-to-tombstone) (action-is pick-from-local-bin)))
           (-> (action-is pick-from-local-bin)
               (until_ie (action-is pick-from-local-bin) (action-is drop-to-tombstone)))
           (-> (action-is drop-to-tombstone)
               (|| (until_ie (action-is drop-to-tombstone) (action-is pick-from-local-bin))
                (until_ie (action-is drop-to-tombstone) (action-is go-to-bin-area))))
           )))

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

;;
;; ACTION PRECONDITIONS
;;

(defun becomes (x)
  (&& x
      (past (!! x) 1)))

(defconstant pre-go-to-bin-area
  (alw (-> (becomes (action-is go-to-bin-area))
           (&& (bin-empty)
               (!! (-V- holding))
               (cart-speed-is speed-none))
           )))

(defconstant pre-pick-from-bin-area
  (alw (-> (becomes (action-is pick-from-bin-area))
           (&& (!! (bin-full))
               (!! (-V- holding))
               (-E- x areas (&& (cart-in x)
                                (are-adjacent x bin-area)))
               (cart-speed-is speed-none)))))

(defconstant during-pick-from-bin-area
  (alw (-> (action-is pick-from-bin-area)
           (!! (-V- piece-removed)))))

(defconstant pre-drop-to-local-bin
  (alw (-> (becomes (action-is drop-to-local-bin))
           (&& (!! (bin-full))
               (-V- holding)
               (cart-speed-is speed-none)
               (-E- x areas (&& (cart-in x)
                                (arm-in x))))
           )))

(defconstant pre-go-to-tombstone
  (alw (-> (becomes (action-is go-to-tombstone))
           (&& (bin-full)
               (!! (-V- holding))
               (-E- x areas (&& (cart-in x)
                                (are-adjacent x tombstone)))
               ))))

(defconstant pre-pick-from-local-bin
  (alw (-> (becomes (action-is pick-from-local-bin))
           (&& (!! (bin-empty))
               (!! (-V- holding))
               (-E- x areas (&& (cart-in x)
                                (arm-in x)))
               (cart-speed-is speed-none))
           )))

(defconstant pre-drop-to-tombstone
  (alw (-> (becomes (action-is drop-to-tombstone))
           (&& (-V- holding)
               (cart-speed-is speed-none)
               (-E- x areas (&& (cart-in x)
                                (arm-in x)))
               ))))

(defconstant during-drop-to-tombstone
  (alw (-> (action-is drop-to-tombstone)
           (!! (-V- piece-added)))))

(defconstant arm-pick-only-during
  (alw (-> (-V- pick)
           (|| (&& (action-is pick-from-bin-area)
                    (arm-in bin-area))
             (action-is pick-from-local-bin))
           )))

(defconstant arm-drop-only-during
  (alw (-> (-V- drop)
           (|| (action-is drop-to-local-bin)
            (&& (action-is drop-to-tombstone)
                (arm-in tombstone)))
           )))

(defconstant move-only-during
  (alw (-> (-V- cart-moved)
           (|| (action-is go-to-bin-area)
            (action-is go-to-tombstone)))))

(defconstant robot-controller-axiom
  (&& action-definition
      action-order
      hdi-definition
      hdi-behavior
      hdi-after-emergency
      hdi-before-emergency
      hdi-after-continue
      hdi-before-continue
      pre-go-to-bin-area
      pre-pick-from-bin-area
      during-pick-from-bin-area
      pre-drop-to-local-bin
      pre-go-to-tombstone
      pre-pick-from-local-bin
      pre-drop-to-tombstone
      during-drop-to-tombstone
      arm-pick-only-during
      arm-drop-only-during
      move-only-during
      ))