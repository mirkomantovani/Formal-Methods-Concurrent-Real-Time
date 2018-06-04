(asdf:operate 'asdf:load-op 'ae2sbvzot)
(use-package :trio-utils)

;; the areas are 15
(defvar areas (loop for i from 1 to 15 collect i))
(defconstant bin-area 13)
(defconstant tombstone 14)
(defconstant conveyor-belt 15)

(define-item cart areas)
(define-item robot-arm areas)
(define-item operator areas)

(define-var adjacent "areas" "areas")

(defconstant grid-adjacency
  (-A- x areas (-A- y areas
                    (<-> (or (-V- adjacent x y) (-V- adjacent y x))
                         (or (and (= x 1) (= y 2))
                             (and (= x 1) (= y 5))
                             (and (= x 1) (= y 6))
                             (and (= x 2) (= y 3))
                             (and (= x 2) (= y 5))
                             (and (= x 2) (= y 6))
                             (and (= x 2) (= y 7))
                             (and (= x 3) (= y 4))
                             (and (= x 3) (= y 6))
                             (and (= x 3) (= y 7))
                             (and (= x 3) (= y 8))
                             (and (= x 3) (= y 8))
                             (and (= x 4) (= y 7))
                             (and (= x 4) (= y 8))
                             (and (= x 5) (= y 6))
                             (and (= x 5) (= y 9))
                             (and (= x 5) (= y 10))
                             (and (= x 6) (= y 7))
                             (and (= x 6) (= y 9))
                             (and (= x 6) (= y 10))
                             (and (= x 6) (= y 11))
                             (and (= x 7) (= y 8))
                             (and (= x 7) (= y 10))
                             (and (= x 7) (= y 11))
                             (and (= x 7) (= y 12))
                             (and (= x 8) (= y 11))
                             (and (= x 8) (= y 12))
                             (and (= x 9) (= y 10))
                             (and (= x 10) (= y 11))
                             (and (= x 11) (= y 12))
                             (and (= x 1) (= y tombstone))
                             (and (= x 2) (= y tombstone))
                             (and (= x 1) (= y conveyor-belt))
                             (and (= x 2) (= y conveyor-belt))
                             (and (= x 3) (= y conveyor-belt))
                             (and (= x 11) (= y bin-area))
                             (and (= x 12) (= y bin-area))
                             )))))

(defconstant init (&&
                   (cart= 1)
                   (robot-arm= 2)
                   (operator= 12)
                   ))

(defvar spec
  (alw
   (&&
    ;; at least one area is occupied by the robot's cart
    (-E- x areas (cart= x))
    ;; the area is unique
    (-A- x areas (-A- y areas (-> (&& (!! (= x y))
                                      (cart= x))
                                  (!! (cart= y)))))
    ;; the cart cannot teleport
    (-A- x areas (-> (cart= x)
                     (futr (or (cart= x)
                               (-E- y areas (and (adjacent x y)
                                                 (cart= y)))) 1)))
    ;; at least one area is occupied by the robot's arm
    ;; (-E- x areas (robot-arm= x))
    ;; ;; the area is unique
    ;; (-A- x areas (-A- y areas (-> (&& (!! x y) (robot-arm= x)) (!! (robot-arm= y)))))
    ;; ;; at least one area is occupied by the operator
    ;; (-E- x areas (operator= x))
    ;; ;; the area is unique
    ;; (-A- x areas (-A- y areas (-> (&& (!= x y) (operator= x)) (!! (operator= y)))))
    )))

(ae2sbvzot:zot 10
               (yesterday (&&
                           spec
                           init
                           (somf (cart= 5))
                           )))