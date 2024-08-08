% Solutia a fost adaptata folosind codul din cartea PROLOG PROGRAMMING FOR ARTIFICIAL INTELLIGENCE
% scrisa de Ivan Bratko. Capitolul 7.1.2 A cryptarithmetic puzzle using nonvar (pag. 176 - 180)
% linkul - https://silp.iiita.ac.in/wp-content/uploads/PROLOG.pdf
% initial am vrut sa fac cu operatii dar era deja cam mult de implementat pentru 3 cuvinte, de aceea exista operation

puzzle(Word1, Word2, Word3, Result,Operation) :-
    % pentru a nu folosi doi carry intoarcem listele ca sa fie mai usor
    reverse_list(Word1, W1),
    reverse_list(Word2, W2),
    reverse_list(Word3, W3),
    reverse_list(Result, R),
    % am initializat lista de cifre
    digits(Digits),
    solve_puzzle(W1, W2, W3, R,Digits,0,Operation),
    %niciunul nu incepe cu zero
    not_start_with_zero(Word1),
    not_start_with_zero(Word2),
    not_start_with_zero(Word3).

not_start_with_zero([Head|_]) :- Head \= 0.

reverse_list(List, Reversed) :- reverse(List, Reversed).

digits([0,1,2,3,4,5,6,7,8,9]).

%Cazul 1. Toate cuvintele inca mai au litere
solve_puzzle([W1_head|W1_tail], [W2_head|W2_tail], [W3_head|W3_tail], [R_head|R_tail],Digits_old, Carry_old, +) :-
    sel(W1_head,Digits_old,Digits_new1),
    sel(W2_head,Digits_new1,Digits_new2),
    sel(W3_head,Digits_new2,Digits_new3),
    sel(R_head,Digits_new3,Digits_new4),
    Digit_Sum is W1_head+W2_head+W3_head+Carry_old,
    R_head is Digit_Sum mod 10,
    Carry_new is Digit_Sum div 10,
    solve_puzzle(W1_tail, W2_tail, W3_tail, R_tail,Digits_new4, Carry_new, +).

%Cazul 2.1. Doar primele doua mai au litere
solve_puzzle([W1_head|W1_tail], [W2_head|W2_tail], [], [R_head|R_tail],Digits_old, Carry_old, +) :-
    sel(W1_head,Digits_old,Digits_new1),
    sel(W2_head,Digits_new1,Digits_new2),
    sel(R_head,Digits_new2,Digits_new3),
    Digit_Sum is W1_head+W2_head+Carry_old,
    R_head is Digit_Sum mod 10,
    Carry_new is Digit_Sum div 10,
    solve_puzzle(W1_tail, W2_tail,[], R_tail,Digits_new3, Carry_new, +).

%Cazul 2.2. Doar primul si ultimul mai au litere
solve_puzzle([W1_head|W1_tail],[],[W3_head|W3_tail], [R_head|R_tail],Digits_old, Carry_old, +) :-
    sel(W1_head,Digits_old, Digits_new1),
    sel(W3_head,Digits_new1, Digits_new2),
    sel(R_head,Digits_new2, Digits_new3),
    Digit_Sum is W1_head+W3_head+Carry_old,
    R_head is Digit_Sum mod 10,
    Carry_new is Digit_Sum div 10,
    solve_puzzle(W1_tail, [], W3_tail, R_tail,Digits_new3, Carry_new, +).

%Cazul 2.3. Doar ultimele doua mai au litere
solve_puzzle([],[W2_head|W2_tail],[W3_head|W3_tail], [R_head|R_tail],Digits_old, Carry_old, +) :-
    sel(W2_head,Digits_old, Digits_new1),
    sel(W3_head,Digits_new1, Digits_new2),
    sel(R_head,Digits_new2, Digits_new3),
    Digit_Sum is W2_head+W3_head+Carry_old,
    R_head is Digit_Sum mod 10,
    Carry_new is Digit_Sum div 10,
    solve_puzzle([], W2_tail,W3_tail, R_tail,Digits_new3, Carry_new, +).

%Cazurile 3.i doar cuvantul i mai are litere
solve_puzzle([W1_head|W1_tail], [],[],[R_head|R_tail],Digits_old, Carry_old, +) :-
    sel(W1_head,Digits_old, Digits_new1),
    sel(R_head,Digits_new1, Digits_new2),
    Digit_Sum is W1_head+Carry_old,
    R_head is Digit_Sum mod 10,
    Carry_new is Digit_Sum div 10,
    solve_puzzle(W1_tail, [],[], R_tail,Digits_new2, Carry_new, +).

solve_puzzle([] ,[W2_head|W2_tail], [],[R_head|R_tail],Digits_old, Carry_old, +) :-
    sel(W2_head,Digits_old, Digits_new1),
    sel(R_head,Digits_new1, Digits_new2),
    Digit_Sum is W2_head+Carry_old,
    R_head is Digit_Sum mod 10,
    Carry_new is Digit_Sum div 10,
    solve_puzzle([], W2_tail,[], R_tail,Digits_new2, Carry_new, +).

solve_puzzle([], [],[W3_head|W3_tail],[R_head|R_tail],Digits_old, Carry_old, +) :-
    sel(W3_head,Digits_old, Digits_new1),
    sel(R_head,Digits_new1, Digits_new2),
    Digit_Sum is W3_head+Carry_old,
    R_head is Digit_Sum mod 10,
    Carry_new is Digit_Sum div 10,
    solve_puzzle(W3_tail, [],[], R_tail,Digits_new2, Carry_new, +).

%Cazul 4 niciun cuvant nu mai are litere si am ramas cu carry 0 sau respectiv 1 pt ultima din R
solve_puzzle([], [], [], [],_,0,+).
solve_puzzle([], [], [],[1],_,1,+).

%Dacă cumva cifra este o nonvariabila nicio instantiere nu se intampla, ! are rolul de a
% a oprii cautarea potrivii cu predicatul sel
sel(Digit,List_of_digits,List_of_digits) :- nonvar(Digit), !.

% Daca digit ete primul caracter din lista este eliminat si continuam
sel(Digit,[Digit|List_of_digits],List_of_digits).

% Dacă nu continuam asignarea recursiv
sel(Digit,[First_Digit|List_of_digits],[First_Digit|List_of_digits_2]) :- sel(Digit,List_of_digits,List_of_digits_2).

% ? - puzzle([O,N,E],[T,W,O],[T,W,O],[F,I,V,E],+).
% ? - puzzle([R,E,A,D],[B,O,O,K],[M,O,R,E],[S,M,A,R,T],+).
% ? - puzzle([S,E,N,D],[M,O,R,E],[M,O,N,E,Y],[W,O,R,D,S],+).
