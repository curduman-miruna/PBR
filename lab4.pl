% Problema 2. Nicio limbă nu era comună tuturor celor patru interlocutori dar fiecare știa două din cele patru limbi, celelalte fiindu-le străine.
% 3.Salal nu știa persana, dar traducea atunci când bătrânul profesor Atar voia să vorbească cu Eber.
% 4. Eber vorbea aramaica și discuta liber cu Zaman deși acesta nu cunoștea aramaica.
% 5. Nici Salal nici Atar și nici Zaman nu cunoșteau o unică limbă în care să se înțeleagă între ei.
% 6.Niciunul dintre ei nu vorbea și aramaica și armeana.
% Limbile erau diferite, nu vb aceeasi limba de doua ori.

:- use_rendering(table,
		 [header(h('Professor', 'Language1', 'Language2'))]).

professor_languages(Professor, Language1, Language2) :-
    professors(Ps),
    member(h(Professor, Language1, Language2), Ps),
    \+ Language1 == Language2.

professors(Ps) :-
    % fiecare profesor din lista Ps de profesori este reprezentat ca:
    %      h(Professor, Language1, Language2)
    length(Ps, 4),
    member(h(salal, _, _), Ps),
    member(h(eber, aramaic, _), Ps), % Eber vorbește aramaică
    member(h(eber, _, X), Ps),
    member(h(zaman, X, _), Ps), % Eber și Zaman vorbesc o limbă comună
    member(h(atar, _, Y), Ps),
    member(h(salal, _, Z), Ps),
    Y \== Z,
    member(h(zaman, _, W), Ps),
    Y \== W,
    Z \== W, % Salal, Atar și Zaman nu au o limbă comună
    member(h(_, armenian, _), Ps),
    member(h(_, _, armenian), Ps),
    member(h(_, persian, _), Ps),
    member(h(_, _, persian), Ps),
    member(h(_, greek, _), Ps),
    member(h(_, _, greek), Ps),
    member(h(_, aramaic, _), Ps),
    member(h(_, _, aramaic), Ps),

    %Restrictii
    \+ member(h(_, L, L),Ps),
    \+ member(h(salal,persian,L),Ps),
    \+ member(h(salal,L,persian),Ps),
    \+ member(h(_,aramaic,armenian),Ps),
    \+ member(h(_,armenian,aramaic),Ps),
    \+ member(h(zaman,_,aramaic),Ps),
    \+ member(h(zaman,aramaic,_),Ps).


/** <examples>

?- professor_languages(Professor, Language1, Language2).

?- professors(Professors).

*/
