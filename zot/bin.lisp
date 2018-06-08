(asdf:operate 'asdf:load-op 'ae2zot)
(use-package :trio-utils)

(define-tvar bin-status *int*)
(define-tvar piece-added *bool*)
(define-tvar piece-removed *bool*)

(defun bin-has (x)
  ([=] (-V- bin-status) x))

(defun bin-empty ()
  ([=] (-V- bin-status) 0))

(defun bin-full ()
  ([=] (-V- bin-status) 1))

(defconstant bin-status-set (list 0 1))

(defconstant bin-status-definition
  (alw (-E- x bin-status-set (bin-has x))))

(defconstant possible-variation-bin
  (alw (-E- x bin-status-set
            (<-> (bin-has x)
                 (||
                  (past (bin-has x) 1)
                  (past (bin-has (+ x 1)) 1)
                  (past (bin-has (- x 1)) 1))
                 ))))

(defconstant piece-added-necessary
  (alw (-A- x bin-status-set
            (-> (&& (bin-has x)
                    (past (bin-has (- x 1)) 1))
                (-V- piece-added))
            )))

(defconstant piece-removed-necessary
  (alw (-A- x bin-status-set
            (-> (&& (bin-has x)
                    (past (bin-has (+ x 1)) 1))
                (-V- piece-removed)
                ))))

(defconstant add-remove-exclusive
  (alw (&& (-> (-V- piece-added)
               (!! (-V- piece-removed)))
           (-> (-V- piece-removed)
               (!! (-V- piece-added)))
           )))

(defconstant neither-add-nor-remove
  (alw (-> (-E- x bin-status-set
                (&& (bin-has x)
                    (past (bin-has x) 1)))
           (!! (||
                (-V- piece-added)
                (-V- piece-removed)))
           )))

(defconstant bin-axioms
  (&& bin-status-definition
      possible-variation-bin
      add-remove-exclusive
      piece-added-necessary
      piece-removed-necessary
      neither-add-nor-remove
      ))