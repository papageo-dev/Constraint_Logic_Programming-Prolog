%%% Constraint Logic Programming
%%% Prolog
%%% Lab 5
%%% Cut and Higher Order Predicates


%%% lunion/3
%%% lunion(List1,List2,List3)
%%% Create List3, that is the union of elements
%%% that are members of List1 and NOT members
%%% of List2, with List2.
lunion([], L, L).
lunion([H|L1tail], List2, List3) :-
	memberchk(H, List2),
	!,
	lunion(L1tail, List2, List3).
lunion([H|L1tail], List2, [H|L3tail]) :-
	lunion(L1tail, List2, L3tail).
	

%%% reduce/3
%%% reduce(Operation, List, Result)
%%% Call a function with three variables
%%% and return the result.
reduce(_, [LastElem|[]], LastElem).
reduce(Operation, [H|T], Result) :-
    reduce(Operation, T, Acc),
	!,
    call(Operation, H, Acc, Result).



	