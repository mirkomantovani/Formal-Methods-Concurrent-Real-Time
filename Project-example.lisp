(asdf:operate 'asdf:load-op 'ae2sbvzot)
(use-package :trio-utils)

;;examples of defining variables
(defvar l_indexes `(bin aisle ws belt))
(defvar r_indexes `(Link1 Link2 EndEff Cart))
(defvar o_indexes `(head_area chest_area arm_area leg_area))
(defvar velocity_indexes `(low mid high))
(defvar alpha 3)


;;examples of defining functions
(defun l-constraints ()
  (eval (append `(&&) 
	(loop for l in l_indexes collect 
		`(-> 
			(-P- ,(read-from-string (format nil "Link1_In_~A" l)))
			(!! (||
					(-P- ,(read-from-string (format nil "Link1_In_~A" l)))
					(-P- ,(read-from-string (format nil "Link1_In_~A" l)))
					(-P- ,(read-from-string (format nil "Link1_In_~A" l)))
				))))

	(loop for l in l_indexes collect 
		`(-> 
			(-P- ,(read-from-string (format nil "Link2_In_~A" l)))
			(!! (||
					(-P- ,(read-from-string (format nil "Link2_In_~A" l)))
					(-P- ,(read-from-string (format nil "Link2_In_~A" l)))
					(-P- ,(read-from-string (format nil "Link2_In_~A" l)))
				))))

	(loop for l in l_indexes collect 
		`(-> 
			(-P- ,(read-from-string (format nil "Endeff_In_~A" l)))
			(!! (||
					(-P- ,(read-from-string (format nil "Endeff_In_~A" l)))
					(-P- ,(read-from-string (format nil "Endeff_In_~A" l)))
					(-P- ,(read-from-string (format nil "Endeff_In_~A" l)))
				))))
	(loop for l in l_indexes collect 
		`(-> 
			(-P- ,(read-from-string (format nil "Cart_In_~A" l)))
			(!! (||
					(-P- ,(read-from-string (format nil "Cart_In_~A" l)))
					(-P- ,(read-from-string (format nil "Cart_In_~A" l)))
					(-P- ,(read-from-string (format nil "Cart_In_~A" l)))
				))))

)))

(defun velocity-constraints ()
  (eval (append `(&&) 	
	(loop for v in velocity_indexes collect 
		`(-> 
			(-P- ,(read-from-string (format nil "Link1_vel_~A" v)))
			(!! (||
					(-P- ,(read-from-string (format nil "Link1_vel_~A" v)))
					(-P- ,(read-from-string (format nil "Link1_vel_~A" v)))
					(-P- ,(read-from-string (format nil "Link1_vel_~A" v)))
				))))

	(loop for v in velocity_indexes collect 
		`(-> 
			(-P- ,(read-from-string (format nil "Link2_vel_~A" v)))
			(!! (||
					(-P- ,(read-from-string (format nil "Link2_vel_~A" v)))
					(-P- ,(read-from-string (format nil "Link2_vel_~A" v)))
					(-P- ,(read-from-string (format nil "Link2_vel_~A" v)))
				))))

	(loop for v in velocity_indexes collect 
		`(-> 
			(-P- ,(read-from-string (format nil "Endeff_vel_~A" v)))
			(!! (||
					(-P- ,(read-from-string (format nil "Endeff_vel_~A" v)))
					(-P- ,(read-from-string (format nil "Endeff_vel_~A" v)))
					(-P- ,(read-from-string (format nil "Endeff_vel_~A" v)))
				))))
	(loop for v in velocity_indexes collect 
		`(-> 
			(-P- ,(read-from-string (format nil "Cart_vel_~A" v)))
			(!! (||
					(-P- ,(read-from-string (format nil "Cart_vel_~A" v)))
					(-P- ,(read-from-string (format nil "Cart_vel_~A" v)))
					(-P- ,(read-from-string (format nil "Cart_vel_~A" v)))
				))))

)))

;;examples of defining predicates
(defconstant contact
	(Alw(&&
		(->
				(&&(-P- endeff_in_belt)(-P- arm_area_in_belt))
				(-P- contact)
		)
		(->
			(&&(-P- Endeff_vel_high) (-P- contact))
			(withinF (-P- Endeff_vel_low) alpha)
		)
)))

(defvar *spec*
	(alw
		(&&
			(l-constraints)
			(velocity-constraints)
			contact
)))


(format t "~S" *spec*)
(ae2sbvzot:zot 10
	(yesterday(&&
				*spec*
	)))
