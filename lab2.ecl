%%% Constraint Logic Programming
%%% Prolog
%%% Lab 2
%%% Recursion


%%% sumn/2
%%% sumn(Number, Sum)
%%% Calculate sum of numbers, from 1 to N.
sumn(0,0).               % If input number(N)=0, sum(S)=0.
sumn(N,S):-              % If input nummber(N)>0, then calculate sum(S).
    N>0,
    NN is N-1,
    sumn(NN,SS),
    S is SS+N.