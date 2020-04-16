%%% Constraint Logic Programming
%%% Prolog
%%% Lab 4
%%% Structure: Lists


%%% common_suffix/4
%%% common_suffix(L1,L2,Suffix,Pos)
%%% Succeeds if lists L1 and L2 have common suffix,
%%% returns the suffix and the position of suffix's begin.
common_suffix(L1,L2,Suffix,Pos):-
    append(_,Ls,L1),
    append(_,Ls,L2),
    Suffix = Ls,
    length(Suffix,Pos).







