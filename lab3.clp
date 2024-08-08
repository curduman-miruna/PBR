(deftemplate student
    (slot nume)
    (multislot punctaje-laborator)
    (slot total-lab (default 0))
    (slot punctaj-examen (default 0))
    (slot punctaj-proiect (default 0))
    (slot status (default nepromovat)))

(deffacts fapte-initiale
    (meniu))

(defrule afiseaza-meniu
    ?opt<- (meniu)
    =>
    (retract ?opt)
    (printout t "1. Adauga un student" crlf)
    (printout t "2. Adauga punctaje la laborator pentru un student" crlf)
    (printout t "3. Adauga punctaj la examen pentru un student" crlf)
    (printout t "4. Adauga punctaj la proiect pentru un student" crlf)
    (printout t "5. Afiseaza situatie student" crlf)
    (printout t "6. Afiseaza studentii promovati si cei nepromovati" crlf)
    (printout t "7. Iesire" crlf)
    (printout t "Alege optiunea: ")
    (assert(option (read))))

;1.Adauga un student
(defrule adauga-student
    ?opt<- (option 1)
    =>
    (retract ?opt)
    (printout t "Introduceti nume student: ")
    (assert (student (nume (read)) (punctaje-laborator 0) (punctaj-examen 0) (punctaj-proiect 0) (status nepromovat)))
    (assert(meniu)))

;2. Adauga punctaje la laborator pentru un student
(defrule adauga-pct-lab
    ?opt<- (option 2)
    =>
    (retract ?opt)
    (printout t "Introduceti nume student: ")
    (bind ?nume (read))
    (assert (modifica-punctaje-laborator ?nume)))

(defrule modifica-lab-score
    ?opt<- (modifica-punctaje-laborator ?nume)
    ?temp <- (student (nume ?nume))
    =>
    (retract ?opt)
    (printout t "Introduceti punctaje laborator: ")
    (modify ?temp (punctaje-laborator (explode$ (readline))))
    (assert(suma-punctaje ?nume))
    )

(defrule total_lab
  ?temp <- (suma-punctaje ?nume)
  ?std <- (student (nume ?opt) (punctaje-laborator $?y))
  =>
  (retract ?temp)
  (bind ?sum 0)
  (progn$ (?punctaj ?y)
    (bind ?sum (+ ?sum ?punctaj)))
  (modify ?std (total-lab ?sum))
  (assert (modifica-promovare ?nume)))

;3. Adauga punctaj la examen pentru un student
(defrule punctaj-examen-option
    ?opt<- (option 3)
    =>
    (retract ?opt)
    (printout t "Introduceti nume student: ")
    (bind ?nume (read))
    (printout t "Introduceti punctaj examen: ")
    (bind ?score (read))
    (assert (modifica-punctaj-examen ?nume ?score)))

(defrule adauga-punctaj-examen
    ?opt<- (modifica-punctaj-examen ?nume ?score)
    ?temp <- (student (nume ?nume))
    =>
    (retract ?opt)
    (modify ?temp (nume ?nume) (punctaj-examen ?score))
    (assert (modifica-promovare ?nume))
)

;4. Adauga punctaj la proiect pentru un student
(defrule exam-project-option
    ?opt<- (option 4)
    =>
    (retract ?opt)
    (printout t "Introduceti nume student: ")
    (bind ?nume (read))
    (printout t "Introduceti punctaj proiect: ")
    (bind ?score (read))
    (assert (modifica-punctaj-proiect ?nume ?score))
)

(defrule adauga-punctaj-proiect
    ?opt<- (modifica-punctaj-proiect ?nume ?score)
    ?temp <- (student (nume ?nume))
    =>
    (retract ?opt)
    (modify ?temp (nume ?nume) (punctaj-proiect ?score))
    (assert (modifica-promovare ?nume ))
)

;Status
(defrule modif-promovare
    ?opt<- (modifica-promovare ?nume)
    ?temp <- (student (nume ?nume) (total-lab ?x1) (punctaj-examen ?x2) (punctaj-proiect ?x3))
    (test (> (+ ?x1 ?x2 ?x3) 50))
    =>
    (retract ?opt)
    ;(printout t "Studentul " ?nume " a fost promovat" crlf)
    (modify ?temp (status promovat))
    (assert(meniu))
)

(defrule modif-nepromovare
    ?opt<- (modifica-promovare ?nume)
    ?temp <- (student (nume ?nume) (total-lab ?x1) (punctaj-examen ?x2) (punctaj-proiect ?x3))
    (test (<= (+ ?x1 ?x2 ?x3) 50))
    =>
    (retract ?opt)
    ;(printout t "Studentul " ?nume " nu a promovat" crlf)
    (modify ?temp (status nepromovat))
    (assert(meniu))
)

;5. Afiseaza situatie student
(defrule situation-option
    ?opt<- (option 5)
    =>
    (retract ?opt)
    (printout t "Introduceti nume student: ")
    (bind ?nume (read))
    (assert (show-situation ?nume)))


(defrule show-situation
    ?opt<- (show-situation ?nume)
    (student (nume ?nume) (punctaje-laborator $?punctaje_laborator) (total-lab ?total_lab) (punctaj-examen ?punctaj_examen) (punctaj-proiect ?punctaj_proiect) (status ?status))
    =>
    (retract ?opt)
    (printout t "" crlf)
    (printout t "Nume student: " ?nume crlf)
    (printout t "Punctaje laborator: " (implode$ $?punctaje_laborator) crlf)
    (printout t "Total laborator: " ?total_lab crlf)
    (printout t "Punctaj examen: " ?punctaj_examen crlf)
    (printout t "Punctaj proiect: " ?punctaj_proiect crlf)
    (printout t "Status: " ?status crlf)
    (printout t "" crlf)
    (assert(meniu)))

;6. Afiseaza studentii promovati si cei nepromovati
(defrule show-all-students-option
    ?opt<- (option 6)
    (student (nume ?nume) (punctaje-laborator $?punctaje_laborator) (total-lab ?total_lab) (punctaj-examen ?punctaj_examen) (punctaj-proiect ?punctaj_proiect) (status ?status))
    =>
    (retract ?opt)
    (do-for-all-facts ((?student student)) TRUE
      (printout t "Nume student: " ?student:nume crlf)
      (printout t "Punctaje laborator: " (implode$ ?student:punctaje-laborator) crlf)
      (printout t "Total laborator: " ?student:total-lab crlf)
      (printout t "Punctaj examen: " ?student:punctaj-examen crlf)
      (printout t "Punctaj proiect: " ?student:punctaj-proiect crlf)
      (printout t "Status: " ?student:status crlf)
      (printout t "" crlf))
    (assert (meniu))
)
