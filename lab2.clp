;citire culori si tari
(defrule reading-input
    (declare (salience 30))
    =>
    (printout t "Read colors:" crlf)
    (assert (colors (explode$ (readline))))
    (printout t "Read countries" crlf)
    (assert (countries (explode$ (readline))))
)

;citire vecini
(defrule read-neighbours
    (declare (salience 20))
    (countries $? ?country $?)
    =>
    (printout t "Read neighbours of " ?country crlf)
    (assert ( neighbours ?country (explode$ (readline))))
)

;face un fapt pentru fiecare pereche de vecini
(defrule set-neighbour
    (neighbours  ?country1 $? ?country2 $?)
    =>
    (assert (neighbour ?country1 ?country2))
    (assert (neighbour ?country2 ?country1))
)

;; metoda greedy care testeaza toate combinatiile de tari si culori,
;; daca o tara nu are culoare si niciun vecin de a ei nu are culoarea
;; pe care o testeaza in momentul respectiv atunci ii asociaza tarii culoarea

 (defrule assert-colors
    (declare (salience 0))
    (colors $? ?colorr $?)
    (countries $? ?countryy $?)
    (not (coloring ?countryy ?))
    (not(and(neighbour ?countryy ?neighbour)(coloring ?neighbour ?colorr)))
    =>
    (assert( coloring ?countryy ?colorr))
 )

;daca gaseste vreo tara fara culoare creaza faptul possible false
(defrule possible
    (declare (salience -10))
    (countries $? ?country $?)
    (not (coloring ?country ?))
    =>
    (assert (possible false))
)

(defrule check-true
    (declare (salience -20))
    (not (possible false))
    (coloring ?country ?color)
    =>
    (printout t "Color of " ?country " is " ?color crlf)
)

(defrule check-false
    (declare (salience -20))
    (possible false)
    =>
    (printout t "Nu solution found." crlf)
)
