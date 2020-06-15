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
exclude_range(_,_,[],[]).

exclude_range(Low,High,[X|List],NewList):-
	X >= Low, X =< High,
	!,
	exclude_range(Low,High,List,NewList).

exclude_range(Low,High,[X|List],[X|NewList]):-
	exclude_range(Low,High,List,NewList).       



%%% Exec 2

%%% Relations Available for Exec 2
double(X,Y):-Y is X * 2.
inc(X,Y):-Y is X + 1.
square(X,Y):- Y is X*X.


%%% math_match/3
%%% math_match(List, C, Solution)
%%% Succeed when arguments satisfy a condition
math_match([_], _, []).

math_match([X,Y|RestNums],Func,[(X,Y)|Rest]):-
	Call =.. [Func,X,Y],
	Call,!,
	math_match([Y|RestNums],Func,Rest).
	
math_match([_|RestNums],Func,Rest):-
	math_match(RestNums,Func,Rest).
	
	
%%% math_match_alt/3
%%% math_match_alt/3(List, C, Solution)	
%%% Succeed when arguments satisfy a condition
math_match_alt(List, C, Solution):-
	findall((X,Y),
	(append(_,[X,Y|_],List),
	F =..[C,X,Y],F),Solution).
	
	
	
	



