% Grammar rules
% E -> T R
% R -> ε | + E
% T -> F S
% S -> ε | * T
% F -> n | ( E )

% Terminal symbols
terminal(n).
terminal(+).
terminal(*).
terminal('(').
terminal(')').

% E -> T R
rule(net_E, [T | Rest0], Rest) :-
    writeln('Aplicat E -> T R'),
    rule(net_T, [T | Rest0], Rest1),
    writeln(Rest1),
    rule(net_R, Rest1, Rest).

% R -> ε
rule(net_R, Rest, Rest) :- writeln('Aplicat R -> ε ').

% R -> + E
rule(net_R, ['+' | Rest], Rest1) :-
    writeln('Aplicat R -> + E'),
    rule(net_E, Rest, Rest1).

% T -> F S
rule(net_T, [F | S], Rest) :-
    writeln('Aplicat T -> F S'),
    rule(net_F, [F | S], Rest1),
    rule(net_S, Rest1, Rest).

% S -> ε
rule(net_S, Rest, Rest) :- writeln('Aplicat S -> ε ').

% S -> * T
rule(net_S, ['*' | Rest], Rest1) :-
    writeln('Aplicat S -> * T'),
    rule(net_T, Rest, Rest1).

% F -> n
rule(net_F, [n | Rest], Rest) :-
    writeln('Aplicat F -> n'),
    terminal(n).

% F -> ( E )
rule(net_F, ['(' | Rest], Rest1) :-
    writeln('Aplicat F -> ( E )'),
    rule(net_E, Rest, [')' | Rest1]),
    terminal(')').

parse(Input) :-
    writeln(Input),
    rule(net_E, Input, []),
    writeln(Input).

test :-
    Input = ['(', n, '+', n, ')','*','(',n,'*',n,')'],
    parse(Input),
    writeln('Parsing successful!').
