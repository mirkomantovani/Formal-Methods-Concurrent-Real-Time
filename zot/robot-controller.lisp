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

(defconstant hdi-emergency 1)
(defconstant hdi-none 0)
(defconstant hdi-command-set (list hdi-emergency hdi-none))

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

(defconstant arm-pick-only-during
  (alw (-> (-V- pick)
           (||
            (&& (action-is pick-from-bin-area)
                (arm-in bin-area))
            (&& (action-is pick-from-local-bin)
                (-E- x areas (&& (cart-in x)
                                 (arm-in x))))
           ))))

(defconstant arm-drop-only-during
  (alw (-> (-V- drop)
           (||
            (&& (action-is drop-to-local-bin)
                (-E- x areas (&& (cart-in x)
                                 (arm-in x))))
            (&& (action-is drop-to-tombstone)
                (arm-in tombstone))
            ))))

(defconstant move-only-during
  (alw (-> (-V- cart-moved)
           (|| (action-is go-to-bin-area)
            (action-is go-to-tombstone)))))

;;
;; ACTION PRECONDITIONS
;;
(defun becomes (x)
  (&& x
      (past (!! x) 1)))

(defconstant pre-go-to-bin-area
  (alw (-> (becomes (action-is go-to-bin-area))
           (past (&& (!! (-V- holding))
                     (bin-empty))
                 1))))

(defconstant post-go-to-bin-area
  (alw (-> (becomes (!! (action-is go-to-bin-area)))
           (past (&& (!! (-V- holding))
                     (bin-empty)
                     (-E- x areas (&& (cart-in x)
                                      (arm-in x)
                                      (are-adjacent x bin-area))))
                 1))))

(defconstant pre-pick-from-bin-area
  (alw (-> (becomes (action-is pick-from-bin-area))
           (past (&& (!! (-V- holding))
                     (-E- x areas (&& (arm-in x)
                                      (cart-in x)
                                      (are-adjacent x bin-area)))
                     (!! (bin-full)))
                 1))))

(defconstant pre-drop-to-local-bin
  (alw (-> (becomes (action-is drop-to-local-bin))
           (past (&& (-V- holding)
                     (-E- x areas (&& (arm-in x)
                                      (cart-in x)))
                     (!! (bin-full)))
                 1))))

(defconstant pre-go-to-tombstone
  (alw (-> (becomes (action-is go-to-tombstone))
           (past (&& (!! (-V- holding))
                     (bin-full))
                 1))))

(defconstant post-go-to-tombstone
  (alw (-> (becomes (!! (action-is go-to-tombstone)))
           (past (&& (!! (-V- holding))
                     (bin-full)
                     (-E- x areas (&& (cart-in x)
                                      (arm-in x)
                                      (are-adjacent x tombstone))))
                 1))))

(defconstant pre-pick-from-local-bin
  (alw (-> (becomes (action-is pick-from-local-bin))
           (past (&& (!! (-V- holding))
                     (!! (bin-empty)))
                 1))))

(defconstant pre-drop-to-tombstone
  (alw (-> (becomes (action-is drop-to-tombstone))
           (past (&& (-V- holding)
                     (-E- x areas (&& (arm-in x)
                                      (cart-in x)
                                      (are-adjacent x tombstone))))
                 1))))


(defconstant robot-controller-axiom
  (&& action-definition
      action-order
      hdi-definition
      hdi-behavior
      hdi-after-emergency
      hdi-before-emergency
      arm-pick-only-during
      arm-drop-only-during
      move-only-during
      pre-go-to-bin-area
      post-go-to-bin-area
      pre-pick-from-bin-area
      pre-drop-to-local-bin
      pre-go-to-tombstone
      post-go-to-tombstone
      ;; pre-pick-from-local-bin
      ;; pre-drop-to-tombstone
      ))