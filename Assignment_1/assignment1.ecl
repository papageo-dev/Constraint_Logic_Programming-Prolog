%%% Constraint Logic Programming
%%% Prolog
%%% %%% Coursework 1 - 2020
%%% ECLiPSe Constraints 
%%% List Processing & Matching Number Series



%%% Exec 1

%%% exclude_range/4
%%% exclude_range(Low, High, List, NewList)
%%% Sucess when given a list of integers (3rd argument), 
%%% the NewList list contains all integers that do NOT belong 
%%% to the closed space defined by the first two Low and High arguments.
exclude_range(_, _, [], []).                          %%% When input List is empty, return an empty NewList
exclude_range(Low, High, [A|List], [A|NewList]) :- 
    ( A<Low ; A>High ),                               %%% Check if a list head item(A), NOT belongs to the given range(Low-Hight)
	!,                                                %%% (use cut(!) to prevent unwanted backtracking)
    exclude_range(Low, High, List, NewList).          %%% If it NOT belongs, add to NewList
	
exclude_range(Low, High, [A|List], NewList) :- 
    ( A>=Low ; A=<High ),                             %%% Check if a list tail item(A), NOT belongs to the given range(Low-Hight)
	!,                                                %%% (use cut(!) to prevent unwanted backtracking)
    exclude_range(Low, High, List, NewList).          %%% If it NOT belongs, add to NewList



%%% Exec 2

%%% Relations Available for Exec 2
double(X,Y):-Y is X * 2.
inc(X,Y):-Y is X + 1.
square(X,Y):- Y is X*X.


%%% math_match/3
%%% math_match(List, C, Solution)
%%% Succeed when arguments satisfy a condition
math_match([H|T], C, Solution):-
	onePair([H,T|_], [X,Y]),
	maplist(C, X, Y),!,
	pair([H|T], Solution),!.

%%% onePair/2
%%% onePair(List, PairList)
%%% Return a consecutive pair(one at a time)
onePair([X,Y|_], [X,Y]).
onePair([_|Tail], XY):-
	onePair(Tail,XY).
  
%%% pair/2
%%% pair(List, ListConsPairs)
%%% Return a list of all consecutive pairs
pair([_],[]).
pair([X,Y|T],[[X,Y]|T1]):-
    pair([Y|T],T1).
	
	
%%% math_match_alt/3
%%% math_match_alt/3(List, C, Solution)	
%%% Succeed when arguments satisfy a condition
math_match_alt(List, C, Solution):-
	maplist(C, X, Y),
	findall((X,Y),append(_,[X,Y|_],List),Solution).
	
	
	
	



