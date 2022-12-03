read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_next_line(Stream,X),
    read_file(Stream,L).

read_next_line(Stream,[C|L]) :-
    get_char(Stream,C),
    C \= '\n',
    C \= end_of_file,
    read_next_line(Stream,L).

read_next_line(_,[]) :- !.

read_lines_from_file(Path,Lines) :-
    open(Path,read,Stream),
    read_file(Stream,Lines),
    close(Stream).

parse_second_char([' '|[K]],K) :-
    !.

parse_chars([J|Rest],J,K) :-
    parse_second_char(Rest,K).

wins('A','Y').
wins('B','Z').
wins('C','X').

ties('A','X').
ties('B','Y').
ties('C','Z').

loses('A','Z').
loses('B','X').
loses('C','Y').

ties(J,K) :-
    \+ wins(J,K),
    \+ loses(J,K).

shapeval('X',V) :-
    V is 1.

shapeval('Y',V) :-
    V is 2.

shapeval('Z',V) :-
    V is 3.

outcomeval(J,K,V) :-
    wins(J,K),
    V is 6.

outcomeval(J,K,V) :-
    ties(J,K),
    V is 3.

outcomeval(J,K,V) :-
    loses(J,K),
    V is 0.

points(J,K,V) :-
    shapeval(K,SP),
    outcomeval(J,K,OP),
    V is SP + OP.

points_for_lines_1([],V) :-
    V is 0.

points_for_lines_1([L|Rest],V) :-
    parse_chars(L,J,K),
    points(J,K,LinePoints),
    points_for_lines_1(Rest,RestPoints),
    V is LinePoints + RestPoints.

% Begin part 2 stuff

pick_play(J,K,H) :-
    K = 'X',
    loses(J,H).

pick_play(J,K,H) :-
    K = 'Y',
    ties(J,H).

pick_play(J,K,H) :-
    K = 'Z',
    wins(J,H).

points_for_lines_2([],V) :-
    V is 0.

points_for_lines_2([L|Rest],V) :-
    parse_chars(L,J,K),
    pick_play(J,K,H),
    points(J,H,LinePoints),
    points_for_lines_2(Rest,RestPoints),
    V is LinePoints + RestPoints.

% End part 2 stuff

main :-
    read_lines_from_file('./input.txt',Lines),
    points_for_lines_1(Lines,V),
    points_for_lines_2(Lines,W),
    write('Part A: '),
    write(V),
    write('\n'),
    write('Part B: '),
    write(W),
    nl.
