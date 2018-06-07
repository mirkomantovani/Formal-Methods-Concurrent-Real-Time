(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

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

(defconstant test-1
  (somf (&& (past (action-is pick-from-bin-area) 1)
            (action-is drop-to-local-bin))))

(defconstant test-2
  (somf (&& (past (action-is drop-to-local-bin) 1)
            (action-is pick-from-bin-area))))

(defconstant test-3
  (somf (&& (past (action-is drop-to-local-bin) 1)
            (action-is go-to-tombstone))))

(defconstant test-4
  (somf (&& (past (action-is go-to-tombstone) 1)
            (action-is pick-from-local-bin))))

(defconstant test-5
  (somf (&& (past (action-is pick-from-local-bin) 1)
            (action-is drop-to-tombstone))))

(defconstant test-6
  (somf (&& (past (action-is drop-to-tombstone) 1)
            (action-is go-to-bin-area))))

(defconstant test-7
  (somf (&& (past (action-is drop-to-tombstone) 1)
            (action-is pick-from-local-bin))))
                  

(defconstant *time* 20)
(ae2zot:zot *time* (&&
                    action-definition
                    action-order
                    test-1
                    test-2
                    test-3
                    test-4
                    test-5
                    test-6
                    test-7
                    ))