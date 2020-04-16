%%% Constraint Logic Programming
%%% Prolog
%%% Lab 3
%%% Structure: Lists


%%% sum_even/2
%%% sum_even([],even_sum)
%%% Find sum of all even numbers in input list
sum_even([], 0).                  % When list is empty, sum of even numbers is 0.
sum_even([H|T], X) :-             % When number is even, add it to sum.
	0 is H mod 2,
	sum_even(T, Y), 
	X is Y+H.
sum_even([H|T], X) :-             % When number is odd, ignore it.
	1 is H mod 2,
	sum_even(T, X).


%%% replace_all/4
%%% replace_all(X,Y,List,ResultList)
%%% Replace all same elements X of a list, with an element Y and create a new list with result
replace_all(_, _, [], []).             % When input list is empty, result list is empty.
replace_all(X, Y, [X|T], [Y|T2]) :-
replace_all(X, Y, T, T2).
replace_all(X, Y, [H|T], [H|T2]) :-
H \= X,
replace_all(X, Y, T, T2).


%%% replase/4
%%% replace(X,Y,List,ResultList)
%%% Replace an element X of a list, with an element Y and create a new list with result
replace(X,Y,[X|Tail],[Y|Tail]).
replace(X,Y,[Z|Tail],[Z|Answer]):-
	replace(X,Y,Tail,Answer).
